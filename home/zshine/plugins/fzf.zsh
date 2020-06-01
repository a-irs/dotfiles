#!/usr/bin/env zsh

if [[ $commands[fd] ]]; then
    export FZF_DEFAULT_COMMAND="fd --hidden --no-ignore --color never -E .vim/undo -E .vim/plugged -E __pycache__ -E Cache -E .cache -E cache -E .gem -E .npm -E .thumbnails -E .steam -E .local/share/Steam -E .git"

    _fzf_compgen_path() {
        eval $FZF_DEFAULT_COMMAND . "$@"
    }
    _fzf_compgen_dir() {
        eval $FZF_DEFAULT_COMMAND --type directory . "$@"
    }
fi
# note: 'rg --files --hidden --no-ignore' is equally fast (benchmarked with hyperfine

for x in \
    /usr/local/opt/fzf/shell/{key-bindings,completion}.zsh \
    /usr/share/fzf/{key-bindings,completion}.zsh \
    /usr/share/doc/fzf/examples/key-bindings.zsh \
    /usr/share/zsh/vendor-completions/_fzf \
    ; do
    [[ -f "$x" ]] && source "$x"
done
unset x

export FZF_DEFAULT_OPTS='--no-mouse --cycle --ansi --color=16 --tiebreak=end,begin,length --inline-info --tiebreak=length'

export FZF_CTRL_R_OPTS='--height 70% --exact'
export FZF_ALT_C_OPTS='--height 70% --preview="show {}"'
export FZF_CTRL_T_OPTS='--height 70% --preview="show {}"'

export FZF_COMPLETION_TRIGGER='#'
export FZF_COMPLETION_OPTS='--multi --preview="show {}" --height 70%'


c() {
    dir=$(while read -r line; do
        d="${(Q)line}"
        [[ -d "$d" ]] && printf "%s\n" "${d/$HOME/~}"
    done < ~/.zsh_recent-dirs | fzf)
    cd "${dir/\~/$HOME}"
}
