#!/usr/bin/env bash

source "$HOME/.bin/lib/genmon/settings.cfg"

status=$(cat /sys/class/power_supply/BAT0/status)
percent=$(cat /sys/class/power_supply/BAT0/capacity)

if [ -z "$percent" ]; then
    image="$HOME/.bin/lib/genmon/img/battery_crit.png"
    color="Red"
    echo "<txt><span weight='bold' fgcolor='$color'>N/A</span></txt>"
    exit
fi

[[ "$percent" -ge 100 ]] && echo "" && exit

if [[ "$percent" -le 19 ]]; then
        image="$HOME/.bin/lib/genmon/img/battery_crit.png"
        color="#DB3131"
        color_tmux="red"
elif [[ "$percent" -le 39 ]]; then
    if [ $MONOCHROME -ne 1 ]; then
        image="$HOME/.bin/lib/genmon/img/battery_low.png"
        color="Yellow"
        color_tmux="yellow"
    else
        image="$HOME/.bin/lib/genmon/img/monochrome/battery_low.png"
        color="#aaaaaa"
    fi
elif [[ "$percent" -le 69 ]]; then
    if [ $MONOCHROME -ne 1 ]; then
        image="$HOME/.bin/lib/genmon/img/battery_normal.png"
        color="White"
        color_tmux="white"
    else
        image="$HOME/.bin/lib/genmon/img/monochrome/battery_normal.png"
        color="#cccccc"
    fi
else
    [[ "$percent" -eq 100 ]] && percent='00'
    if [ $MONOCHROME -ne 1 ]; then
        image="$HOME/.bin/lib/genmon/img/battery_high.png"
        color="LightGreen"
        color_tmux="green"
    else
        image="$HOME/.bin/lib/genmon/img/monochrome/battery_high.png"
        color="#ffffff"
    fi
fi

if [[ $TMUX ]]; then
    txt="#[fg=$color_tmux]$percent%#[default]"
else
    txt="<span weight='bold' fgcolor='$color'>$percent"
fi

if [[ "$status" == Charging ]] || [[ "$status" == Full ]]; then
    if [[ $TMUX ]]; then
        txt="#[fg=yellow]⚡#[default] $txt"
    else
        txt=$txt"<span weight='bold' fgcolor='LightGreen'> +</span></span>"
    fi
else
    [[ ! $TMUX ]] && txt=$txt"</span>"
fi

click="sh -c 'xset dpms force off && slimlock'"
[[ $ICONS == 1 && ! $TMUX ]] && echo -n "<img>$image</img>"
if [[ $TMUX ]]; then
    echo -n "$txt"
else
    echo -n "<txt>$txt</txt><click>$click</click>"
fi
