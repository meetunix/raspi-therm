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
			'warning-low-humid=s'			=> \$arg_w_low_humid,
			'critical-low-humid=s'			=> \$arg_c_low_humid,
			'warning-high-humid|W=s' 		=> \$arg_w_high_humid,
			'critical--high-humid|C=s'	    => \$arg_c_high_humid );

sub f_show_help {
print <<"EOF";

Aufruf: $0 [-w HUMID] [-c HUMID] [-W HUMID] [-C HUMID] [-h]

Check Humidity!

Icinga/Nagios-Plugin for raspi-humid.

-w | --warning-low-humid
-c | --critical-low-humid
-W | --warning-high-humid
-C | --critical-high-humid
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

$act_humid = $dht22->humidity;
my $perf_text = "Humidity: $act_humid %\n";

if (($act_humid le $arg_w_low_humid) or ($act_humid ge $arg_w_high_humid)) {
    print "WARNING - " . $perf_text;
    exit 1;
} elsif (($act_humid le $arg_c_low_humid) or ($act_humid ge $arg_c_high_humid)) {
    print "CRITICAL - " . $perf_text;
    exit 2;
} else {
    print "OK - " . $perf_text;
    exit 0;
}
