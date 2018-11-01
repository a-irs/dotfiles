#!/usr/bin/env bash

set -eu

current_brightness() {
    xbacklight -get | cut -d . -f 1
}

if [[ "$1" == + ]]; then
    xbacklight + 5
    notify-send -t 500 -i brightness "$(current_brightness)"
elif [[ "$1" == - ]]; then
    xbacklight - 5
    notify-send -t 500 -i brightness "$(current_brightness)"
fi

# limit to 1
if [[ "$(current_brightness)" == 0 ]]; then
    xbacklight = 1
fi

