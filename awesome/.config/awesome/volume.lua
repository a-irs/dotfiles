local volume   = {}

function volume.toggle()
    os.execute 'pactl set-sink-mute @DEFAULT_SINK@ toggle'
    pulsewidget.update()
end

function volume.increase()
    os.execute 'pactl set-sink-volume @DEFAULT_SINK@ +1%'
    pulsewidget.update()
end

function volume.decrease()
    os.execute 'pactl set-sink-volume @DEFAULT_SINK@ -1%'
    pulsewidget.update()
end

return volume
