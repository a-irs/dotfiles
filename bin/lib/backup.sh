#!/usr/bin/env bash

set -e

destination="root@srv:/media/data/backups/host/$HOSTNAME"

pacman -Qqe | sort > /tmp/packages.txt && scp /tmp/packages.txt "$destination" && rm -f /tmp/packages.txt

rsync -axH --delete --delete-excluded --stats --progress --human-readable --numeric-ids --info=progress2 \
--rsync-path="sudo rsync" \
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
--exclude '**/compile-cache' \
--exclude '**/Package Control.cache' \
--exclude '**/Cache' \
--exclude '**/cache' \
--exclude '**/backup' \
--exclude '**/Backup' \
--exclude '.cache/*' \
--exclude '.dropbox*' \
--exclude '.kodi/addons/packages/*' \
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
--exclude '.xfce4-session.verbose-log*' \
--exclude '.git-credentials' \
"$HOME" "$destination/home"

sudo rsync -axH --delete --delete-excluded --stats --progress --human-readable --numeric-ids --info=progress2 \
--rsync-path="sudo rsync" \
--exclude 'udev/hwdb.bin' \
--exclude 'ld.so.cache' \
--exclude '*.pacnew' \
--exclude '*.pacorig' \
--exclude '*.pacsave' \
--exclude '*~' \
/etc "$destination"

sudo rsync -axH --delete --delete-excluded --stats --progress --human-readable --numeric-ids --info=progress2 \
--rsync-path="sudo rsync" \
--exclude '.cache/*' \
--exclude '.git-credentials' \
/root "$destination"
