#!/usr/bin/env bash

RESET=$(tput sgr0)
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
GREY=$(tput setaf 8)
BOLD_BLACK=$(tput bold; tput setaf 0)
BOLD_RED=$(tput bold; tput setaf 1)
BOLD_GREEN=$(tput bold; tput setaf 2)
BOLD_YELLOW=$(tput bold; tput setaf 3)
BOLD_BLUE=$(tput bold; tput setaf 4)
BOLD_MAGENTA=$(tput bold; tput setaf 5)
BOLD_CYAN=$(tput bold; tput setaf 6)
BOLD_WHITE=$(tput bold; tput setaf 7)
BOLD_GREY=$(tput bold; tput setaf 8)

# ~/.bin/lib/colortests/pacman

printf "\n"

os="Arch Linux"
kernel=$(uname -r | cut -d- -f 1)

printf " %s\n" "${BOLD_BLUE}OS:${RESET} $os"
printf " %s\n" "${BOLD_BLUE}Kernel:${RESET} $kernel"
printf " %s\n" "${BOLD_BLUE}Shell:${RESET} $(zsh --version | cut -d\( -f 1)"

printf "\n"

if [[ -f ~/.gtkrc-2.0 ]]; then
    gtk2_theme=$(grep '^gtk-theme-name' "$HOME/.gtkrc-2.0" | awk -F' = ' '{print $2}')
    gtk2_theme=${gtk2_theme//\"/}
    gtk_icons=$(grep '^gtk-icon-theme-name' "$HOME/.gtkrc-2.0" | awk -F' = ' '{print $2}')
    gtk_icons=${gtk_icons//\"/}
    gtk_font=$(grep '^gtk-font-name' "$HOME/.gtkrc-2.0" | awk -F' = ' '{print $2}')
    gtk_font=${gtk_font//\"/}
    gtk_font=${gtk_font//[0-9]/}
    gtk_font=$(printf "%s" "$gtk_font" | xargs)
fi

if [[ -f ~/.config/termite/config ]]; then
    terminal_font=$(grep '^font' ~/.config/termite/config | awk -F' = ' '{print $2}')
    terminal_font=${terminal_font//[0-9]/}
    terminal_font=$(printf "%s" "$terminal_font" | xargs)
fi

wm="$(wmctrl -m | grep '^Name: ' | awk -F": " '{$1=""; print substr($0,2)}')"
printf " %s\n" "${BOLD_YELLOW}WM:${RESET} $wm"
printf " %s\n" "${BOLD_YELLOW}GTK:${RESET} $gtk2_theme, $gtk_icons, $gtk_font"
printf " %s\n" "${BOLD_YELLOW}Fonts:${RESET} $gtk_font, $terminal_font, Cure"

printf "\n"
printf " %s\n" "${BOLD_GREEN}dotfiles ${RESET}→ https://github.com/a-irs/dotfiles"
