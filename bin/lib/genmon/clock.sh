#!/usr/bin/env bash

source "$HOME/.bin/lib/genmon/settings.cfg"

image="$HOME/.bin/lib/genmon/img/clock.png"

date=$(date "+%a, %d.%m.")
time=$(date "+%H:%M")

if [[ $1 == awesome ]]; then
    txt1="<span foreground='#ffffff'>$date</span>"
    txt2="<span foreground='#ffffff'><b>$time</b></span>"
else
    txt1="<span fgcolor='#ffffff'>$date</span>"
    txt2="<span fgcolor='#ffffff' weight='bold'>$time</span>"
fi

if [[ $1 == awesome ]]; then
    echo -n "$txt1 $txt2   "
else
    [[ $ICONS == 1 ]] && echo -n "<img>$image</img>"
    echo -n "<txt>$txt1 $txt2 </txt><click>gsimplecal</click>"
fi
