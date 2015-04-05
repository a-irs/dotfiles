#!/usr/bin/env bash

remote=desktop

ping -c 1 "$remote" &> /dev/null
[ $? -ne 0 ] && echo "not reachable, exiting" && exit 1

xprop -root | grep PULSE_SERVER | grep -v "$(hostname)" | grep -v localhost &> /dev/null
if [[ $? == 0 ]]; then
    pax11publish -e -r
    echo "now using: local at $(ponymix get-volume 2> /dev/null)%"
else
    pax11publish -e -S "$remote"
    echo "now using: $remote at $(ponymix get-volume 2> /dev/null)%"
    ponymix unmute > /dev/null
fi

echo ""
ponymix
