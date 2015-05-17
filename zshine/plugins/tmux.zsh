#!/usr/bin/env zsh

[[ -n $SSH_CONNECTION || -n "$TMUX" || -z "$commands[tmux]" || $- != *i* || "$TERM" == linux ]] && return

exec tmux new-session -A -s main
