#!/usr/bin/perl

#use strict;
use warnings;
use HiPi::GPIO;
use Time::HiRes;
use HiPi qw( :rpi ); # constants like RPI_MODE_OUTPUT
use v5.10;

#initialize wiringpi and my pins
my $gpio = HiPi::GPIO->new;

my @led_pin = ( RPI_PIN_12,
                RPI_PIN_13,
                RPI_PIN_15,
                RPI_PIN_16,
                RPI_PIN_18,
                RPI_PIN_19,
                RPI_PIN_21);
#get arguments for further use
if ( @ARGV < 1 ) {
    die "\nEs wird eines der folgenden Argumente benötigt: on, off, blink\n";
}
my $arg = shift @ARGV; 
foreach my $pin (@led_pin) {
    $gpio->set_pin_mode($pin, RPI_MODE_OUTPUT);
}

if ( $arg  eq "on") {
    say "LEDs are going up ...";
    foreach my $pin (@led_pin) {
        $gpio->set_pin_level($pin, 1);
    }
}elsif ( $arg eq "off") {
    say "LEDs are going down ...";
    foreach my $pin (@led_pin) {
        $gpio->set_pin_level($pin, 0);
    }
}elsif ( $arg eq "blink" ) {
    while (1) {
    say "LEDs are going blink forever (use CTRL-C to stop)";
        foreach my $pin (@led_pin) {
            $gpio->set_pin_level($pin, 1);
        }
        Time::HiRes::usleep(300_000);
        foreach my $pin (@led_pin) {
            $gpio->set_pin_level($pin, 0); 
        }	
        Time::HiRes::usleep(300_000);
    }
}

