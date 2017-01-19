path+=("$ZSHINE_DIR/plugins/fzf/bin")
manpath+=("$ZSHINE_DIR/plugins/fzf/man")
source "$ZSHINE_DIR/plugins/fzf/shell/key-bindings.zsh"
source "$ZSHINE_DIR/plugins/fzf/shell/completion.zsh"

export FZF_DEFAULT_OPTS='--multi --no-mouse --cycle --height=20 --inline-info --preview="head -n 20 {}" --color=16'
export FZF_COMPLETION_TRIGGER='#'

_fzf_compgen_path() {
  ag --hidden --ignore .git --ignore Cache --ignore cache --ignore .gem --ignore .npm -g "" "$1"
}
