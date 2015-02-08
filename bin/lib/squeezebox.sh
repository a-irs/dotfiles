#!/bin/bash

player="00:04:20:12:de:3e"
host="srv.home"
port="9090"

if [ "$1" == "p" ]; then
	echo "${player} pause
    exit" | nc -w1 ${host} ${port} > /dev/null
else
	ping -c 1 squeezebox.home > /dev/null 2>&1
	if [ "$?" -eq 0 ]; then
		ARTIST=`echo "${player} artist ?
		exit" | nc -w1 ${host} ${port} \
		| cut -f 3 -d ' ' \
		| sed -e "s/\%20/ /g;n" \
		| sed -e "s/\%26/\&/g;n" \
		| sed -e "s/\%5B/\(/g;n" \
		| sed -e "s/\%5D/\)/g;n"`

		TITLE=`echo "${player} title ?
		exit" | nc -w1 ${host} ${port} \
		| cut -f 3 -d ' ' \
		| sed -e "s/\%20/ /g;n" \
		| sed -e "s/\%26/\&/g;n" \
		| sed -e "s/\%5B/\(/g;n" \
		| sed -e "s/\%5D/\)/g;n"`

		# COVER ART
		#wget -O /tmp/cover.jpg http://${host}:9000/music/current/cover.jpg > /dev/null 2>&1
		#convert /tmp/cover.jpg -resize 24x24 /tmp/cover_small.jpg
		#rm /tmp/cover.jpg
		#echo "<img>/tmp/cover_small.jpg</img>"

		# OUTPUT TITLE + ARTIST
		echo "$TITLE ($ARTIST)"
	else
		echo "off"
	fi
fi
