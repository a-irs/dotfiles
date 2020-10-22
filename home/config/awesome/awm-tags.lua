local awful      = require 'awful'

local default_layout = awful.layout.layouts[1]

if hostname == "desk" then
    awful.screen.connect_for_each_screen(function(s)
        awful.tag({" ☐ ", " ☐ ", " ☐ ", " ☐ ", " ☐ ", " ☐ ", " ☐ "}, s, default_layout)
    end)
else
    awful.screen.connect_for_each_screen(function(s)
        awful.tag({" ☐ ", " ☐ ", " ☐ ", " ☐ ", " ☐ "}, s, default_layout)
    end)
end
