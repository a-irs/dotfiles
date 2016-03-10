#!/usr/bin/env bash

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        source "$f"
    done
    unset f
fi

setxkbmap -option caps:escape
xset r rate 200 30
xrdb -merge ~/.Xresources

session=${1:-awesome}
exec "$session"
