os=$(uname | tr '[:upper:]' '[:lower:]')
v="fzf-0.13.3-${os}_amd64"
bin="$HOME/.local/share/fzf-bin/$v"

if [[ ! -f "$bin" ]]; then
    url="https://github.com/junegunn/fzf-bin/releases/download/0.13.3/$v.tgz"
    echo "INSTALLING fzf FROM $url"
    mkdir -p "$(dirname "$bin")"
    curl -sL "$url" | tar -xzC "$(dirname "$bin")"
fi

alias fzf="$bin --no-mouse --color=16"

__fsel() {
    command find . \
    \( -fstype 'dev' -o -fstype 'proc' \
        -o -path \*Cache\* \
        -o -path \*cache\* \
        -o -path \*/.atom/packages \
        -o -path \*/.atom/.node-gyp \
        -o -path \*/.atom/.apm \
        -o -name '.git' \
        -o -path \*/.gem \
        -o -path \*/.kodi/userdata/thumbnails \
        -o -path \*/.npm \
        -o -path \*/.m2 \
        -o -name \*.pyc \
    \) -prune \
    -o -type f -print \
    -o -type d -print \
    -o -type l -print 2> /dev/null | sed 1d | cut -b3- | fzf --extended-exact --preview='$HOME/.bin/preview {}' -m | while read item; do
        printf '%q ' "$item"
    done
    echo
}

# CTRL-T - Paste the selected file path(s) into the command line
fzf-file-widget() {
    LBUFFER="${LBUFFER}$(__fsel)"
    zle redisplay
}
zle     -N   fzf-file-widget
bindkey '^T' fzf-file-widget

# CTRL-G - cd into the selected directory
fzf-cd-widget() {
    old_chpwd=$(which chpwd 2> /dev/null)
    unfunction chpwd
    cd "${$(command find . \
        \( -fstype 'dev' -o -fstype 'proc' \) -prune \
        -o -type d -print 2> /dev/null | sed 1d | cut -b3- | fzf +m):-.}"
    eval "$old_chpwd"
    unset "$old_chpwd"
    zle reset-prompt
}
zle     -N    fzf-cd-widget
bindkey '^G' fzf-cd-widget

# CTRL-R - command history
fzf-history-widget() {
  local selected num
  setopt localoptions noglobsubst pipefail 2> /dev/null
  selected=( $(fc -l 1 | eval "fzf +s --extended-exact --tac +m -n2..,.. --tiebreak=index --toggle-sort=ctrl-r -q ${(q)LBUFFER}") )  
  local ret=$?
  if [ -n "$selected" ]; then
    num=$selected[1]
    if [ -n "$num" ]; then
      zle vi-fetch-history -n $num
    fi
  fi
  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init
  return $ret
}
zle     -N   fzf-history-widget
bindkey '^R' fzf-history-widget

