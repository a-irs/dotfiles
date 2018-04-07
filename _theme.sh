#!/usr/bin/env bash

set -e

this_dir="$(dirname "$(readlink -f "$0")")"
cc_file="$this_dir/_theme.current_color"
current_color=$(< "$cc_file")

if [[ ! $1 ]]; then
    echo "USAGE: theme 2b4500 -> generating random HEX instead"
    new_color="$(openssl rand -hex 3)"
else
    new_color=$1
fi

cd "$this_dir"
sed -i "s|$current_color|$new_color|g" \
    "$this_dir/awesome/.config/awesome/theme.lua" \
    "$this_dir/subl3/.config/sublime-text-3/Packages/User/zshine.tmTheme" \
    "$this_dir/subl3/.config/sublime-text-3/Packages/User/zshine-desaturated.tmTheme" \
    "$this_dir/termite/.config/termite/config" \
    "$this_dir/zathura/.config/zathura/zathurarc" \
    "$cc_file"

killall -USR1 termite 2> /dev/null
echo "awesome.restart()" | awesome-client 2> /dev/null
