#!/usr/bin/env bash

set -e

f=~/.Xresources
value=$(grep Xft.dpi "$f" | rev | cut -d ":" -f 1 | tr -d '[[:space:]]' | rev)

hi=144
no=96

if [[ $value == "$hi" ]]; then
    sed --follow-symlinks -i "s|Xft.dpi: $hi|Xft.dpi: $no|" "$f"
    echo "Xresources: HiDPI → normal"
elif [[ $value == "$no" ]]; then
    sed --follow-symlinks -i "s|Xft.dpi: $no|Xft.dpi: $hi|" "$f"
    echo "Xresources: normal → HiDPI"
fi

echo "awesome.quit()" | awesome-client

