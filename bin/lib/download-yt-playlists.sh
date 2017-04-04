#!/usr/bin/env bash

out=/media/data/videos/youtube

playlist_urls=(
'https://www.youtube.com/playlist?list=PL7F1D3966ECF3A588'
'https://www.youtube.com/playlist?list=PLjpFFKfSIL4LVHgdqn0mjZ1Oany3en7n3'
)

for url in "${playlist_urls[@]}"; do
    youtube-dl --restrict-filenames -o "$out/%(playlist)s/%(playlist_index)03d - %(title)s - %(id)s.%(ext)s" -- "$url"
done
