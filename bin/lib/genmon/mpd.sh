#!/usr/bin/env bash

source "$HOME/.bin/lib/genmon/settings.cfg"

status=$(mpc status -f "" 2> /dev/null)
[ $? != 0 ] && echo "" && exit
echo "$status" | grep "paused" &> /dev/null && echo "" && exit
echo "$status" | grep "volume: n/a" &> /dev/null && echo "" && exit

full=$(mpc current -f "%artist%;;%title%" 2> /dev/null)
artist=${full%%;;*}
title=${full##*;;}
title=$(echo "$title" | head -n 1)

color="#B895B5"
color2="#9A7797"
[[ $MONOCHROME == 1 ]] && color="#bbb" && color2="#888"

txt1="<span weight=\"bold\" fgcolor=\"$color\">$title</span>"
txt2="<span weight=\"bold\" fgcolor=\"$color2\">($artist)</span>"
echo "<txt>$txt1 $txt2</txt>"
