#!/usr/bin/env zsh

# exit if tmux not installed, not starting a interactive shell or logged in to TTY
[[ -z "$commands[tmux]" || $- != *i* || "$TERM" = linux ]] && return

tmux attach &> /dev/null
[[ -z "$TMUX" ]] && exec tmux
