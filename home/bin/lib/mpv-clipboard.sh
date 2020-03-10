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

[[ -z "$clip" ]] && { notify-send -i error "EMPTY"; exit 1; }

notify-send "MPV: $clip" &
out=$(mpv "$clip" 2>&1)

if [[ $? -ne 0 ]]; then
    notify-send -i error "MPV: $clip" "$out"
    exit 1
fi
