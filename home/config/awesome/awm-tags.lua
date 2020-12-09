local awful = require 'awful'

local tag_count = 7
local tag_count_floating = 0

awful.screen.connect_for_each_screen(function(s)
    for i = 1, tag_count do
        awful.tag.add(" ☐ ", {
            layout = awful.layout.layouts[1],
            screen = s,
        })
    end
    for i = 1, tag_count_floating do
        x = awful.tag.add(" ☐ ", {
            layout = awful.layout.suit.floating,
            screen = s,
        })
    end
end)
