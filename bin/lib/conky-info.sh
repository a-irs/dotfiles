DEV="wlan0"

case "$1" in
"wifi-channel")
    iw dev $DEV info | grep channel | cut -f 2 | cut -f 2 -d " "
    ;;
"wifi-width")
    iw dev $DEV info | grep channel | cut -f 2 | cut -f 6 -d " "
    ;;
"wifi-bitrate")
    iwlist $DEV bitrate | grep Mb | cut -d "=" -f 2 | cut -d " " -f 1
    ;;
"kernel")
    uname -r | cut -d "-" -f 1
    ;;
*)
	echo invalid
    ;;
esac
