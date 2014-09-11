#!/usr/bin/perl -w

# Script to retrieve education data for each LEA

#use strict;
use CGI qw(:standard);
use DBI;
use LWP::Simple qw(!head);

my $status;
my $edurl;

#set up logfile
open my $LOGFILE, '>>', '../logs/getEdDataLog' or
	die "can't open logfile for append: $!\n";
print $LOGFILE 'Retrieving LEA education data ' . scalar localtime . "\n";

# Connect to the dev database
my $dbh = DBI->connect('dbi:mysql:tortie_co_uk_db','tortie','Emily')
              or die "Connection Error: $DBI::errstr\n";

# Connect to the prod database
#my $dbh = DBI->connect('dbi:mysql:tortie_co_uk_db:database.lcn.com','LCN371857_tortie','12Erbevy')
#              or die "Connection Error: $DBI::errstr\n";

# Retrieve the LEA Codes
my $sql = "select LEA from LEACodesTb where RegionName not like '%London%'";
#my $sql = "select LEA from LEACodesTb";

my $sth = $dbh->prepare($sql);
$sth-> execute
	or die "SQL Error: $DBI::errstr\n";

while ($leacode = $sth->fetchrow_array) {
	
	print $LOGFILE "Retrieving file for LEA: " . $leacode . "\n";

	$edurl = "http://www.education.gov.uk/schools/performance/download/csv/" . $leacode . "_spine.csv";
	#$status = getstore("http://www.doogal.co.uk/AdministrativeAreasCSV.php?district=$districtcode","/tmp/$districtcode");
	$status = getstore("$edurl","/tmp/$leacode");

	if (is_error($status)) {
		print $LOGFILE 'Failed to retrieve file ' . "\n";
	} else {
		print $LOGFILE 'File retrieved to /tmp ' . "\n";
	}	


	# now load in the education spine data for each LEA file
	my $sqlLEA = "load data local infile '/tmp/$leacode' into table EdSpineTb fields terminated by ',' enclosed by '\"' lines terminated by '\n'";
	my $sth2 = $dbh->prepare($sqlLEA);
        $sth2->execute
                or die "SQL Error: $DBI::errstr\n";

	# delete the header line from the table
	$sqlLEA = "delete from EdSpineTb where URN='URN'";
	$sth2 = $dbh->prepare($sqlLEA);
        $sth2->execute
                or die "SQL Error: $DBI::errstr\n";

	# now delete the file as it is no longer needed
	#system("rm /tmp/$leacode");
}
$dbh->disconnect();
print $LOGFILE "All files retrieved " . scalar localtime . "\n";

close $LOGFILE;

