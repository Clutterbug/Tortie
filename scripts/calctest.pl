#!/usr/bin/perl -w

# Script to calculate the average house prices for each ward.

#use strict;
use CGI qw(:standard);
use DBI;

my $avTer;
my $avSemi;
my $avFlat;
my $avDet;
my $avAll;

# Connect to the database
my $dbh = DBI->connect('dbi:mysql:tortie_co_uk_db','tortie','Emily')
              or die "Connection Error: $DBI::errstr\n";

# Retrieve the list of wards from the LA

# Currently hardcoding the LATable
$LATable = "richmondUponThamesTb";

my $sql = "select distinct Ward from $LATable";
my $sth = $dbh->prepare($sql);
$sth->execute
        or die "SQL Error: $DBI::errstr\n";
while ($ward = $sth->fetchrow_array) {
    	print "$ward\t";

	$avTer=0;
	$avSemi=0;
	$avFlat=0;
	$avDet=0;
	$avAll=0;

	# For each ward retrieved, calculate the average property price
	# Average flat price
	my $sqlWard = "call calcAverageWardPriceProc('$ward','richmondUponThamesTb','F')";
	
	my $sth2 = $dbh->prepare($sqlWard);
	$sth2->execute
		or die "SQL Error: $DBI::errstr\n";

	while ($average = $sth2->fetchrow_array) { 
		print "$average\t";
		$avFlat=$average;
	}
	
	# Average Detached Price
	$sqlWard = "call calcAverageWardPriceProc('$ward','richmondUponThamesTb','D')";
	
	$sth2 = $dbh->prepare($sqlWard);
	$sth2->execute
		or die "SQL Error: $DBI::errstr\n";

	while ($average = $sth2->fetchrow_array) {
		print "$average\t";
		$avDet=$average;
	}

	# Average Terraced Price
	$sqlWard = "call calcAverageWardPriceProc('$ward','richmondUponThamesTb','T')";
	
	$sth2 = $dbh->prepare($sqlWard);
	$sth2->execute
		or die "SQL Error: $DBI::errstr\n";

	while ($average = $sth2->fetchrow_array) {
		print "$average\t";
		$avTer=$average;
	}

	# Average Semi Price
	$sqlWard = "call calcAverageWardPriceProc('$ward','richmondUponThamesTb','S')";
	
	$sth2 = $dbh->prepare($sqlWard);
	$sth2->execute
		or die "SQL Error: $DBI::errstr\n";

	while ($average = $sth2->fetchrow_array) {
		print "$average\t";
		$avSemi=$average;
	}

	# Average All Price
	$sqlWard = "call calcAverageWardPriceProc('$ward','richmondUponThamesTb','%')";
	
	$sth2 = $dbh->prepare($sqlWard);
	$sth2->execute
		or die "SQL Error: $DBI::errstr\n";

	while ($average = $sth2->fetchrow_array) {
		print "$average\n";
		$avAll=$average
	}

	# Add the average prices to the wardLocations
	#$sqlWard = "call updateWardAvsProc('$ward','$avAll','$avFlat','$avDet','$avTer','$avSemi'";
	#$sqlWard = "UPDATE wardLocationsTb SET AveragePrice=6.0,AvFPrice=6.0,AvDPrice=6.0,AvTPrice=6.0,AvSPrice=6.0 WHERE Ward='$ward'";
	$sqlWard = "UPDATE wardLocationsTb SET AveragePrice=$avAll,AvFPrice=$avFlat,AvDPrice=$avDet,AvTPrice=$avTer,AvSPrice=$avSemi WHERE Ward='$ward'";

        $sth2 = $dbh->prepare($sqlWard);
        $sth2->execute
                or die "SQL Error: $DBI::errstr\n";

} 

$dbh->disconnect();
