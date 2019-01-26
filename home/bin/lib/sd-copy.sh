#!/usr/bin/env bash

log() {
    printf "%s\n" "$(date +'%F %T') $1"
}

SRC=/media/sd-card
DEST=/media/data4/photos

log "starting"

cleanup() {
    log "starting cleanup"
    sync
    umount -lf "$SRC"
    sync
    log "finished cleanup, exiting"
    exit $?
}
trap cleanup INT TERM EXIT

delay=0.3
log "mounting $SRC"
mount "$SRC"
if [ $? -eq 0 ]; then
        echo -e '\a' > /dev/console
        log "starting copy"
        /root/.bin/camcopy.py "$SRC" "$DEST"
        log "finished copy"
        echo -e '\a' > /dev/console ; sleep $delay
        echo -e '\a' > /dev/console
else
        echo -e '\a' > /dev/console ; sleep $delay
        echo -e '\a' > /dev/console ; sleep $delay
        echo -e '\a' > /dev/console
fi
