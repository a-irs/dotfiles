#!/bin/bash

DEST=/media/backup
SRC=/media/data

rsync_launch() {
	echo
	echo '########################################'
	echo
	echo "starting rsync..."
	echo
	echo "source: $1/$2"
	echo "target: $3/$2"
	echo
	echo "logfile: $3/$2.log"
	echo "backup-dir: $3/__archive/$2/$(date +%Y-%m-%d_%H-%M-%S)/"
	echo
	echo '########################################'
	echo
	rsync -av -h --delete --stats --log-file="$3/$2.log" --backup --backup-dir="$3/__archive/$2/$(date +%Y-%m-%d_%H-%M-%S)/" "$1/$2" "$3"
}

control_c() {
  echo -en "\n*** CTRL+C - starting cleanup ***\n"
  sync
  umount -lf "$DEST"
  sync
  exit $?
}

trap control_c SIGINT

delay=0.3
mount "$DEST"
if [ "$?" -eq 0 ]; then
	echo -e '\a' > /dev/console
	rsync_launch "$SRC" photos "$DEST"
	rsync_launch "$SRC" music "$DEST"
	rsync_launch "$SRC" books "$DEST"
	rsync_launch "$SRC" virtualbox "$DEST"
	rsync_launch "$SRC" backups "$DEST"
	rsync_launch "$SRC" games "$DEST"
	sync
	umount -lf "$DEST"
	sleep 5s
	sync
	echo -e '\a' > /dev/console ; sleep $delay
	echo -e '\a' > /dev/console
else
	echo -e '\a' > /dev/console ; sleep $delay
	echo -e '\a' > /dev/console ; sleep $delay
	echo -e '\a' > /dev/console
fi
