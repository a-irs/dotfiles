#!/usr/bin/env zsh

is_svn() {
    [[ -d .svn ]] && return 0

    if $(svn info >/dev/null 2>&1); then
        return 0
    else
        return 1
    fi
}

svn_prompt_info() {
    is_svn || return

    prompt_segment "$ZSHINE_GIT_URL_BG" "$ZSHINE_GIT_URL_FG" "$(svn_get_url)"
    prompt_segment "$ZSHINE_GIT_COMMIT_BG" "$ZSHINE_GIT_COMMIT_FG" "$(svn_get_rev)"
    prompt_segment "$ZSHINE_GIT_DIRTY_BG" "$ZSHINE_GIT_DIRTY_FG" "$(svn_dirty)"

}

svn_get_url() {
    local l=$(LC_ALL=C svn info | grep "Repository Root")
    l=${l/Repository Root: /}
    echo $l
}

svn_get_rev() {
    LC_ALL=C svn info 2> /dev/null | sed -n 's/Revision:\ //p'
}

svn_dirty() {
    local root=$(LC_ALL=C svn info 2> /dev/null | sed -n 's/^Working Copy Root Path: //p')
    if $(LC_ALL=C svn status $root 2> /dev/null | command grep -Eq '^\s*[ACDIM!?L]'); then
        echo -n "$ZSHINE_GIT_SYMBOL_SIMPLE"
    fi
}
