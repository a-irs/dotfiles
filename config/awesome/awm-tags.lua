local awful      = require 'awful'
local tyrannical = require 'tyrannical'
local lain       = require 'lain'


tyrannical.settings.block_children_focus_stealing = true
tyrannical.settings.group_children = true

tyrannical.tags = {
    {
        name        = "○",
        init        = true,
        exclusive   = true,
        layout      = awful.layout.suit.tile,
        class       = { user_browser, "firefox", "chromium" }
    },
    {
        name        = "○",
        init        = true,
        exclusive   = true,
        layout      = awful.layout.suit.tile.bottom,
        mwfact      = 0.6,
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
        layout      = awful.layout.suit.tile,
       -- exec_once   = { user_filemanager },
        class       = { user_filemanager, "thunar", "engrampa" }
    },
    {
        name        = "○",
        init        = false,
        exclusive   = true,
        layout      = awful.layout.suit.tile,
        class       = { "kodi", "gimp" }
    },
    {   name        = "○",
        init        = true,
        fallback    = true,
        layout      = awful.layout.suit.tile,
    },
}
-- Ignore the tag "exclusive" property for the following clients (matched by classes)
tyrannical.properties.intrusive = {
    "kupfer.py", "gcolor2", "gtksu", "pinentry",
}
-- Ignore the tiled layout for the matching clients
tyrannical.properties.floating = {
    "mpv", "pinentry", "plugin-container",
}
-- Make the matching clients (by classes) on top of the default layout
tyrannical.properties.ontop = {
    "mpv", "pinentry", "plugin-container",
}
-- Force the matching clients (by classes) to be centered on the screen on init
tyrannical.properties.centered = {
    "gcolor2",
}
