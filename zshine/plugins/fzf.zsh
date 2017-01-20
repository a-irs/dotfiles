path+=("$ZSHINE_DIR/plugins/fzf/bin")
if [[ ! $commands[fzf] ]]; then
    "$ZSHINE_DIR/plugins/fzf/install" --bin
fi

manpath+=("$ZSHINE_DIR/plugins/fzf/man")
source "$ZSHINE_DIR/plugins/fzf/shell/key-bindings.zsh"
source "$ZSHINE_DIR/plugins/fzf/shell/completion.zsh"

export FZF_COMPLETION_OPTS='--multi --no-mouse --cycle --height=20 --inline-info --preview="head -n 20 {}" --color=16'
export FZF_COMPLETION_TRIGGER='#'

if [[ $commands[ag] ]]; then
    _fzf_compgen_path() {
        ag --hidden --g "" \
            --ignore .git \
            --ignore Cache \
            --ignore cache \
            --ignore .gem \
            --ignore .npm \
            "$1"
    }
fi
