#!/usr/bin/env bash

if [[ "$os" == Darwin ]]; then
    if [[ "$commands[gls]" ]]; then
        chpwd() { gls -F --literal --color=auto --group-directories-first; }
    else
        chpwd() { command ls -F; }
    fi
else
    chpwd() { command ls -F --literal --color=auto --group-directories-first; }
fi
