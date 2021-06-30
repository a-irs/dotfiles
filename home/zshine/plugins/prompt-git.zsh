#!/usr/bin/env zsh

gitstatus_init() {
    GITSTATUS_CACHE_DIR=~/.local/share/gitstatus
    source "$ZSHINE_DIR/plugins/gitstatus/gitstatus.plugin.zsh"

    autoload -Uz add-zsh-hook
    add-zsh-hook precmd gitstatus_prompt_update
    gitstatus_stop 'MY' && gitstatus_start -s -1 -u -1 -c -1 -d -1 'MY'
    function gitstatus_prompt_update() {
      gitstatus_query 'MY' || return 1
      [[ $VCS_STATUS_RESULT == 'ok-sync' ]] || return 0
    }
}
gitstatus_init

zmodload zsh/pcre

git_get_dirt() {
    local git_out=$1
    if [[ "$git_out" == gitstatus ]]; then
        s=""
        (( VCS_STATUS_NUM_STAGED )) && s+=" $ZSHINE_GIT_SYMBOL_ADDED${VCS_STATUS_NUM_STAGED}"
        (( VCS_STATUS_NUM_UNSTAGED )) && s+=" $ZSHINE_GIT_SYMBOL_MODIFIED${VCS_STATUS_NUM_UNSTAGED}"
        (( VCS_STATUS_NUM_UNTRACKED )) && s+=" $ZSHINE_GIT_SYMBOL_UNTRACKED${VCS_STATUS_NUM_UNTRACKED}"
        printf '%s' "$s"
        return
    fi

    local s=()
    local match

    pcre_compile -m -- "^\?"
    pcre_match -- "$git_out" && s+="$ZSHINE_GIT_SYMBOL_UNTRACKED"

    pcre_compile -m -- "^\d (M\.|\.M)"
    pcre_match -- "$git_out" && s+="$ZSHINE_GIT_SYMBOL_MODIFIED"

    pcre_compile -m -- "^\d (D\.|\.D)"
    pcre_match -- "$git_out" && s+="$ZSHINE_GIT_SYMBOL_DELETED"

    pcre_compile -m -- "^\d (A\.|\.A)"
    pcre_match -- "$git_out" && s+="$ZSHINE_GIT_SYMBOL_ADDED"

    pcre_compile -m -- "^\d (R\.|\.R)"
    pcre_match -- "$git_out" && s+="$ZSHINE_GIT_SYMBOL_RENAMED"

    printf "%s" "$s"
}

git_get_commit() {
    local git_out=$1
    if [[ "$git_out" == gitstatus ]]; then
        s=${VCS_STATUS_COMMIT[0,7]}
        [[ -n "$VCS_STATUS_TAG" ]] && s="$s ($VCS_STATUS_TAG)"
        printf '%s' "$s"
        return
    fi

    local s match tag gen
    pcre_compile -m -- "^# branch.oid (.+)"
    pcre_match -- "$git_out"
    s=$match[1]
    [[ "$s" == "(initial)" ]] || s=${s[0,7]}

    gen=$(command git rev-list --count HEAD 2> /dev/null)
    [[ "$?" -eq 0 ]] && s="${gen} « $s"

    tag=$(command git describe --tags 2> /dev/null)
    [[ "$?" -eq 0 ]] && s="$s ($tag)"

    printf "%s" "$s"
}

git_get_branch() {
    local git_out=$1
    if [[ "$git_out" == gitstatus ]]; then
        s=$VCS_STATUS_LOCAL_BRANCH
        [[ "$s" == master ]] && s=""
        printf '%s' "$s"
        return
    fi

    local s match
    pcre_compile -m -- "^# branch.head (.*)$"
    pcre_match -- "$git_out"
    s=$match[1]

    [[ "$s" == master ]] && s=''
    printf "%s" "$s"
}

