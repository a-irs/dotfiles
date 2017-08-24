#!/usr/bin/env bash

set -e

f=~/.Xresources
value=$(grep Xft.dpi "$f" | rev | cut -d ":" -f 1 | tr -d '[:space:]' | rev)

no=96
hi=144
factor=1.5

printf "%s\n" "current DPI: $value"
if [[ $value == "$hi" ]]; then
    sed --follow-symlinks -i "s|Xft.dpi: .*|Xft.dpi: $no|" "$f"
    sudo sed -i "s|Exec=spotify .*|Exec=spotify %U|" /usr/share/applications/spotify.desktop
    echo "Xresources: HiDPI $hi → normal $no"
elif [[ $value == "$no" ]]; then
    sed --follow-symlinks -i "s|Xft.dpi: .*|Xft.dpi: $hi|" "$f"
    sudo sed -i "s|Exec=spotify .*|Exec=spotify --force-device-scale-factor=$factor %U|" /usr/share/applications/spotify.desktop
    echo "Xresources: normal $no → HiDPI $hi"
fi

xrdb -merge ~/.Xresources
echo "awesome.restart()" | awesome-client
