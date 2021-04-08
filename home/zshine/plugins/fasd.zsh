# https://github.com/clvv/fasd
#
# TODO:
# - make fasd faster...?

[[ $commands[fasd] ]] || return

export _FASD_IGNORE="fasd ls echo rm rmdir touch"
export _FASD_DATA=${XDG_DATA_HOME:-~/.local/share}/fasd

[[ -d "$HOME/.cache" ]] || mkdir -p "$HOME/.cache"
fasd_cache="$HOME/.cache/fasd.zsh"
if [[ "$commands[fasd]" -nt "$fasd_cache" || ! -s "$fasd_cache" ]]; then
    # just use zsh preexec and none of the completion definitions - we use fasd-fzf instead
    fasd --init zsh-hook >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache
