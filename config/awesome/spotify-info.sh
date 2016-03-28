#!/usr/bin/env bash

set -e

color=${1:-ffffff}

### slower, worse parsing, but can get paused status

windowtitle=$(wmctrl -lx | awk '$3 ~ /spotify.Spotify/{$1=$2=$3=$4=""; print}' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
[[ $windowtitle ]] || exit
if [[ $windowtitle == "Spotify" ]]; then
    echo ''
    exit
else
    artist=$(echo "$windowtitle" | cut -d- -f 1 | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    artist=${artist//&/&amp;}
    title=$(echo "$windowtitle" | cut -d- -f 2- | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
    title=${title//&/&amp;}
    echo " <span foreground='#$color'>♫ <b>$title</b> ($artist)</span> "
fi


### faster, better parsing, missing play/pause status
### https://community.spotify.com/t5/Help-Desktop-Linux-Windows-Web/Linux-Spotify-DBus-MPRIS2-support-not-fully-working/td-p/1208249

# out=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata')
# title=$(echo "$out" | grep -A 1 xesam:title | tail -1 | cut -d\" -f 2)
# title=${title//&/&amp;}
# artist=$(echo "$out" | grep -A 2 xesam:artist | tail -1 | cut -d\" -f 2)
# artist=${artist//&/&amp;}
# if [[ "$title" && "$artist" ]]; then
#     echo " <span foreground='#eaa12e'>♫ <b>$title</b> ($artist)</span> "
# fi


### or

# import dbus
# spotify_bus = dbus.SessionBus().get_object("org.mpris.MediaPlayer2.spotify", "/org/mpris/MediaPlayer2")
# spotify_interface = dbus.Interface(spotify_bus, "org.freedesktop.DBus.Properties")
# metadata = spotify_interface.Get("org.mpris.MediaPlayer2.Player", "Metadata")
# title = metadata['xesam:title']
# artist = metadata['xesam:artist'][0]
# print title
# print artist
# ...
