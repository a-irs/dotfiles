#!/usr/bin/env bash

set -e

destination="root@srv:/media/data/backups/host/$HOSTNAME"

rsync -axH --delete --delete-excluded --stats --progress --human-readable --numeric-ids --info=progress2 \
--exclude 'dev/android' \
--exclude 'dev/venvs' \
--exclude 'dev/virtualbox' \
--exclude 'todo' \
--exclude 'media' \
--exclude 'media-gmusic' \
--exclude 'downloads/*' \
--exclude 'doc' \
--exclude '.mozilla/firefox/*/storage/temporary' \
--exclude '.mozilla/firefox/*/sessionstore-backups' \
--exclude '**/Cache' \
--exclude '**/cache' \
--exclude '**/backup' \
--exclude '**/Backup' \
--exclude '.cache/*' \
--exclude '.dropbox*' \
--exclude '.kodi/userdata/Thumbnails/*' \
--exclude '.kodi/userdata/Database/Textures*.db' \
--exclude '.local/share/gvfs-metadata/*' \
--exclude '.local/share/Trash' \
--exclude '.local/share/Steam' \
--exclude '.thumbnails/*' \
--exclude '.config/freshwrapper-data/Shockwave Flash/WritableRoot' \
--exclude '.zsh_recent-dirs' \
--exclude '.zcompdump' \
--exclude '.config/chrom*/Safe Browsing*' \
--exclude '.config/mpd/log' \
"$HOME" "$destination/home"

sudo rsync -axH --delete --delete-excluded --stats --progress --human-readable --numeric-ids --info=progress2 \
--exclude 'udev/hwdb.bin' \
/etc "$destination"

sudo rsync -axH --delete --delete-excluded --stats --progress --human-readable --numeric-ids --info=progress2 \
--exclude '.cache/*' \
/root "$destination"
