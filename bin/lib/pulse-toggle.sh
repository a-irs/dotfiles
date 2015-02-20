#!/usr/bin/env bash

xprop -root | grep PULSE_SERVER &> /dev/null
if [[ $? == 0 ]]; then
    pax11publish -e -r
else
    pax11publish -e -S desktop
fi
