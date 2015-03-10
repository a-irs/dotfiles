if [ -n "$commands[startx]" ]; then
    [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && startx
fi
