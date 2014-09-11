#!/usr/bin/perl -w

# Script to retrieve ofsted rating data for each school

#use strict;
use CGI qw(:standard);
use DBI;
use LWP::Simple qw(!head);

my $status;
my $schurl;

#set up logfile
open my $LOGFILE, '>>', '../logs/getOfRatingLog' or
	die "can't open logfile for append: $!\n";
print $LOGFILE 'Retrieving ofsted rating data ' . scalar localtime . "\n";

# Connect to the dev database
my $dbh = DBI->connect('dbi:mysql:tortie_co_uk_db','tortie','Emily')
              or die "Connection Error: $DBI::errstr\n";
# Connect to the prod database
#my $dbh = DBI->connect('dbi:mysql:tortie_co_uk_db:database.lcn.com','LCN371857_tortie','12Erbevy')
#              or die "Connection Error: $DBI::errstr\n";


# Retrieve the District Codes
my $sql = "select URN from EdSpineTb";
my $sth = $dbh->prepare($sql);
$sth-> execute
	or die "SQL Error: $DBI::errstr\n";

while ($urn = $sth->fetchrow_array) {
	
	print $LOGFILE "Retrieving file for school: " . $urn . "\n";

	$schurl = "http://www.education.gov.uk/cgi-bin/schools/performance/school.pl?urn=" . $urn . "&download=csv";
	$status = getstore("$schurl","/tmp/$urn");

	if (is_error($status)) {
		print $LOGFILE 'Failed to retrieve file ' . "\n";
	} else {
		print $LOGFILE 'File retrieved to /tmp ' . "\n";
	}	

	# truncate the school data table
	my $sqlSch = "truncate table tempSchData";
	my $sth2 = $dbh->prepare($sqlSch);
	$sth2->execute
		or die "SQL Error: $DBI::errstr\n";

	# now load in the school data for each LEA file
	$sqlSch = "load data local infile '/tmp/$urn' into table tempSchData fields terminated by ',' enclosed by '\"' lines terminated by '\n'";
	$sth2 = $dbh->prepare($sqlSch);
        $sth2->execute
                or die "SQL Error: $DBI::errstr\n";

	# add the ofsted data to EdSpineTb
	$sqlDist = "CALL addOfstedRatingProc ('$urn')";
        $sth2 = $dbh->prepare($sqlDist);
        $sth2->execute
                or die "SQL Error: $DBI::errstr\n";

	# add the fsm data to EdSpineTb
	$sqlDist = "CALL addFSMProc ('$urn')";
        $sth2 = $dbh->prepare($sqlDist);
        $sth2->execute
                or die "SQL Error: $DBI::errstr\n";

	# add the ks2 results data to EdSpineTb
	$sqlDist = "CALL addKS2ResultsProc ('$urn')";
        $sth2 = $dbh->prepare($sqlDist);
        $sth2->execute
                or die "SQL Error: $DBI::errstr\n";

	
	# now delete the file as it is no longer needed
	system("rm /tmp/$urn");
}
$dbh->disconnect();
print $LOGFILE "All files retrieved " . scalar localtime . "\n";

close $LOGFILE;

