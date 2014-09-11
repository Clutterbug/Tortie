#!/usr/bin/perl -w

# Script to calculate the average house prices for each ward.

#use strict;
use CGI qw(:standard);
use DBI;

#set up logfile
open my $LOGFILE, '>>', '../logs/calcAvPriceLog' or
	die "can't open logfile for append: $!\n";
print $LOGFILE 'Calculating average house prices for each ward ' . scalar localtime . "\n";


my $avTer;
my $avSemi;
my $avFlat;
my $avDet;
my $avAll;

# Connect to the database
my $dbh = DBI->connect('dbi:mysql:tortie_co_uk_db','tortie','Emily')
              or die "Connection Error: $DBI::errstr\n";

# Retrieve the list of wards from the LA

$LATable = $ARGV[0]; 

my $sql = "select distinct Ward from $LATable";
my $sth = $dbh->prepare($sql);
$sth->execute
        or die "SQL Error: $DBI::errstr\n";
while ($ward = $sth->fetchrow_array) {

	print $LOGFILE "Calculating for ward: " . $ward . "\t";

	$avTer=0;
	$avSemi=0;
	$avFlat=0;
	$avDet=0;
	$avAll=0;

	# For each ward retrieved, calculate the average property price
	# Average flat price
	# Handle any quote characters in $ward variable
	$ward = $dbh->quote($ward);

	my $sqlWard = "call calcAverageWardPriceProc($ward,'$LATable','F')";
	$sth2 = $dbh->prepare($sqlWard);
	$sth2->execute
		or die "SQL Error: $DBI::errstr\n";

	while ($average = $sth2->fetchrow_array) { 
		$avFlat=$average;
		print $LOGFILE $avFlat . "\t";
	}
	
	# Average Detached Price
	$sqlWard = "call calcAverageWardPriceProc($ward,'$LATable','D')";
	
	$sth2 = $dbh->prepare($sqlWard);
	$sth2->execute
		or die "SQL Error: $DBI::errstr\n";

	while ($average = $sth2->fetchrow_array) {
		$avDet=$average;
		print $LOGFILE $avDet . "\t";
	}

	# Average Terraced Price
	$sqlWard = "call calcAverageWardPriceProc($ward,'$LATable','T')";
	
	$sth2 = $dbh->prepare($sqlWard);
	$sth2->execute
		or die "SQL Error: $DBI::errstr\n";

	while ($average = $sth2->fetchrow_array) {
		$avTer=$average;
		print $LOGFILE $avTer . "\t";
	}

	# Average Semi Price
	$sqlWard = "call calcAverageWardPriceProc($ward,'$LATable','S')";
	
	$sth2 = $dbh->prepare($sqlWard);
	$sth2->execute
		or die "SQL Error: $DBI::errstr\n";

	while ($average = $sth2->fetchrow_array) {
		$avSemi=$average;
		print $LOGFILE $avSemi . "\t";
	}

	# Average All Price
	$sqlWard = "call calcAverageWardPriceProc($ward,'$LATable','%')";
	
	$sth2 = $dbh->prepare($sqlWard);
	$sth2->execute
		or die "SQL Error: $DBI::errstr\n";

	while ($average = $sth2->fetchrow_array) {
		$avAll=$average;
		print $LOGFILE $avAll . "\n";
	}

	# Add the average prices to the wardLocations
	$sqlWard = "UPDATE wardLocationsTb SET AveragePrice=$avAll,AvFPrice=$avFlat,AvDPrice=$avDet,AvTPrice=$avTer,AvSPrice=$avSemi WHERE Ward=$ward";

        $sth2 = $dbh->prepare($sqlWard);
        $sth2->execute
                or die "SQL Error: $DBI::errstr\n";

} 

$dbh->disconnect();
print $LOGFILE "Calculations Complete " . scalar localtime . "\n";

close $LOGFILE;

