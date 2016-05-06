#!/usr/bin/perl

use strict;
use warnings;
use v5.10;
use DBD::Pg;

###################
my $dbname 		= "wetterdb";
my $dbuser 		= "wetter";
my $dbhost 		= "192.168.42.72";
my $dbpassword		= "password";
###################


say "Hello";


my $dbh = DBI->connect("dbi:Pg:dbname=$dbname;
			host=$dbhost","$dbuser",
			"$dbpassword" , {AutoCommit => 1}) or die DBI::errstr;

my $stmt = qq(CREATE TABLE wetterdaten (
	epoch	INTEGER		PRIMARY KEY,
	time 	TIMESTAMP 	NOT NULL,
	temp	FLOAT    	NOT NULL,
	humid	FLOAT     	NOT NULL););					

my $rv = $dbh->do($stmt);

$dbh->disconnect;
