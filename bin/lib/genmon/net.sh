#!/usr/bin/env bash

source "$HOME/.bin/lib/genmon/settings.cfg"

if [[ $MONOCHROME == 1 ]]; then
    color="#ffffff"
    image="$HOME/.bin/lib/genmon/img/monochrome/wifi.png"
    vpn_color="#bbbbbb"
else
    color="Orange"
    color_tmux="blue"
    image="$HOME/.bin/lib/genmon/img/wifi.png"
    vpn_color="gold"
    vpn_color_tmux="yellow"
fi

devs=$(< /proc/net/route)

if [[ $devs == *$'\nwlan'* ]] || [[ $devs == *$'\nwlp'* ]]; then
    ssid=$(iwgetid --raw)
    [[ -z "$ssid" ]] && return
    if [[ $TMUX ]]; then
        txt+=("#[bg=$color_tmux,fg=colour235] $ssid #[default]")
    elif [[ $1 == awesome ]]; then
        txt+=("<span foreground='$color'><b>$ssid</b></span>")
    else
        txt+=("<span weight='bold' fgcolor='$color'>$ssid</span>")
    fi
fi

if [[ $devs == *$'\neth'* ]] || [[ $devs == *$'\nenp'* ]]; then
    speed=$(ethtool eth0 2> /dev/null | grep Speed)
    speed="${speed##*:}"
    speed="${speed// /}"
    speed="${speed//[^0-9]/}"
    if [[ $TMUX ]]; then
        txt+=("#[bg=$color_tmux,fg=colour235] $speed #[default]")
    elif [[ $1 == awesome ]]; then
        txt+=("<span foreground='$color'>Speed: <b>$speed</b></span>")
    else
        txt+=("<span weight='bold' fgcolor='$color'>$speed</span>")
    fi
fi

if [[ $devs == *$'\nusb'* ]]; then
    if [[ $TMUX ]]; then
        txt+=("#[bg=$color_tmux,fg=colour235] USB #[default]")
    elif [[ $1 == awesome ]]; then
        txt+=("<span foreground='$color'><b>USB</b></span>")
    else
        txt+=("<span weight='bold' fgcolor='$color'>USB</span>")
    fi
fi

if [ -f /tmp/sshuttle.pid ]; then
    if [[ $TMUX ]]; then
        txt+=("#[bg=$vpn_color_tmux,fg=colour235] sshuttle #[default]")
    elif [[ $1 == awesome ]]; then
        txt+=("<span foreground='$vpn_color'><b>sshuttle</b></span>")
    else
        txt+=("<span weight='bold' fgcolor='$vpn_color'>sshuttle</span>")
    fi
fi

if [[ $devs == *$'\ntun'* ]] || [[ $devs == *$'\ntap'* ]]; then
    pid=$(pidof -s openvpn)
    if [[ -n "$pid" ]]; then
        vpn_profile=$(cat "/proc/$pid/cmdline")
        vpn_profile="${vpn_profile##*/}"
        vpn_profile="${vpn_profile%.ovpn}"
        if [[ $TMUX ]]; then
            txt+=("#[bg=$vpn_color_tmux,fg=colour235] $vpn_profile #[default]")
        elif [[ $1 == awesome ]]; then
            txt+=("<span foreground='$vpn_color'><b>$vpn_profile</b></span>")
        else
            txt+=("<span weight='bold' fgcolor='$vpn_color'>$vpn_profile</span>")
       fi
    fi
fi

total="${#txt[@]}"
count=1
[[ $TMUX || $1 == awesome ]] || echo -n "<txt>"
if [[ $total == 0 ]]; then
    if [[ $TMUX ]]; then
        echo -n "#[bg=black,fg=white]n/a#[default]"
    elif [[ $1 == awesome ]]; then
        echo -n "<b>no network</b>"
    else
        echo -n "<span weight='bold' fgcolor='grey'>n/a</span>"
        image="$HOME/.bin/lib/genmon/img/wifi_off.png"
    fi
else
    for item in "${txt[@]}"; do
        echo -n "$item"
        [[ $TMUX ]] && continue
        [[ "$count" == "$total" ]] || echo -n " + "
        count=$((count+1))
    done
fi
[[ $TMUX || $1 == awesome ]] || echo "</txt><click>terminator -m -e 'ip addr;read'</click>"

if [[ ! $TMUX && $1 != awesome ]]; then
    [[ $ICONS == 1 ]] && echo "<img>$image</img>"
fi
