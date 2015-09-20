#!/usr/bin/env bash

set -e

this_dir="$(dirname "$(readlink -f "$0")")"
cc_file="$this_dir/_theme.current_color"
current_color=$(< "$cc_file")

[[ ! $1 ]] && echo "USAGE: theme 2b4500" && exit 1

cd "$this_dir"
ag --ignore "$cc_file" -l "$current_color" | xargs -d '\n' sed -i "s|$current_color|$1|g"
echo "$1" > "$cc_file"

echo "awesome.restart()" | awesome-client
