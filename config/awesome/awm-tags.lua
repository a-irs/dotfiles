local awful      = require 'awful'
local tyrannical = require 'tyrannical'
local lain       = require 'lain'


tyrannical.settings.block_children_focus_stealing = true
tyrannical.settings.group_children                = true
tyrannical.settings.default_layout                = awful.layout.suit.tile
tyrannical.settings.mwfact                        = 0.5

tyrannical.tags = {
    {
        name        = "○",
        init        = true,
        exclusive   = true,
        class       = { user_browser, "firefox", "chromium" }
    },
    {
        name        = "○",
        init        = true,
        exclusive   = true,
        layout      = awful.layout.suit.tile.bottom,
        exec_once   = { user_terminal },
        class       = { user_terminal, "urxvt", "terminator" }
    },
    {
        name        = "○",
        init        = true,
        exclusive   = true,
        layout      = awful.layout.suit.tile.bottom,
        class       = { user_editor, "subl3", "atom" }
    },
    {
        name        = "○",
        init        = true,
        exclusive   = true,
       -- exec_once   = { user_filemanager },
        class       = { user_filemanager, "thunar", "engrampa" }
    },
    {
        name        = "○",
        init        = false,
        exclusive   = true,
        class       = { "kodi", "gimp" }
    },
    {   name        = "○",
        init        = true,
        fallback    = true,
    },
}
-- Ignore the tag "exclusive" property for the following clients (matched by classes)
tyrannical.properties.intrusive = {
    "kupfer.py", "gcolor2", "gtksu", "pinentry",
}
-- Ignore the tiled layout for the matching clients
tyrannical.properties.floating = {
    "pinentry", "plugin-container",
}
-- Make the matching clients (by classes) on top of the default layout
tyrannical.properties.ontop = {
    "pinentry", "plugin-container", "gcolor2"
}
-- Force the matching clients (by classes) to be centered on the screen on init
tyrannical.properties.centered = {
    "gcolor2",
}
