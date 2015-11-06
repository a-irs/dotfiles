#!/usr/bin/env zsh

is_git() {
    export IS_GIT=0
    [[ "$PWD" == /var/aur* ]] && return 1
    [[ "$PWD" == ~/net/* ]] && return 1
    [[ "$PWD" == /media/* ]] && return 1
    [[ "$PWD" == /run/user/*/gvfs/* ]] && return 1
    [ -d .git ] && IS_GIT=1 && return 0
    git rev-parse --is-inside-work-tree > /dev/null 2>&1 && IS_GIT=1 && return 0
}

git_prompt_info() {
    is_git || return
    commit=$(command git --no-pager log --pretty=format:'%h' -n 1 2> /dev/null)
    branch=$(command git symbolic-ref --short HEAD)
    [[ "$branch" = "master" ]] && branch=''
    tag=$(command git describe --tags 2> /dev/null)
    [[ "$?" -eq 0 ]] && commit="$tag"
    url=$(command git ls-remote --get-url 2> /dev/null)
    if [[ $ZSHINE_GIT_SHRINK_URL == 1 ]]; then
        if [[ "$url" == *://*github.com/*/*.git ]]; then
            # https://github.com/user/repo.git -> user/repo
            #   git://github.com/user/repo.git -> user/repo
            if [[ "$url" == */ ]]; then
                url1=${url%?}
                url1=${url1##*/}
            else
                url1=${url##*/}
            fi
            url2=${url//$url1/}
            url1=${url1%.git}
            url2=${url2#*:}
            url2=${url2#*/}
            url2=${url2#*/}
            url2=${url2#*/}
            url2=${url2//\//}
            url="$url2/$url1"
        elif [[ "$url" == git@github.com:*/*.git ]]; then
            # git@github.com:user/repo.git -> user/repo
            url1=${url##*/}
            url2=${url//$url1/}
            url1=${url1%.git}
            url2=${url2#*:}
            url2=${url2//\//}
            url="$url2/$url1"
        fi
    fi
    [[ "${url}" == / ]] && url="N/A"
    prompt_segment "$ZSHINE_GIT_URL_BG" "$ZSHINE_GIT_URL_FG" "${url}"
    prompt_segment "$ZSHINE_GIT_COMMIT_BG" "$ZSHINE_GIT_COMMIT_FG" "${commit}"
    [[ "$branch" = '' ]] || prompt_segment "$ZSHINE_GIT_BRANCH_BG" "$ZSHINE_GIT_BRANCH_FG" "${branch}"
    prompt_segment "$ZSHINE_GIT_DIRTY_BG" "$ZSHINE_GIT_DIRTY_FG" "$(git_remote_state)$(git_dirty)"
}

git_dirty() {
    if [[ $ZSHINE_GIT_SIMPLE_DIRTY == 1 ]]; then
        _git_dirty_simple
    else
        _git_dirty_advanced
    fi
}

git_remote_state() {
    remote_state=$(git status --ignore-submodules --porcelain -b 2> /dev/null | grep -oh "\[.*\]")
    if [[ "$remote_state" != "" ]]; then
        out=""
        if [[ "$remote_state" == *ahead* ]] && [[ "$remote_state" == *behind* ]]; then
            behind_num=$(echo "$remote_state" | grep -oh "behind [0-9]*" | grep -oh "[0-9]*$")
            ahead_num=$(echo "$remote_state" | grep -oh "ahead [0-9]*" | grep -oh "[0-9]*$")
            out="-$behind_num,+$ahead_num"
        elif [[ "$remote_state" == *ahead* ]]; then
            ahead_num=$(echo "$remote_state" | grep -oh "ahead [0-9]*" | grep -oh "[0-9]*$")
            out="+$ahead_num"
        elif [[ "$remote_state" == *behind* ]]; then
            behind_num=$(echo "$remote_state" | grep -oh "behind [0-9]*" | grep -oh "[0-9]*$")
            out="-$behind_num"
        fi
        echo -n "%{%B%F{$ZSHINE_GIT_DIRTY_FG}%}$out"
    fi
}

_git_dirty_simple() {
    if [[ -n $(git status --ignore-submodules --porcelain 2> /dev/null) ]]; then
        echo -n "%{%B%F{$ZSHINE_GIT_DIRTY_FG}%}$ZSHINE_GIT_SYMBOL_SIMPLE"
    fi
}

_git_dirty_advanced() {
    INDEX=$'\n'$(git status --ignore-submodules --porcelain 2> /dev/null) || return
    STATUS=""

    # renamed
    if [[ "$INDEX" == *$'\nR  '* ]]; then
        [[ -n "$STATUS" ]] && STATUS=" $STATUS"
        STATUS="$ZSHINE_GIT_SYMBOL_RENAMED$STATUS"
    fi

    # untracked
    if [[ "$INDEX" == *$'\n\?\? '* ]]; then
        [[ -n "$STATUS" ]] && STATUS=" $STATUS"
        STATUS="$ZSHINE_GIT_SYMBOL_UNTRACKED$STATUS"
    fi

    # added
    if [[ "$INDEX" == *$'\nA  '* ]]; then
        [[ -n "$STATUS" ]] && STATUS=" $STATUS"
        STATUS="$ZSHINE_GIT_SYMBOL_ADDED$STATUS"
    fi

    # modified
    if [[ "$INDEX" == *$'\n M '* ]] || \
        [[ "$INDEX" == *$'\nM  '* ]]; then
        [[ -n "$STATUS" ]] && STATUS=" $STATUS"
        STATUS="$ZSHINE_GIT_SYMBOL_MODIFIED$STATUS"
    fi

    # deleted
    if [[ "$INDEX" == *$'\nD  '* || "$INDEX" == *$'\n D '* ]]; then
        [[ -n "$STATUS" ]] && STATUS=" $STATUS"
        STATUS="$ZSHINE_GIT_SYMBOL_DELETED$STATUS"
    fi

    [[ -n $STATUS ]] && echo -n "%{%F{$ZSHINE_GIT_DIRTY_FG}%}$STATUS%{%f%}"
}
