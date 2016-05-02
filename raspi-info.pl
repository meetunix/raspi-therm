#!/usr/bin/perl

use strict;
use warnings;
use HiPi::Wiring;
use HiPi::RaspberryPi;
use v5.20;


say "\nInformationen zum verwendeten RPi: \n";
my $rInfo = &HiPi::RaspberryPi::get_cpuinfo();

my @rasp_keys = keys %{$rInfo};

foreach (@rasp_keys) {
	printf "%-20s %-20s\n",$_, ${$rInfo}{"$_"};
}	

say "\nInformationen zum verwendeten Board des RPi: \n";


my $rInfo = &HiPi::RaspberryPi::get_piboard_info();

my @rasp_keys = keys %{$rInfo};

foreach (@rasp_keys) {
	printf "%-20s %-20s\n",$_, ${$rInfo}{"$_"};
}	


my @pins = &HiPi::RaspberryPi::get_validpins();

say "\nvalid Pins:\n";

foreach (@pins) {
	say;
}

