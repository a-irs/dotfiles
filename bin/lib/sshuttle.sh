#!/bin/bash

pid=/tmp/sshuttle.pid

sudo sshuttle --dns -r alexi@aquila.uberspace.de 0/0 \
    -x 192.168.2.0/24 -x 10.0.0.0/24 -x 10.0.1.0/24 \
    -D --pidfile="$pid" --no-latency-control

echo [ENTER TO STOP]
read
[ -f "$pid" ] && sudo kill $(cat "$pid") && sudo rm -f "$pid"
