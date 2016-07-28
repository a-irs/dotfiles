if [[ "$TERM" == xterm-termite && -f /etc/profile.d/vte.sh ]]; then
    source /etc/profile.d/vte.sh
    __vte_osc7 &> /dev/null
fi
