#!/usr/bin/env bash

cmdline=$(cat /proc/cmdline)
echo $cmdline | grep subvol &> /dev/null
if [[ $? -eq 0 ]]; then
    c=$(echo "$cmdline" | cut -d " " -f 4 | cut -d "=" -f 3)
    echo "<txt><span weight='bold' fgcolor='#FB2020'>$c  </span> </txt>"
else
    echo ""
fi
