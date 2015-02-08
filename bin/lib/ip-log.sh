#!/usr/bin/env bash

ip4=$(curl -4 -s icanhazip.com)
ip6=$(curl -6 -s icanhazip.com)
echo "$(date +%Y-%m-%d);$ip4;$ip6" >> /var/log/external-ips.log
