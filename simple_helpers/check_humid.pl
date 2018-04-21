#!/usr/bin/env perl

use strict;
use warnings;
use Getopt::Long qw(GetOptions);
use RPi::PIGPIO;
use RPi::PIGPIO::Device::DHT22;

my $pi;
my $dht22;
my $act_humid;

my $arg_help;
my $arg_w_low_humid  = 35;
my $arg_c_low_humid  = 30;
my $arg_w_high_humid = 60;
my $arg_c_high_humid = 65;

GetOptions(	'help'			                => \$arg_help,
			'critical-low-humid|a=s'		=> \$arg_c_low_humid,
			'warning-low-humid|b=s'			=> \$arg_w_low_humid,
			'warning-high-humid|x=s' 		=> \$arg_w_high_humid,
			'critical--high-humid|y=s'	    => \$arg_c_high_humid );

sub f_show_help {
print <<"EOF";

Aufruf: $0 [-w HUMID] [-c HUMID] [-W HUMID] [-C HUMID] [-h]

Check Humidity!

Icinga/Nagios-Plugin for raspi-humid.

-a | --critical-low-humid
-b | --warning-low-humid
-x | --warning-high-humid
-y | --critical-high-humid
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

$act_humid = $dht22->humidity;
my $perf_text = "Humidity: $act_humid %\n";

$act_humid = 53;

if (($act_humid < $arg_w_low_humid) && ($act_humid > $arg_c_low_humid )) {
    print "WARNING - " . $perf_text;
    exit 1;
} elsif (($act_humid < $arg_w_low_humid) && ($act_humid < $arg_c_low_humid )) {
    print "CRITICAL - " . $perf_text;
    exit 2;
} elsif (($act_humid > $arg_w_high_humid) && ($act_humid < $arg_c_high_humid )) {
    print "WARNING - " . $perf_text;
    exit 1;
} elsif (($act_humid > $arg_w_high_humid) && ($act_humid > $arg_c_high_humid )) {
    print "CRITICAL - " . $perf_text;
    exit 2;
} else {
    print "OK - " . $perf_text;
    exit 0;
}


