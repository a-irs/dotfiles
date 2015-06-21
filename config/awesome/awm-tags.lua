local awful      = require 'awful'
local tyrannical = require 'tyrannical'
local lain       = require 'lain'


tyrannical.settings.block_children_focus_stealing = true
tyrannical.settings.group_children                = true
tyrannical.settings.mwfact                        = 0.5
tyrannical.settings.default_layout                = lain.layout.uselesstile

tyrannical.tags = {
    {
        name        = "○",
        init        = true,
        exclusive   = true,
        mwfact      = 0.68,
        class       = { user_browser, "firefox", "chromium" }
    },
    {
        name        = "○",
        init        = true,
        exclusive   = true,
        exec_once   = { user_terminal },
        class       = { user_terminal, "urxvt", "terminator", "termite" }
    },
    {
        name        = "○",
        init        = true,
        exclusive   = true,
        class       = { user_editor, "subl3", "atom" }
    },
    {   name        = "○",
        init        = false,
        fallback    = true,
    },
}
-- Ignore the tag "exclusive" property for the following clients (matched by classes)
tyrannical.properties.intrusive = {
    "kupfer.py", "gtksu", "pinentry", "gcolor2", "gcolor3", "Colorgrab",
}
-- Ignore the tiled layout for the matching clients
tyrannical.properties.floating = {
    "pinentry", "plugin-container", "gcolor3", "Colorgrab",
}
-- Make the matching clients (by classes) on top of the default layout
tyrannical.properties.ontop = {
    "pinentry", "plugin-container", "gcolor2", "gcolor3", "Colorgrab",
}
-- Force the matching clients (by classes) to be centered on the screen on init
tyrannical.properties.centered = {
    "gcolor2", "gcolor3", "Colorgrab",
}

tyrannical.properties.sticky = {
    "gcolor2", "gcolor3", "Colorgrab",
}

tyrannical.properties.master = {
    "firefox", "atom",
}
