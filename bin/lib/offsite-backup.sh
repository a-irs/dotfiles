#!/usr/bin/env bash

set -e

tmp=/var/tmp/offsite-backup

send_backup() {
    mount | grep "on $tmp/$1" || return 1

    rsync -a --delete --numeric-ids "/media/data/backups/host/$1/" "$tmp/$1"
    rsync -a --compress --delete --numeric-ids -e "ssh -p 5522" "$tmp/$1-encrypted" alex@zshine.net:backups
    rsync -a --compress --delete --numeric-ids -e "ssh -p 5522" "$tmp/$1-ecryptfs" alex@zshine.net:backups
}

send_backup dell
send_backup desktop
