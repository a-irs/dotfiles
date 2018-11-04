#!/usr/bin/env bash

set -eu

current_brightness() {
    xbacklight -get | cut -d . -f 1
}

if [[ "$1" == + ]]; then
    xbacklight + 5
elif [[ "$1" == - ]]; then
    xbacklight - 5
fi

cur=$(current_brightness)

# limit to 1
if [[ "$cur" == 0 ]]; then
    xbacklight = 1
    notify-send -t 1000 -i /usr/share/icons/Faba-Mono/48x48/notifications/notification-display-brightness.svg -- 1%
else
    notify-send -t 1000 -i /usr/share/icons/Faba-Mono/48x48/notifications/notification-display-brightness.svg -- "$cur"%
fi

