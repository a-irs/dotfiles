#!/usr/bin/env bash

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        source "$f"
    done
    unset f
fi

# keyboard
setxkbmap -option caps:escape &
xset r rate 200 30 &
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources &
[[ $HOSTNAME == desk ]] && numlockx &

# screen
xset -dpms &
xset s off &

# applications
nitrogen --restore &
kupfer --no-splash &
lxpolkit &
redshift &
parcellite --no-icon &
dropbox-cli start &
mkdir -p ~/.thumbnails && ln -sf ~/.thumbnails ~/.cache/thumbnails
compton &
start-pulseaudio-x11 &
keepassxc &
~/.bin/wait-for-host 8.8.8.8 spotify &

session=${1:-awesome}
exec "$session"
