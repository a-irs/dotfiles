#!/bin/sh

echo "deprecated. use rsnapshot-backup.sh"
exit 1

DEST="root@srv.home:/mnt/data2/backups/host/dell.home"

# backup /etc
sudo rsync -av --delete --stats \
--delete-excluded --exclude-from=$HOME/bin/rsync-backup.exclude \
/etc $DEST

# backup /home
pacman -Qm | sudo tee /home/pkg_aur.txt > /dev/null
pacman -Qn | sudo tee /home/pkg_official.txt > /dev/null
pacman -Qe | sudo tee /home/pkg_explicit.txt > /dev/null
pacman -Q  | sudo tee /home/pkg_all.txt > /dev/null

rsync -av --delete --stats \
--delete-excluded --exclude-from=$HOME/bin/rsync-backup.exclude \
/home $DEST
