#!/usr/bin/perl

#use strict;
use warnings;
use HiPi::Wiring;
use v5.20;

say "$0 works only with root privileges";

#initialize wiringpi and my pins
&HiPi::Wiring::wiringPiSetup();
my @led_pin = ( 1..5,12,13 );
#get arguments for further use
if ( @ARGV < 1 ) {
	die "\nEs wird eines der folgenden Argumente benötigt: on, off\n";
}
my $arg = shift @ARGV; 
foreach my $pin (@led_pin) {
	&HiPi::Wiring::pinMode ($pin, 1);
}


#main
if ( $arg  eq "on") {
	foreach my $pin (@led_pin) {
		&HiPi::Wiring::digitalWrite($pin, 1);
	}
}elsif ( $arg eq "off") {
	foreach my $pin (@led_pin) {
		&HiPi::Wiring::digitalWrite($pin, 0);
	}
}elsif ( $arg eq "blink" ) {
	while (1) {
		foreach my $pin (@led_pin) {
			&HiPi::Wiring::digitalWrite($pin, 1);
		}
		&HiPi::Wiring::delay(500);
		foreach my $pin (@led_pin) {
			&HiPi::Wiring::digitalWrite($pin, 0); 
        	}	
		&HiPi::Wiring::delay(500);
	}
}

