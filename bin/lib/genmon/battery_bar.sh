#!/usr/bin/env bash

b=$(acpi -bt)
percent=$(echo "$b" | head -n 1 | cut -d "," -f 2 | tr -d ' ' | tr -d '%')

if [ -z $percent ]; then
    color="Red"
    echo "<txt><span weight=\"bold\" fgcolor=\"$color\">N/A</span></txt><tool>$b</tool>"
    exit
fi

percent=35

if [[ "$percent" -le 9 ]]; then
    txt="<span weight=\"bold\" fgcolor=\"Red\"       >|</span>|||||||||"
elif [[ "$percent" -le 19 ]]; then
    txt="<span weight=\"bold\" fgcolor=\"Red\"       >||</span>||||||||"
elif [[ "$percent" -le 29 ]]; then
    txt="<span weight=\"bold\" fgcolor=\"Red\"       >|||</span>|||||||"
elif [[ "$percent" -le 39 ]]; then
    txt="<span weight=\"bold\" fgcolor=\"Yellow\"    >||||</span>||||||"
elif [[ "$percent" -le 49 ]]; then
    txt="<span weight=\"bold\" fgcolor=\"Yellow\"    >|||||</span>|||||"
elif [[ "$percent" -le 59 ]]; then
    txt="<span weight=\"bold\" fgcolor=\"Yellow\"    >||||||</span>||||"
elif [[ "$percent" -le 69 ]]; then
    txt="<span weight=\"bold\" fgcolor=\"White\"     >|||||||</span>|||"
elif [[ "$percent" -le 79 ]]; then
    txt="<span weight=\"bold\" fgcolor=\"White\"     >||||||||</span>||"
elif [[ "$percent" -le 89 ]]; then
    txt="<span weight=\"bold\" fgcolor=\"LightGreen\">|||||||||</span>|"
else
    txt="<span weight=\"bold\" fgcolor=\"LightGreen\">||||||||||</span>"
fi

if [[ "$b" == *Charging* ]] || [[ "$b" == *Full* ]]; then
    txt="$txt <span weight=\"bold\">+</span>"
fi

echo "<txt>$txt</txt>\
      <tool>$b</tool>"
