#!/bin/bash

#extrem einfaches Skript, was eine HTML Datei erzeugt und Werte aus loldht verwendet

HTML_FILE=/var/www/static/index.html
LOL_DHT=/home/uschy/lol_dht22/loldht

LOL_OUTPUT=$($LOL_DHT 0 | grep Hum)

TEMP=$(echo $LOL_OUTPUT | cut -d "=" -f 3 | cut -d "*" -f 1)
HUMI=$(echo $LOL_OUTPUT | cut -d "=" -f 2 | cut -d "%" -f 1)
TIME=$(date "+%T")
DATE=$(date "+%d.%m.%Y")


echo '<html>' > $HTML_FILE
echo '<head>' >> $HTML_FILE
echo '<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>' >> $HTML_FILE
echo '<title>Wetterstation</title>' >> $HTML_FILE
echo '</head>' >> $HTML_FILE
echo '<body style="font-size:250%">' >> $HTML_FILE
echo "<p align=\"center\"><b>Datum: $DATE </b></p>" >> $HTML_FILE
echo "<p align=\"center\"><b>Uhrzeit: $TIME </b></p>" >> $HTML_FILE
echo "<p align=\"center\">Temperatur: $TEMP °C</p>" >> $HTML_FILE
echo "<p align=\"center\">rel. Luftfeuchte: $HUMI %</p>" >> $HTML_FILE
echo '</body>' >> $HTML_FILE
echo '</html>' >> $HTML_FILE
