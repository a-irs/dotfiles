ZSHINE_PLUGINS=(
  completion # tweaks for TAB-completion
  keys # bind keys for delete, history-search etc.

  dircolors # colors for "ls" command
  tty-colors # colors for $TERM=linux
  syntax-highlighting # provides a syntax highlighted prompt
  zsh-history-substring-search # arrow key up/down history search

  prompt-git # provides functions for a git-prompt
  # magic-paste # auto-quote URLs on paste
  term-title # sets terminal/tab title

  # pwd-hell # show warning message when [[ pwd != readlink -f ./ ]]
  # tmux # autostart tmux
  # notify # notify-send after long command has been completed
  bd # move back in current directory tree (breadcrumb-style)
  auto-ls # launch "ls" when entering directory
  fzf # CTRL+T for fuzzy-search of files
  cdr # recent dirs command
  zshmarks # set bookmarks
  todo # show ~/.todo on start
  explain # explain command switches
  # ssh-agent # autostart ssh-agent
  homebrew # macos package manager
  python # python dev stuff
  aliases # provides some aliases and functions for daily work
  nix # nixos, nix package manager
  fasd # autocomplete paths
)

if [[ "$ZSHINE_DEBUG" == 1 ]]; then
    zmodload zsh/datetime
    b_prof_last=$((EPOCHREALTIME * 1000))
    for z in $ZSHINE_PLUGINS; do
        source "$ZSHINE_DIR/plugins/$z.zsh"
        b_prof_now=$((EPOCHREALTIME * 1000))
        printf "%3d %s -- %s\n" "$((b_prof_now - b_prof_last))" "ms" "$ZSHINE_DIR/plugins/$z.zsh"
        b_prof_last=$b_prof_now
    done
else
    for z in $ZSHINE_PLUGINS; do
        source "$ZSHINE_DIR/plugins/$z"
    done
fi
unset z
