#!/usr/bin/env bash

clip=$(xclip -o -selection clipboard)
[[ -z "$clip" ]] && clip=$(xclip -o -selection primary)
[[ -z "$clip" ]] && clip=$(xclip -o -selection secondary)

[[ -z "$clip" ]] && { notify-send -u critical "EMPTY"; exit 1; }

notify-send "$clip"
mpv "$clip"

if [[ $? -ne 0 ]]; then
    notify-send -u critical "$clip"
    exit 1
fi
