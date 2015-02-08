#!/usr/bin/env bash

source "$HOME/.bin/lib/genmon/settings.cfg"

if [[ $MONOCHROME == 1 ]]; then
    color="#ffffff"
    image="$HOME/.bin/lib/genmon/img/monochrome/wifi.png"
    vpn_color="#bbbbbb"
else
    color="LightBlue"
    image="$HOME/.bin/lib/genmon/img/wifi.png"
    vpn_color="gold"
fi

devs=$(cat /proc/net/route)

if [[ $devs == *$'\nwlan'* ]] || [[ $devs == *$'\nwlp'* ]]; then
    ssid=$(iwgetid --raw)
    [[ -z "$ssid" ]] && break
    txt+=("<span weight='bold' fgcolor='$color'>$ssid</span>")
fi

if [[ $devs == *$'\neth'* ]] || [[ $devs == *$'\nenp'* ]]; then
    speed=$(ethtool eth0 2> /dev/null | grep Speed)
    speed="${speed##*:}"
    speed="${speed// /}"
    speed="${speed//[^0-9]/}"
    txt+=("<span weight='bold' fgcolor='$color'>$speed</span>")
fi

if [[ $devs == *$'\nusb'* ]]; then
    txt+=("<span weight='bold' fgcolor='$color'>USB</span>")
fi

if [ -f /tmp/sshuttle.pid ]; then
    txt+=("<span weight='bold' fgcolor='$vpn_color'>sshuttle</span>")
fi

if [[ $devs == *$'\ntun'* ]] || [[ $devs == *$'\ntap'* ]]; then
    pid=$(pidof -s openvpn)
    [[ -z "$pid" ]] && break
    vpn_profile=$(cat /proc/$pid/cmdline)
    vpn_profile="${vpn_profile##*/}"
    vpn_profile="${vpn_profile%.ovpn}"
    txt+=("<span weight='bold' fgcolor='$vpn_color'>$vpn_profile</span>")
fi

total="${#txt[@]}"
count=1
printf "<txt>"
if [[ $total == 0 ]]; then
    echo -n "<span weight='bold' fgcolor='grey'>n/a</span>"
    image="$HOME/.bin/lib/genmon/img/wifi_off.png"
else
    for item in "${txt[@]}"; do 
        printf "$item"
        [[ $count == $total ]] || printf " + "
        count=$((count+1))
    done
fi
echo "</txt>"
echo "<click>terminator -m -e 'ip addr;read'</click>"

[[ $ICONS == 1 ]] && echo "<img>$image</img>"
