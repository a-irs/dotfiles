#!/bin/sh

if test -t 0 -a -z "$1"; then
    xclip -out -selection clipboard || exit 1
elif test -n "$1"; then
    xclip -in -selection clipboard < "$1" || exit 1
else
    xclip -in -selection clipboard <&0 || exit 1
fi
