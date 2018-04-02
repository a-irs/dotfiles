#!/usr/bin/env bash

if [[ $HOSTNAME == desk ]]; then
    if xrandr | grep "DVI-D-0 connected"; then
        xrandr --output "DisplayPort-0" --off
    fi
fi

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

if [[ $HOSTNAME == desk ]]; then
    numlockx &
    bash -c "$HOME/.bin/wait-for-host spotify.com && exo-open /usr/share/applications/spotify.desktop && wmctrl -a KeePassXC" &
    bash -c "$HOME/.bin/wait-for-host srv.home && sudo mount /media/data && docker start cm_plex_1" &
fi

session=${1:-awesome}
exec "$session"
