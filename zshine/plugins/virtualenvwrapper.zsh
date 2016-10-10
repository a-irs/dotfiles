WORKON_HOME=~/dev/venvs
VIRTUAL_ENV_DISABLE_PROMPT=1

[ -f /usr/bin/python2 ] && alias mkvirtualenv2="mkvirtualenv -p /usr/bin/python2"
[ -f /usr/bin/python3 ] && alias mkvirtualenv3="mkvirtualenv -p /usr/bin/python3"

[ -f /usr/bin/virtualenvwrapper_lazy.sh ] && source /usr/bin/virtualenvwrapper_lazy.sh
[ -f /usr/local/bin/virtualenvwrapper_lazy.sh ] && source /usr/local/bin/virtualenvwrapper_lazy.sh
[ -f /usr/share/virtualenvwrapper/virtualenvwrapper_lazy.sh ] && source /usr/share/virtualenvwrapper/virtualenvwrapper_lazy.sh

pa="$WORKON_HOME/postactivate"
if [[ -w "$pa" ]]; then

    cat <<EOF > $pa
#!/usr/bin/zsh

cd "\$VIRTUAL_ENV"

cd() {
    if (( \$# == 0 )) && [[ -n "\$VIRTUAL_ENV" ]]; then
        builtin cd "\$VIRTUAL_ENV"
    else
        builtin cd "\$@"
    fi
}
EOF

fi
