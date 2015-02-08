ZSHINE_DIR=~/.zshine

# no duplicate entries for path arrays
typeset -gU cdpath fpath mailpath path
[ -d "$HOME/.bin" ] && path=("$HOME/.bin" $path)
[ -d "$HOME/.bin/$HOST" ] && path=("$HOME/.bin/$HOST" $path)
fpath+=($ZSHINE_DIR/completion $ZSHINE_DIR/prompts)

# load prompt
autoload -U promptinit
promptinit
setopt prompt_subst
prompt zshine

# zmv file-renaming
autoload -U zmv

# auto-escape URLs
autoload -U url-quote-magic
zle -N self-insert url-quote-magic

# edit current command line in $EDITOR
autoload -U edit-command-line
zle -N edit-command-line

# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#Recent-Directories
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':chpwd:*' recent-dirs-file ~/.zsh_recent-dirs +

zstyle ":completion:*:commands" rehash 1 # always rehash on completion

export GREP_COLOR='1;32'
export EDITOR="nano"
export PAGER="less"
export WINEARCH=win32
export TZ='Europe/Berlin'
export REPORTTIME=5

export HISTSIZE=50000
export SAVEHIST=50000
export HISTFILE=~/.zsh_history

setopt NOTIFY # Report status of background jobs immediately.
unsetopt BG_NICE # Don't run all background jobs at a lower priority.
unsetopt HUP # Don't kill jobs on shell exit.
unsetopt CHECK_JOBS # Don't report on jobs when shell exit.
setopt LONG_LIST_JOBS # list jobs in the long format (with pid etc.)
setopt HIST_IGNORE_ALL_DUPS # dont add duplicate dommands
setopt HIST_IGNORE_SPACE # do not add commands starting with space to history
setopt HIST_NO_FUNCTIONS # do not add function declarations to history
setopt HIST_NO_STORE # do not add 'history' command to history
setopt HIST_REDUCE_BLANKS # strip spaces etc. when adding to history
setopt HIST_VERIFY # safe history expansion
setopt SHARE_HISTORY # immediately add command to history and share with other shells
setopt NOTIFY
setopt HASH_CMDS
setopt HASH_LIST_ALL
setopt COMPLETEINWORD
setopt NOCHECKJOBS
setopt NOHUP
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt INTERACTIVECOMMENTS
setopt GLOBDOTS
setopt MULTIOS
setopt AUTOCD
unsetopt CORRECTALL
unsetopt CORRECT

ZSHINE_PLUGINS=(
  aliases # provides some aliases and functions for daily work
  term-title # sets terminal/tab title
  tty-colors # sets fancy terminal colors for TTY-login
  dircolors # set directory/filetype colors
  ls-colors # colors for "ls" command
  virtualenvwrapper # wrapper for python-virtualenv
  syntax-highlighting # provides a syntax highlighted prompt
  host-specific # sets some machine-specific details
  less-syntax-highlighting # syntax highlighting for "less" command
  auto256 # auto set 256 TERM
  history-substring-search # arrow key up/down history search
#  command-not-found # show packages that need to be installed for unknown commands
  bd # move back in current directory tree (breadcrumb-style)
  fzf # CTRL+T for fuzzy-search of files
  rationalise-dot # type cd ...... to change directory fast
  auto-ls # launch "ls" when entering directory
  prompt-git # provides functions for a git-prompt
  completion # tweaks for TAB-completion
  bindkey # bind keys for delete, history-search etc.
  zaw # better CTRL+R history search
#  notify # notify-send after long command has been completed
)
for z in $ZSHINE_PLUGINS; do source "$ZSHINE_DIR/plugins/$z.zsh"; done

RESET=$(tput sgr0)
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
GREY=$(tput setaf 8)
BOLD_BLACK=$(tput bold; tput setaf 0)
BOLD_RED=$(tput bold; tput setaf 1)
BOLD_GREEN=$(tput bold; tput setaf 2)
BOLD_YELLOW=$(tput bold; tput setaf 3)
BOLD_BLUE=$(tput bold; tput setaf 4)
BOLD_MAGENTA=$(tput bold; tput setaf 5)
BOLD_CYAN=$(tput bold; tput setaf 6)
BOLD_WHITE=$(tput bold; tput setaf 7)
BOLD_GREY=$(tput bold; tput setaf 8)
