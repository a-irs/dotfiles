#!/usr/bin/env zsh

[[ $- != *i* || "$TERM" = linux ]] && return

tmux attach &> /dev/null
[[ -z "$TMUX" ]] && exec tmux

