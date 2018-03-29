#!/usr/bin/perl

use strict;
use warnings;
use HiPi::RaspberryPi;
use v5.10;

my $pi = HiPi::RaspberryPi->new();
print $pi->dump_board_info;
