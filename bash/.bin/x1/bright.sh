#!/usr/bin/env bash

set -eu

action=$1

get_current_brightness() {
    a=$(xbacklight -get | cut -d . -f 1)
    # # round to fives
    printf '%s\n' $((5*(a/5)))
}

notify() {
    icon=/usr/share/icons/Faba-Mono/48x48/notifications/notification-display-brightness.svg
    notify-send -t 1000 -i "$icon" -- "Light" "$@"
}

backlight() {
    xbacklight -time 100 "$@"
}

if [[ "$action" == + ]]; then
    backlight -inc 5
elif [[ "$action" == - ]]; then
    backlight -dec 5
fi

current=$(get_current_brightness)

# limit to 1
if [[ "$current" == 0 ]]; then
    backlight -set 1
    notify 1%
else
    notify "$current"%
fi

