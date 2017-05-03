#!/usr/bin/env bash

set -e
PATH=/usr/bin

out=/media/data/videos/youtube

args="--write-description"
playlist_urls=(
    'https://www.youtube.com/playlist?list=PL7F1D3966ECF3A588'
    'https://www.youtube.com/playlist?list=PLjpFFKfSIL4LVHgdqn0mjZ1Oany3en7n3'
)

for url in "${playlist_urls[@]}"; do
    youtube-dl --restrict-filenames $args -o "$out/%(playlist)s/%(title)s - %(id)s.%(ext)s" -- "$url"
done
