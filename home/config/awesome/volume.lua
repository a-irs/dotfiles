local volume = {}

function volume.toggle()
    os.execute 'pactl set-sink-mute @DEFAULT_SINK@ toggle; dunstify -r 20 -t 1500 "mute toggle" -i /usr/share/icons/Faba/48x48/notifications/notification-audio-volume-muted.svg'
    audiowidget.update()
end

function volume.increase()
    os.execute 'pactl set-sink-volume @DEFAULT_SINK@ +1%; dunstify -r 20 -t 1500 "Volume +" -i /usr/share/icons/Faba/48x48/notifications/notification-audio-volume-high.svg'
    audiowidget.update()
end

function volume.increase_10()
    os.execute 'pactl set-sink-volume @DEFAULT_SINK@ +10%; dunstify -r 20 -t 1500 "Volume +++" -i /usr/share/icons/Faba/48x48/notifications/notification-audio-volume-high.svg'
    audiowidget.update()
end

function volume.decrease()
    os.execute 'pactl set-sink-volume @DEFAULT_SINK@ -1%; dunstify -r 20 -t 1500 "Volume -" -i /usr/share/icons/Faba/48x48/notifications/notification-audio-volume-low.svg'
    audiowidget.update()
end

function volume.decrease_10()
    os.execute 'pactl set-sink-volume @DEFAULT_SINK@ -10%; dunstify -r 20 -t 1500 "Volume ---" -i /usr/share/icons/Faba/48x48/notifications/notification-audio-volume-low.svg'
    audiowidget.update()
end

return volume
