explain() {
    extract_text() {
        printf "$man" | awk -v regex="^\\\s*$1\\\>" '$0 ~ regex{f=1; print; next} (/^\s*$/  || /^\s*-/) && f{exit} f' | xargs
    }

    colorize() {
        sed "s/^-[^ ]*/$(tput setaf 4)&$(tput sgr0)/g;s/ -[^ ]*/$(tput setaf 4)&$(tput sgr0)/g"
    }

    man=$(man "$1" | col -bx) && shift

    printf "\n$(tput setaf 3)%s$(tput sgr0)\n\n" "$(echo "$man" | awk '/^NAME$/{f=1; next} /^\s*$/ && f{exit} f' | xargs)"

    for arg in "$@" ; do
        if [[ $arg =~ ^-- ]] ; then
            arg_mod="(-[a-zA-Z](\\\s*[^,]*)?,\\\s*)?${arg%%=*}"
            out=$(extract_text "$arg_mod")
            if [[ "$out" ]]; then
                printf "%s\n" "$out" | colorize
            else
                printf "%s\n" "$(tput setaf 1)${arg} not found$(tput sgr0)"
            fi
        elif echo "$man" | grep -q "^\s*$arg\b"; then
            extract_text "$arg" | colorize
        elif [[ $arg =~ ^-[^-] ]] ; then
            for (( i = 1; i < $#arg; i++ )); do
                out=$(extract_text -${arg:$i:1})
                if [[ "$out" ]]; then
                    printf "%s\n" "$out" | colorize
                else
                    printf "%s\n" "$(tput setaf 1)-${arg:$i:1} not found$(tput sgr0)"
                fi
            done
        else
            printf "$man" | grep -iw -C3 "$arg" | xargs
        fi
    done
}

