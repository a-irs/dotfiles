# wait for internet, then launch dropbox
nohup bash -c "$HOME/.bin/wait-for-host dropbox.com && dropbox-cli start" < /dev/null &> /dev/null &

[[ "$HOST" == dell ]] && return
if [ -n "$commands[startx]" ]; then
    [[ -z $DISPLAY && $XDG_VTNR -eq 1 && $USER == alex ]] && startx
fi
