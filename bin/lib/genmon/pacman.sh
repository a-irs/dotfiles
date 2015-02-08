#!/usr/bin/env bash

updates=$(pacman -Qu)
if [[ $(echo "$updates" | wc -c) -le 1 ]]; then
    echo ""
else
    count=$(echo "$updates" | wc -l)
    if [ $count -eq 1 ]; then
        s="Update"
    else
        s="Updates"
    fi
    img="$HOME/.bin/lib/genmon/img/update.png"
    txt="<span weight=\"bold\" fgcolor=\"Orange\">$count $s</span>"
    term="terminator --title 'PACMAN UPDATE' -m -x "
    cmd="'sudo pacman -Su ; echo \"\" ; echo \"[DONE]\" ; read'"
    echo "<img>$img</img><txt>$txt</txt><tool>$updates</tool><click>$term $cmd</click>"
fi
