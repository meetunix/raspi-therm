#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long qw(GetOptions);
use RPi::PIGPIO;
use RPi::PIGPIO::Device::DHT22;

my $pi;
my $dht22;
my $act_temp;

my $arg_help;
my $arg_w_low_temp  = 12;
my $arg_c_low_temp  = 16;
my $arg_w_high_temp = 26;
my $arg_c_high_temp = 30;

GetOptions(	'help'			                => \$arg_help,
			'critical-low-temp|a=s'			=> \$arg_c_low_temp,
			'warning-low-temp|b=s'			=> \$arg_w_low_temp,
			'warning-high-temp|x=s' 		=> \$arg_w_high_temp,
			'critical--high-temp|y=s'	    => \$arg_c_high_temp );

sub f_show_help {
print <<"EOF";

Aufruf: $0 [-w TEMP] [-c TEMP] [-W TEMP] [-C TEMP] [-h]

Check Temperature!

Icinga/Nagios-Plugin for raspi-temp.

-a | --critical-low-temp
-b | --warning-low-temp
-x | --warning-high-temp
-y | --critical-high-temp
-h | --help

Use long options in icinga service description!
	
           (a)          (b)      (x)           (y)
--low-crit--|--low-warn--|--norm--|--high-warn--|--high-crit

EOF
}

if (defined $arg_help) {
    f_show_help;
    exit 0;
}

$pi = RPi::PIGPIO->connect('127.0.0.1');
$dht22 = RPi::PIGPIO::Device::DHT22->new($pi,17);
$dht22->trigger();

$act_temp = $dht22->temperature;
my $perf_text = "Temperature: $act_temp °C\n";

if (($act_temp < $arg_w_low_temp) && ($act_temp > $arg_c_low_temp )) {
    print "WARNING - " . $perf_text;
    exit 1;
} elsif (($act_temp < $arg_w_low_temp) && ($act_temp < $arg_c_low_temp )) {
    print "CRITICAL - " . $perf_text;
    exit 2;
} elsif (($act_temp > $arg_w_high_temp) && ($act_temp < $arg_c_high_temp )) {
    print "WARNING - " . $perf_text;
    exit 1;
} elsif (($act_temp > $arg_w_high_temp) && ($act_temp > $arg_c_high_temp )) {
    print "CRITICAL - " . $perf_text;
    exit 2;
} else {
    print "OK - " . $perf_text;
    exit 0;
}


