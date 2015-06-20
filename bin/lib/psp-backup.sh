#!/usr/bin/env bash

dir="/run/media/$USER/PSP"
cd "$dir" && tar cvzf "$HOME/psp_$(date +%Y%m%d-%H%M%S).tar.gz" . \
--exclude ISO \
--exclude roms \
--exclude Roms \
--exclude .DS_STORE \
--exclude Thumbs.db \
--exclude .Trash* \
--exclude "Roms GBC" \
--exclude "Roms SMS"
sync
