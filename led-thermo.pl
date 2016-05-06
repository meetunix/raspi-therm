#!/usr/bin/perl
#Raspberrypi: LED-Digitalthermometer
use strict;
use warnings;
use HiPi::Wiring;
use Time::Local;
use v5.10;

#functions
my $csv_file = "/var/loldata.csv";
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

#initialize wiringpi and my pins
&HiPi::Wiring::wiringPiSetup();
my @led_pin = ( 1..5,12,13 );
foreach my $pin (@led_pin) {
        &HiPi::Wiring::pinMode ($pin, 1);
}

#get data from dht22
my $below_zero = 0;
my $lol_temp = undef;

my @lol_data = f_get_loldht_data();
#my @lol_data = qw(74 5);

#set Frost-indikator
if ( int($lol_data[1]) < 0 ) {
	$below_zero = 1;
	$lol_temp = abs(int($lol_data[1]));
}else {
	$lol_temp = abs(int($lol_data[1]));
}

say "lol_temp: $lol_temp";
#convert temperatur in binary
my $bin_temp = sprintf '%05b', $lol_temp;

#re-check if data is good
if ( length $bin_temp > 5 ) {
	say length $bin_temp;
	say "temp is higher then 32 degree - therm can't schow this high temperature";
}

#format data for further use
my @temp_list = split //, $bin_temp;

my %act_temp = ('below_zero' => $below_zero,
		'2_1' => $temp_list[0],
		'2_2' => $temp_list[1],
		'2_4' => $temp_list[2],
		'2_8' => $temp_list[3],
		'2_16' => $temp_list[4] );

#switch all leds off
foreach my $pin (@led_pin) {
	&HiPi::Wiring::digitalWrite($pin, 0); 
}

#switch the right leds
if ( $act_temp{'below_zero'} != 0 ) {
	&HiPi::Wiring::digitalWrite(12, 1); 
	&HiPi::Wiring::digitalWrite(13, 1); 
}
if ( $act_temp{'2_1'} != 0 ) {
	&HiPi::Wiring::digitalWrite(5, 1); 
}
if ( $act_temp{'2_2'} != 0 ) {
	&HiPi::Wiring::digitalWrite(4, 1); 
}
if ( $act_temp{'2_4'} != 0 ) {
	&HiPi::Wiring::digitalWrite(3, 1); 
}
if ( $act_temp{'2_8'} != 0 ) {
	&HiPi::Wiring::digitalWrite(2, 1); 
}
if ( $act_temp{'2_16'} != 0 ) {
	&HiPi::Wiring::digitalWrite(1, 1); 
}


f_write_csv (f_get_epoc(),$lol_data[1],$lol_data[0]);


