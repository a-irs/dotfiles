#!/usr/bin/env zsh

chpwd() {
    command ls --quoting-style=literal -F --color=auto --group-directories-first 2> /dev/null
}
[[ "$TERM" != linux ]] && chpwd
