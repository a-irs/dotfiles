#!/usr/bin/env bash

celsius=$( echo $(( $(cat /sys/class/thermal/thermal_zone0/temp)/1000 )) )

if [[ "$celsius" -le 49 ]]; then
    color="lightblue"
elif [[ "$celsius" -le 59 ]]; then
    color="white"
elif [[ "$celsius" -le 69 ]]; then
    color="orange"
else
    color="red"
fi

echo "<txt><span weight=\"bold\" fgcolor=\"$color\"> $celsius °C</span></txt>"
