#!/usr/bin/env bash

out=/media/data/videos/internet
urls=~/youtube
archive=~/youtube.archive

if ! command -v ffmpeg >/dev/null; then
    echo "ffmpeg needed"
    exit 1
fi

while read -r line; do
    url=$(printf "$line" | cut -d '|' -f 2)
    playlist=$(printf "$line" | cut -d '|' -f 1)

    youtube-dl \
        --write-sub --sub-lang en,de --embed-subs --prefer-free-formats \
        --write-info-json -f bestvideo+bestaudio --restrict-filenames \
        --download-archive "${archive}_$playlist" --ignore-errors \
        -o "$out/%(playlist)s/%(title)s - %(id)s.%(ext)s" \
        -- "$url"
done < "$urls"
