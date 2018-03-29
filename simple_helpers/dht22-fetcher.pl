#!/usr/bin/env perl

use strict;
use warnings;
use v5.10;
use RPi::PIGPIO;
use RPi::PIGPIO::Device::DHT22;

my $pi = RPi::PIGPIO->connect('127.0.0.1');

my $dht22 = RPi::PIGPIO::Device::DHT22->new($pi,17);

$dht22->trigger(); #trigger a read

my $act_temp = $dht22->temperature;
my $act_humi = $dht22->humidity;

say "Temperature: " . $act_temp;
say "Humidity: " .  $act_humi;




