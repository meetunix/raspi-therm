#!/usr/bin/perl
#imports data from led-thermo.pl's loldata.csv in a simple database
#made for backup issues or for transition issues
#to create DB use the setup-database.pl skript

use strict;
use warnings;
use v5.10;
use Text::CSV;
use DBD::Pg;

################### database konfiguration ################
my $dbname 		= "wetterdb";
my $dbuser 		= "wetter";
my $dbhost 		= "192.168.42.72";
my $dbpassword		= "password";
###########################################################

#connect to above DB
my $dbh = DBI->connect("dbi:Pg:dbname=$dbname;
			host=$dbhost","$dbuser",
			"$dbpassword" , {AutoCommit => 1}) or die $DBI::errstr;


my @hr_time = undef ;
my $curr_epoch = undef;
my $curr_temp = undef;
my $curr_humid = undef;
my $curr_time = undef;

#first argument should be path to csv-file
my $csv_file = shift @ARGV;


my $csv = Text::CSV->new ( { binary => 1 ,sep_char => ';' } ) or die "can't use CSV: ".Text::CSV->error_diag ();

open my $fh, "<:encoding(utf8)", $csv_file or die "can't open file: $csv_file";

while (my $row = $csv->getline($fh)) {
	$curr_epoch = $row->[0];
	$curr_temp = $row->[1];
	$curr_humid = $row->[2];
	#prepare timestamp for db use: YYYY-MM-DD HH:MM:SS
	@hr_time =  gmtime($curr_epoch); #all times in UTC
	$curr_time = sprintf("%04d-%02d-%02d %02d:%02d:%02d\n", $hr_time[5] + 1900, $hr_time[4]+1, $hr_time[3], $hr_time[2], $hr_time[1], $hr_time[0]);
	#write dataset to db	
	my $rv = $dbh->do("INSERT INTO wetterdaten (epoch,time,temp,humid) VALUES ('$curr_epoch','$curr_time','$curr_temp','$curr_humid');");
}





$dbh->disconnect;
