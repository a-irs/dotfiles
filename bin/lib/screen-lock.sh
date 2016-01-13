#!/usr/bin/env bash

# lock

killall i3lock
tmpbg=/tmp/screen.png
icon=~/.bin/lib/screen-lock.png
scrot "$tmpbg" && convert "$tmpbg" -scale 10% -scale 1000% "$tmpbg"
convert "$tmpbg" "$icon" -gravity center -composite -matte "$tmpbg"

i3lock --image="$tmpbg" --show-failed-attempts --ignore-empty-password

(($# == 0)) && exit

# suspend

dropbox-cli stop
mpc pause
killall ncmpcpp

systemctl suspend
