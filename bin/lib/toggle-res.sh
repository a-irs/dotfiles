#!/usr/bin/env bash

[[ $HOSTNAME == desktop ]] || exit

OUTPUT="DVI-1"
MODE1="1920x1200"
MODE2="1024x640"

[[ -n "$1" ]] && DISPLAY=:0 xrandr --output "$OUTPUT" --mode "$1" && exit

modeline=$(cvt 1024 640 | grep Modeline)
modeline=${modeline/Modeline/}
modeline=${modeline/_60.00/}
mode=$(echo "$modeline" | cut -d" " -f 2)
xrandr --newmode $modeline
xrandr --addmode "$OUTPUT" "$mode"

CURRENT=$(DISPLAY=:0 xrandr -q | awk -F'current' -F',' 'NR==1 {gsub("( |current)","");print $2}')

if [[ "$CURRENT" == "$MODE1" ]]; then
    DISPLAY=:0 xrandr --output "$OUTPUT" --mode "$MODE2"
    echo "changed $OUTPUT to $MODE2"
else
    DISPLAY=:0 xrandr --output "$OUTPUT" --mode "$MODE1"
    echo "changed $OUTPUT to $MODE1"
fi
