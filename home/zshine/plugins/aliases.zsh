#!/usr/bin/env zsh

if [[ "$commands[nvim]" ]]; then
    alias vim='nvim'
    vim=nvim
else
    vim=vim
fi

alias et="emacsclient -c --alternate-editor='' -t"
alias e="emacsclient -c --alternate-editor='' -n"

# open e.g. html file in temporary browser in app mode
web() {
    local t f
    f=$1
    t=$(mktemp -d)

    bash -c "chromium --user-data-dir=\"$t\" --app=\"file://\$(readlink -f \"$f\")\" &> /dev/null; rm -rf \"$t\"" &
}

kali() { _kali kali "$@"; }
kali-gpu() { _kali kali-gpu "$@" --device /dev/dri --device /dev/vga_arbiter; }
kali-rev() { _kali kali-rev "$@" -p 4444:4444 -p 9000:9000 -p 9001:9001 -p 9002:9002 -p 9003:9003; }
kali-x11() { _kali kali-x11 "$@" -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=unix$DISPLAY; }
_kali() {
    local d=~/doc/ctf

    if [[ "$1" == build ]]; then
        shift
        (cd "$d" && docker build "$@" -t kali .)
        return
    else
        hostname=$1 && shift
        touch "$d/shell.history"
        docker run -h "$hostname" -it --rm -w /root \
            -v "$d:/work" \
            -v "$d/shell.history:/root/.bash_history" \
            -v "$d/shell.conf:/root/.bashrc" \
            "$@" kali
    fi
}

tmpdir() {
    local t=$(mktemp -d)
    trap "rm -rfv "$t"" EXIT
    cd "$t"
}

es() {
    local query=$1
    local line=$(command rg -n --color=always "$query" | fzf --reverse)

    local filename=$(printf '%s' "$line" | awk -F ':' '{print $1}')
    local linenumber=$(printf '%s' "$line" | awk -F ':' '{print $2}')

    if [[ -n "$filename" ]]; then
        echo $vim "+$linenumber" -c "silent! /$query" "$filename"
        $vim "+$linenumber" -c "silent! /$query" "$filename"
    fi
}

for c in find ftp locate rake rsync wcalc scp; do
    [[ "$commands[$c]" ]] && alias $c="noglob $c"
done

mac() { curl -q "https://api.macvendors.com/${1:0:8}" && printf "\n"; }

cht() { curl "https://cht.sh/$1"; }

tar-tar() { tar cvaf "$(basename "$PWD")".tar -- "$@"; }
tar-gz()  { tar cvaf "$(basename "$PWD")".tar.gz -- "$@"; }
tar-xz()  { tar cvaf "$(basename "$PWD")".tar.xz -- "$@"; }
tar-bz()  { tar cvaf "$(basename "$PWD")".tar.bz2 -- "$@"; }
tar-lz()  { tar cvaf "$(basename "$PWD")".tar.lzma -- "$@"; }
tar-zip() { zip -r "$(basename "$PWD")".zip -- "$@"; }

rotate-log() {
    [[ "$1" ]] || return 1
    local outname="$1.$(date +'%F_%T')"
    mv -v "$1" "$outname" && bzip2 -v "$outname"
}

toggle-scheme() {
    # Termite
    if [[ $(readlink ~/.config/termite/config) == config_light ]]; then
        (cd ~/.config/termite && ln -sfv config_dark config)
    elif [[ $(readlink ~/.config/termite/config) == config_dark ]]; then
        (cd ~/.config/termite && ln -sfv config_light config)
    else
        (cd ~/.config/termite && ln -sfv config_dark config)
    fi
    killall -USR1 termite 2> /dev/null

    # VIM
    if grep -q 'set background=dark' ~/.vimrc; then
        sed --follow-symlinks -i 's/set background=dark/set background=light/g' ~/.vimrc
        echo "sed dark -> light"
    elif grep -q 'set background=light' ~/.vimrc; then
        sed --follow-symlinks -i 's/set background=light/set background=dark/g' ~/.vimrc
        echo "sed light -> dark"
    fi
}

each-file() {
    for f in *(.); do
        echo -e "\n${BOLD_YELLOW}$* ${f}${RESET}\n"
        eval "$@" "$f"
    done
}

back() {
    nohup "$@" </dev/null &>/dev/null &
}

