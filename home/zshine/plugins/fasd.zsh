# https://github.com/clvv/fasd
#
# Word completion is triggered by any command line argument that starts with , (all), f, (files), or d, (directories), or that ends with ,, (all), ,,f (files), or ,,d (directories). Examples:
# $ vim ,rc,lo<Tab>
# $ vim /etc/rc.local
# $ mv index.html d,www<Tab>
# $ mv index.html /var/www/

fasd_cache="$HOME/.cache/fasd.zsh"
if [[ "$commands[fasd]" -nt "$fasd_cache" || ! -s "$fasd_cache" ]]; then
  fasd --init \
    posix-alias \
    zsh-hook \
    zsh-wcomp \
    zsh-wcomp-install \
    >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache
