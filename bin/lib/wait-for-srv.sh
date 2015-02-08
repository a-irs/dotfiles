#!/usr/bin/env bash

cmd=$*
[ -z "$cmd" ] && exit 1
REACHABLE_HOST="srv"

TRIES=0
while true; do
    let TRIES++
    if ((TRIES>50)); then
        echo "Maximum tries reached, aborting."
        notify-send "\"$REACHABLE_HOST\" not reachable." "Command: $cmd" --icon=dialog-error
        exit 1
    fi

    echo "Waiting for host at \"$REACHABLE_HOST\". Attempt Number "$TRIES"."

    ping -c 1 $REACHABLE_HOST &> /dev/null
    if [ $? -eq 0 ]; then
        echo "Host now reachable, executing \"$cmd\""
        $cmd
        exit
    else
        echo "\"$REACHABLE_HOST\" not reachable."
    fi

    sleep 1
done


