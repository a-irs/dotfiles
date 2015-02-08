#!/bin/bash
declare -i cpuFreq
cpuFreq=$(cat /proc/cpuinfo | grep "cpu MHz" | sed 's/\ \ */ /g' | cut -f3 -d" " | cut -f1 -d"." | head -n 1)
if [ "$cpuFreq" -ge 1000 ]
then
  cpu="$(echo $cpuFreq | cut -c1).$(echo $cpuFreq | cut -c2) GHz"
else
  cpu="${cpuFreq} MHz"
fi
echo "$cpu" 
