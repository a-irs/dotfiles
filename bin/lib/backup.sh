#!/usr/bin/env bash

set -euo pipefail

[[ $UID != 0 ]] && { echo "$(tput setaf 1)run as root"; exit 1; }
(( $# < 1 )) && { echo "$(tput setaf 3)$(basename "$0") start|mount|list|check"; exit 2; }

TOPDIR=/media/crypto/borg
TARGET=$TOPDIR/$HOSTNAME
USER_HOST=root@srv

ssh $USER_HOST test -d "$TOPDIR" || { echo "$(tput setaf 1)$USER_HOST:$TOPDIR does not exist"; exit 1; }

t=/0-info

REPO=$USER_HOST:$TARGET
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP=( $t )
[[ -d /home ]]           && BACKUP+=( /home )
[[ -d /etc ]]            && BACKUP+=( /etc )
[[ -d /root ]]           && BACKUP+=( /root )
[[ -d /srv ]]            && BACKUP+=( /srv )
[[ -d /var/spool/cron ]] && BACKUP+=( /var/spool/cron )

header() {
    d=$(date +'%F %T')
    if [[ -t 1 ]]; then
        echo -e "\n$(tput setaf "${1}";tput bold)${d} -- ${2}$(tput init;tput sgr0)\n"
    else
        echo -e "\n${d} -- ${2}\n"
    fi
}

finish() {
    header 2 "CLEANING UP BACKUP INFO FILES in $t"
    rm -rfv "$t"
}
trap finish EXIT

export BORG_CACHE_DIR=/var/tmp/borg

case $1 in
    mount|mnt)
        header 3 "MOUNT $REPO::$2 to $3"
        borg mount "$REPO"::"$2" "$3" -o allow_other
        exit
        ;;
    check|chk)
        header 3 "CHECK $REPO"
        borg check "$REPO"
        exit
        ;;
    list|ls)
        header 3 "LIST ARCHIVES OF $REPO"
        borg list --verbose "$REPO"
        exit
        ;;
    start)
        ;;
    *)
        exit
esac

header 2 "STARTING BACKUP. INFORMATION ABOUT BACKUP"
echo "  - TARGET:   $(tput setaf 4)$REPO$(tput init;tput sgr0)"
echo "  - SOURCES:  $(tput setaf 4)${BACKUP[*]}$(tput init;tput sgr0)"

header 2 "MAKING BACKUP INFO FILES in $t"
mkdir -p "$t"
echo "  - PACMAN PACKAGES → packages.txt"
pacman -Qe | sort > "$t/packages.txt"
echo "  - PARTITION LAYOUT OF /dev/sda → disk-fdisk-sda.txt"
LC_ALL=C fdisk -l /dev/sda > "$t/disk-fdisk-sda.txt"
if [[ $HOSTNAME == dell ]]; then
    LUKS=/dev/sda1
    name=$(basename $LUKS)
    echo "  - LUKS DUMP OF $LUKS → disk-luks-$name.txt"
    LC_ALL=C cryptsetup luksDump $LUKS > "$t/disk-luks-$name.txt"
    echo "  - LUKS HEADER BACKUP OF $LUKS → disk-luks-header-$name.img"
    cryptsetup luksHeaderBackup $LUKS --header-backup-file "$t/disk-luks-header-$name.img"
fi

header 2 "INIT REPOSITORY"
borg init --verbose --encryption none "$REPO" || true

header 2 "BACKING UP ${BACKUP[*]}"
borg create \
    --progress --stats --verbose \
    --exclude-caches --exclude-from "$(dirname "$(readlink -f "$0")")/backup.exclude" \
    --one-file-system \
    "$REPO"::"$DATE" \
    "${BACKUP[@]}"

header 2 "PRUNING BACKUPS OLDER THAN 6 MONTHS"
borg prune --verbose --stats --list --keep-within 6m "$REPO"
