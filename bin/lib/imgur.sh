#!/usr/bin/env bash

apikey="b3625162d3418ac51a9ee805b1840452"

function usage {
    echo "Usage: $(basename "$0") <filename> [<filename> [...]]" >&2
    echo "Upload images to imgur and output their new URLs to stdout. Each one's" >&2
    echo "delete page is output to stderr between the view URLs." >&2
    echo "If xsel or xclip is available, the URLs are put on the X selection for" >&2
    echo "easy pasting." >&2
}

if [ "$1" = "-h" -o "$1" = "--help" ]; then
    usage
    exit 0
elif [ $# == 0 ]; then
    echo "No file specified" >&2
    usage
    exit 16
fi

type curl >/dev/null 2>/dev/null || {
    echo "Couln't find curl, which is required." >&2
    exit 17
}

clip=""
errors=false

while [ $# -gt 0 ]; do
    file="$1"
    shift

    if [ ! -f "$file" ]; then
        echo "file '$file' doesn't exist, skipping" >&2
        errors=true
        continue
    fi

    response=$(curl -F "key=$apikey" -H "Expect: " -F "image=@$file" \
        http://imgur.com/api/upload.xml 2>/dev/null)
    if [ $? -ne 0 ]; then
        echo "Upload failed" >&2
        errors=true
        continue
    elif [ "$(echo "$response" | grep -c "<error_msg>")" -gt 0 ]; then
        echo "Error message from imgur:" >&2
        echo $response | sed -r 's/.*<error_msg>(.*)<\/error_msg>.*/\1/' >&2
        errors=true
        continue
    fi

    url=$(echo $response | sed -r 's/.*<original_image>(.*)<\/original_image>.*/\1/')
    deleteurl=$(echo $response | sed -r 's/.*<delete_page>(.*)<\/delete_page>.*/\1/')
    echo "$url"
    echo "Delete page: $deleteurl"

    echo -n "$(date "+%Y-%m-%d %H:%M:%S")" >> "$HOME/.config/imgur-history"
    echo -n " | $(readlink -f "$file")" >> "$HOME/.config/imgur-history"
    echo -n " | $url" >> "$HOME/.config/imgur-history"
    echo " | $deleteurl" >> "$HOME/.config/imgur-history"

    clip="$clip$url
"
done

if [ "$DISPLAY" ]; then
    { type xsel >/dev/null 2>/dev/null && echo -n "$clip" | xsel -bi; } \
        || { type xclip >/dev/null 2>/dev/null && echo -n "$clip" | xclip -selection clipboard; } \
        || echo "Haven't copied to the clipboard: no xsel or xclip" >&2
else
    echo "Haven't copied to the clipboard: no \$DISPLAY" >&2
fi

if $errors; then
    exit 1
fi
