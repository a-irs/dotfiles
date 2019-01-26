#!/usr/bin/env bash

OUT=/media/data/videos/internet/youtube
URLS=~/youtube
ARCHIVE=~/youtube.archive

if ! command -v ffmpeg >/dev/null; then
    echo "ffmpeg needed"
    exit 1
fi

ytdl() {
    url=$1
    playlist=$2
    youtube-dl \
        --write-sub --sub-lang en,de --embed-subs --prefer-free-formats \
        --write-info-json -f bestvideo+bestaudio --restrict-filenames \
        --download-archive "${ARCHIVE}_$playlist" --ignore-errors \
        -o "$OUT/%(playlist)s/%(title)s - %(id)s.%(ext)s" \
        -- "$url"
}

while read -r line; do
    url=$(printf "$line" | cut -d '|' -f 2)
    playlist=$(printf "$line" | cut -d '|' -f 1)
    ytdl "$url" "$playlist"
done < "$URLS"
