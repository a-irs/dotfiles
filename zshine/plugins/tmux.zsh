#!/usr/bin/env zsh

# exit if tmux not installed, not starting a interactive shell or logged in to TTY
[[ -z "$commands[tmux]" || $- != *i* || "$TERM" = linux ]] && return

if [[ -n $SSH_TTY && -z $TMUX ]]; then
    if ! tmux has-session -t remote; then
        exec tmux new-session -s remote
    else
        exec tmux \
            new-session -d -s remote_$$ -t remote \;\
            new-window \;\
            attach \;\
            set-option destroy-unattached on
    fi
else
    tmux attach &> /dev/null
    [[ -z "$TMUX" ]] && exec tmux
fi