monitor() {
    while true; do
        clear
        printf '%s%s\n' "$GREEN" "$*"
        printf '%s%*s%s' "$GREEN" "$(tput cols)" "$(date +%H:%M:%S)" "$RESET"
        eval "$@"
        sleep 0.5
    done
}

wait_until_process_not_exists() {
    while pgrep -x "$1" > /dev/null; do
        sleep 0.5
    done
    echo "$1 does not exist any more"
}

wait_until_file_does_not_exist() {
    while [[ -e "$1" ]]; do
        sleep 0.1
    done
    echo "$1 does not exist any more"
}

dl() {
    case "$1" in
        (*T|*t|*Tb|*TB|*tb|*tB) UNIT1=TB ;;
        (*G|*g|*Gb|*GB|*gb|*gB) UNIT1=GB ;;
        (*M|*m|*Mb|*MB|*mb|*mB) UNIT1=MB ;;
        (*K|*k|*Kb|*KB|*kb|*kB) UNIT1=KB ;;
        (*) echo "unknown" && return 1;;
    esac
    local VAL1=${1//,/\.}
    VAL1=${VAL1//[^0-9|\.]}

    case "$2" in
        (*T|*t|*Tb|*TB|*tb|*tB) UNIT2=TB ;;
        (*G|*g|*Gb|*GB|*gb|*gB) UNIT2=GB ;;
        (*M|*m|*Mb|*MB|*mb|*mB) UNIT2=MB ;;
        (*K|*k|*Kb|*KB|*kb|*kB) UNIT2=KB ;;
        (*) echo "unknown" && return 1;;
    esac
    local VAL2=${2//,/\.}
    VAL2=${VAL2//[^0-9|\.]}

    case "$UNIT1" in
        KB) VAL1B=$((VAL1*1024)) ;;
        MB) VAL1B=$((VAL1*1024*1024)) ;;
        GB) VAL1B=$((VAL1*1024*1024*1024)) ;;
        TB) VAL1B=$((VAL1*1024*1024*1024*1024)) ;;
    esac

    case "$UNIT2" in
        KB) VAL2B=$((VAL2*1024)) ;;
        MB) VAL2B=$((VAL2*1024*1024)) ;;
        GB) VAL2B=$((VAL2*1024*1024*1024)) ;;
        TB) VAL2B=$((VAL2*1024*1024*1024*1024)) ;;
    esac

    echo -ne "\nDownloading ${BOLD_GREEN}$VAL2 $UNIT2${RESET} at ${BOLD_GREEN}$VAL1 $UNIT1/s${RESET} takes ${BLUE}"

    local TIME=$((VAL2B/VAL1B))
    local DAYS=$(( TIME / 60 / 60 / 24 ))
    local HOURS=$(( TIME / 60 / 60 % 24 ))
    local MINUTES=$(( TIME / 60 % 60 ))
    local SECONDS=$(( TIME % 60 ))
    (( DAYS > 0 )) && echo -n "${DAYS}d and "
    (( HOURS > 0 )) && echo -n "${HOURS}h "
    (( MINUTES > 0 )) && echo -n "${MINUTES}m "
    (( SECONDS > 0 )) && echo -n "${SECONDS}s"
    (( SECONDS == 0 )) && echo -n "less than 1s."
    echo "${RESET}"
}

calc() { printf "%s\n" "$@" | bc -l; }
alias calc="noglob calc"

p() { for f in "$@"; do printf "\n%s\n\n" "=========== $f" && show "$f"; done }

[[ "$commands[less]" ]] && alias less='less -FXR'
[[ "$commands[lsblk]" ]] && alias lsblk='lsblk -o NAME,LABEL,TYPE,FSTYPE,SIZE,MOUNTPOINT,UUID -p'
[[ "$commands[grep]" ]] && alias grep='grep --color=auto'
[[ "$commands[dmesg]" ]] && alias dmesg='dmesg -T --color=auto'
[[ "$commands[sudo]" ]] && alias sudo='sudo '
[[ "$commands[pydf]" ]] && alias df='pydf'

[[ "$commands[fd]" ]] && alias fd='fd --hidden --no-ignore'
[[ "$commands[fdfind]" ]] && alias fd='fdfind --hidden --no-ignore'
[[ "$commands[rg]" ]] && alias rg='rg --case-sensitive'

