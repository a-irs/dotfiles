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

# screen
xset -dpms &
xset s off &

# applications
nitrogen --restore &
kupfer --no-splash &
lxpolkit &
redshift &
parcellite --no-icon &
mkdir -p ~/.thumbnails && ln -sf ~/.thumbnails ~/.cache/thumbnails
compton &
start-pulseaudio-x11 &
keepassxc &

# wait for internet
~/.bin/wait-for-host dropbox.com && dropbox-cli start &
if [[ $HOSTNAME == desk ]]; then
    numlockx &
    ~/.bin/wait-for-host spotify.com && exo-open /usr/share/applications/spotify.desktop &
fi

session=${1:-awesome}
exec "$session"
