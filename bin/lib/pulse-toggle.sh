#!/usr/bin/env bash

xprop -root | grep PULSE_SERVER | grep -v "$(hostname)" | grep -v localhost &> /dev/null
if [[ $? == 0 ]]; then
    pax11publish -e -r
    echo "now using: local at $(ponymix get-volume 2> /dev/null)%"
else
    pax11publish -e -S desktop
    echo "now using: DESKTOP at $(ponymix get-volume 2> /dev/null)%"
fi
