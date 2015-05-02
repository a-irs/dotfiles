#!/usr/bin/env bash

if pgrep -x x2goagent > /dev/null; then
    echo -n "<txt><span weight='bold' fgcolor='Red'> X2GO CONNECTED </span></txt>"
else
    echo -n "<txt></txt>"
fi
