#!/usr/bin/env zsh

# exit if tmux not installed, not starting a interactive shell or logged in to TTY
[[ -n "$TMUX" || -z "$commands[tmux]" || $- != *i* || "$TERM" = linux ]] && return

exec tmux new-session -A -s main
