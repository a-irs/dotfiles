WORKON_HOME=~/dev/venvs

[ -f /usr/bin/python2 ] && alias mkvirtualenv2="mkvirtualenv -p /usr/bin/python2"
[ -f /usr/bin/virtualenvwrapper_lazy.sh ] && source /usr/bin/virtualenvwrapper_lazy.sh

pa="$WORKON_HOME/postactivate"

if [[ -w "$pa" ]]; then

    cat <<EOF > $pa
#!/usr/bin/zsh

cd "\$VIRTUAL_ENV"
PROMPT="\$_OLD_VIRTUAL_PS1"

cd() {
    if (( \$# == 0 )) && [[ -n "\$VIRTUAL_ENV" ]]; then
        builtin cd "\$VIRTUAL_ENV"
    else
        builtin cd "\$@"
    fi
}
EOF

fi
