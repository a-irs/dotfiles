#!/usr/bin/env bash

xrandr --output LVDS1 --set "scaling mode" "Center"
xrandr --newmode "1280x720" 74.50 1280 1344 1472 1664 720 723 728 748 -hsync +vsync 2> /dev/null
xrandr --addmode LVDS1 1280x720

amixer -q set Master mute 50%
[[ $(pgrep redshift) ]] || redshift -l 48.7:13.0 -t 5800:3200 -m vidmode -r &
[[ $(pgrep cstats) ]] || cstats &
~/.bin/save-packagelists.sh
