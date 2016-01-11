#!/usr/bin/env bash

set -e

this_dir="$(dirname "$(readlink -f "$0")")"
cc_file="$this_dir/_theme.current_color"
current_color=$(< "$cc_file")

[[ ! $1 ]] && echo "USAGE: theme 2b4500" && exit 1

cd "$this_dir"
sed -i "s|$current_color|$1|g" "$this_dir/config/awesome/theme.lua" "$this_dir/config/sublime-text-3/Packages/User/Monokai Extended 2.tmTheme" "$this_dir/config/sublime-text-3/Packages/User/Monokai Extended 2 desaturated.tmTheme" "$this_dir/config/termite/config" "$this_dir/config/zathura/zathurarc" "$this_dir/newtab.html" "$this_dir/userChrome.css"
echo "$1" > "$cc_file"

killall -USR1 termite
echo "awesome.restart()" | awesome-client
