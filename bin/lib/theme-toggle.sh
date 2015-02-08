#!/usr/bin/env bash

DARK_THEME='Numix-Dark-GTK2'
DARK_ICONS='Faba-Mono-Dark'
DARK_GTK='Numix-Yosemite'

LIGHT_THEME='Greybird'
LIGHT_ICONS='Faba-Mono-Dark'
LIGHT_GTK='Numix-Yosemite'

_dark() {
    xfconf-query -c xsettings -p /Net/ThemeName -s "$DARK_THEME"
    xfconf-query -c xsettings -p /Net/IconThemeName -s "$DARK_ICONS"
    xfconf-query -c xfwm4 -p /general/theme -s "$DARK_GTK"
    xfconf-query -c xsettings -p /Gtk/ButtonImages -s false
}

_light() {
    xfconf-query -c xsettings -p /Net/ThemeName -s "$LIGHT_THEME"
    xfconf-query -c xsettings -p /Net/IconThemeName -s "$LIGHT_ICONS"
    xfconf-query -c xfwm4 -p /general/theme -s "$LIGHT_GTK"
    xfconf-query -c xsettings -p /Gtk/ButtonImages -s true
}

_toggle() {
    CURRENT_THEME=$(xfconf-query -c xsettings -p /Net/ThemeName)
    if [[ "$CURRENT_THEME" == "$LIGHT_THEME" ]]; then
        echo "previous theme: "$CURRENT_THEME" (light)"
        _dark
        echo 'switched theme and icons to: dark'
    else
        echo "previous theme: "$CURRENT_THEME" (dark)"
        _light
        echo 'switched theme and icons to: light'
    fi
}

if [ "$1" == "dark" ]; then
    _dark
    exit
fi

if [ "$1" == "light" ]; then
    _light
    exit
fi

_toggle
