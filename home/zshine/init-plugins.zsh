ZSHINE_PLUGINS=(
  completion # tweaks for TAB-completion
  keys # bind keys for delete, history-search etc.
  magic-paste # auto-quote URLs on paste

  dircolors # colors for "ls" command
  tty-colors # colors for $TERM=linux
  syntax-highlighting # provides a syntax highlighted prompt
  zsh-history-substring-search # arrow key up/down history search

  prompt-git # provides functions for a git-prompt
  term-title # sets terminal/tab title

  fzf # fuzzy-search of files
  cdr # recent dirs command
  zshmarks # set bookmarks
  explain # explain command switches
  ssh-agent # autostart ssh-agent
  python # python dev stuff
  aliases # provides some aliases and functions for daily work
  auto-ls # launch "ls" when entering directory
  nix # nixos, nix package manager
  fasd # autocomplete paths
  todo # show ~/.todo on start
  kubernetes  # aliases, autocompletion for k8s

  infra # custom
)

for _loadx in $ZSHINE_PLUGINS; do
    source "$ZSHINE_DIR/plugins/$_loadx.zsh"
done
unset _loadx