alias cp='cp -i'
alias ln='ln -i'
alias mv='mv -i'
alias mkdir='mkdir -p'
take() { mkdir -p "$1" && cd "$1"; }
alias rd='rmdir'
alias f='noglob find . -name'
alias ff='noglob find . -type f -name'

alias mmv='noglob zmv -W'

# define basic "ls" first
if [[ "$commands[lsd]" ]]; then
    ls="\lsd -F --date relative --group-dirs first"
elif [[ "$commands[gls]" ]]; then
    ls="\gls -F --literal --color=auto --group-directories-first"
else
    if [[ "$os" == darwin* ]]; then
        ls="\ls -F"
        alias lo="\ls -lhGF -O@"
    else
        ls="\ls -F --literal --color=auto --group-directories-first"
    fi
fi

# ls aliases
alias l="$ls"
alias ls="$ls -lh"
alias ll="$ls -lh"
alias la="$ls -lhA"
alias lss="$ls -lhSr"
alias l.="$ls -lhd .*"
alias lt="$ls -lhtr"
alias lS="$ls -lhSr"

[[ "$commands[python]" ]] && alias http-share='python -m http.server'
[[ "$commands[dropbox-cli]" ]] && alias ds='dropbox-cli status'
[[ "$commands[dropbox-cli]" ]] && alias dstop='dropbox-cli stop'
[[ "$commands[dropbox-cli]" ]] && alias dstart='dropbox-cli start'
[[ "$commands[nmcli]" ]] && alias nu='nmcli connection up'
[[ "$commands[nmcli]" ]] && alias nd='nmcli connection down'

if [[ "$commands[tmux]" ]]; then
    alias t='tmux'
    alias ta='tmux attach -t'
    alias tn='tmux new-session -s'
    alias tk='tmux kill-session -t'
    alias tl='tmux list-sessions'

    # capture tmux pane and edit in vim
    tc() {
        # http://man7.org/linux/man-pages/man1/tmux.1.html
        tmux capture-pane -pCS - \
            | sed '$!N; /^\(.*\)\n\1$/!P; D' \
            | sed 's/❯/$/g;s//>/g' \
            | $vim -
    }
fi

[[ "$commands[xev]" ]] && capture-keys() { xev | grep -A2 --line-buffered '^KeyRelease' | sed -n '/keycode /s/^.*keycode \([0-9]*\).* (.*, \(.*\)).*$/\1 \2/p'; }
[[ "$commands[youtube-dl]" ]] && alias yt-audio='noglob youtube-dl -f bestaudio -x -o "%(title)s.%(ext)s"'
[[ "$commands[youtube-dl]" ]] && alias yt='noglob youtube-dl --write-sub --sub-lang en,de --embed-subs --prefer-free-formats --write-info-json -f bestvideo+bestaudio'
[[ "$commands[journalctl]" ]] && alias j='sudo journalctl'

if [[ "$commands[xdg-open]" ]]; then
    os() {
        [[ -z "$1" || ! -e "$1" ]] && return 1
        mimeopen --ask-default "$1"
    }
    o() {
        if [[ ! "$1" ]]; then
            nohup xdg-open . < /dev/null &> /dev/null &
        else
            nohup xdg-open $* < /dev/null &> /dev/null &
        fi
    }
fi

cd() {
    if [[ -f "$1" ]]; then
        printf "${YELLOW}%s${RESET}\n\n" "cd: correcting $1 to ${1:h}"
        builtin cd "${1:h}"
    else
        builtin cd "$@"
    fi
}

[[ -d ~/.dot ]] && dot() { cd ~/.dot; git status -sb; }
[[ -d ~/git/a-irs/dot ]] && dot() { cd ~/git/a-irs/dot; git status -sb; }
[[ -d /srv/infra ]] && infra() { cd /srv/infra; git status -sb; }

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias .......="cd ../../../../../.."

