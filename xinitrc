#!/usr/bin/env bash

#if [ -d /etc/X11/xinit/xinitrc.d ]; then
#    for f in /etc/X11/xinit/xinitrc.d/*; do
#        [ -x "$f" ] && [[ "$f" != "40-libcanberra-gtk-module.sh" ]] && source "$f"
#    done
#    unset f
#fi

xset r rate 200 30
xrdb -merge ~/.Xresources
exec dbus-launch --sh-syntax --exit-with-session awesome
