#!/usr/bin/env bash

source "$HOME/.bin/lib/genmon/settings.cfg"

image="$HOME/.bin/lib/genmon/img/clock.png"

date=$(date "+%a, %d.%m.")
time=$(date "+%H:%M")

txt1="<span fgcolor='#ffffff'>$date</span>"
txt2="<span fgcolor='#ffffff' weight='bold'>$time</span>"

[[ $ICONS == 1 ]] && echo -n "<img>$image</img>"
echo "<txt>$txt1 $txt2 </txt>\
      <click>gsimplecal</click>"
