#!/usr/bin/perl -w

# Script to retrieve postcode data for each postcode area

#use strict;
use CGI qw(:standard);
use DBI;
use LWP::Simple qw(!head);

my $status;

#set up logfile
open my $LOGFILE, '>>', '../logs/getUKPCLog' or
	die "can't open logfile for append: $!\n";
print $LOGFILE 'Retrieving uk postcodes data ' . scalar localtime . "\n";

# Connect to the dev database
#my $dbh = DBI->connect('dbi:mysql:tortie_co_uk_db','tortie','Emily')
#              or die "Connection Error: $DBI::errstr\n";

# Connect to the prod database
my $dbh = DBI->connect('dbi:mysql:tortie_co_uk_db:database.lcn.com','LCN371857_tortie','12Erbevy')
              or die "Connection Error: $DBI::errstr\n";


# Retrieve the postcode area codes
my $sql = "select AreaCode from postCodeAreas";

my $sth = $dbh->prepare($sql);
$sth-> execute
	or die "SQL Error: $DBI::errstr\n";

while ($areacode = $sth->fetchrow_array) {
	
	print $LOGFILE "Retrieving file for area: " . $areacode . "\n";
	$status = getstore("http://www.doogal.co.uk/UKPostcodesCSV.php?Search=$areacode","/tmp/$areacode");
	if (is_error($status)) {
		print $LOGFILE 'Failed to retrieve file ' . "\n";
	} else {
		print $LOGFILE 'File retrieved to /tmp ' . "\n";
	}	

	# now load in the postcode data for the area from the retrieved file
	$sqlDist = "load data local infile '/tmp/$areacode' into table PostCodeLoadTb fields terminated by ',' enclosed by '\"' lines terminated by '\n'";
	$sth2 = $dbh->prepare($sqlDist);
        $sth2->execute
                or die "SQL Error: $DBI::errstr\n";

	# delete the header line from the table
	$sqlDist = "delete from PostCodeLoadTb where Ward='Ward'";
	$sth2 = $dbh->prepare($sqlDist);
        $sth2->execute
                or die "SQL Error: $DBI::errstr\n";


	# now delete the file as it is no longer needed
	system("rm /tmp/$areacode");
}
$dbh->disconnect();
print $LOGFILE "All files retrieved " . scalar localtime . "\n";

close $LOGFILE;

