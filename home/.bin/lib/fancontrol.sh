#!/usr/bin/env bash

set -e

this_dir="$(dirname "$(readlink -f "$0")")"

[[ $UID != 0 ]] && echo 'run as root' && exit 1

auto-fan() { "$this_dir"/smm-i8kfan 31a3 > /dev/null; }
manual-fan() { "$this_dir"/smm-i8kfan 30a3 > /dev/null; }
fan-0() { i8kfan -1 0 > /dev/null; }
fan-1() { i8kfan -1 1 > /dev/null; }
fan-2() { i8kfan -1 2 > /dev/null; }

manual-fan
while true; do
    cur=$(</sys/class/thermal/thermal_zone0/temp)
    s="current temp: $cur, "
    if [[ "$cur" -lt 70000 ]]; then
        fan-0
        s+='set fan to 0'
        sleep 5
    elif [[ "$cur" -lt 80000 ]]; then
        fan-1
        s+='set fan to 1'
        sleep 20
    else
        fan-2
        s+='set fan to 2'
        echo "$s" | systemd-cat
        sleep 45
    fi
done
auto-fan
