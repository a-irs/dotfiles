#!/usr/bin/env bash

[[ ! -d /sys/class/power_supply/BAT0 ]] && exit

source "$HOME/.bin/lib/genmon/settings.cfg"

status=$(< /sys/class/power_supply/BAT0/status)
percent=$(< /sys/class/power_supply/BAT0/capacity)

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

if [[ "$status" == Charging ]] || [[ "$status" == Full ]]; then
    charging=1
    if [[ $TMUX ]]; then
        txt="#[bg=colour237,fg=colour220]#[bg=colour220,fg=colour235] ⚡ #[default]"
    elif [[ $1 == awesome ]]; then
            txt="<span foreground='LightGreen'>+</span> "
    else
        txt="<span weight='bold' fgcolor='LightGreen'> +</span>"
    fi
fi

if [[ $TMUX ]]; then
    if [[ $charging == 1 ]]; then
        txt=$txt"#[bg=colour220,fg=$color_tmux]#[bg=$color_tmux,fg=colour235] $percent% #[default]"
    else
        txt=$txt"#[bg=colour237,fg=$color_tmux]#[bg=$color_tmux,fg=colour235] $percent% #[default]"
    fi
elif [[ $1 == awesome ]]; then
    txt=$txt"<span foreground='$color'>$percent</span>"
else
    txt="<span weight='bold' fgcolor='$color'>$percent"$txt"</span>"
fi

click="sh -c 'xset dpms force off && slimlock'"
if [[ -n $TMUX ]] || [[ $1 == awesome ]]; then
    echo -n "<b>$txt</b>   "
else
    [[ $ICONS == 1 ]] && echo -n "<img>$image</img>"
    echo -n "<txt>$txt</txt><click>$click</click>"
fi
