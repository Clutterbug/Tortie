#!/usr/bin/perl -w

# Script to collate all the postcodes into one table

#use strict;
use CGI qw(:standard);
use DBI;

#set up logfile
open my $LOGFILE, '>>', '../logs/collatepcodes' or
	die "can't open logfile for append: $!\n";
print $LOGFILE 'Collating postcodes for all LAs ' . scalar localtime . "\n";


# Connect to the database
my $dbh = DBI->connect('dbi:mysql:tortie_co_uk_db','tortie','Emily')
              or die "Connection Error: $DBI::errstr\n";

# Retrieve the list of wards from the LA

my $sql = "select DistrictCode from adminAreasTb where District like '%London%'";
my $sth = $dbh->prepare($sql);
$sth->execute
        or die "SQL Error: $DBI::errstr\n";
while ($distcode = $sth->fetchrow_array) {

	print $LOGFILE "Collating for District: " . $distcode . "\t";

	my $sqldist = "insert UKPCodeLocationsTb select Postcode,Latitude,Longitude from $distcode";
	$sth2 = $dbh->prepare($sqldist);
	$sth2->execute
		or die "SQL Error: $DBI::errstr\n";

} 

$dbh->disconnect();
print $LOGFILE "Collation Complete " . scalar localtime . "\n";

close $LOGFILE;

