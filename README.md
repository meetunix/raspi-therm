# raspi-therm

A very simple binary thermometer for the RaspberryPI. Consists of 5 LED for temperature
and two LED for +/-. 

**prerequesites:**

1. working [pigpio-daemon](http://abyz.me.uk/rpi/pigpio/index.html)

        # sudo apt-get update
        # sudo apt-get install pigpio python-pigpio python3-pigpio

        # systemctl start pigpiod.service
        # systemctl enable pigpiod.service

Without any configuration, pigpio is listen only on localhost at port 8888 (tcp).

2. [HiPi Perl module](http://hipi.znix.com/install.html) 
        
3. [RPi::PIGPIO::Device::DHT22 Perl Module](https://metacpan.org/pod/RPi::PIGPIO::Device::DHT22)

simple install with cpanminus

        # cpanm RPi::PIGPIO::Device::DHT22

**how to use:**

1.	Set up the database credentials in `wetterdb-setup.pl` and `raspi-therm.pl`


		###################                                                                          
		my $dbname              = "wetterdb";                                                        
		my $dbuser              = "wetter";                                                          
		my $dbhost              = "192.168.42.72";                                                   
		my $dbpassword          = "password";                                                        
		###################                              

2.	Set up postgresql dbms 

3.	Create database with `wetterdb-setup.pl`

4.	Connect the DHT22 (or DHT11)

		CONNECTION		PIN		WiPi	GPIO
		DHT-3.3 V		17
		DHT-DATA		11		0	17
		DHT-ground		20

5.	Connect the LED, 5 for binary representation of the temperature in °Celsius and
	2 LED for the indication of negative °Celsius


		binary		PIN	WiPi	GPIO	BCM2135
		1		12	1	18	12
		2		13	2	21	13
		4		15	3	22	15
		8		16	4	23	16
		16		18	5	24	18

		-°Celsius	19	12	10	19	
		-°Celsius	21	13	9	21

6.	Run `raspi-therm.pl`. The values are written in the postgres-db `wetterdb` 
	and the Thermometer	will show the actual temperature in binary representation.

7. Configure the cron-daemon:

        0-55/5  *       *       *       *       /opt/raspi-therm/raspi-therm.pl


