#!/usr/bin/env bash

clip=$(xclip -o)
[[ "$clip" ]] || { notify-send -u critical "empty"; exit 1; }

notify-send "$clip"
if ! mpv $clip; then
    notify-send -u critical "$clip"
    exit 1
fi

echo -n '' | xclip -selection clipboard
echo -n '' | xclip -selection primary
echo -n '' | xclip -selection secondary
