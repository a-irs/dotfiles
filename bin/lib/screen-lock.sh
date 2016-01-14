#!/usr/bin/env bash

# lock

logger "preparing screenshot"
killall i3lock
tmpbg=/tmp/screen.png
icon=~/.bin/lib/screen-lock.png
scrot -z -q 100 "$tmpbg"
convert -limit thread 2 "$tmpbg" -scale 10% -scale 1000% -strip "$tmpbg"
convert -limit thread 2 "$tmpbg" "$icon" -gravity center -composite -matte "$tmpbg"

logger "locking screen"
i3lock --image="$tmpbg" --show-failed-attempts --ignore-empty-password
rm -f "$tmpbg"


(($# == 0)) && exit

# suspend

logger "stopping services"
mpc pause
killall ncmpcpp
dropbox-cli stop

logger "suspending"
systemctl suspend
