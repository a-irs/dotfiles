#!/usr/bin/env bash

set -eu

if [[ "$1" == + ]]; then
    xbacklight + 5
elif [[ "$1" == - ]]; then
    xbacklight - 5
fi

# limit to 1
if [[ "$(xbacklight -get | cut -d . -f 1)" == 0 ]]; then
    xbacklight = 1
fi

