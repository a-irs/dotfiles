#!/usr/bin/env bash

set -e

if [[ $UID != 0 ]]; then
    echo "run as root"
    exit 1
fi

t=/0-backup-info

finish() {
    rm -rf "$t"
}
trap finish EXIT

REPO=root@srv:/media/data/backups/borg/$HOSTNAME
DATE=$(date +%Y-%m-%d)_$(date +%H-%M-%S)
BACKUP=( $t )
[[ -d /home ]]           && BACKUP+=( /home )
[[ -d /etc ]]            && BACKUP+=( /etc )
[[ -d /root ]]           && BACKUP+=( /root )
[[ -d /srv ]]            && BACKUP+=( /srv )
[[ -d /var/spool/cron ]] && BACKUP+=( /var/spool/cron )

header() {
    echo -e "\n$(tput setaf "${1}";tput bold)${2}$(tput init;tput sgr0)\n"
}

if [[ -z "$BORG_PASSPHRASE" ]]; then
    if [[ -f /borg-passphrase ]]; then
        export BORG_PASSPHRASE=$(< /borg-passphrase)
    else
        header 2 "ENTER PASSPHRASE"
        read -r -s -p "Passphrase: " BORG_PASSPHRASE
        echo ''
        export BORG_PASSPHRASE
    fi
fi

export BORG_CACHE_DIR=/var/tmp/borg
excludes="$(dirname "$(readlink -f "$0")")/backup.exclude"

if [[ $1 == list ]]; then
    header 3 "LIST ARCHIVES OF $REPO"
    borg list "$REPO"
    exit
fi

if [[ $1 == extract ]]; then
    header 3 "EXTRACT $REPO::$2"
    borg extract --verbose "$REPO"::"$2"
    exit
fi

if [[ $1 == info ]]; then
    header 3 "INFO FOR $REPO::$2"
    borg info --verbose "$REPO"::"$2"
    exit
fi

header 2 "INFORMATION ABOUT BACKUP"
echo "  - TARGET:   $(tput setaf 4)$REPO$(tput init;tput sgr0)::$DATE"
echo "  - SOURCES:  $(tput setaf 4)${BACKUP[*]}$(tput init;tput sgr0)"

header 2 "MAKING BACKUP INFO FILES in $t"
mkdir -p $t
echo "  - PACMAN PACKAGES"
pacman -Qe | sort > $t/packages.txt
echo "  - PARTITION LAYOUT OF /dev/sda"
LC_ALL=C fdisk -l /dev/sda > $t/disk-fdisk-sda.txt
if [[ $HOSTNAME == dell ]]; then
    echo "  - LUKS DUMP OF /dev/sda5"
    LC_ALL=C cryptsetup luksDump /dev/sda5 > $t/disk-luks-sda5.txt
    echo "  - LUKS HEADER BACKUP OF /dev/sda5"
    cryptsetup luksHeaderBackup /dev/sda5 --header-backup-file $t/disk-luks-header-sda5.img
fi

header 2 "INIT REPOSITORY"
borg init --encryption repokey "$REPO" || true

header 2 "BACKING UP ${BACKUP[*]}"
borg create --progress --stats --verbose \
    --exclude-caches --exclude-from "$excludes" \
    --checkpoint-interval 30 \
    --one-file-system \
    --compression lz4 \
    --chunker-params 19,23,21,4095 \
    "$REPO"::"$DATE" \
    "${BACKUP[@]}"

header 2 "PRUNING BACKUPS OLDER THAN 1 MONTH"
borg prune --verbose --stats --keep-within 1m "$REPO"

header 2 "CLEANING UP BACKUP INFO FILES in $t"
rm -rf "$t"


############## offsite backup

[[ $HOSTNAME != srv ]] && exit

b=/media/data/backups

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
