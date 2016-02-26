local execute  = os.execute
local volume   = {}

function volume.toggle()
    execute 'pamixer --toggle-mute'
    pulsewidget.update()
end

function volume.increase()
    execute 'pamixer --increase 1'
    pulsewidget.update()
end

function volume.decrease()
    execute 'pamixer --decrease 1'
    pulsewidget.update()
end

return volume