extract() {
    while (( $# > 0 )); do
        if [[ ! -f "$1" ]]; then
            echo "extract: '$1' is not a valid file" 1>&2
            shift
            continue
      fi

      file_name="$( basename "$1" )"
      extract_dir="$( echo "$file_name" | sed "s/\.${1##*.}//g" )"
      case "$1" in
            (*.tar.gz|*.tgz) [[ ! $commands[pigz] ]] && tar zxvf "$1" || pigz -dc "$1" | tar xv ;;
            (*.tar.bz2|*.tbz|*.tbz2) tar xvjf "$1" ;;
            (*.tar.xz|*.txz) tar --xz --help &> /dev/null \
                && tar --xz -xvf "$1" \
                || xzcat "$1" | tar xvf - ;;
            (*.tar.zma|*.tlz) tar --lzma --help &> /dev/null \
                && tar --lzma -xvf "$1" \
                || lzcat "$1" | tar xvf - ;;
                (*.tar) tar xvf "$1" ;;
            (*.gz) [[ ! $commands[pigz] ]] && gunzip "$1" || pigz -d "$1" ;;
            (*.bz2) bunzip2 "$1" ;;
            (*.xz) unxz "$1" ;;
            (*.lzma) unlzma "$1" ;;
            (*.Z) uncompress "$1" ;;
            (*.zip|*.war|*.jar|*.sublime-package|*.ipsw|*.xpi|*.apk) unzip "$1" -d $extract_dir ;;
            (*.rar) unrar x -ad "$1" ;;
            (*.7z) 7za x "$1" ;;
            (*.deb)
                mkdir -p "$extract_dir/control"
                mkdir -p "$extract_dir/data"
                cd "$extract_dir"; ar vx "../${1}" > /dev/null
                cd control; tar xzvf ../control.tar.gz
                cd ../data; tar xzvf ../data.tar.gz
                cd ..; rm *.tar.gz debian-binary
                cd .. ;;
            (*) echo "extract: '$1' cannot be extracted" 1>&2 ;;
      esac

      shift
  done
}
alias x=extract

highlight()       {
    grep --color -E "$1|$"
}

highlight_files() {
    grep --color -E "$1|$" "${@:2}"
}

if [[ "$commands[git]" ]]; then
    alias gl="git log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white) %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
    alias gc="git c"
    alias gca="git ca"
    alias gp="git push"
    alias gs="git s"
    alias gd="git d"
    alias ge="git ls-files -mo --exclude-standard -z | fzf --multi --preview='show {}' --exit-0 --read0 --print0 --height=70% --reverse --select-1 | xargs --no-run-if-empty -0 -o $vim -o"

    clone() {
        git clone --depth 1 "$1" && cd $(basename ${1//.git/})
    }

    gop() {
        # change protocol to https, remove port, remove .git
        local repo_url=$(git config remote.origin.url | perl -pe 's/^ssh:\/\/.*@/https:\/\//; s/:[0-9]+\//\//g; s/\.git$//')
        if [[ -n "$1" ]]; then
            local branch=$(git rev-parse --abbrev-ref HEAD)
            local path=$(git rev-parse --show-prefix "$@" | tr '\n' '/')
            # TODO: resolve links/.. etc.
            local url="$repo_url/tree/$branch/$path"
        fi

        printf '%s\n' "opening: $url"
        if [[ "$os" == darwin* ]]; then
            /usr/bin/open "$url"
        else
            xdg-open "$url"
        fi
    }
fi

psg() {
    [[ ! "$1" ]] && echo "psg <string>" && return
    INP="$*";
    REST=$(echo $INP | tail -c +2)
    ps aux | grep -i \[${INP:0:1}\]${INP:1:${#INP}-1}
}

if [[ "$commands[pacman]" ]]; then
    toggle-testing() {
        grep '^\[testing\]' /etc/pacman.conf &> /dev/null
        if [[ $? == 0 ]]; then
            sudo perl -0777 -pi -e 's/\[testing\]\nInclude = \/etc\/pacman.d\/mirrorlist/\#\[testing\]\n\#Include = \/etc\/pacman.d\/mirrorlist/igs' /etc/pacman.conf
            sudo perl -0777 -pi -e 's/\[community-testing\]\nInclude = \/etc\/pacman.d\/mirrorlist/\#\[community-testing\]\n\#Include = \/etc\/pacman.d\/mirrorlist/igs' /etc/pacman.conf
            echo -e "\n${YELLOW}! disabled testing repos${RESET}"
        else
            sudo perl -0777 -pi -e 's/\#\[testing\]\n\#Include = \/etc\/pacman.d\/mirrorlist/\[testing\]\nInclude = \/etc\/pacman.d\/mirrorlist/igs' /etc/pacman.conf
            sudo perl -0777 -pi -e 's/\#\[community-testing\]\n\#Include = \/etc\/pacman.d\/mirrorlist/\[community-testing\]\nInclude = \/etc\/pacman.d\/mirrorlist/igs' /etc/pacman.conf
            echo -e "\n${RED}! enabled testing repos${RESET}\n"
            sudo pacman -Sy
            echo ""
            LC_ALL=C pacman -Sl testing | cut -d " " -f 2- | grep "\[installed" | awk 'function r(s){return "\033[1;31m" s "\033[0m"}function y(s){return "\033[1;33m" s "\033[0m"}{gsub("]","",$4); printf("%-35s %s -> %s\n", y($1), $4, r($2))}'
        fi
    }
    alias psyu='sudo pacman -Syu'
    alias psyyu='sudo pacman -Syyu'
    alias pi='sudo pacman -S'
    alias pid='sudo pacman -S --asdeps'
    alias pr='sudo pacman -Rns'
    alias prc='sudo pacman -Rnsc'
    alias pss='pacman -Ss'
    alias psi='pacman -Si'
    alias pqi='pacman -Qi'
    alias pqk='sudo pacman -Qk > /dev/null'
    alias pqo='pacman -Qo'
    function pql() { pacman -Qlq "$1" | xargs ls --color -dlh; }
    psc() {
        printf "%s\n" "keep 3 installed packages, remove rest"
        sudo paccache --remove --keep 3 -v
        printf "%s\n" "keep 1 uninstalled package, remove rest"
        sudo paccache --remove --keep 1 -v --uninstalled
    }
    alias psl='pkgfile -l'
    alias pu='sudo pacman -U'
    alias pacorph='sudo pacman -Rns $(pacman -Qttdq)'
    alias pacdiff='sudo pacdiff'
    alias pacdep='sudo pacman -D --asdeps'
    alias pacexp='sudo pacman -D --asexplicit'
    if [[ "$commands[yay]" ]]; then
        if [[ $USER == root ]]; then
            alias yay="sudo -u makepkg yay"
        fi
    fi
elif [[ "$commands[apt-get]" ]]; then
    alias aptupg="sudo apt-get update && sudo apt-get -V dist-upgrade"
    alias aptin="sudo apt-get -V install"
    alias aptrem="sudo apt-get -V purge"
    alias aptauto="sudo apt-get -V autoremove --purge"
    alias aptsearch="apt-cache search"
fi

fonttest() {
    for family in "serif" "sans" "sans-serif" "monospace" "Arial" "Helvetica" "Verdana" "Times New Roman" "Courier New"; do
        echo -n "$family | "
        fc-match "$family"
    done | column -t -s '|' | column -t -s ':'
    echo ""
    echo "🥯 🦆 🦉 🥓 🦄 🦀 🖕 🍣 🍤 🍥 🍡 🥃 🥞 🤯 🤪 🤬 🤮 🤫 🤭 🧐 🐕 🦖"
}

if [[ "$commands[man]" ]]; then
    man() {
        env LESS_TERMCAP_mb=$'\E[01;31m' \
        LESS_TERMCAP_md=$'\E[1;94m' \
        LESS_TERMCAP_me=$'\E[0m' \
        LESS_TERMCAP_se=$'\E[0m' \
        LESS_TERMCAP_so=$'\E[2m' \
        LESS_TERMCAP_ue=$'\E[0m' \
        LESS_TERMCAP_us=$'\E[1;92m' \
        man "$@"
    }
fi

[[ "$commands[xrandr]" ]] && xr-scale() {
    # get settings from xrandr
    xrandr=$(LC_ALL=C xrandr)
    local -i x_default=$(echo ${xrandr} | grep "\*" | column -t | cut -d " " -f 1 | cut -d "x" -f 1)
    local -i y_default=$(echo ${xrandr} | grep "\*" | column -t | cut -d " " -f 1 | cut -d "x" -f 2)
    local output=$(echo ${xrandr} | grep " connected" | cut -d " " -f 1)
    unset -v xrandr

    # set to default if no func argument is given
    if [[ -z "$1" ]]; then
        echo "usage: xr <width>"
        echo "setting default display size"
        xrandr --output "${output}" --mode "${x_default}x${y_default}" --panning "${x_default}x${y_default}" --scale 1x1
        return
    fi

    # set safe constraints for the display
    safe_bottom=$((x_default/2))
    safe_top=$((x_default*3))
    if [[ "$1" -lt $safe_bottom || "$1" -gt $safe_top ]]; then
        echo "$1 is not in safe display range between $safe_bottom and $safe_top"
        return
    fi

    # calculate new sizes
    local ratio=$(LC_ALL=C printf "%.2f" $(($x_default.0/y_default)))
    local -i x="$1"
    local -i y=$((x/ratio))
    local scale=$((${x}.0/x_default))

    # change panning
    echo "output: ${output}"
    echo "size: ${x}x${y}"
    echo "scale: ${scale}"
    xrandr --output "${output}" --mode "${x_default}x${y_default}" --panning "${x}x${y}" --scale "${scale}x${scale}"
}

russian-roulette() {
    echo -n "spinning "
    s=$(( $RANDOM.0 / 75000 ))
    num=$(( RANDOM % 8 + 2 ))

    for (( c = 0; c <= num; c++ )); do
        echo -n "."
        sleep $s
    done

    if (( RANDOM % 6 == 0)); then
        echo '\033[1;31m BOOM'
    else
        echo '\033[2m click'
    fi
}

separator() {
    BAR="="
    FILL="\${(l.${COLUMNS}..${BAR}.)}"
    printf "\n\033[33m${(e)FILL}\033[0m\n\n"
}

spectrum_ls() {
    for code in {000..255}; do
        print -P -- "$code: %F{$code}Arma virumque cano Troiae qui primus ab oris%f"
    done
}

spectrum_bls() {
    for code in {000..255}; do
        print -P -- "%{\e[48;5;${code}m%}$code: Arma virumque cano Troiae qui primus ab oris %{$reset_color%}"
    done
}

colortest() {
    echo
    echo -en "\e[0;39mDefault\e[0m   "
    echo -e "\e[1;39mDefault Bold\e[0m"
    echo -en "\e[0;30mBlack\e[0m     "
    echo -e "\e[1;30mBlack Bold\e[0m"
    echo -en "\e[0;31mRed\e[0m       "
    echo -e "\e[1;31mRed Bold\e[0m"
    echo -en "\e[0;32mGreen\e[0m     "
    echo -e "\e[1;32mGreen Bold\e[0m"
    echo -en "\e[0;33mYellow\e[0m    "
    echo -e "\e[1;33mYellow Bold\e[0m"
    echo -en "\e[0;34mBlue\e[0m      "
    echo -e "\e[1;34mBlue Bold\e[0m"
    echo -en "\e[0;35mMagenta\e[0m   "
    echo -e "\e[1;35mMagenta Bold\e[0m"
    echo -en "\e[0;36mCyan\e[0m      "
    echo -e "\e[1;36mCyan Bold\e[0m"
    echo -en "\e[0;37mGrey\e[0m      "
    echo -e "\e[1;37mGrey Bold\e[0m"
}

if [[ "$commands[systemctl]" ]]; then
    user_commands=(
        list-units is-active status show help list-unit-files is-enabled
        list-jobs show-environment suspend suspend-then-hibernate hibernate
    )
    sudo_commands=(
        start stop reload restart try-restart isolate kill daemon-reload
        reset-failed enable disable reenable preset mask unmask
        link load cancel set-environment unset-environment
    )
    for c in $user_commands; do; alias sc-$c="systemctl $c"; done
    for c in $sudo_commands; do; alias sc-$c="sudo systemctl $c"; done
fi
unset sudo_commands user_commands

nfo() {
    iconv -f cp437 -t utf8 "$@" | less -Q
}

pall() {
    printf "\n"
    local git_dirs=(
        ~/.dot
        ~/git/a-irs/dot
        /srv/infra
        ~/git/a-irs/infra
    )
    for d in "${git_dirs[@]}"; do
        if [[ -d "$d" ]]; then
            printf "${BLUE}%s${RESET}\n" "${d//$HOME/~}"
            git -C "$d" status -sbu
            git -C "$d" pull
            printf "\n"
        fi
    done
}

sandbox() {
    [[ -z "$1" ]] && return
    program=$1
    mkdir -p "$HOME/sandbox/$program"
    firejail --private="$HOME/sandbox/$program" --private-dev --private-tmp --caps.drop=all --disable-mnt --noprofile --net=wlan0 --protocol=unix,inet,inet6 "$@"
}

sandbox-light() {
    [[ -z "$1" ]] && return
    program=$1
    mkdir -p "$HOME/sandbox/$program"
    firejail --private="$HOME/sandbox/$program" --noprofile "$@"
}
