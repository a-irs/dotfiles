#!/usr/bin/env bash

if pgrep x2goagent > /dev/null; then
   echo -n "<txt><span weight='bold' fgcolor='red'> CONNECTED </span></txt>"
fi
