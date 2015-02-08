#!/usr/bin/env bash

status=$(playerctl status)

if [[ "$status" == "Playing" ]]; then
    img="$HOME/.bin/lib/genmon/img/mpd.png"
    color="LightBlue"
elif [[ "$status" == "Paused" ]]; then
    img="$HOME/.bin/lib/genmon/img/mpd_grey.png"
    color="Grey"
else
    echo ""
    exit
fi

artist=$(playerctl metadata xesam:artist | sed "s/&/&amp;/;s/</&lt;/;s/>/&gt;/")
title=$(playerctl metadata xesam:title | sed "s/&/&amp;/;s/</&lt;/;s/>/&gt;/")

if [[ $title == "" ]]; then
    title=$(playerctl metadata xesam:url | rev | cut -d "/" -f 1 | rev)
fi

a="<span weight=\"normal\">$artist</span>"
t="<span weight=\"bold\">$title</span>"

if [[ $artist == "" ]]; then
    txt="<span fgcolor=\"$color\">$t</span>"
else
    txt="<span fgcolor=\"$color\">$t ($a)</span>"
fi

echo "<img>$img</img>\
      <txt>$txt</txt>\
      <click>playerctl play-pause</click>\
      <tool>$tool</tool>"
