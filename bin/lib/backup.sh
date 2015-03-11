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
    sudo -E duplicity --archive-dir="$archive_dir" --exclude-other-filesystems --exclude-globbing-filelist="$(dirname "$(readlink -f "$0")")/backup.exclude" "$src" "$dst"
}

backup /home "$destination/home"
backup /etc "$destination/etc"
backup /root "$destination/root"
[[ -f /usr/bin/crond ]] && backup /var/spool/cron "$destination/cron"

header 3 "sending package list to $destination_ssh/$(date "+%Y-%m-%d_%H-%M")_packages.txt"
pacman -Qqe | sort > /tmp/packages.txt && scp /tmp/packages.txt "$destination_ssh/$(date "+%Y-%m-%d_%H-%M")_packages.txt" && rm -f /tmp/packages.txt
