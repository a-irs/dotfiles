#!/usr/bin/env zsh

chpwd() {
    command gls --quoting-style=literal -F --color=auto --group-directories-first
}

[[ "$TERM" != linux ]] && chpwd 2> /dev/null
