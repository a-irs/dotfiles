#!/usr/bin/env bash

set -e

if [[ -z "$PASSPHRASE" ]]; then
    if [[ -f /duplicity-passphrase ]]; then
        export PASSPHRASE=$(cat /duplicity-passphrase)
    else
       read -r -s -p "Passphrase: " PASSPHRASE
       export PASSPHRASE
    fi
fi

destination="scp://root@srv//media/data/backups/duplicity/$HOSTNAME"
destination_ssh="root@srv:/media/data/backups/duplicity/$HOSTNAME"
archive_dir="/var/tmp/duplicity"
excludes="$(dirname "$(readlink -f "$0")")/backup.exclude"

header() {
    echo -e "\n$(tput setaf "${1}";tput bold)${2}$(tput init;tput sgr0)\n"
}

if [[ "$1" == clean ]]; then
    header 3 "cleaning $destination/home"
    sudo -E duplicity --archive-dir="$archive_dir" clean --force "$destination/home"
    header 3 "cleaning $destination/etc"
    sudo -E duplicity --archive-dir="$archive_dir" clean --force "$destination/etc"
    header 3 "cleaning $destination/root"
    sudo -E duplicity --archive-dir="$archive_dir" clean --force "$destination/root"
    if [[ $HOSTNAME == srv ]]; then
        header 3 "cleaning $destination/srv"
        sudo -E duplicity --archive-dir="$archive_dir" clean --force "$destination/srv"
        header 3 "cleaning $destination/cron"
        sudo -E duplicity --archive-dir="$archive_dir" clean --force "$destination/cron"
    fi
    exit
fi

header 4 "backing up '/home' to '$destination/home'"
sudo -E duplicity --full-if-older-than 1M --archive-dir="$archive_dir" --exclude-other-filesystems --exclude-filelist="$excludes" "/home" "$destination/home"
sudo -E duplicity --archive-dir="$archive_dir" remove-older-than 3M --force "$destination/home"

header 4 "backing up '/etc' to '$destination/etc'"
sudo -E duplicity --full-if-older-than 1M --archive-dir="$archive_dir" --exclude-other-filesystems --exclude-filelist="$excludes" "/etc" "$destination/etc"
sudo -E duplicity --archive-dir="$archive_dir" remove-older-than 3M --force "$destination/etc"

header 4 "backing up '/root' to '$destination/root'"
sudo -E duplicity --full-if-older-than 1M --archive-dir="$archive_dir" --exclude-other-filesystems --exclude-filelist="$excludes" "/root" "$destination/root"
sudo -E duplicity --archive-dir="$archive_dir" remove-older-than 3M --force "$destination/root"

if [[ $HOSTNAME == srv ]]; then
    header 4 "backing up '/srv to '$destination/srv'"
    sudo -E duplicity --full-if-older-than 1M --archive-dir="$archive_dir" --include /srv/smb --include /srv/http --include /srv/docker/sabnzbd/state/sabnzbd.ini --exclude '**' "/srv" "$destination/srv"
    sudo -E duplicity --archive-dir="$archive_dir" remove-older-than 3M --force "$destination/srv"

    header 4 "backing up '/var/spool/cron' to '$destination/cron'"
    sudo -E duplicity --full-if-older-than 1M --archive-dir="$archive_dir" --exclude-other-filesystems --exclude-filelist="$excludes" "/var/spool/cron" "$destination/cron"
    sudo -E duplicity --archive-dir="$archive_dir" remove-older-than 3M --force "$destination/cron"
fi

unset PASSPHRASE

header 5 "sending package list to '$destination_ssh/$(date "+%Y-%m-%d_%H-%M")_packages.txt'"
pacman -Qe | sort > /tmp/packages.txt
scp /tmp/packages.txt "$destination_ssh/$(date "+%Y-%m-%d_%H-%M")_packages.txt" > /dev/null
rm -f /tmp/packages.txt
