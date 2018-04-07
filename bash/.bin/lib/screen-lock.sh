#!/usr/bin/env bash

if keepassxc; then
    sleep 0.2
    xdotool keydown Ctrl key l keyup Ctrl
fi

killall i3lock
i3lock --image="$HOME/.bin/lib/screen-lock.png" --tiling --color=263657 --show-failed-attempts --ignore-empty-password

[[ "$1" == suspend ]] && systemctl suspend
