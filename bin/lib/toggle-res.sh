#!/usr/bin/env bash

OUTPUT="DVI-0"
MODE_NATIVE="1920x1200"
MODE_COUCH="1280x800"

CURRENT=$(xrandr -q | awk -F'current' -F',' 'NR==1 {gsub("( |current)","");print $2}')

if [[ "$CURRENT" == "$MODE_NATIVE" ]]; then
    xrandr --output "$OUTPUT" --mode "$MODE_COUCH"
    echo "changed $OUTPUT to $MODE_COUCH"
else
    xrandr --output "$OUTPUT" --mode "$MODE_NATIVE"
    echo "changed $OUTPUT to $MODE_NATIVE"
fi
