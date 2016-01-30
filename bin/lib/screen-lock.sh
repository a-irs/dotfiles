#!/usr/bin/env bash

# lock

killall i3lock
icon=~/.bin/lib/screen-lock.png

logger "locking screen"
i3lock --image="$icon" --tiling --color=303E5B --show-failed-attempts --ignore-empty-password


(($# == 0)) && exit

# suspend

logger "stopping services"
mpc pause 2> /dev/null
killall ncmpcpp 2> /dev/null
dropbox-cli stop

logger "suspending"
systemctl suspend
