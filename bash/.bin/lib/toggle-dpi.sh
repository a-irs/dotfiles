#!/usr/bin/env bash

set -e

name=${0/$HOME/\~}

f=~/.Xresources
current_dpi=$(grep Xft.dpi "$f" | rev | cut -d ":" -f 1 | tr -d '[:space:]' | rev)

no=96
hi=192
factor=2

if [[ $current_dpi != "$no" ]]; then
    sed --follow-symlinks -i "s|Xft.dpi: .*|Xft.dpi: $no|" "$f"
    cp /usr/share/applications/spotify.desktop ~/.local/share/applications/
    s="switched to → normal $no"
else
    sed --follow-symlinks -i "s|Xft.dpi: .*|Xft.dpi: $hi|" "$f"
    sed -i "s|Exec=spotify .*|Exec=spotify --force-device-scale-factor=$factor %U|" ~/.local/share/applications/spotify.desktop
    s="switched to → HiDPI $hi"
fi

xrdb -merge ~/.Xresources
echo "awesome.restart()" | awesome-client &
sleep 0.2
notify-send "$name" "$s"
