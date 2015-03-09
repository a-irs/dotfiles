#!/usr/bin/env bash

set -e

send_backup() {
    [ "$(ls -A /media/data-local/encrypted-upload/unlocked/$1)" ] || exit 1
    rsync -ax --delete --numeric-ids "/media/data/backups/host/$1/" "/media/data-local/encrypted-upload/unlocked/$1"
    rsync -axz --delete --numeric-ids -e 'ssh -p 5522' "/media/data-local/encrypted-upload/encrypted/$1" alex@zshine.net:backups
}

send_backup dell
send_backup desktop
