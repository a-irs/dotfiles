#!/usr/bin/env bash

set -e

this_dir="$(dirname "$(readlink -f "$0")")"
cc_file="$this_dir/_theme.current_color"
current_color=$(< "$cc_file")

[[ ! $1 ]] && echo "USAGE: theme 2b4500" && exit 1

cd "$this_dir"
sed -i "s|$current_color|$1|g" \
    "$this_dir/awesome/.config/awesome/theme.lua" \
    "$this_dir/subl3/.config/sublime-text-3/Packages/User/zshine.tmTheme" \
    "$this_dir/subl3/.config/sublime-text-3/Packages/User/zshine-desaturated.tmTheme" \
    "$this_dir/termite/.config/termite/config" \
    "$this_dir/zathura/.config/zathura/zathurarc" \
    "$cc_file"

killall -USR1 termite 2> /dev/null
echo "awesome.restart()" | awesome-client 2> /dev/null
