#!/usr/bin/env zsh

zmodload zsh/pcre

git_get_dirt() {
    local git_out=$1
    local s=()
    local match

    pcre_compile -m -- "^\?"
    pcre_match -- "$git_out" && s+="$ZSHINE_GIT_SYMBOL_UNTRACKED"

    pcre_compile -m -- "^1 (M\.|\.M)"
    pcre_match -- "$git_out" && s+="$ZSHINE_GIT_SYMBOL_MODIFIED"

    pcre_compile -m -- "^1 (D\.|\.D)"
    pcre_match -- "$git_out" && s+="$ZSHINE_GIT_SYMBOL_DELETED"

    pcre_compile -m -- "^1 (A\.|\.A)"
    pcre_match -- "$git_out" && s+="$ZSHINE_GIT_SYMBOL_ADDED"

    pcre_compile -m -- "^1 (R\.|\.R)"
    pcre_match -- "$git_out" && s+="$ZSHINE_GIT_SYMBOL_RENAMED"

    printf "%s" "$s"
}

git_get_commit() {
    local git_out=$1
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
    local s match
    pcre_compile -m -- "^# branch.head (.*)$"
    pcre_match -- "$git_out"
    s=$match[1]

    [[ "$s" == master ]] && s=''
    printf "%s" "$s"
}

git_get_remote() {
    local git_out=$1
    local s=()
    local match
    pcre_compile -m -- "^# branch.ab (.+) (.+)$"
    pcre_match -- "$git_out"

    [[ "$match[1]" == "+0" ]] || s+="$match[1]"
    [[ "$match[2]" == "-0" ]] || s+="$match[2]"
    [[ ${#s[@]} ]] && s=""
    printf "%s" "$s"
}

git_get_repo() {
    local url protocol repo match
    url=$(command git ls-remote --get-url 2> /dev/null)
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
    [[ "$protocol" == "ssh" ]] || prompt_segment "$ZSHINE_GIT_PROTOCOL_BG" "$ZSHINE_GIT_PROTOCOL_FG" "$protocol"
}

git_prompt_info() {
    local git_out
    git_out=$(git status --ignore-submodules --porcelain=v2 --branch)

    [[ "$?" -eq 0 ]] || return
    [[ "$PWD" == /mnt/* ]] && return
    [[ "$PWD" == /media/* ]] && return
    [[ "$PWD" == /run/user/*/gvfs/* ]] && return

    git_get_repo "$git_out"
    prompt_segment "$ZSHINE_GIT_COMMIT_BG" "$ZSHINE_GIT_COMMIT_FG" "$(git_get_commit "$git_out")"
    prompt_segment "$ZSHINE_GIT_BRANCH_BG" "$ZSHINE_GIT_BRANCH_FG" "$(git_get_branch "$git_out")"
    prompt_segment "$ZSHINE_GIT_DIRTY_BG" "$ZSHINE_GIT_DIRTY_FG" "$(git_get_remote "$git_out")"
    prompt_segment "$ZSHINE_GIT_DIRTY_BG" "$ZSHINE_GIT_DIRTY_FG" "$(git_get_dirt "$git_out")"
}
