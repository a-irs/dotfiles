#!/usr/bin/bash

d="$HOME/doc"
mkdir -p "$d"
pacman -Qqe | sort > "$d/$(hostname)-packages.txt"
