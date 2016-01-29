#!/usr/bin/env bash

set -e

if [[ $UID != 0 ]]; then
    echo "run as root"
    exit 1
fi

b=/media/data/backups

[[ ! -d "$b" ]] && exit 1

read -r -s -p "Passphrase: " BORG_PASSPHRASE
echo ''
export BORG_PASSPHRASE

rsync --size-only -av --delete -e "ssh -p 5522" "$b/borg/" alex@zshine.net:backups/borg-hosts

REPO=ssh://alex@zshine.net:5522/home/alex/backups/borg-private
DATE=$(date +%Y-%m-%d)_$(date +%H-%M-%S)
BACKUP=( $b/host $b/studium $b/encrypt $b/encrypt-old $b/privat )

borg init --encryption repokey "$REPO" || true
borg create --verbose --stats --progress \
    --one-file-system \
    --compression lz4 \
    --chunker-params 19,23,21,4095 \
    "$REPO"::"$DATE" \
    "${BACKUP[@]}"
borg prune --verbose --stats --keep-within 1m "$REPO"
