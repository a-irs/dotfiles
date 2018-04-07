#!/usr/bin/env bash

wifi_color="#ffa200"
eth_color="#ffa500"
vpn_color="#ffd700"

out=$(nmcli --wait 1 --terse --colors no --fields name,type,device,state,active connection show)
active=$(printf "%s\n" "$out" | awk -F: '$5 == "yes" {print $1":"$2}' | sort -r)

declare -a txt
while read -r line; do
    type=${line##*:}
    name=${line%%:*}
    case "$type" in
        tun)        continue ;;
        vpn)        c=$vpn_color; name=vpn ;;
        *-wireless)
            c=$wifi_color
            freq=$(iwgetid -f --raw)
            [[ $freq == 5* ]] && freq=5
            [[ $freq == 2* ]] && freq=2.4
            suffix="(${freq})"
            suffix_color="#A8F5EF"
            ;;
        *-ethernet) c=$eth_color ;;
    esac
    suffix_color="#A8F5EF"
    txt+=("<span foreground='$c'><b>${name}</b></span><span foreground='$suffix_color'><b>${suffix}</b></span>")
done <<< "$active"

total="${#txt[@]}"
count=1
if [[ $total == 0 ]]; then
    printf "%s" "<b>disconnected</b>"
else
    for item in "${txt[@]}"; do
        printf "%s" "$item"
        [[ "$count" == "$total" ]] || printf "%s" " + "
        count=$((count+1))
    done
fi
