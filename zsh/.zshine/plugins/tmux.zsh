#!/usr/bin/env zsh

[[ $SSH_CONNECTION || "$TMUX" || ! "$commands[tmux]" || $- != *i* || "$TERM" == linux ]] && return

exec tmux new-session
