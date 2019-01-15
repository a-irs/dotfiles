# TODO: revise commented out entries

# links:
# - http://zsh.sourceforge.net/Doc/Release/Completion-System.html
# - http://www.masterzen.fr/2009/04/19/in-love-with-zsh-part-one/
# - https://github.com/paulmillr/dotfiles/blob/master/terminal/completion.sh

# disable flow control keys (ctrl+s, ctrl+q)
unsetopt flowcontrol

# setopt complete_in_word
# setopt always_to_end

zmodload -i zsh/complist

fpath+=($ZSHINE_DIR/completion $ZSHINE_DIR/plugins/zshmarks)
[[ -d ~/Homebrew/share/zsh/site-functions ]] && fpath+=~/Homebrew/share/zsh/site-functions

# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# zstyle ':completion:*' list-colors ''

# # should this be in keybindings?
# bindkey -M menuselect '^o' accept-and-infer-next-history

# in completion menu, show progress bar on bottom
zstyle ':completion:*' select-prompt %S%p%s

# show selection menu
zstyle ':completion:*' menu select

# verbose output when no match found
zstyle ':completion:*:warnings' format "%B%F{yellow}no match for:%f%b %d"

# separate matches into categories (files, aliases, ...)
zstyle ':completion:*' group-name ''
zstyle ':completion:*' format '%B%F{magenta}--- %d%f%b'

# show dirs before files (like ls --group-directories-first)
# not working with ls though it seems
zstyle ':completion:*' list-dirs-first true

# rm, diff, ...: disable autocompletion of files if they are already in argument list
zstyle ':completion:*:(rm|kill|diff):*' ignore-line other
zstyle ':completion:*:rm:*' file-patterns '*:all-files'

# treat foo//bar as foo/bar instead of foo/*/bar when completing
zstyle ':completion:*' squeeze-slashes true

# disable named-directories autocompletion
# zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories
# cdpath=(.)

# use ssh_config for hostname completion
[[ -r ~/.ssh/config ]] && _ssh_config=($(cat ~/.ssh/config | sed -ne 's/Host[=\t ]//p')) || _ssh_config=()
zstyle ':completion:*:hosts' hosts "$_ssh_config[@]"

zstyle ':completion:*' users off

# not working?
# # Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion:*' use-cache true

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache avahi beaglidx bin cacti canna clamav daemon \
        dbus distcache dovecot fax ftp games gdm gkrellmd gopher \
        hacluster haldaemon halt hsqldb ident junkbust ldap lp mail \
        mailman mailnull mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx openvpn \
        operator pcap postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm shutdown squid sshd sync uucp vcsa xfs

# ... unless we really want to.
zstyle '*' single-ignored show

# show '...' while autocomplete loads
expand-or-complete-with-dots() {
  echo -n "\e[1;31m…\e[0m"
  zle expand-or-complete
  zle redisplay
}
zle -N expand-or-complete-with-dots
bindkey "^I" expand-or-complete-with-dots

autoload -U compinit && compinit -u

zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==02=01}:${(s.:.)LS_COLORS}")'
