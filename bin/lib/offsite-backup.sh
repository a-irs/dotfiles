#!/usr/bin/env bash

set -e

send_backup() {
    mount | grep "on /var/tmp/offsite-backup/$1" || return 1
    [[ $? == 1 ]] && return 1

    rsync -a --delete --numeric-ids "/media/data/backups/host/$1/" "/var/tmp/offsite-backup/$1"
    rsync -a --compress --delete --numeric-ids -e "ssh -p 5522" "/var/tmp/offsite-backup/$1-encrypted" alex@zshine.net:backups
    rsync -a --compress --delete --numeric-ids -e "ssh -p 5522" "/var/tmp/offsite-backup/$1-ecryptfs" alex@zshine.net:backups
}

send_backup dell
send_backup desktop
