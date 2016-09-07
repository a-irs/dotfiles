
alias bup() {
    brew update && brew upgrade
    date +%s > ~/.brew-last-update
}

current=$(date +%s)
last=$(< ~/.brew-last-update)
if (( current - last > 60 * 60 * 24 * 2 )); then
    printf "\n$(tput setaf 1;tput bold)%s$(tput sgr0)\n" "Homebrew not updated for more than 2 days, please run bup."
fi

