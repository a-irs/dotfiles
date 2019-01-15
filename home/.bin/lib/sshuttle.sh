#!/bin/bash

pid=/tmp/sshuttle.pid

echo BEFORE
before_ip=$(curl -s icanhazip.com)
before_info=$(curl -s ipinfo.io/$before_ip)
before_hostname=$(echo "$before_info" | grep '"hostname"' | cut -d: -f 2 | tr -d \" | tr -d , | xargs)
before_city=$(echo "$before_info" | grep '"city"' | cut -d: -f 2 | tr -d \" | tr -d , | xargs)
before_region=$(echo "$before_info" | grep '"region"' | cut -d: -f 2 | tr -d \" | tr -d , | xargs)
before_country=$(echo "$before_info" | grep '"country"' | cut -d: -f 2 | tr -d \" | tr -d , | xargs)
before_org=$(echo "$before_info" | grep '"org"' | cut -d: -f 2 | tr -d \" | tr -d , | xargs)
echo "IP:  $before_ip ($before_hostname)"
echo "GEO: $before_city, $before_region, $before_country"
echo "ORG: $before_org"
sudo sshuttle -e 'ssh -i /home/alex/.ssh/id_rsa' --dns -r alex@zshine.net:5522 0/0 \
    -x 192.168.2.0/24 -x 10.0.0.0/24 -x 10.0.1.0/24 \
    -D --pidfile="$pid" --no-latency-control
sleep 1

echo
echo AFTER
after_ip=$(curl -s icanhazip.com)
after_ip=$(curl -s icanhazip.com)
after_info=$(curl -s ipinfo.io/$after_ip)
after_hostname=$(echo "$after_info" | grep '"hostname"' | cut -d: -f 2 | tr -d \" | tr -d , | xargs)
after_city=$(echo "$after_info" | grep '"city"' | cut -d: -f 2 | tr -d \" | tr -d , | xargs)
after_region=$(echo "$after_info" | grep '"region"' | cut -d: -f 2 | tr -d \" | tr -d , | xargs)
after_country=$(echo "$after_info" | grep '"country"' | cut -d: -f 2 | tr -d \" | tr -d , | xargs)
after_org=$(echo "$after_info" | grep '"org"' | cut -d: -f 2 | tr -d \" | tr -d , | xargs)
echo "IP:  $after_ip ($after_hostname)"
echo "GEO: $after_city, $after_region, $after_country"
echo "ORG: $after_org"

echo -e "\n[ENTER TO STOP]"
read
[ -f "$pid" ] && sudo kill "$(cat "$pid")" && sudo rm -f "$pid"
