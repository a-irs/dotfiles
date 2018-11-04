#!/usr/bin/env bash

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

# blank screen after 5min
xset s 300 300 &

# applications
nitrogen --restore &
kupfer --no-splash &
lxpolkit &
redshift &
parcellite --no-icon &
compton &
keepassxc &

start-pulseaudio-x11 &

# wait for internet, then launch dropbox
if [[ -n "$commands[dropbox-cli]" ]]; then
    nohup bash -c "$HOME/.bin/wait-for-host dropbox.com && dropbox-cli start" < /dev/null &> /dev/null &
fi

if [[ $HOSTNAME == x1 ]]; then
    pulseeffects --gapplication-service &
    xset s 60 60 &
    xss-lock -n "notify-send -- locking soon" ~/.bin/lock &
    ~/.bin/workstats &
fi

if [[ $HOSTNAME == desk ]]; then
    numlockx &
    pulseeffects --gapplication-service &
    bash -c "$HOME/.bin/wait-for-host spotify.com && exo-open $HOME/.local/share/applications/spotify.desktop && wmctrl -a KeePassXC" &
    if ! mount | grep -q "root@srv.home:/media/data"; then
        bash -c "$HOME/.bin/wait-for-host srv.home && sshfs root@srv.home:/media/data /media/data -o reconnect -o BatchMode=yes -o allow_other && docker restart cm_plex_1" &
    fi
fi

exec awesome
