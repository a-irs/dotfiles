#!/usr/bin/env bash

icon=~/.bin/lib/screen-lock.png
tmpbg=/tmp/screen.png

scrot "$tmpbg"
convert "$tmpbg" -scale 10% -scale 1000% "$tmpbg"
convert "$tmpbg" "$icon" -gravity center -composite -matte "$tmpbg"

i3lock -e -i "$tmpbg"

(($# == 0)) && exit

systemctl suspend

sleep 3
xset r rate 200 30
