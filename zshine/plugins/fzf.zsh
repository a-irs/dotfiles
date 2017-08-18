path+=("$ZSHINE_DIR/plugins/fzf/bin")
if [[ ! $commands[fzf] ]]; then
    "$ZSHINE_DIR/plugins/fzf/install" --bin
fi

manpath+=("$ZSHINE_DIR/plugins/fzf/man")
source "$ZSHINE_DIR/plugins/fzf/shell/key-bindings.zsh"
source "$ZSHINE_DIR/plugins/fzf/shell/completion.zsh"

export FZF_DEFAULT_OPTS='--exact --no-mouse --cycle --color=16'
export FZF_CTRL_R_OPTS='--exact --height=20'

export FZF_COMPLETION_OPTS='--multi --preview="head -n 20 {}" --height=20 --no-exact'
export FZF_COMPLETION_TRIGGER='#'

if [[ $commands[ag] ]]; then
    _fzf_compgen_path() {
        ag --hidden -g "" \
            --ignore .git \
            --ignore Cache \
            --ignore cache \
            --ignore .gem \
            --ignore .npm \
            "$1"
    }
fi

FZF_ALT_C_OPTS='--height=20 --preview="gls -1 --color=always --group-directories-first -F -- {}"'
bindkey '^f' fzf-cd-widget

c() {
    dir=$(while read -r line; do
        d="${(Q)line}"
        [[ -d "$d" ]] && printf "%s\n" "${d/$HOME/~}"
    done < ~/.zsh_recent-dirs | fzf)
    cd "${dir/\~/$HOME}"
}
