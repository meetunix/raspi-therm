#!/usr/bin/env perl

use strict;
use warnings;
use Time::Local;
use HiPi qw( :rpi );
use HiPi::GPIO;
use RPi::PIGPIO;
use RPi::PIGPIO::Device::DHT22;
use v5.10;

my $gpio = HiPi::GPIO->new;
#write fetched data to csv file
##make sure you have writing permissions to:
my $csv_file = "/var/temp-ng-data.csv";
sub f_write_csv {
    open CSV, '>>:encoding(UTF-8)', $csv_file or die "can't open file: $csv_file";  
    say CSV "$_[0];$_[1];$_[2]"; 
    close CSV;
}

#generate epoc time for csv export
sub f_get_epoc {
    my @l_time =  gmtime;
    #timegm(sec, min, hour, day, month, year)
    my $epoch = timegm( $l_time[0],
                        $l_time[1],
                        $l_time[2],
                        $l_time[3],
                        $l_time[4],
                        $l_time[5] + 1900);
    return $epoch;
}

#using pigpiod to fetch temp and humidity from DHT22
sub f_get_local_data {
    my $local_raspi = RPi::PIGPIO->connect('127.0.0.1');
    my $local_dht22 = RPi::PIGPIO::Device::DHT22->new($local_raspi,17);

    $local_dht22->trigger();
    my @data = ($local_dht22->humidity,$local_dht22->temperature); 

    return @data;
}

#using external loldht binary to fetch temp/humidity
#sub f_get_loldht_data {
#	my $lol_output = `loldht 0`;
#
#    if ( $lol_output =~ /=\s([-\.0-9]+).+=\s([-\.0-9]+)/) {
#        #1: Humidity 2: Temperature
#        my @data = ( $1, $2 );
#        return @data;
#    } else {
#        die 'lol_dht does not provide usefull data';
#    }
#}

#convert to binary number
sub f_get_binary {
	my $binary = sprintf '%05b',$_[0]; 
	return $binary;
}

#set pins to output mode
sub f_init_pins {

    my @led_pin = ( RPI_PIN_12,
                    RPI_PIN_13,
                    RPI_PIN_15,
                    RPI_PIN_16,
                    RPI_PIN_18,
                    RPI_PIN_19,
                    RPI_PIN_21);

    foreach my $pin (@led_pin) {
        $gpio->set_pin_mode($pin, RPI_MODE_OUTPUT);
        $gpio->set_pin_level($pin, RPI_LOW);
    }
}

###main
f_init_pins();

#get data from dht22
my $below_zero = 0;
my $bin_temp = undef;
my @local_data = f_get_local_data();

#set Frost-indikator and maximum temp = 31 degree (2^5)
if ( int($local_data[1]) < 0 ) {
	$below_zero = 1;
	$bin_temp = f_get_binary(abs(int($local_data[1]))); 
}elsif ( int($local_data[1] >= 31 )) {
	$bin_temp = 11111;	
}else {
	$bin_temp = f_get_binary(abs(int($local_data[1]))); 
}

#format data for further use
my @temp_list = split //, $bin_temp;

my %act_temp = ('below_zero' => $below_zero,
                '2_1' => $temp_list[0],
                '2_2' => $temp_list[1],
                '2_4' => $temp_list[2],
                '2_8' => $temp_list[3],
                '2_16' => $temp_list[4] );

#switch the correct leds
if ( $act_temp{'below_zero'} != 0 ) {
	$gpio->set_pin_level(RPI_PIN_19, RPI_HIGH); 
	$gpio->set_pin_level(RPI_PIN_21, RPI_HIGH); 
}
if ( $act_temp{'2_1'} != 0 ) {
	$gpio->set_pin_level(RPI_PIN_18, RPI_HIGH); 
}
if ( $act_temp{'2_2'} != 0 ) {
	$gpio->set_pin_level(RPI_PIN_16, RPI_HIGH); 
}
if ( $act_temp{'2_4'} != 0 ) {
	$gpio->set_pin_level(RPI_PIN_15, RPI_HIGH); 
}
if ( $act_temp{'2_8'} != 0 ) {
	$gpio->set_pin_level(RPI_PIN_13, RPI_HIGH); 
}
if ( $act_temp{'2_16'} != 0 ) {
	$gpio->set_pin_level(RPI_PIN_12, RPI_HIGH); 
}

f_write_csv (f_get_epoc(),$local_data[1],$local_data[0]);

