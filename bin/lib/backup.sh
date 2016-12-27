#!/usr/bin/env bash

set -euo pipefail

[[ $UID != 0 ]] && { echo "$(tput setaf 1)run as root"; exit 1; }
(( $# < 1 )) && { echo "$(tput setaf 3)$(basename "$0") start|mount|list|check"; exit 2; }

TARGET=/media/crypto/borg
USER_HOST=root@srv

ssh $USER_HOST test -d $TARGET || { echo "$(tput setaf 1)$USER_HOST:$TARGET does not exist"; exit 1; }

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
    echo -e "\n$(tput setaf "${1}";tput bold)${2}$(tput init;tput sgr0)\n"
}

finish() {
    rm -rf "$t"
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

header 2 "INFORMATION ABOUT BACKUP"
echo "  - TARGET:   $(tput setaf 4)$REPO$(tput init;tput sgr0)"
echo "  - SOURCES:  $(tput setaf 4)${BACKUP[*]}$(tput init;tput sgr0)"

header 2 "MAKING BACKUP INFO FILES in $t"
mkdir -p $t
echo "  - PACMAN PACKAGES → packages.txt"
pacman -Qe | sort > $t/packages.txt
echo "  - PARTITION LAYOUT OF /dev/sda → disk-fdisk-sda.txt"
LC_ALL=C fdisk -l /dev/sda > $t/disk-fdisk-sda.txt
if [[ $HOSTNAME == dell ]]; then
    echo "  - LUKS DUMP OF /dev/sda5 → disk-luks-sda5.txt"
    LC_ALL=C cryptsetup luksDump /dev/sda5 > $t/disk-luks-sda5.txt
    echo "  - LUKS HEADER BACKUP OF /dev/sda5 → disk-luks-header-sda5.img"
    cryptsetup luksHeaderBackup /dev/sda5 --header-backup-file $t/disk-luks-header-sda5.img
fi

header 2 "INIT REPOSITORY"
borg init --verbose --encryption none "$REPO" || true

header 2 "BACKING UP ${BACKUP[*]}"
borg create \
    --progress --stats --verbose \
    --exclude-caches --exclude-from "$(dirname "$(readlink -f "$0")")/backup.exclude" \
    --one-file-system \
    "$REPO"::'{hostname}_'"$DATE" \
    "${BACKUP[@]}"

header 2 "PRUNING BACKUPS OLDER THAN 1 MONTH"
borg prune --verbose --stats --list --prefix '{hostname}_' --keep-within 1m "$REPO"

header 2 "CLEANING UP BACKUP INFO FILES in $t"
rm -rfv "$t"

