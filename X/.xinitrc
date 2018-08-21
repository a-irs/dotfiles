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
setxkbmap -option caps:escape
xset r rate 200 30
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

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
# fix for mesa 18, see https://github.com/chjj/compton/issues/477
allow_rgb10_configs=false compton &
start-pulseaudio-x11 &
keepassxc &

if [[ $HOSTNAME == desk ]]; then
    numlockx &
    exo-open /usr/share/applications/com.github.wwmm.pulseeffects.desktop &
    bash -c "$HOME/.bin/wait-for-host spotify.com && exo-open $HOME/.local/share/applications/spotify.desktop && wmctrl -a KeePassXC" &
    if ! mount | grep -q "root@srv.home:/media/data"; then
        bash -c "$HOME/.bin/wait-for-host srv.home && sshfs root@srv.home:/media/data /media/data -o reconnect -o BatchMode=yes -o allow_other && docker start cm_plex_1" &
    fi
fi

session=${1:-awesome}
exec "$session"
