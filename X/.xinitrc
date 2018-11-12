#!/usr/bin/env bash

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        source "$f"
    done
    unset f
fi

[[ $HOSTNAME == x1 ]] && xcalib ~/.config/x1carbon3rd_notebookcheck.com.icc &

# keyboard
setxkbmap -option caps:escape
xset r rate 200 30

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

xset s 0 0
# turn off after 10m
xset dpms 600 600 600

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
nohup bash -c "$HOME/.bin/wait-for-host dropbox.com && dropbox-cli start" < /dev/null &> /dev/null &

if [[ $HOSTNAME == x1 || $HOSTNAME == dell ]]; then
    xset s 0 0
    # turn off after 5m
    xset dpms 300 300 300
    xss-lock --transfer-sleep-lock -n "notify-send -i /usr/share/icons/Faba/48x48/actions/system-lock-screen.svg -- locking" -- ~/.bin/lock &
fi

if [[ $HOSTNAME == x1 ]]; then
    pulseeffects --gapplication-service &
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
