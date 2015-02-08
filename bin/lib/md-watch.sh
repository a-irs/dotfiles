#!/usr/bin/env bash

[ -z "$1" ] && echo "choose folder" && exit 1

echo "monitoring ${1/$HOME/\~} for changes..."
inotifywait -mrq -e move -e create -e modify --format %w%f "$1" | while read FILE
do
    if [[ "$FILE" == *.md ]]; then
    	md.py "$FILE"
    fi
done
