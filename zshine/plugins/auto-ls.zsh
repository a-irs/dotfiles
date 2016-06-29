#!/usr/bin/env zsh

if [[ "$os" = Darwin ]]; then
    chpwd() {        gls --quoting-style=literal -F --color=auto --group-directories-first; }
else
    chpwd() { command ls --quoting-style=literal -F --color=auto --group-directories-first; }
fi

[[ "$TERM" != linux ]] && chpwd 2> /dev/null
