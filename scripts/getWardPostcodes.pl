#!/usr/bin/perl -w

# Script to retrieve postcode data for each ward

#use strict;
use CGI qw(:standard);
use DBI;
use LWP::Simple qw(!head);

my $status;

#set up logfile
open my $LOGFILE, '>>', '../logs/getWardPCLog' or
	die "can't open logfile for append: $!\n";
print $LOGFILE 'Retrieving ward postcodes data ' . scalar localtime . "\n";

# Connect to the database
my $dbh = DBI->connect('dbi:mysql:tortie_co_uk_db','tortie','Emily')
              or die "Connection Error: $DBI::errstr\n";

# Retrieve the District Codes
#my $sql = "select DistrictCode from adminAreasTb where District like '%London%'";
my $sql = "select DistrictCode from adminAreasTb where County like 'Surrey%'";
my $sth = $dbh->prepare($sql);
$sth-> execute
	or die "SQL Error: $DBI::errstr\n";

while ($districtcode = $sth->fetchrow_array) {
	
	print $LOGFILE "Retrieving file for district: " . $districtcode . "\n";

	$status = getstore("http://www.doogal.co.uk/AdministrativeAreasCSV.php?district=$districtcode","/tmp/$districtcode");
	if (is_error($status)) {
		print $LOGFILE 'Failed to retrieve file ' . "\n";
	} else {
		print $LOGFILE 'File retrieved to /tmp ' . "\n";
	}	

	# for each district create a new table
	my $sqlDist = "create table " . $districtcode . " (Postcode VARCHAR(8),Latitude DECIMAL(8,6),Longitude DECIMAL(8,6),Easting INT(6),Northing INT(6),GridRef VARCHAR(8),Ward VARCHAR(60))";
	my $sth2 = $dbh->prepare($sqlDist);
	$sth2->execute
		or die "SQL Error: $DBI::errstr\n";

	# now load in the postcode data for the district from the retrieved file
	$sqlDist = "load data local infile '/tmp/$districtcode' into table $districtcode fields terminated by ',' enclosed by '\"' lines terminated by '\n'";
	$sth2 = $dbh->prepare($sqlDist);
        $sth2->execute
                or die "SQL Error: $DBI::errstr\n";

	# delete the header line from the table
	$sqlDist = "delete from $districtcode where Ward='Ward'";
	$sth2 = $dbh->prepare($sqlDist);
        $sth2->execute
                or die "SQL Error: $DBI::errstr\n";

	# create index on new table
	$sqlDist = "ALTER TABLE $districtcode ADD INDEX dc_ix (Postcode)";
	$sth2 = $dbh->prepare($sqlDist);
        $sth2->execute
                or die "SQL Error: $DBI::errstr\n";

	# add the ward location data
	$sqlDist = "CALL calcAverageWardLocProc ('$districtcode')";
        $sth2 = $dbh->prepare($sqlDist);
        $sth2->execute
                or die "SQL Error: $DBI::errstr\n";

	# calculate the average ward prices
	system("/Users/clarenewall1/tortie/scripts/calculateWardAvPrices.pl $districtcode");

	# the district table is not currently needed, so to save space we will delete it.
	#$sqlDist = "DROP TABLE " . $districtcode;
	#$sth2 = $dbh->prepare($sqlDist);
        #$sth2->execute
        #        or die "SQL Error: $DBI::errstr\n";

	# now delete the file as it is no longer needed
	system("rm /tmp/$districtcode");
}
$dbh->disconnect();
print $LOGFILE "All files retrieved " . scalar localtime . "\n";

close $LOGFILE;

