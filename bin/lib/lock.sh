#!/bin/sh

SSID=$(iwgetid --raw)
CURRENT_RES=`xrandr | grep HDMI2 | cut -d ' ' -f 3`
INTERNAL_RES="1280x800"
EXTERNAL_RES="1360x768"

if [[ "$CURRENT_RES" != $EXTERNAL_RES* ]]; then
	if [[ "$SSID" != "tpl" && "$SSID" != "fb" && "$SSID" != "TPL" ]]; then
		echo "not at home"
		echo "internal display active, locking screen."
		sleep 3
		slimlock
	else
		echo "at home, not locking."
	fi
else
	echo "external display connected"
#    amixer set Master unmute
#	/usr/bin/xbmc
fi
