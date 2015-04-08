#!/usr/bin/env bash

set -e

if [[ -f /duplicity-passphrase ]]; then
    export PASSPHRASE=$(cat /duplicity-passphrase)
else
    read -r -s -p "Passphrase: " PASSPHRASE
    export PASSPHRASE
fi

destination="scp://root@srv//media/data/backups/duplicity/$HOSTNAME"
destination_ssh="root@srv:/media/data/backups/duplicity/$HOSTNAME"
archive_dir="/var/tmp/duplicity"

header() {
    echo -e "\n$(tput setaf "${1}";tput bold)${2}$(tput init)\n"
}

backup() {
    src=$1
    dst=$2
    extra_options=$3
    header 4 "backing up $src to $dst"
    if [[ -n "$extra_options" ]]; then
        eval $(echo sudo -E duplicity --archive-dir="$archive_dir" --exclude-other-filesystems $(echo $extra_options) "$src" "$dst")
    else
        sudo -E duplicity --archive-dir="$archive_dir" --exclude-other-filesystems --exclude-globbing-filelist="$(dirname "$(readlink -f "$0")")/backup.exclude" "$src" "$dst"
    fi
}

backup /home "$destination/home"
backup /etc "$destination/etc"
backup /root "$destination/root"

if [[ $HOSTNAME == srv ]]; then
    backup /srv "$destination/srv" "--include /srv/smb --include /srv/http --include /srv/docker/sabnzbd/state/sabnzbd.ini --exclude '**'"
    backup /var/spool/cron "$destination/cron"
fi
unset PASSPHRASE

header 5 "sending package list to $destination_ssh/$(date "+%Y-%m-%d_%H-%M")_packages.txt"
pacman -Qe | sort > /tmp/packages.txt && scp /tmp/packages.txt "$destination_ssh/$(date "+%Y-%m-%d_%H-%M")_packages.txt" && rm -f /tmp/packages.txt

