#!/usr/bin/env bash

OUTPUT="DVI-1"
MODE_NATIVE="1920x1200"
MODE_COUCH="1280x800"

[[ -n "$1" ]] && DISPLAY=:0 xrandr --output "$OUTPUT" --mode "$1" && exit

CURRENT=$(DISPLAY=:0 xrandr -q | awk -F'current' -F',' 'NR==1 {gsub("( |current)","");print $2}')

if [[ "$CURRENT" == "$MODE_NATIVE" ]]; then
    DISPLAY=:0 xrandr --output "$OUTPUT" --mode "$MODE_COUCH"
    echo "changed $OUTPUT to $MODE_COUCH"
else
    DISPLAY=:0 xrandr --output "$OUTPUT" --mode "$MODE_NATIVE"
    echo "changed $OUTPUT to $MODE_NATIVE"
fi
