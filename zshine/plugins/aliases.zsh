noglobs=(find ftp locate rake rsync scp sftp wcalc)
for c in $noglobs; do
    [ -n "$commands[$c]" ] && alias $c="noglob $c"
done

bottomblur() {
    d="/tmp/blur"
    mkdir -p $d && \
    convert $1 -resize 1280x800\! "$d/out.png" && \
    convert "$d/out.png" -flip "$d/flip.png" && \
    convert "$d/flip.png" -blur 12x8 "$d/blur.png" && \
    convert "$d/flip.png" -gamma 0 -fill white -draw "rectangle 0,-22 1280,22" "$d/mask.png" && \
    convert "$d/flip.png" "$d/blur.png" "$d/mask.png" -composite "$d/final_flip.png" && \
    convert "$d/final_flip.png" -flip "${1:r}_blur.png" && \
    rm -rf "$d"
}

if [[ -d /home/.snapshots ]]; then
    restore() {
        [ -z "$1" ] && echo "usage: restore <files|directories>" && return 1
        echo ""
        if [ -n "$commands[snapper]" ]; then
            LC_ALL=C snapper -c home list | awk '{print $3 " | " $6 " " $7 " " $8 " " $9 " " $10}' | tail -n +4
        else
            command ls --color -lgGh /home/.snapshots | tail -n +2 | cut -d " " -f 4-
        fi
        echo ""
        read "gen?${BOLD_BLUE}Choose generation: ${RESET}"
        echo ""
        [ -z "$gen" ] && return 1
        for el in "$@"; do
            el=$(readlink -f "$el")
            src="/home/.snapshots/$gen/snapshot/${el/\/home\//}"
            [ ! -e "$src" ] && echo "'$src' does not exist" && continue
            if [ -d "$el" ]; then
                cp -i -a "$src"/. "$el"
            else
                cp -i -a "$src" "$el"
            fi
        done
    }
fi

__pan() {
    [[ ! -d "$1" ]] && echo "no directory selected" && return 1
    [[ $2 == pdf ]] && params="--number-sections -Vlang=ngerman -V geometry:\"top=3cm, bottom=3.5cm, left=2.5cm, right=2.5cm\" --standalone --smart --toc"
    [[ $2 == html ]] && params="--number-sections --standalone --self-contained --smart --toc -t html5"
    echodir=$(readlink -f "$1")
    echodir=${echodir/$HOME/\~}
    printf "recursively monitoring directory %s\n" "$echodir"
    inotifywait -mrq -e move -e create -e modify --format %w%f "$1" | while read f
    do
        [[ ! -f "$f" ]] && continue
        case "$f" in
            *.md) printf "$GREY$(date +%H:%M:%S) |$RESET converting $YELLOW$f$RESET to $GREEN${f%.*}.${2}$RESET ... " ;
                  secondline=$(head -2 "$f" | tail -1)
                  if [[ "$secondline" =~ "<!--" ]]; then
                      params=${secondline/<\!-- /}
                      params=${params/ -->/}
                  fi ;
                  eval $(echo pandoc $params -o "${f%.*}.${2}" "$f") \
                  && printf "done\n" \
                  || printf "${RED}error${RESET}\n" ;;
        esac
    done
}
if [[ -n "$commands[pandoc]" && -n "$commands[inotifywait]" ]]; then
    pan-pdf() { __pan "$1" pdf; }
    pan-html() { __pan "$1" html; }
fi

