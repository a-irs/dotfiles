#!/usr/bin/env bash

green() { echo -en "\e[1;32m$*\e[0m"; }

red() { echo -en "\e[1;31m$*\e[0m"; }

sstatus() {
    status=$(systemctl show "$1" | grep ActiveState | cut -d= -f 2)
    if [[ "$status" == "active" ]]; then
        green "$1\n"
    else
        red "$1\n"
    fi
}

docker_active=$(docker ps | tail -n +2 | awk '{print $NF}')
docker_inactive=$(docker ps -a -f="status=exited" | tail -n +2)
dstatus() {
    name=$1
    if echo "$docker_active" | grep -q "$name"; then
        green "$1.docker\n"
    else
        red "$1.docker\n"
    fi
}


echo ""
echo -n "load "
awk '{print $1 " " $2 " " $3}' /proc/loadavg
echo ""
if [[ $HOSTNAME == srv1 ]]; then
    sstatus containerd.service
    sstatus cronie.service
    sstatus dhcpcd@eth0.service
    sstatus docker.service
    sstatus iptables.service
    sstatus qemu-guest-agent.service
    sstatus sshd.service
    echo ""
    sstatus media-data1.mount
    sstatus media-data2.mount
    sstatus media-data3.mount
    sstatus media-data4.mount
    sstatus media-data.mount
    sstatus media-crypto.mount
    exclude_df='(/var/lib/docker|/srv/sftp)'
elif [[ $HOSTNAME =~ srv(2|3) ]]; then
    sstatus containerd.service
    sstatus cron.service
    sstatus docker.service
    sstatus qemu-guest-agent.service
    sstatus rsyslog.service
    sstatus sshd.service
    sstatus unattended-upgrades.service
    exclude_df='(/var/lib/docker|/media/data)'
elif [[ $HOSTNAME == desk ]]; then
    sstatus cronie.service
    sstatus dhcpcd@eth0.service
    sstatus docker.service
    sstatus hd-idle.service
    sstatus iptables.service
    sstatus sshd.service
    echo ""
    sstatus media-HDD_GAMES.mount
    sstatus media-data.mount
    exclude_df='(/var/lib/docker)'
fi
echo ""
if command -v pydf > /dev/null 2>&1; then
    pydf --mounts <(grep -Ev "$exclude_df" /proc/mounts)
else
    df -h | grep -Ev "$exclude_df"
fi
echo ""
echo -n "$(tput setaf 1)"
docker ps -f status=exited | tail +2
docker ps -f health=unhealthy | tail +2
docker ps -f status=dead | tail +2
docker ps -f status=restarting | tail +2
echo -n "$(tput sgr0)"
