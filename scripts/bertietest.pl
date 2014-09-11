#!/usr/bin/perl -w

# Script for Bertie to test coding

#use strict;
use CGI qw(:standard);
use DBI;

my $i = 1;
my $tv = 0;

#print "How many times? \n";
#my $donut=<>;

#$donut=$donut*2;

# Print out the 21x tables

while ($i<=15) {
	print "21 times ";
	print "$i";
	$tv = 21*$i;
	print " = ";
	print "$tv";
	print "\n";
	$i = $i + 1;
};