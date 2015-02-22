#!/usr/bin/env bash

source "$HOME/.bin/lib/genmon/settings.cfg"

status=$(cat /sys/class/power_supply/BAT0/status)
percent=$(cat /sys/class/power_supply/BAT0/capacity)

if [ -z $percent ]; then
    image="$HOME/.bin/lib/genmon/img/battery_crit.png"
    color="Red"
    echo "<txt><span weight='bold' fgcolor='$color'>N/A</span></txt>"
    exit
fi

[[ "$percent" -gt 100 ]] && echo "" && exit

if [[ "$percent" -le 19 ]]; then
        image="$HOME/.bin/lib/genmon/img/battery_crit.png"
        color="#DB3131"
elif [[ "$percent" -le 39 ]]; then
    if [ $MONOCHROME -ne 1 ]; then
        image="$HOME/.bin/lib/genmon/img/battery_low.png"
        color="Yellow"
    else
        image="$HOME/.bin/lib/genmon/img/monochrome/battery_low.png"
        color="#aaaaaa"
    fi
elif [[ "$percent" -le 69 ]]; then
    if [ $MONOCHROME -ne 1 ]; then
        image="$HOME/.bin/lib/genmon/img/battery_normal.png"
        color="White"
    else
        image="$HOME/.bin/lib/genmon/img/monochrome/battery_normal.png"
        color="#cccccc"
    fi
else
    [[ "$percent" -eq 100 ]] && percent='00'
    if [ $MONOCHROME -ne 1 ]; then
        image="$HOME/.bin/lib/genmon/img/battery_high.png"
        color="LightGreen"
    else
        image="$HOME/.bin/lib/genmon/img/monochrome/battery_high.png"
        color="#ffffff"
    fi
fi

txt="<span weight='bold' fgcolor='$color'>$percent"
if [[ "$status" == Charging ]] || [[ "$status" == Full ]]; then
    txt=$txt"<span weight='bold' fgcolor='LightGreen'> +</span></span>"
else
    txt=$txt"</span>"
fi

click="sh -c 'xset dpms force off && slimlock'"
[[ $ICONS == 1 ]] && echo -n "<img>$image</img>"
echo "<txt>$txt</txt>\
      <click>$click</click>"
