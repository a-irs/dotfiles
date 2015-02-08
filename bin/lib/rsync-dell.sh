#!/usr/bin/env bash

source="$HOME"
destination="root@srv:/media/data/backups/host/dell/home"

rsync -axH --delete --stats --progress --human-readable --numeric-ids --info=progress2 \
--exclude 'dev/android' \
--exclude 'dev/venvs' \
--exclude 'dev/virtualbox' \
--exclude 'todo' \
--exclude 'media' \
--exclude 'downloads/*' \
--exclude 'doc' \
--exclude '.cache/*' \
--exclude '.dropbox-folder' \
--exclude '.kodi/userdata/Thumbnails/*' \
--exclude '.local/share/gvfs-metadata/*' \
--exclude '.local/share/Trash' \
--exclude '.thumbnails/*' \
"$source" "$destination"
