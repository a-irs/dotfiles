#!/usr/bin/env bash

set -e

destination="scp://root@srv//media/data/backups/duplicity/$HOSTNAME"
destination_ssh="root@srv:/media/data/backups/duplicity/$HOSTNAME"

header() {
    echo -e "\n$(tput setaf "${1}";tput bold)${2}$(tput init;tput sgr0)\n"
}
date="$(date "+%Y-%m-%d_%H-%M")"

# (UNENCRYPTED) backup package list

header 5 "sending package list to '$destination_ssh/${date}_packages.txt'"
pacman -Qe | sort > /tmp/packages.txt
scp /tmp/packages.txt "$destination_ssh/${date}_packages.txt"
rm -f /tmp/packages.txt


# (UNENCRYPTED) backup partition table and LUKS header

header 5 "sending storage info to '$destination_ssh'"
device=/dev/sda
LC_ALL=C sudo sfdisk ${device} -d > /tmp/disk-sfdisk-sda.txt
scp /tmp/disk-sfdisk-sda.txt "$destination_ssh/${date}_disk-sfdisk-sda.txt"
LC_ALL=C sudo fdisk -l ${device}  > /tmp/disk-fdisk-sda.txt
scp /tmp/disk-fdisk-sda.txt "$destination_ssh/${date}_disk-fdisk-sda.txt"

if [[ $HOSTNAME == dell ]]; then
    LC_ALL=C sudo cryptsetup luksDump ${device}5 > /tmp/disk-luks-sda5.txt
    scp /tmp/disk-luks-sda5.txt "$destination_ssh/${date}_disk-luks-sda5.txt"

    sudo rm -f /tmp/disk-luks-header-sda5.img
    sudo cryptsetup luksHeaderBackup ${device}5 --header-backup-file /tmp/disk-luks-header-sda5.img
    sudo chmod +r /tmp/disk-luks-header-sda5.img
    scp /tmp/disk-luks-header-sda5.img "$destination_ssh/${date}_disk-luks-header-sda5.img"
fi

sudo rm -f /tmp/disk-fdisk-sda.txt /tmp/disk-disk-sda.txt /tmp/disk-luks-sda5.txt /tmp/disk-luks-header-sda5.img


# encrypted duplicity backup

if [[ -z "$PASSPHRASE" ]]; then
    if [[ -f /duplicity-passphrase ]]; then
        export PASSPHRASE=$(cat /duplicity-passphrase)
    else
       read -r -s -p "Passphrase: " PASSPHRASE
       export PASSPHRASE
    fi
fi

archive_dir="/var/tmp/duplicity"
excludes="$(dirname "$(readlink -f "$0")")/backup.exclude"

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

if [[ "$1" == clean-all ]]; then
    header 2 "cleaning $destination/home"
    sudo -E duplicity --archive-dir="$archive_dir" remove-all-but-n-full 1 --force "$destination/home"
    header 2 "cleaning $destination/etc"
    sudo -E duplicity --archive-dir="$archive_dir" remove-all-but-n-full 1 --force "$destination/etc"
    header 2 "cleaning $destination/root"
    sudo -E duplicity --archive-dir="$archive_dir" remove-all-but-n-full 1 --force "$destination/root"
    if [[ $HOSTNAME == srv ]]; then
    header 2 "cleaning $destination/srv"
        sudo -E duplicity --archive-dir="$archive_dir" remove-all-but-n-full 1 --force "$destination/srv"
    header 2 "cleaning $destination/cron"
        sudo -E duplicity --archive-dir="$archive_dir" remove-all-but-n-full 1 --force "$destination/cron"
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
