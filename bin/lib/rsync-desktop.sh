#!/usr/bin/env bash

source="/"
destination="root@srv:/media/data/backups/host/desktop"

sudo rsync -e 'ssh -i /home/alex/.ssh/id_rsa' \
-axH --delete --stats --progress --human-readable --numeric-ids --info=progress2 \
--exclude '/lost+found' \
--exclude '/var/log/journal/*' \
--exclude '/var/lib/systemd/coredump/*' \
--exclude '/home/alex/downloads/*' \
--exclude '/home/alex/.cache/*' \
--exclude '/home/alex/.local/share/gvfs-metadata/*' \
--exclude '/home/alex/.local/share/Trash' \
--exclude '/home/alex/.thumbnails/*' \
"$source" "$destination"
