local execute  = os.execute
local volume   = {}

function volume.toggle()
    execute 'pamixer --toggle-mute'
    volumewidget.update()
end

function volume.increase()
    execute 'pamixer --increase 1'
    volumewidget.update()
end

function volume.decrease()
    execute 'pamixer --decrease 1'
    volumewidget.update()
end

return volume
