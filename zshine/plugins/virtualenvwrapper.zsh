WORKON_HOME=~/dev/venvs
VIRTUAL_ENV_DISABLE_PROMPT=1

# (N) is for NULL_GLOB
for p in /usr/bin/python[2-3]\.[0-9](N) /usr/bin/python[2-3](N); do
    local v=${p:t}
    v=${v//python/}
    alias mkvirtualenv${v}="mkvirtualenv -p ${p}"
done

for p in /usr/bin /usr/local/bin /usr/share/virtualenvwrapper; do
    p=$p/virtualenvwrapper_lazy.sh
    [[ -f "$p" ]] && source "$p"
done
