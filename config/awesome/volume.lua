local execute  = os.execute
local volume   = {}

function volume.toggle()
    execute 'pactl set-sink-mute 0 toggle'
    pulsewidget.update()
end

function volume.increase()
    execute 'pactl set-sink-volume 0 +1%'
    pulsewidget.update()
end

function volume.decrease()
    execute 'pactl set-sink-volume 0 -1%'
    pulsewidget.update()
end

return volume
