#!/usr/bin/env bash

[[ -z $1 ]] && exit 1

playlist=$1
pl_name=$(basename -s .m3u "$playlist")
outputdir="$HOME/media-gmusic"

lines=$(wc -l < "$playlist")
songs=$((($lines-1)/2))

mkdir -p "$outputdir/playlists"
rm -f "$outputdir/playlists/$pl_name.m3u"

for ((song = 1; song <= $songs; song++)); do
    title="$(awk "NR==$song*2 {print}" "$playlist" | cut -d',' -f2)"
    link="$(awk "NR==$song*2+1 {print}" "$playlist")"

    dest="$outputdir/$title.mp3"
    if [[ ! -f "$dest" ]]; then
        echo -e "$song/$songs\t$title"
    	curl -o "$dest" "$link"
        echo ""
    else
        echo -e "$song/$songs\t skipped: $title"
    fi

    echo "$outputdir/$title.mp3" >> "$outputdir/playlists/$pl_name.m3u"
done
