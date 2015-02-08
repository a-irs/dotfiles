#!/usr/bin/env bash

update() {
    echo "[waiting for connection...]"
    nm-online
    echo ""
    echo "[updating repos...]"
    sudo pacman -Sy
    echo ""
    echo "[updating timestamp in ~/.pacman-last-update]"
    echo $(date '+%s') > ~/.pacman-last-update
    echo ""
}

WAIT=14400

update
while [ true ]; do
    if [ -f ~/.pacman-last-update ]; then
        LASTUPD=$(cat ~/.pacman-last-update)
        SECONDS_AGO=$(($(date '+%s')-$LASTUPD))
        echo [last update check was $SECONDS_AGO seconds ago]
        if [[ $WAIT -le $SECONDS_AGO ]]; then
            echo ""
            update
        else
            echo [... skipping]
            echo ""
        fi
    else
        echo [no last update found]
        echo ""
        update
    fi
    echo "[waiting 4 hours]"
    echo ""
    sleep $WAIT
done