s() {
    typeset -U files
    [[ -n $* ]] && files=($*) || files=(*(.))
    for f in $files; do
        if [ -d "$f" ] || [ ! -f "$f" ]; then
            continue
        fi

        if [[ ${#files} > 1 ]]; then
            LENGTH=${#f}
            FILL="\${(l.$((COLUMNS/2-LENGTH/2-2))..=.)}"
            s="${(e)FILL} $f ${(e)FILL}"
            [[ "${#s}" == $((COLUMNS-1)) ]] && s+="="
            [[ "${#s}" == $((COLUMNS-2)) ]] && s+="=="
            printf "\n${BOLD_YELLOW}${s}${RESET}\n\n"
        fi

        mime=$(file --mime-encoding -b "$f")
        if [[ $mime == "binary" ]]; then
            if [[ -s "$f" ]]; then
                echo -e "${RED}BINARY FILE${RESET}" && continue
            else
                echo -e "${MAGENTA}EMPTY FILE${RESET}" && continue
            fi
        fi

        if [ -r "$f" ]; then
            source-highlight -t 4 --failsafe --infer-lang -f esc --style-file=esc.style -i "$f"
        else
            sudo source-highlight -t 4 --failsafe --infer-lang -f esc --style-file=esc.style -i "$f"
        fi
    done
}

alias cp='cp -i'
alias ln='ln -i'
alias mv='mv -i'
alias mmv='noglob zmv -W'
alias mkdir='mkdir -p'
alias l='\ls  -F             --color=auto --group-directories-first'
alias ls='\ls -F -l -h       --color=auto --group-directories-first'
alias la='\ls -F -l -h -A    --color=auto --group-directories-first'
alias l.='\ls -F    -h -d .* --color=auto --group-directories-first'
alias lt='\ls -F -l -h -t -r --color=auto --group-directories-first'
[ -n "$commands[python]" ] && alias http-share='python -m http.server 10000'
[ -n "$commands[dmesg]" ] && alias dmesg='dmesg -T --color=auto'
[ -n "$commands[watch]" ] && alias ddstatus='sudo watch --interval=1 "pkill -USR1 dd"'
[ -n "$commands[less]" ] && alias less='less -FXR'
[ -n "$commands[lsblk]" ] && alias lsblk='lsblk -o NAME,FSTYPE,SIZE,LABEL,MOUNTPOINT,UUID -p'
[ -n "$commands[grep]" ] && alias grep='grep --color=auto'
[ -n "$commands[make]" ] && alias make="LC_ALL=C make"
[ -n "$commands[gcc]" ]  && alias  gcc="LC_ALL=C gcc"
[ -n "$commands[g++]" ]  && alias  g++="LC_ALL=C g++"
[ -n "$commands[acp]" ] && alias cp='acp -g'
[ -n "$commands[amv]" ] && alias mv='amv -g'
[ -n "$commands[mpv]" ] && alias mpv='mpv --no-audio-display'

if [ -n "$commands[tmux]" ]; then
    alias t='tmux'
    alias ta='tmux attach -t'
    alias tn='tmux new-session -s'
    alias tk='tmux kill-session -t'
    alias tl='tmux list-sessions'
fi

take() { mkdir -p $1 && cd $1 }

if [ -n "$commands[wget]" ]; then
    alias wget='wget --continue --progress=bar --timestamping'
    alias speedtest='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test100.zip'
fi
[ -n "$commands[curl]" ] && alias curl='curl --continue-at - --location --progress-bar --remote-name --remote-time'
[ -n "$commands[tree]" ] && alias tree="tree -F --dirsfirst --noreport"
[ -n "$commands[sudo]" ] && alias sudo='sudo '
[ -n "$commands[mc]" ] && alias mc='mc --nocolor'
[ -n "$commands[iotop]" ] && alias iotop='sudo iotop -o'
[ -n "$commands[updatedb]" ] && alias updatedb='sudo updatedb'
[ -n "$commands[ps_mem]" ] && alias ps_mem='sudo ps_mem'
[ -n "$commands[abs]" ] && alias abs='sudo abs'
[ -n "$commands[ufw]" ] && alias ufw='sudo ufw'

[ -n "$commands[latexmk]" ] && alias ltx="latexmk -cd -f -pdf -pvc -outdir=/tmp/latexmk"
[ -n "$commands[reflector]" ] && alias mirrorlist_update='sudo reflector --verbose -l 20 --sort rate --country 'Germany' --save /etc/pacman.d/mirrorlist'
[ -n "$commands[impressive]" ] && alias show='impressive -t FadeOutFadeIn --fade --transtime 300 --mousedelay 500 --nologo --nowheel --noclicks'
[ -n "$commands[youtube-dl]" ] && alias yt-audio='youtube-dl -f bestaudio -x -o "%(title)s.%(ext)s"'
[ -n "$commands[colorsvn]" ] && alias svn='colorsvn'
[ -n "$commands[pydf]" ] && alias df='pydf'
[ -n "$commands[journalctl]" ] && alias j='sudo journalctl'
[ -n "$commands[journalctl]" ] && alias journalctl='sudo journalctl'
[ -n "$commands[docker]" ] && alias d='docker'
[ -n "$commands[scrot]" ] && alias shoot="sleep 1 && scrot '%Y-%m-%d_%H-%M-%S.png' -e 'mv \$f ~/media/screenshots/'"
[ -n "$commands[ncmpc]" ] && alias ncmpc='LC_ALL=en_IE.UTF-8 ncmpc'

if [ -n "$commands[xdg-open]" ]; then
    o() {
        if [ -f "$1" ]; then
            xdg-open "$1" &> /dev/null
        elif [ -z "$1" ]; then
            xdg-open . &> /dev/null
        else
            echo "'$1' could not be read"
        fi
    }
fi

if [ -n "$commands[encfs]" ]; then
    enc-mount() {
        mkdir ~/encrypt && \
        encfs ~/.encrypt ~/encrypt && \
        xdg-open ~/encrypt && \
        find ~/.thumbnails > ~/.encrypt-thumbs-before
    }
    enc-umount() {
        fusermount -u ~/encrypt
        rmdir ~/encrypt
        find ~/.thumbnails > ~/.encrypt-thumbs-after
        diff ~/.encrypt-thumbs-* | awk '{print $NF}' | tail -n +2 | xargs rm 2> /dev/null
        rm ~/.encrypt-thumbs-* 2> /dev/null
    }
fi

if [ -n "$commands[adb]" ]; then
    alias adb-forward='adb forward tcp:2222 tcp:22'
    alias adb-ssh='ssh root@localhost -p 2222'
fi

alias rd='rmdir -p'

alias f='noglob find . -name'
alias fd='noglob find . -type d -name'
alias ff='noglob find . -type f -name'

smart_cd() {
    if [[ -f $1 ]] ; then
        [[ ! -e ${1:h} ]] && return 1
        print correcting ${1} to ${1:h}
        builtin cd ${1:h}
    else
        builtin cd ${1}
    fi
}

cd() {
    setopt localoptions
    setopt extendedglob
    local approx1 ; approx1=()
    local approx2 ; approx2=()
    if (( ${#*} == 0 )) || [[ ${1} = [+-]* ]] ; then
        builtin cd "$@"
    elif (( ${#*} == 1 )) ; then
        approx1=( (#a1)${1}(N) )
        approx2=( (#a2)${1}(N) )
        if [[ -e ${1} ]] ; then
            smart_cd ${1}
        elif [[ ${#approx1} -eq 1 ]] ; then
            print correcting ${1} to ${approx1[1]}
            smart_cd ${approx1[1]}
        elif [[ ${#approx2} -eq 1 ]] ; then
            print correcting ${1} to ${approx2[1]}
            smart_cd ${approx2[1]}
        else
            print couldn\'t correct ${1}
        fi
    elif (( ${#*} == 2 )) ; then
        builtin cd $1 $2
    else
        print cd: too many arguments
    fi
}

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias .......='cd ../../../../../..'
alias ........='cd ../../../../../../..'
alias .........='cd ../../../../../../../..'
alias cd..='cd ..'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

if [ -n "$commands[subl3]" ]; then
    alias e='subl3'
    alias sudoe='EDITOR="subl3 -w" sudoedit'
else
    alias e="$EDITOR"
    alias sudoe="sudoedit"
fi

highlight()       { grep --color -E "$1|$" }
highlight_files() { grep --color -E "$1|$" "${@:2}" }

dict() {
    dict.py de en $@
    echo
    dict.py en de $@
}

if [ -n "$commands[openvpn]" ]; then
    vpn() {
        for f in $HOME/.openvpn/**/$1.ovpn; do
            d=$(echo $f | rev | cut -d "/" -f 2- | rev)
            vpncolor.py sudo openvpn --cd "$d" --config "$f"
        done
    }
fi

if [ -n "$commands[git]" ]; then
    alias git='LC_ALL=en_IE.UTF-8 git'
    alias g="git"
    alias gl="git log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white) %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
    alias glog='git log --color --patch --stat --decorate --date=relative --all --abbrev-commit'
    alias gpull="git -C ~/.dotfiles pull"
    alias gpush="git -C ~/.dotfiles p"
fi

psg() {
    [ -z "$1" ] && echo "psg <string>" && return
    INP="$*";
    REST=$(echo $INP | tail -c +2)
    ps aux | grep -i \[${INP:0:1}\]${INP:1:${#INP}-1}
}

if [ -n "$commands[pacman]" ]; then
    aur() {
        [ -d /var/aur ] && sudo git -C /var/aur pull || sudo git -C /var clone git://pkgbuild.com/aur-mirror.git aur
    }
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
    alias pr='sudo pacman -Rns'
    alias prc='sudo pacman -Rnsc'
    alias pss='pacman -Ss'
    alias psi='pacman -Si'
    alias pqi='pacman -Qi'
    alias pqk='sudo pacman -Qk > /dev/null'
    alias pqo='pacman -Qo'
    alias pql='pacman -Qlq'
    alias psc='sudo pacman -Sc'
    alias psl='pkgfile -l'
    alias pu='sudo pacman -U'
    alias pacorph='sudo pacman -Rns $(pacman -Qtdq)'
    alias pacdiff='sudo pacdiff'
    alias pacdep='sudo pacman -D --asdeps'
    alias pacexp='sudo pacman -D --asexplicit'
    if [ -n "$commands[pacaur]" ]; then
        alias aurupg='pacaur -Syu'
        alias aursearch='pacaur -Ss'
        alias aurin='pacaur -S'
    fi
    if [ -n "$commands[aura]" ]; then
        alias ai='sudo aura -Aakx'
        alias ayu='sudo aura -Akuax'
        alias as='sudo aura -Asx'
        alias aura='sudo aura'
    fi
    if [ -n "$commands[yaourt]" ]; then
        alias y='yaourt'
        alias ys='yaourt -S'
        alias ysua='yaourt -Syua'
    fi
elif [ -n "$commands[apt-get]" ]; then
    alias aptupg="apt-get update && apt-get -V upgrade && apt-get -V dist-upgrade"
    alias aptin="apt-get -V install"
    alias aptrem="apt-get -V purge"
    alias aptsearch="apt-cache search"
fi

_fonttest() {
    for family in "serif" "sans" "sans-serif" "monospace" "Arial" "Helvetica" "Verdana" "Times New Roman" "Courier New"; do
        echo -n "$family | "
        fc-match "$family"
    done
    unset -v $family
}
alias fonttest="_fonttest | column -t -s '|' | column -t -s ':'"

if [ -n "$commands[grc]" ]; then
    for c in diff ping netstat traceroute dig ps mount ifconfig mtr ; do
        [ -n "$commands[$c]" ] && alias ${c}="grc -es --colour=auto ${c}"
    done
fi

if [ -n "$commands[man]" ]; then
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

cmp-init() {
    rm /tmp/after.log 2> /dev/null
    find ~ | sort > /tmp/before.log
}

cmp-diff() {
    if [ -f /tmp/before.log ]; then
        find ~ | sort > /tmp/after.log
        echo "" ; command diff /tmp/before.log /tmp/after.log | sed "s|.\./| |" | sed '/<\|>/!d' \
            | sed "s|>|"$'\e[1;32m'"&|" | sed "s|<|"$'\e[1;31m'"&|" # colorize
    else
        echo "use cmp-init first"
    fi
}

if [ -f "$HOME/.config/user-dirs.dirs" ]; then
    new() {
        if [ -z $1 ] || [ -z $2 ]; then
            echo "usage: new <Filetype> <Name>"
            return
        fi
        source "$HOME/.config/user-dirs.dirs"
        tofind=$(find "$XDG_TEMPLATES_DIR/" -type f -name "$1*")
        extension="${tofind##*.}"
        newfile="$2".$extension
        cp "$tofind" "$newfile"
        unset XDG_DESKTOP_DIR XDG_TEMPLATES_DIR XDG_DOWNLOAD_DIR XDG_PUBLICSHARE_DIR XDG_DOCUMENTS_DIR XDG_MUSIC_DIR XDG_PICTURES_DIR XDG_VIDEOS_DIR
        xdg-open "$newfile"
    }
fi

extract() {
    local file_name
    local extract_dir

    while (( $# > 0 )); do
        if [[ ! -r "$1" ]]; then
            echo "extract: '$1' does not exist" 1>&2
            shift
            continue
        fi

        file_name="${1:t}"
        extract_dir="${file_name//.${file_name##*.}/}"
        case "$1" in
          (*.tar.gz|*.tgz) tar xvzf "$1" ;;
          (*.tar.bz2|*.tbz|*.tbz2) tar xvjf "$1" ;;
          (*.tar.xz|*.txz) tar --xz --help &> /dev/null && tar --xz -xvf "$1" || xzcat "$1" | tar xvf - ;;
          (*.tar.zma|*.tlz) tar --lzma --help &> /dev/null && tar --lzma -xvf "$1" || lzcat "$1" | tar xvf - ;;
          (*.tar) tar xvf "$1" ;;
          (*.gz) gunzip "$1" ;;
          (*.bz2) bunzip2 "$1" ;;
          (*.xz) unxz "$1" ;;
          (*.lzma) unlzma "$1" ;;
          (*.Z) uncompress "$1" ;;
          (*.zip|*.war|*.jar|*.apk) unzip "$1" -d $extract_dir ;;
          (*.rar) unrar x -ad "$1" ;;
          (*.7z) 7za x "$1" ;;
          (*.deb)
            mkdir -p "$extract_dir/control" && mkdir -p "$extract_dir/data"
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

xr() {
    # composition sometimes breaks xr somehow, kill it
    #killall compton 2> /dev/null
    xfconf-query -c xfwm4 -p /general/use_compositing -s false

    # get settings from xrandr
    xrandr=$(LC_ALL=C xrandr)
    local -i x_default=$(echo ${xrandr} | grep "\*" | column -t | cut -d " " -f 1 | cut -d "x" -f 1)
    local -i y_default=$(echo ${xrandr} | grep "\*" | column -t | cut -d " " -f 1 | cut -d "x" -f 2)
    local output=$(echo ${xrandr} | grep " connected" | cut -d " " -f 1)
    unset -v xrandr

    # set to default if no func argument is given
    if [ -z "$1" ]; then
        echo "usage: xr <width>"
        echo "setting default display size"
        xrandr --output ${output} --mode ${x_default}x${y_default} --panning ${x_default}x${y_default} --scale 1x1
        xfconf-query -c xfwm4 -p /general/use_compositing -s true
    fi

    # set safe constraints for the display
    safe_bottom=$(($x_default/2))
    safe_top=$(($x_default*3))
    if [ "$1" -lt $safe_bottom -o "$1" -gt $safe_top ]; then
        echo "$1 is not in safe display range between $safe_bottom and $safe_top"
        return
    fi

    # calculate new sizes
    local ratio=$(LC_ALL=C printf "%.2f" $(($x_default.0/$y_default)))
    local -i x="$1"
    local -i y=$(($x/$ratio))
    local scale=$((${x}.0/$x_default))

    # change panning
    echo "output: ${output}"
    echo "size: ${x}x${y}"
    echo "scale: ${scale}"
    xrandr --output ${output} --mode ${x_default}x${y_default} --panning ${x}x${y} --scale ${scale}x${scale}

    # restart composition
    #compton -b
    xfconf-query -c xfwm4 -p /general/use_compositing -s true
}

rollback() {
    base="ftp://seblu.net/archlinux/arm/packages"
    arch=$(uname -m)

    if [[ "$1" == "list" ]]; then
        url="${base}/${2:0:1}/${2}/"
        avail=$(\curl -ss -l "$url" --user anonymous:anonymous | grep -e $arch -e any.pkg)
        echo $avail
    else
        pkgname=$(echo "$1" | rev | cut -d "-" -f 4- | rev)
        url="${base}/${pkgname:0:1}/${pkgname}"
        \curl -o "/tmp/$1" --progress-bar "$url/$1" --user anonymous:anonymous && sudo pacman -U "/tmp/$1" && rm "/tmp/$1"
    fi
}

russian-roulette() {
    echo -n "spinning "
    s=$(($RANDOM.0/100000))
    num=$(($RANDOM/3000))

    [ $num -le 4 ] && num=5
    for (( c=0; c<=$num; c++ ))
    do
        echo -n "."
        sleep $s
    done

    if [ $(($RANDOM%6)) -eq 0 ]; then
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

if [ -n "$commands[systemctl]" ]; then
    user_commands=(
        list-units is-active status show help list-unit-files
        is-enabled list-jobs show-environment)
    sudo_commands=(
        start stop reload restart try-restart isolate kill
        reset-failed enable disable reenable preset mask unmask
        link load cancel set-environment unset-environment)
    for c in $user_commands; do; alias sc-$c="systemctl $c"; done
    for c in $sudo_commands; do; alias sc-$c="sudo systemctl $c"; done
fi

if [ -n "$commands[machinectl]" ]; then
    user_commands=(list status show)
    sudo_commands=(login reboot poweroff kill terminate)
    for c in $user_commands; do; alias mc-$c="machinectl $c"; done
    for c in $sudo_commands; do; alias mc-$c="sudo machinectl $c"; done
fi

if [ -n "$commands[netctl]" ]; then
    user_nc_commands=(
        list status is-enabled)
    sudo_nc_commands=(
        start stop stop-all restart switch-to enable disable
        reenable)
    for c in $user_nc_commands; do; alias nc-$c="netctl $c"; done
    for c in $sudo_nc_commands; do; alias nc-$c="sudo netctl $c"; done
fi

if [  -n "$commands[pushbullet.sh]" ]; then
    alias pushf='pushbullet.sh push "Xperia ZL" file'
    alias pusht='pushbullet.sh push "Xperia ZL" note Text'
    alias pushl='pushbullet.sh push "Xperia ZL" link Link'
fi

nfo() {
    iconv -f cp437 -t utf8 "$1" | less -Q
}
