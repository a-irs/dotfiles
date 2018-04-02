#!/usr/bin/env bash

set -uo pipefail

[[ $UID != 0 ]] && { echo "run as root"; exit 1; }
(( $# < 1 )) && { echo "$(basename "$0") start|mount|list|check"; exit 2; }

TOPDIR=/media/crypto/borg
TARGET=$TOPDIR/$HOSTNAME
USER_HOST=root@srv.home

if ! ssh $USER_HOST test -d "$TOPDIR"; then
    echo "$USER_HOST:$TOPDIR does not exist"
    /home/alex/.bin/pushover bash "ERROR: backup disk not mounted"
    exit 1
fi

t=/0-info

REPO=$USER_HOST:$TARGET
DATE=$(date +%Y-%m-%d_%H-%M-%S)
BACKUP=( $t )
[[ -d /home ]]           && BACKUP+=( /home )
[[ -d /etc ]]            && BACKUP+=( /etc )
[[ -d /root ]]           && BACKUP+=( /root )
[[ -d /srv ]]            && BACKUP+=( /srv )
[[ -d /boot ]]           && BACKUP+=( /boot )
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
        header 3 "MOUNT $REPO to $2"
        borg mount "$REPO" "$2" -o allow_other
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
header 2 "TARGET: $REPO"
header 2 "SOURCES: ${BACKUP[*]}"

header 2 "MAKING BACKUP INFO FILES in $t"
mkdir -p "$t"
echo "  - PACMAN PACKAGES → packages.txt"
pacman -Qe | sort > "$t/packages.txt"
root_disk=$(awk '$2 == "/"' /proc/self/mounts | grep -oP '^/dev/(sd.|mmcblk.|mapper/\S+)')
echo "  - PARTITION LAYOUT OF $root_disk → disk-fdisk-rootdisk.txt"
LC_ALL=C fdisk -l "$root_disk" > "$t/disk-fdisk-rootdisk.txt"
for dev in /dev/disk/by-uuid/*; do
    if cryptsetup isLuks "$dev"; then
        name=$(basename $dev)
        echo "  - LUKS DUMP OF $dev → disk-luks-$name.txt"
        LC_ALL=C cryptsetup luksDump $dev > "$t/disk-luks-$name.txt"
        echo "  - LUKS HEADER BACKUP OF $dev → disk-luks-header-$name.img"
        cryptsetup luksHeaderBackup $dev --header-backup-file "$t/disk-luks-header-$name.img"
    fi
done

header 2 "INIT REPOSITORY"
borg init --verbose --encryption none "$REPO" || true

header 2 "BACKING UP ${BACKUP[*]}"
borg create \
    --list --filter=AME --stats --verbose \
    --exclude-caches --exclude-from "$(dirname "$(readlink -f "$0")")/backup.exclude" \
    --one-file-system \
    "$REPO"::"$DATE" \
    "${BACKUP[@]}"

header 2 "PRUNING BACKUPS OLDER THAN 6 MONTHS AND >5"
borg prune --verbose --stats --list --keep-within 6m "$REPO" --keep-last 5

# header 2 "CHECKING ARCHIVES"
# borg check --verbose --info --archives-only "$REPO"
