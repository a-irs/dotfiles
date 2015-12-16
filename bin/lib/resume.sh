#!/usr/bin/env bash

sleep 1

logger "running xset"
xset r rate 200 30

logger "waiting for network"
nm-online
logger "network online, starting dropboxd"
$HOME/.dropbox-dist/dropboxd
