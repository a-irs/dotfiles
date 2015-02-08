#!/usr/bin/env bash

dir="/run/media/alex/PSP"
cd $dir && tar cvzf /media/storage/backup/psp/psp_$(date +%Y%m%d-%H%M%S).tar.gz . \
--exclude ISO \
--exclude roms \
--exclude Roms \
--exclude .DS_STORE \
--exclude Thumbs.db \
--exclude .Trash* \
--exclude "Roms GBC" \
--exclude "Roms SMS"
sync
