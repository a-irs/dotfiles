# heavily adapted from https://github.com/wookayin/fzf-fasd/blob/master/fzf-fasd.plugin.zsh

__fasd_fzf_zsh_completion() {
    local args query selection fasd_args
    args=(${(z)LBUFFER})

    # remove prefix/suffix string (f, etc.), then choose the right fasd argument
    case "${args[-1]}" in
        # prefix
        ,*)   query=${args[-1]#,};   fasd_args=(-a) ;;
        f,*)  query=${args[-1]#f,};  fasd_args=(-f) ;;
        d,*)  query=${args[-1]#d,};  fasd_args=(-d) ;;

        # suffix
        *,,)  query=${args[-1]%,,};  fasd_args=(-a) ;;
        *,,f) query=${args[-1]%,,f}; fasd_args=(-f) ;;
        *,,d) query=${args[-1]%,,d}; fasd_args=(-d) ;;

        # fallback to default completion
        *) zle ${__fasd_fzf_default_completion:-expand-or-complete}; return
    esac

    # replace , with whitespace so the fasd query can execute (e.g. for etc,s,svc)
    query=${query//,/ }

    # generate zsh array from the output lines for the given fasd query - see man zshexpn
    matches=(${(f)"$(fasd -lR ${fasd_args[@]} "$query")"})
    matches=(${matches/$HOME/\~})  # replace the absolute home path with a tilde

    # open fzf, if needed
    if [[ "${#matches}" -gt 1 ]]; then
        selection=$(printf '%s\n' "${matches[@]}" \
            | FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $FZF_COMPLETION_OPTS" \
              fzf --height=50% --reverse --bind 'shift-tab:up,tab:down'
        )
    elif [[ "${#matches}" -eq 1 ]]; then
        selection=${matches[1]}
    else
        return
    fi

    # replace our completion argument with the selected path, then redraw the buffer
    if [[ -n "$selection" ]]; then
        selection=$(printf %q "$selection")  # shellquote selected string
        selection=${selection/#\\~/\~}  # replace quoted \~ at the beginning with real ~
        args[-1]="$selection"
        LBUFFER="${args[@]}"
    fi

    zle redisplay
    typeset -f zle-line-init > /dev/null && zle zle-line-init
}


if [ -z "$__fasd_fzf_default_completion" ]; then
    binding=$(bindkey '^I')
    [[ $binding =~ 'undefined-key' ]] || __fasd_fzf_default_completion=$binding[(s: :w)2]
    unset binding
fi

zle      -N  __fasd_fzf_zsh_completion
bindkey '^I' __fasd_fzf_zsh_completion
