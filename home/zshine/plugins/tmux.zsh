#!/usr/bin/env zsh

[[ $SSH_CONNECTION || "$TMUX" || ! "$commands[tmux]" || $- != *i* ]] && return

exec tmux new-session
