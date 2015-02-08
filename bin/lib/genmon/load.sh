#!/usr/bin/env bash

load=$(LC_ALL=C uptime | rev | cut -d " " -f 1-3 | rev)

load1=$(echo $load | cut -d "," -f 1)
load5=$(echo $load | cut -d "," -f 2)
load15=$(echo $load | cut -d "," -f 3)

color1="#ccc"
color5="#999"
color15="#777"

echo "<txt><span weight=\"bold\" fgcolor=\"$color1\">$load1</span> \
<span weight=\"bold\" fgcolor=\"$color5\">$load5</span> \
<span weight=\"bold\" fgcolor=\"$color15\">$load15</span>  \
<span fgcolor=\"$color15\">|</span></txt>"
