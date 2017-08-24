#!/usr/bin/env zsh

if [[ "$os" = Darwin ]]; then
    if [[ "$commands[gls]" ]]; then
        chpwd() { gls -F --literal --color=auto; }
    else
        chpwd() { command ls -F; }
    fi
else
    chpwd() { command ls -F --literal --color=auto; }
fi
