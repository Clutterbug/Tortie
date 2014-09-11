#!/usr/bin/perl -w

#use strict;
use CGI qw(:standard);
use DBI;
my $dbh = DBI->connect('dbi:mysql:tortie_co_uk_db','tortie','Emily')
              or die "Connection Error: $DBI::errstr\n";
my $sql = "select * from landRegTb limit 10";
my $sth = $dbh->prepare($sql);
$sth->execute
        or die "SQL Error: $DBI::errstr\n";
while (@row = $sth->fetchrow_array) {
    print "@row\n";
} 
