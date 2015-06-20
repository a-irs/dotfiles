#!/usr/bin/env bash

REPOS=( "$HOME/.dotfiles" )

show_header() {
    echo -e "\n\033[1;33m$*\033[0m\n"
}

get_count() {
    if [ -z "$1" ]; then
        printf '%s\n' '0'
    else
        printf '%s\n' "${1%$'\n'}" | wc -l
    fi
}

get_update_list() {
    upd=$(pacman -Qu --color=always)
    num=$(get_count "$upd")
    if [[ $num > 0 ]]; then
        [[ $num == 1 ]] && s="update" || s="updates"
        show_header "$num $s available:"
        echo "$upd"
    fi
}

get_single_repo() {
    repo_path=$1
    repo_status=$(LC_ALL=en_IE.UTF-8 git -c color.status=always -C "$repo_path" status -s --ignore-submodules)
    num=$(get_count "$repo_status")
    if [[ $num -gt 0 ]]; then
        [[ $num == 1 ]] && s="change" || s="changes"
        show_header "$num $s for ${repo_path/$HOME/\~}:"
        echo "$repo_status"
    fi
}

get_repos() {
    for repo in "${REPOS[@]}"; do
        get_single_repo "$repo"
    done
}

main() {
    get_update_list
    get_repos
}

main
