#!/usr/bin/env bash

# lock

tmpbg=/tmp/screen.png
scrot "$tmpbg" && convert "$tmpbg" -scale 10% -scale 1000% "$tmpbg"
i3lock --image="$tmpbg" --show-failed-attempts --ignore-empty-password

(($# == 0)) && exit

# suspend

dropbox-cli stop
mpc pause
killall ncmpcpp

systemctl suspend
