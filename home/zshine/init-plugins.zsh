ZSHINE_PLUGINS=(
  completion # tweaks for TAB-completion
  keys # bind keys for delete, history-search etc.

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
  python # python dev stuff
  aliases # provides some aliases and functions for daily work
  auto-ls # launch "ls" when entering directory
  nix # nixos, nix package manager
  kubernetes  # aliases, autocompletion for k8s

  infra # custom
)

if [[ "$os" == darwin* ]]; then
    ZSHINE_PLUGINS+=asdf
else
    ZSHINE_PLUGINS+=ssh-agent  # autostart ssh-agent
    ZSHINE_PLUGINS+=fasd  # autocomplete paths
    ZSHINE_PLUGINS+=todo  # show ~/.todo on start
fi

for _loadx in $ZSHINE_PLUGINS; do
    source "$ZSHINE_DIR/plugins/$_loadx.zsh"
done
unset _loadx
