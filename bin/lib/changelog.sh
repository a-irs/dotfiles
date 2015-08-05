#!/usr/bin/env bash

case "$1" in
    exo|garcon|gtk-xfce-engine|libxfce4ui|libxfce4util|thunar|thunar-desktop-plugin|thunar-volman|tumbler|xfce4-appfinder|xfce4-dev-tools|xfce4-panel|xfce4-power-manager|xfce4-session|xfce4-settings|xfconf|xfdesktop|xfwm4 )
        curl -s "http://git.xfce.org/xfce/$1/plain/NEWS" | less ;;
    systemd )
        curl -s "http://cgit.freedesktop.org/systemd/systemd/plain/NEWS" | less ;;
    * )
        echo "unknown: $1" ;;
esac
