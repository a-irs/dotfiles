#!/usr/bin/env bash

set -e

### slower, worse parsing, but can get paused status

windowtitle=$(wmctrl -lx | awk '$3 ~ /spotify.Spotify/{$1=$2=$3=$4=""; print}' | xargs)
[[ $windowtitle ]] || exit
if [[ $windowtitle == "Spotify" ]]; then
    echo ''
    exit
else
    artist=$(echo "$windowtitle" | cut -d- -f 1 | xargs)
    title=$(echo "$windowtitle" | cut -d- -f 2- | xargs)
    echo " <span foreground='#eaa12e'>♫ <b>$title</b> ($artist)</span> "
fi

### faster, better parsing, missing play/pause status

# out=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata')
# title=$(echo "$out" | grep -A 1 xesam:title | tail -1 | cut -d\" -f 2)
# title=${title//&/&amp;}
# artist=$(echo "$out" | grep -A 2 xesam:artist | tail -1 | cut -d\" -f 2)
# artist=${artist//&/&amp;}
# if [[ "$title" && "$artist" ]]; then
#     echo " <span foreground='#eaa12e'>♫ <b>$title</b> ($artist)</span> "
# fi
