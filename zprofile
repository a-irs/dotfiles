[[ "$TTY" != /dev/tty*  ]] && return

# wait for internet, then launch dropbox
if [[ -n "$commands[dropbox-cli]" ]]; then
    nohup bash -c "$HOME/.bin/wait-for-host dropbox.com && dropbox-cli start" < /dev/null &> /dev/null &
fi

# start redshift in oneshot DRM mode (works in tty)
redshift -o -m drm

if [[ "$HOST" == desk && -n "$commands[startx]" ]]; then
    [[ -z "$DISPLAY" && "$XDG_VTNR" -eq 1 && "$USER" == alex ]] && startx
fi
