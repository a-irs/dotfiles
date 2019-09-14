#!/usr/bin/env bash

if command -v xclip &> /dev/null; then
    clip=$(xclip -o -selection clipboard)
    [[ -z "$clip" ]] && clip=$(xclip -o -selection primary)
    [[ -z "$clip" ]] && clip=$(xclip -o -selection secondary)
elif command -v xsel &> /dev/null; then
    clip=$(xsel --clipboard --output)
    [[ -z "$clip" ]] && clip=$(xsel --primary --output)
    [[ -z "$clip" ]] && clip=$(xsel --secondary --output)
fi

clip=$(echo "$clip" | tr '\n' ' ')

[[ -z "$clip" ]] && { notify-send -u critical "EMPTY"; exit 1; }

notify-send "$clip"
mpv "$clip"

if [[ $? -ne 0 ]]; then
    notify-send -u critical "$clip"
    exit 1
fi
