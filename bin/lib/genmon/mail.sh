#!/usr/bin/env bash

c=$(cut -d ":" -f 1 ~/.thunderbird/k4daoos4.default/unread-counts | head -n 1)
[[ c -eq 0 ]] && echo "" && exit

color="red"

for i in $(seq 1 $c);
do
    t="$t ●"
done

echo "<txt><span weight='bold' fgcolor='$color'>$t </span></txt>"
