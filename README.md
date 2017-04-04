# raspi-therm

A very simple binary thermometer for the RaspberryPI. Consists of 5 LED for temperature
and two LED for +/-.

prerequesites:

1. working [lol\_dht22](https://github.com/technion/lol_dht22)
2. working [WiringPi](https://github.com/WiringPi/WiringPi)


how to use:

1.	Set up the database credentials in `wetterdb-setup.pl` and `led-thermo.pl`


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

6.	Run `led-thermo.pl`. The values are written in the postgres-db `wetterdb` 
	and the Thermometer	will show the actual temperature in binary representation.


