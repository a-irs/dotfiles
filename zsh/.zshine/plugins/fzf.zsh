path+=("$ZSHINE_DIR/plugins/fzf/bin")
if [[ ! $commands[fzf] ]]; then
    "$ZSHINE_DIR/plugins/fzf/install" --bin
fi
[[ $commands[fzf] ]] || return

manpath+=("$ZSHINE_DIR/plugins/fzf/man")
source "$ZSHINE_DIR/plugins/fzf/shell/key-bindings.zsh"
source "$ZSHINE_DIR/plugins/fzf/shell/completion.zsh"

export FZF_DEFAULT_OPTS='--exact --no-mouse --cycle --ansi --color=16'
export FZF_CTRL_R_OPTS='--exact --height=20'

export FZF_COMPLETION_OPTS='--multi --preview="head -n 20 {}" --height=20 --no-exact'
export FZF_COMPLETION_TRIGGER='#'

if [[ $commands[fd] ]]; then
    _fzf_compgen_path() {
        fd --hidden --no-ignore --follow --color always \
            -E .git \
            -E __pycache__ \
            -E Cache \
            -E cache \
            -E .gem \
            -E .npm \
            . "$1"
    }
    export FZF_DEFAULT_COMMAND='fd --type file --hidden --no-ignore --follow --color always'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
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
alias cdr=c
