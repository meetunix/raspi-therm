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
			'warning-low-temp=s'			=> \$arg_w_low_temp,
			'critical-low-temp=s'			=> \$arg_c_low_temp,
			'warning-high-temp|W=s' 		=> \$arg_w_high_temp,
			'critical--high-temp|C=s'	    => \$arg_c_high_temp );

sub f_show_help {
print <<"EOF";

Aufruf: $0 [-w TEMP] [-c TEMP] [-W TEMP] [-C TEMP] [-h]

Check Humidity!

Icinga/Nagios-Plugin for raspi-temp.

-w | --warning-low-temp
-c | --critical-low-temp
-W | --warning-high-temp
-C | --critical-high-temp
-h | --help

Use long options in icinga service description!
	
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

if (($act_temp le $arg_w_low_temp) or ($act_temp ge $arg_w_high_temp)) {
    print "WARNING - " . $perf_text;
    exit 1;
} elsif (($act_temp le $arg_c_low_temp) or ($act_temp ge $arg_c_high_temp)) {
    print "CRITICAL - " . $perf_text;
    exit 2;
} else {
    print "OK - " . $perf_text;
    exit 0;
}
