#!/usr/bin/env zsh

[[ ! "$commands[tmux]" ]] && return

[[ "$VIM" || "$EMACS" || "$INSIDE_EMACS" || "$TMUX" || $- != *i* ]] && return

exec tmux new-session
