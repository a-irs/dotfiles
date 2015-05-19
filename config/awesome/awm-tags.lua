local awful      = require 'awful'
local tyrannical = require 'tyrannical'
local lain       = require 'lain'


tyrannical.settings.block_children_focus_stealing = true
tyrannical.settings.group_children = true

tyrannical.tags = {
    {
        name        = "●",
        init        = true,
        exclusive   = false,
        layout      = lain.layout.uselessfair,
        class       = { user_browser, "firefox", "chromium" }
    },
    {
        name        = "●",
        init        = true,
        exclusive   = false,
        layout      = lain.layout.uselessfair.horizontal,
        exec_once   = { user_terminal },
        class       = { user_terminal, "urxvt", "terminator" }
    },
    {
        name        = "●",
        init        = true,
        exclusive   = false,
        layout      = lain.layout.uselessfair.horizontal,
        class       = { user_editor, "subl3", "atom" }
    },
    {
        name        = "●",
        init        = true,
        exclusive   = false,
        layout      = lain.layout.uselessfair,
        exec_once   = { user_filemanager },
        class       = { user_filemanager, "thunar", "engrampa" }
    },
    {
        name        = "●",
        init        = false,
        exclusive   = false,
        layout      = lain.layout.uselessfair.horizontal,
        class       = { "evince" }
    },
    {   name        = "●",
        init        = false,
        exclusive   = false,
        layout      = awful.layout.suit.max.fullscreen,
        class       = { "gpicview" }
    },
}
-- Ignore the tag "exclusive" property for the following clients (matched by classes)
tyrannical.properties.intrusive = {
    "kupfer.py", "gcolor2",
    "ksnapshot"     , "pinentry"       , "gtksu"     , "kcalc"        , "xcalc"               ,
    "feh"           , "Gradient editor", "About KDE" , "Paste Special", "Background color"    ,
    "kcolorchooser" , "plasmoidviewer" , "Xephyr"    , "kruler"       , "plasmaengineexplorer",
}
-- Ignore the tiled layout for the matching clients
tyrannical.properties.floating = {
    "MPlayer"      , "pinentry"        , "ksnapshot"  , "pinentry"     , "gtksu"          ,
    "xine"         , "feh"             , "kmix"       , "kcalc"        , "xcalc"          ,
    "yakuake"      , "Select Color$"   , "kruler"     , "kcolorchooser", "Paste Special"  ,
    "New Form"     , "Insert Picture"  , "kcharselect", "mythfrontend" , "plasmoidviewer",
}
-- Make the matching clients (by classes) on top of the default layout
tyrannical.properties.ontop = {
    "Xephyr"       , "ksnapshot"       , "kruler"
}
-- Force the matching clients (by classes) to be centered on the screen on init
tyrannical.properties.centered = {
    "gcolor2", "kcalc"
}
