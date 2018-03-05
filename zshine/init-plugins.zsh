ZSHINE_PLUGINS=(
  homebrew # macos package manager
  cdr # recent dirs command
  # magic-paste # auto-quote URLs on paste
  term-title # sets terminal/tab title
  aliases # provides some aliases and functions for daily work
  dircolors # colors for "ls" command
  python # python dev stuff
  syntax-highlighting # provides a syntax highlighted prompt
  less-syntax-highlighting # syntax highlighting for "less" command
  zsh-history-substring-search # arrow key up/down history search
  bd # move back in current directory tree (breadcrumb-style)
  auto-ls # launch "ls" when entering directory
  prompt-git # provides functions for a git-prompt
  completion # tweaks for TAB-completion
  keys # bind keys for delete, history-search etc.
  fzf # CTRL+T for fuzzy-search of files
  # pwd-hell # show warning message when [[ pwd != readlink -f ./ ]]
  # tmux # autostart tmux
  # notify # notify-send after long command has been completed
  zshmarks # set bookmarks
  tty-colors # colors for $TERM=linux
  termite # include CTRL+T for termite terminal program
  todo # show ~/.todo on start
  explain # explain command switches
  ssh-agent
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
        source "$ZSHINE_DIR/plugins/$z.zsh"
    done
fi
unset z
