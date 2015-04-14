#!/usr/bin/env bash

ssid=$(iwgetid --raw)

if [[ "$ssid" == tpl ]]; then
    nmcli connection up HITRON-ABE0 >/dev/null && echo "$(tput bold)now connected to 'HITRON-ABE0'"
else
    nmcli connection up tpl >/dev/null && echo "$(tput bold)now connected to 'tpl'"
fi
