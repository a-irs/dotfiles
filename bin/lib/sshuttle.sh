#!/bin/bash

pid=/tmp/sshuttle.pid

echo "before: $(curl -s icanhazip.com)"
sudo sshuttle -e 'ssh -i /home/alex/.ssh/id_rsa' --dns -r alex@zshine.net:5522 0/0 \
    -x 192.168.2.0/24 -x 10.0.0.0/24 -x 10.0.1.0/24 \
    -D --pidfile="$pid" --no-latency-control > /dev/null
sleep 1
echo "after:  $(curl -s icanhazip.com)"

echo -e "\n[ENTER TO STOP]"
read
[ -f "$pid" ] && sudo kill "$(cat "$pid")" && sudo rm -f "$pid"
