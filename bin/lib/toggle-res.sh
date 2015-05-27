#!/usr/bin/env bash

set -e

[[ $HOSTNAME == desktop ]] || exit

OUTPUT="DVI-1"
MODE1="1920x1200"
MODE2="1440x900"
MODE3="1280x800"

[[ -n "$1" ]] && DISPLAY=:0 xrandr --output "$OUTPUT" --mode "$1" && exit

CURRENT=$(DISPLAY=:0 xrandr -q | awk -F'current' -F',' 'NR==1 {gsub("( |current)","");print $2}')

if [[ "$CURRENT" == "$MODE1" ]]; then
    DISPLAY=:0 xrandr --output "$OUTPUT" --mode "$MODE2"
    echo "changed $OUTPUT to $MODE2"
elif [[ "$CURRENT" == "$MODE2" ]]; then
    DISPLAY=:0 xrandr --output "$OUTPUT" --mode "$MODE3"
    echo "changed $OUTPUT to $MODE3"
else
    DISPLAY=:0 xrandr --output "$OUTPUT" --mode "$MODE1"
    echo "changed $OUTPUT to $MODE1"
fi
