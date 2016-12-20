local awful      = require 'awful'


local function make_name(icon, name)
    str = " "
    if icon == "globe" then
        str = str .. string.char(239, 130, 172)
    elseif icon == "desktop" then
        str = str .. string.char(239, 132, 136)
    elseif icon == "terminal" then
        str = str .. string.char(239, 132, 160)
    elseif icon == "file" then
        str = str .. string.char(239, 128, 150)
    elseif icon == "file-text" then
        str = str .. string.char(239, 133, 156)
    elseif icon == "list-alt" then
        str = str .. string.char(239, 128, 162)
    elseif icon == "cloud" then
        str = str .. string.char(239, 131, 130)
    elseif icon == "asterisk" then
        str = str .. string.char(239, 129, 169)
    elseif icon == "music" then
        str = str .. string.char(239, 128, 129)
    elseif icon == "picture" then
        str = str .. string.char(239, 128, 190)
    elseif icon == "video" then
        str = str .. string.char(239, 133, 170)
    end
    if name and theme.show_tag_names then
        if icon == nil then
            str = str .. name
        else
            str = str .. "  " .. name
        end
    end
    return str .. " "
end

tags = {}
awful.screen.connect_for_each_screen(function(s)
    tags[s] = awful.tag({
        make_name(nil, 1),
        make_name(nil, 2),
        make_name(nil, 3),
        make_name(nil, 4),
        make_name(nil, 5),
        }, s, layouts[1])
end)
