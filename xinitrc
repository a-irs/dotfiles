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
[[ $HOSTNAME == desktop ]] && numlockx &

# screen
xset -dpms &
xset s off &

# applications
nitrogen --restore &
kupfer --no-splash &
pcmanfm --daemon-mode &
lxpolkit &
redshift &
dropbox-cli start &
mkdir -p ~/.thumbnails &
ln -sf ~/.thumbnails ~/.cache/thumbnails &
compton &
start-pulseaudio-x11 &
[[ $HOSTNAME == dell ]] && nm-applet &

session=${1:-awesome}
exec "$session"
