#! /usr/bin/perl

use strict;
use warnings;

use DBI;
use DBD::MySQL;

my $dbh=DBI->connect(
  "DBI:mysql:database=tortie_co_uk_db;host=localhost",
  "tortie",
  "Emily"
) || die "Error connecting to database: $!\n";

my $sth = $dbh->prepare("SELECT * FROM user");

$sth->execute();

while (my $ref = $sth->fetchrow_arrayref) {
  print $ref->[1] . "\n";
}

exit;

