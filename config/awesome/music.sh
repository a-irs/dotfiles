#!/usr/bin/env bash

set -e

color=${1:-eaa12e}

### slower, worse parsing, but can get paused status

# windowtitle=$(wmctrl -lx | awk '$3 ~ /spotify.Spotify/{$1=$2=$3=$4=""; print}')
# if [[ $windowtitle ]]; then
#     windowtitle=$(echo -n "$windowtitle" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
# else
#     exit
# fi
#
# if [[ $windowtitle == "Spotify" ]]; then
#     echo -n ''
#     exit
# else
#     artist=$(echo "$windowtitle" | awk -F" - " '{$0=$1}1' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')  #| iconv -f utf-8 -t ascii//translit)
#     artist=${artist//&/&amp;}
#     title=$(echo "$windowtitle" | awk -F" - " '{$0=$2}1' | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')  #| iconv -f utf-8 -t ascii//translit)
#     title=${title//&/&amp;}
    # echo -n " <span foreground='#$color'><b>$title</b> ($artist)</span> "
# fi


### faster, better parsing, missing play/pause status
### https://community.spotify.com/t5/Help-Desktop-Linux-Windows-Web/Linux-Spotify-DBus-MPRIS2-support-not-fully-working/td-p/1208249

out=$(dbus-send --print-reply --session --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:'org.mpris.MediaPlayer2.Player' string:'Metadata')
title=$(echo "$out" | grep -A 1 xesam:title | tail -1 | cut -d\" -f 2)
title=${title//&/&amp;}
artist=$(echo "$out" | grep -A 2 xesam:artist | tail -1 | cut -d\" -f 2)
artist=${artist//&/&amp;}
if [[ "$title" && "$artist" ]]; then
    echo " <span foreground='#$color'>♫ <b>$title</b> ($artist)</span> "
fi


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
