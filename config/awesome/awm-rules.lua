local awful     = require 'awful'
local rules     = require 'awful.rules'
                  require 'awful.autofocus'
local beautiful = require 'beautiful'


rules.rules = {
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     maximized_vertical   = false,
                     maximized_horizontal = false,
                     buttons = clientbuttons } },
}

dynamic_tagging = function()
    for s = 1, screen.count() do
        -- set name of tag without clients
        local atags = awful.tag.gettags(s)
        for i, t in ipairs(atags) do
            t.name = "○"
        end

        -- set name of tag with clients
        local clist = client.get(s)
        for i, c in ipairs(clist) do
            local ctags = c:tags()
            for i, t in ipairs(ctags) do
                t.name = "●"
            end
        end
    end
end

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    dynamic_tagging()
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

-- signal function to execute when a client disappears
client.connect_signal("unmanage", function (c, startup)
    dynamic_tagging()
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
