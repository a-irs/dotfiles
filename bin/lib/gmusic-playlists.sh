#!/usr/bin/env bash

set -e

out=~/.config/mpd/playlists
tmp="/tmp/all_playlists.m3u"

curl -s "http://localhost:9999/get_all_playlists" > "$tmp"
total=$(wc -l < "$tmp")
total=$((($total - 1) / 2))

i=1
name=""
url=""
while read line; do
    if [[ $i == 1 ]]; then
        :
    elif [[ $(($i % 2)) != 0 ]]; then
        url="$line"
        filename="$out/${name/\//-}.m3u"
        if [ ! -s "$filename" ]; then
            echo "$((($i-1)/2))/$total: downloading ${filename/$HOME/\~}"
            curl -s "$url" | sed -r 's/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}/127.0.0.1/g' > "$filename"
        else
            echo "$((($i-1)/2))/$total: ${filename/$HOME/\~} already exists, skipping"
        fi
    else
        name="${line#*,}"
    fi
    i=$((i+1))
done < "$tmp"

rm "$tmp"
