#!/usr/bin/perl
use Device::BCM2835;
use strict;
use warnings;

Device::BCM2835::init() || die "Could not init library";

# Set RPi pin P1_19 to be an output
Device::BCM2835::gpio_fsel(&Device::BCM2835::RPI_GPIO_P1_21,&Device::BCM2835::BCM2835_GPIO_FSEL_OUTP);
Device::BCM2835::gpio_fsel(&Device::BCM2835::RPI_GPIO_P1_19,&Device::BCM2835::BCM2835_GPIO_FSEL_OUTP);
Device::BCM2835::gpio_fsel(&Device::BCM2835::RPI_GPIO_P1_18,&Device::BCM2835::BCM2835_GPIO_FSEL_OUTP);
Device::BCM2835::gpio_fsel(&Device::BCM2835::RPI_GPIO_P1_16,&Device::BCM2835::BCM2835_GPIO_FSEL_OUTP);
Device::BCM2835::gpio_fsel(&Device::BCM2835::RPI_GPIO_P1_15,&Device::BCM2835::BCM2835_GPIO_FSEL_OUTP);
#folgender PIN funktioniert nicht:
Device::BCM2835::gpio_fsel(&Device::BCM2835::RPI_GPIO_P1_13,&Device::BCM2835::BCM2835_GPIO_FSEL_OUTP);
Device::BCM2835::gpio_fsel(&Device::BCM2835::RPI_GPIO_P1_12,&Device::BCM2835::BCM2835_GPIO_FSEL_OUTP);

while (1) { # Strobe
	Device::BCM2835::gpio_write(&Device::BCM2835::RPI_GPIO_P1_21, 1);
	Device::BCM2835::gpio_write(&Device::BCM2835::RPI_GPIO_P1_19, 1);
	Device::BCM2835::gpio_write(&Device::BCM2835::RPI_GPIO_P1_18, 1);
	Device::BCM2835::gpio_write(&Device::BCM2835::RPI_GPIO_P1_16, 1);
	Device::BCM2835::gpio_write(&Device::BCM2835::RPI_GPIO_P1_15, 1);
	Device::BCM2835::gpio_write(&Device::BCM2835::RPI_GPIO_P1_13, 1);
	Device::BCM2835::gpio_write(&Device::BCM2835::RPI_GPIO_P1_12, 1);
	Device::BCM2835::delay(500);
	Device::BCM2835::gpio_write(&Device::BCM2835::RPI_GPIO_P1_21, 0);
	Device::BCM2835::gpio_write(&Device::BCM2835::RPI_GPIO_P1_19, 0);
	Device::BCM2835::gpio_write(&Device::BCM2835::RPI_GPIO_P1_18, 0);
	Device::BCM2835::gpio_write(&Device::BCM2835::RPI_GPIO_P1_16, 0);
	Device::BCM2835::gpio_write(&Device::BCM2835::RPI_GPIO_P1_15, 0);
	Device::BCM2835::gpio_write(&Device::BCM2835::RPI_GPIO_P1_13, 0);
	Device::BCM2835::gpio_write(&Device::BCM2835::RPI_GPIO_P1_12, 0);
	Device::BCM2835::delay(500);
}
