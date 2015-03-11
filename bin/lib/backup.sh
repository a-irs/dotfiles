#!/usr/bin/env bash

set -e

read -r -s -p "Passphrase: " PASSPHRASE
export PASSPHRASE

destination="scp://root@srv//media/data/backups/duplicity/$HOSTNAME"
destination_ssh="root@srv:/media/data/backups/duplicity/$HOSTNAME"
archive_dir="/var/tmp/duplicity"

header() {
    echo -e "\n$(tput setaf "${1}";tput bold)${2}$(tput init)\n"
}

backup() {
    src=$1
    dst=$2
    header 4 "backing up $src to $dst"
    if [[ "$3" == sudo ]]; then
        sudo -E duplicity --archive-dir="$archive_dir" --exclude-globbing-filelist="$(dirname "$(readlink -f "$0")")/backup.exclude" "$src" "$dst"
    else
        duplicity --archive-dir="$archive_dir" --exclude-globbing-filelist="$(dirname "$(readlink -f "$0")")/backup.exclude" "$src" "$dst"
    fi
}

header 4 "sending package list to $destination_ssh/packages.txt"
pacman -Qqe | sort > /tmp/packages.txt && scp /tmp/packages.txt "$destination_ssh/packages.txt" && rm -f /tmp/packages.txt

backup "$HOME" "$destination/home"
backup "/etc" "$destination/etc" sudo
backup "/root" "$destination/root" sudo
