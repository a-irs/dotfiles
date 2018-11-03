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
    notify-send -t 500 -- 1
else
    notify-send -t 500 -- "$cur"
fi

