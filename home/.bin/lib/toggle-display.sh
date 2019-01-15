#!/usr/bin/env bash

[[ $HOSTNAME == desk ]] || exit

A="DVI-D-0 connected 1920x1200+0+0 (normal left inverted right x axis y axis)"
B="DisplayPort-0 connected primary 2560x1440+0+0 (normal left inverted right x axis y axis)"
if xrandr | grep -q "$A"; then
    off=$(echo "$A" | awk '{print $1}')
    on=$(echo "$B" | awk '{print $1}')
else
    off=$(echo "$B" | awk '{print $1}')
    on=$(echo "$A" | awk '{print $1}')
fi

echo "$on --> $off"
xrandr --output "$on" --auto && xrandr --output "$off" --off

echo 'awesome.restart()' | awesome-client
nitrogen --restore
