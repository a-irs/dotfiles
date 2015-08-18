#!/usr/bin/env zsh

chpwd() {
    command ls -F --color=auto --group-directories-first
}
[[ "$TERM" != linux ]] && chpwd
