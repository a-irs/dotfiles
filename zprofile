if [ -n "$commands[startx]" ]; then
    dpi=$(grep "Xft.dpi" ~/.Xresources | cut -d ":" -f 2 | tr -d "[[:space:]]")
    [[ -z $DISPLAY && $XDG_VTNR -eq 1 && $USER == alex ]] && startx -- -dpi "$dpi"
fi
