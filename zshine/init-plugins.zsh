ZSHINE_PLUGINS=(
  cdr # recent dirs command
  # magic-paste # auto-quote URLs on paste
  term-title # sets terminal/tab title
  aliases # provides some aliases and functions for daily work
  dircolors # colors for "ls" command
  virtualenvwrapper # wrapper for python-virtualenv
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
  # zaw # better CTRL+R history search
  tty-colors # colors for $TERM=linux
  termite # include CTRL+T for termite terminal program
)
for z in $ZSHINE_PLUGINS; do; source "$ZSHINE_DIR/plugins/$z.zsh"; done

unset z
unset ZSHINE_PLUGINS
