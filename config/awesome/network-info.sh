#!/usr/bin/env bash

color="#ffa500"
vpn_color="#ffd700"

devs=$(< /proc/net/route)

if [[ $devs == *$'\nwlan'* ]] || [[ $devs == *$'\nwlp'* ]]; then
    ssid=$(iwgetid --raw)
    [[ -z "$ssid" ]] && return
    if [[ "$ssid" == *_2_4_* ]]; then
        ssid_start=${ssid%%_2_4_*}
        ssid_end=${ssid##*_2_4_}
        ssid_between=_2_4_
        color_between="#ff0000"
        txt+=("<span foreground='$color'><b>$ssid_start</b></span><span foreground='$color_between'><b>$ssid_between</b></span><span foreground='$color'><b>$ssid_end</b></span>")
    elif [[ "$ssid" == *_5_* ]]; then
        ssid_start=${ssid%%_5_*}
        ssid_end="${ssid##*_5_}"
        ssid_between=_5_
        color_between="#00ff00"
        txt+=("<span foreground='$color'><b>$ssid_start</b></span><span foreground='$color_between'><b>$ssid_between</b></span><span foreground='$color'><b>$ssid_end</b></span>")
    else
        txt+=("<span foreground='$color'><b>$ssid</b></span>")
    fi
fi

if [[ $devs == *$'\neth'* ]] || [[ $devs == *$'\nenp'* ]]; then
    speed=$(ethtool eth0 2> /dev/null | grep Speed)
    speed="${speed##*:}"
    speed="${speed// /}"
    speed="${speed//[^0-9]/}"
    txt+=("<span foreground='$color'>ETH0 <b>$speed</b></span>")
fi

if [[ $devs == *$'\nusb'* ]]; then
    txt+=("<span foreground='$color'><b>USB</b></span>")
fi

if [ -f /tmp/sshuttle.pid ]; then
    txt+=("<span foreground='$vpn_color'><b>sshuttle</b></span>")
fi

if [[ $devs == *$'\ntun'* ]] || [[ $devs == *$'\ntap'* ]]; then
    pid=$(pidof -s openvpn)
    if [[ -n "$pid" ]]; then
        vpn_profile=$(cat "/proc/$pid/cmdline")
        vpn_profile="${vpn_profile##*/}"
        vpn_profile="${vpn_profile%.ovpn}"
        txt+=("<span foreground='$vpn_color'><b>$vpn_profile</b></span>")
    fi
fi

total="${#txt[@]}"
count=1
if [[ $total == 0 ]]; then
    echo -n "<b>disconnected</b>"
else
    for item in "${txt[@]}"; do
        echo -n "$item"
        [[ "$count" == "$total" ]] || echo -n " + "
        count=$((count+1))
    done
fi
