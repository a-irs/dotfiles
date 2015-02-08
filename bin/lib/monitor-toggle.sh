#!/bin/bash

INTERNAL='LVDS1'
EXTERNAL='HDMI1'

function ext_on {
    if xrandr --display $EXTERNAL
    then echo "enabled external display"
    fi
}

function ext_off {
    xrandr --output $INTERNAL --auto --output $EXTERNAL --off
    echo "disabled external display"
}

if [ "$1" == "on" ]; then
	ext_on
    exit
fi

if [ "$1" == "off" ]; then
	ext_off
    exit
fi

echo "Parameters: on, off"
