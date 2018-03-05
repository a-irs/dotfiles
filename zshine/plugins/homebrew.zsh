[[ -f /usr/local/bin/brew ]] || return

export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_NO_AUTO_UPDATE=1

bup() { su locai -c 'brew upgrade' && date +%s > ~/.brew-last-update; }
local bup_current=$(date +%s)
local bup_last=$(< ~/.brew-last-update)
if (( bup_current - bup_last > 60 * 60 * 24 * 3 )); then
    printf "\n$BOLD_RED%s$RESET\n" "Homebrew not updated for more than 3 days, please run bup."
fi
unset bup_current bup_last
