local execute  = os.execute
local volume   = {}

function volume.toggle()
    execute 'pactl set-sink-mute @DEFAULT_SINK@ toggle'
    pulsewidget.update()
end

function volume.increase()
    execute 'pactl set-sink-volume @DEFAULT_SINK@ +1%'
    pulsewidget.update()
end

function volume.decrease()
    execute 'pactl set-sink-volume @DEFAULT_SINK@ -1%'
    pulsewidget.update()
end

return volume
