#!/usr/bin/bash

artist=$(ncmpcpp --now-playing %a)
title=$(ncmpcpp --now-playing %t)
notify-send -i music "$artist" "$title"
