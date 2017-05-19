ansrole() {
    if [[ ! "$1" ]]; then
        printf "%s\n" "missing role name"
        return 1
    fi
    mkdir -vp roles/$1/{handlers,tasks,templates,files,defaults}
}
