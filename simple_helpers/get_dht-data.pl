#!/usr/bin/perl
#script executes loldht and collects temp and humidity

use strict;
use warnings;
use diagnostics;
use v5.10;
use Time::Local;

my $csv_file = "/tmp/loldata.csv";

sub f_get_loldht_data {

	my $lol_output = `loldht 0`;

	if ( $lol_output =~ /=\s([-\.0-9]+).+=\s([-\.0-9]+)/) {
		#1: Humidity 2: Temperature
		my @data = ( $1, $2 );
		return @data;
	} else {
		die 'lol_dht does not provide usefull data';
	}
}

sub f_write_csv {
	open CSV, '>>:encoding(UTF-8)', $csv_file or die "can't open file: $csv_file";	
	say CSV "$_[0];$_[1];$_[2]"; 
	close CSV;

}

sub f_get_epoc {
	my @l_time =  gmtime;
	#timegm(sec, min, hour, day, month, year)
	my $epoch = timegm($l_time[0],$l_time[1],$l_time[2],$l_time[3],$l_time[4],$l_time[5] + 1900);
	return $epoch
}

my @lol_data = f_get_loldht_data();

my $epoch = f_get_epoc();

f_write_csv (f_get_epoc(),$lol_data[1],$lol_data[0]); 


say "Aktuelle Werte: Temp: $lol_data[1] , Luftfeuchtigkeit $lol_data[0]";
