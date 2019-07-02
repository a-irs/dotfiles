[[ -f /usr/local/bin/brew ]] || return

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1

bup() { su locai -c 'brew update && brew upgrade' && date +%s > ~/.brew-last-update; }

bup-check() {
    local days=$1

    local bup_current=$(date +%s)
    local bup_last=$(< ~/.brew-last-update)
    if (( bup_current - bup_last > 60 * 60 * 24 * days )); then
        printf "\n$BOLD_MAGENTA%s$RESET\n" "Homebrew not updated for more than ${days}d, please run bup."
    fi
}
bup-check 7
