[[ -d ~/Homebrew ]] || return

export HOMEBREW_CASK_OPTS="--appdir=~/Applications"
export HOMEBREW_NO_ANALYTICS=1

path=(~/Homebrew/bin $path)

bup() {
    brew update && brew upgrade && date +%s > ~/.brew-last-update
}
local bup_current=$(date +%s)
local bup_last=$(< ~/.brew-last-update)
if (( bup_current - bup_last > 60 * 60 * 24 * 3 )); then
    printf "\n$(tput setaf 1;tput bold)%s$(tput sgr0)\n" "Homebrew not updated for more than 3 days, please run bup."
fi

brew-off() {
    printf "%s" "$(tput setaf 1)"
    brew unlink --dry-run "$1" | grep -v '/share/man/' | grep -v 'Would remove:' | sed "s|$HOME|~|"
    printf "%s\n" "$(tput sgr0)"
    brew unlink "$1"
}

brew-on() {
    printf "%s" "$(tput setaf 2)"
    brew link --dry-run "$1" | grep -v '/share/man/' | grep -v 'Would link:' | sed "s|$HOME|~|"
    printf "%s\n" "$(tput sgr0)"
    brew link "$1"
}
