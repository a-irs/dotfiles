#!/usr/bin/env zsh

[[ $SSH_CONNECTION || "$VIM" || "$EMACS" || "$INSIDE_EMACS" || "$TMUX" || ! "$commands[tmux]" || $- != *i* ]] && return

exec tmux new-session
