#!/usr/bin/env bash

set -e

b=/media/data/backups
archive_dir=/var/tmp/duplicity

rsync --size-only -rv --delete -e "ssh -p 5522" "$b/duplicity" alex@zshine.net:backups

export PASSPHRASE=$(cat /duplicity-passphrase)

duplicity --full-if-older-than 1M --archive-dir="$archive_dir" --exclude-other-filesystems "$b/host" scp://alex@zshine.net:5522/backups/host
duplicity --archive-dir="$archive_dir" remove-older-than 1M --force scp://alex@zshine.net:5522/backups/sql

duplicity --full-if-older-than 1M --archive-dir="$archive_dir" --exclude-other-filesystems "$b/sql" scp://alex@zshine.net:5522/backups/sql
duplicity --archive-dir="$archive_dir" remove-older-than 1M --force scp://alex@zshine.net:5522/backups/sql

#duplicity --archive-dir=/var/tmp/duplicity "$b/privat" scp://alex@zshine.net:5522/backups/privat
#duplicity --archive-dir=/var/tmp/duplicity "$b/studium" scp://alex@zshine.net:5522/backups/studium

unset PASSPHRASE