git_get_remote() {
    local git_out=$1
    if [[ "$git_out" == gitstatus ]]; then
        s=""
        # ⇣42 if behind the remote.
        (( VCS_STATUS_COMMITS_BEHIND )) && s+=" ⇣${VCS_STATUS_COMMITS_BEHIND}"
        # ⇡42 if ahead of the remote; no leading space if also behind the remote: ⇣42⇡42.
        (( VCS_STATUS_COMMITS_AHEAD && !VCS_STATUS_COMMITS_BEHIND )) && p+=" "
        (( VCS_STATUS_COMMITS_AHEAD  )) && s+="⇡${VCS_STATUS_COMMITS_AHEAD}"
        # ⇠42 if behind the push remote.
        (( VCS_STATUS_PUSH_COMMITS_BEHIND )) && s+=" ⇠${VCS_STATUS_PUSH_COMMITS_BEHIND}"
        (( VCS_STATUS_PUSH_COMMITS_AHEAD && !VCS_STATUS_PUSH_COMMITS_BEHIND )) && s+=" "
        # ⇢42 if ahead of the push remote; no leading space if also behind: ⇠42⇢42.
        (( VCS_STATUS_PUSH_COMMITS_AHEAD  )) && s+="⇢${VCS_STATUS_PUSH_COMMITS_AHEAD}"
        printf '%s' "$s"
        return
    fi

    local s=()
    local match
    pcre_compile -m -- "^# branch.ab (.+) (.+)$"
    pcre_match -- "$git_out"

    [[ "$match[1]" == "+0" ]] || s+="$match[1]"
    [[ "$match[2]" == "-0" ]] || s+="$match[2]"
    [[ -z "${s// }" ]] && s=""
    printf "%s" "$s"
}

git_get_repo() {
    local url protocol repo match
    if [[ -v VCS_STATUS_REMOTE_URL ]]; then
        url=$VCS_STATUS_REMOTE_URL
    else
        url=$(command git ls-remote --get-url 2> /dev/null)
    fi

    if [[ $ZSHINE_GIT_SHRINK_URL == 1 ]]; then
        if [[ $url == *'://'* ]]; then
            # ssh://git@server/user/project.git
            # https://server/user/project.git
            pcre_compile -m -- "^(.+)://.+?/(.+?)/(.+)"
            pcre_match -- "$url"
            protocol=$match[1]
            namespace=$match[2]
            repo=$match[3]
            repo=${repo/.git/}
        else
            # git@server:user/project.git
            pcre_compile -m -- "^.+:(.+?)/(.+)"
            pcre_match -- "$url"
            namespace=$match[1]
            repo=$match[2]
            repo=${repo/.git/}
            protocol=ssh
        fi
        url="${namespace}/${repo}"
    fi
    [[ "$url" == "/" ]] || prompt_segment "$ZSHINE_GIT_PROJECT_BG" "$ZSHINE_GIT_PROJECT_FG" "$url"
}

git_prompt_info() {
    [[ "$PWD" == /mnt/* ]] && return
    [[ "$PWD" == /media/* ]] && return
    [[ "$PWD" == /run/user/*/gvfs/* ]] && return

    local git_out
    if [[ "$VCS_STATUS_RESULT" == ok-sync ]]; then
        git_out="gitstatus"
    elif [[ -v VCS_STATUS_RESULT ]]; then
        return  # not a git repo
    fi
    [[ "$git_out" == gitstatus ]] || git_out=$(git status --ignore-submodules --porcelain=v2 --branch 2>/dev/null)
    [[ "$?" -eq 0 ]] || return

    git_get_repo "$git_out"
    prompt_segment "$ZSHINE_GIT_COMMIT_BG" "$ZSHINE_GIT_COMMIT_FG" "$(git_get_commit "$git_out")"
    prompt_segment "$ZSHINE_GIT_BRANCH_BG" "$ZSHINE_GIT_BRANCH_FG" "$(git_get_branch "$git_out")"
    prompt_segment "$ZSHINE_GIT_DIRTY_BG" "$ZSHINE_GIT_DIRTY_FG" "$(git_get_remote "$git_out")"
    prompt_segment "$ZSHINE_GIT_DIRTY_BG" "$ZSHINE_GIT_DIRTY_FG" "$(git_get_dirt "$git_out")"
}
