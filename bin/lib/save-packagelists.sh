#!/usr/bin/bash

d="$HOME/doc"
[ ! -d "$d" ] && mkdir "$d"
pacman -Qqe | sort > "$d/$(hostname)-packages.txt"
