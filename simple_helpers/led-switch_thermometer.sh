#!/bin/bash

# das Skript verwendet das wiringpi executable gpio

# GPIOs des Binärthermometers werden auf Modus output gesetzt

for gpio in `seq 1 5` "12" "13" ; do gpio mode $gpio output ; done

gpio="1"

#Argumente:
case $1 in

	on)
		for gpio in `seq 1 5` "12" "13"
		do
			gpio write $gpio 1
		done
      		;;
	off)
		for gpio in `seq 1 5` "12" "13"
		do
			gpio write $gpio 0
		done
		;;
	blink)	
		for i in `seq 20000`
		do
			sleep 0.3
				
			for gpio in `seq 1 5` "12" "13"
                	do
				sleep 0.3
                        	gpio write $gpio 1
                	done
			
			for gpio in `seq 1 5` "12" "13"
                	do
				sleep 0.3
                        	gpio write $gpio 0
                	done

		done
		;;
	fastblink)	
		for i in `seq 20000`
		do
			for gpio in `seq 1 5` "12" "13"
                	do
				sleep 0.01
                        	gpio write $gpio 1
                	done
			
			
			for gpio in `seq 1 5` "12" "13"
                	do
				sleep 0.01
                        	gpio write $gpio 0
                	done

		done
		;;
	robin)	
		for i in `seq 20000`
		do
			sleep 0.05
				
			for gpio in `seq 1 5` "12" "13"
                	do
				sleep 0.03
                        	gpio write $gpio 1
				sleep 0.03
                        	gpio write $gpio 0
                	done

		done
		;;
	*)
		echo -e "Bitte mit einem Argument verwenden z.B.: \n$0 on \n$0 off \n$0 blink \n$0 fastblink \n$0 robin"
		exit 1
		;;
esac
