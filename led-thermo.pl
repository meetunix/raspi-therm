#!/usr/bin/perl
#Raspberrypi: LED-Digitalthermometer
use strict;
use warnings;
use HiPi::Wiring;
use Time::Local;
use v5.10;
use DBD::Pg;

###################
my $dbname              = "wetterdb";
my $dbuser              = "wetter";
my $dbhost              = "192.168.42.72";
my $dbpassword          = "password";
###################

#functions
my $csv_file = "/var/loldata.csv";
sub f_write_csv {
        open CSV, '>>:encoding(UTF-8)', $csv_file or die "can't open file: $csv_file";  
        say CSV "$_[0];$_[1];$_[2]"; 
        close CSV;

}

sub f_get_epoc {
        my @l_time =  gmtime;
        #timegm(sec, min, hour, day, month, year)
        my $epoch = timegm($l_time[0],$l_time[1],$l_time[2],$l_time[3],$l_time[4],$l_time[5] + 1900);
        return $epoch
}

sub f_get_loldht_data {
	my $lol_output = `loldht 0`;
        if ( $lol_output =~ /=\s([-\.0-9]+).+=\s([-\.0-9]+)/) {
                #1: Humidity 2: Temperature
                my @data = ( $1, $2 );
                return @data;
        } else {
                die 'lol_dht does not provide usefull data';
        }
}
#database functions
#f_write_db (EPOCH, TEMP, HUMID)
sub f_write_db {
	#db-connect
	my $dbh = DBI->connect("dbi:Pg:dbname=$dbname;host=$dbhost","$dbuser","$dbpassword" , {AutoCommit => 1}) or die $DBI::errstr;
	my $curr_epoch = $_[0];
        my $curr_temp = $_[1];
        my $curr_humid = $_[2];
	my @hr_time =  gmtime($curr_epoch); #all times in UTC
        my $curr_time = sprintf("%04d-%02d-%02d %02d:%02d:%02d\n", $hr_time[5] + 1900, $hr_time[4]+1, $hr_time[3], $hr_time[2], $hr_time[1], $hr_time[0]);
	#write dataset to db    
	my $rv = $dbh->do("INSERT INTO wetterdaten (epoch,time,temp,humid) VALUES ('$curr_epoch','$curr_time','$curr_temp','$curr_humid');");
	$dbh->disconnect;
}

sub f_get_binary {
	my $binary = sprintf '%05b',$_[0]; 
	return $binary;
}

#initialize wiringpi and my pins
&HiPi::Wiring::wiringPiSetup();
my @led_pin = ( 1..5,12,13 );
foreach my $pin (@led_pin) {
        &HiPi::Wiring::pinMode ($pin, 1);
}

#get data from dht22
my $below_zero = 0;
my $bin_temp = undef;

my @lol_data = f_get_loldht_data();
#my @lol_data = qw(74 5);

#set Frost-indikator and maximum temp = 31 degree (2^5)
if ( int($lol_data[1]) < 0 ) {
	$below_zero = 1;
	$bin_temp = f_get_binary(abs(int($lol_data[1]))); 
}elsif ( int($lol_data[1] >= 31 )) {
	$bin_temp = 11111;	
}else {
	$bin_temp = f_get_binary(abs(int($lol_data[1]))); 
}


#format data for further use
my @temp_list = split //, $bin_temp;

my %act_temp = ('below_zero' => $below_zero,
		'2_1' => $temp_list[0],
		'2_2' => $temp_list[1],
		'2_4' => $temp_list[2],
		'2_8' => $temp_list[3],
		'2_16' => $temp_list[4] );

#switch all leds off
foreach my $pin (@led_pin) {
	&HiPi::Wiring::digitalWrite($pin, 0); 
}

#switch the right leds
if ( $act_temp{'below_zero'} != 0 ) {
	&HiPi::Wiring::digitalWrite(12, 1); 
	&HiPi::Wiring::digitalWrite(13, 1); 
}
if ( $act_temp{'2_1'} != 0 ) {
	&HiPi::Wiring::digitalWrite(5, 1); 
}
if ( $act_temp{'2_2'} != 0 ) {
	&HiPi::Wiring::digitalWrite(4, 1); 
}
if ( $act_temp{'2_4'} != 0 ) {
	&HiPi::Wiring::digitalWrite(3, 1); 
}
if ( $act_temp{'2_8'} != 0 ) {
	&HiPi::Wiring::digitalWrite(2, 1); 
}
if ( $act_temp{'2_16'} != 0 ) {
	&HiPi::Wiring::digitalWrite(1, 1); 
}

my $epoch_time = f_get_epoc();

f_write_csv ($epoch_time,$lol_data[1],$lol_data[0]);

f_write_db ($epoch_time,$lol_data[1],$lol_data[0]);
