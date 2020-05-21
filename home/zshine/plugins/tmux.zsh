#!/usr/bin/env zsh

[[ ! "$commands[tmux]" ]] && return

[[ "$SSH_CONNECTION" || "$VIM" || "$EMACS" || "$INSIDE_EMACS" || "$TMUX" || $- != *i* ]] && return

exec tmux new-session
