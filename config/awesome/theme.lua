theme                               = {}

theme.basedir                       = os.getenv("HOME") .. "/.config/awesome"

theme.font                          = "Ubuntu 8"
theme.taglist_font                  = "Ubuntu 7"
theme.statusbar_height              = 20

theme.bg_normal                     = "#2d2d2d"
theme.bg_focus                      = theme.bg_normal
theme.bg_urgent                     = "#aa0000"
theme.bg_systray                    = theme.bg_normal
theme.fg_normal                     = "#aaaaaa"
theme.fg_focus                      = "#eeeeee"
theme.fg_urgent                     = "#af1d18"

theme.border_width                  = 0
theme.border_normal                 = theme.bg_normal
theme.border_focus                  = theme.bg_focus

theme.useless_gap_width             = 15

theme.widget_date_fg                = "#fff"
theme.widget_date_calendar_font     = "Input"
theme.widget_alsa_fg                = "#B895B5"
theme.widget_alsa_mute_fg           = "grey"
theme.widget_yawn_fg                = "#ababab"
theme.widget_speed_down             = "#F8B83E"
theme.widget_speed_up               = "#F8743E"

-- TITLEBAR

theme.titlebar_height = 18
theme.titlebar_font   = "Roboto Bold 8"

theme.titlebar_close_button_focus              = theme.basedir .. "/titlebar/close.xpm"
theme.titlebar_close_button_normal             = theme.basedir .. "/titlebar/unfocused_inactive.xpm"
theme.titlebar_ontop_button_focus_inactive     = theme.basedir .. "/titlebar/ontop_inactive.xpm"
theme.titlebar_ontop_button_focus_active       = theme.basedir .. "/titlebar/ontop_active.xpm"
theme.titlebar_ontop_button_normal_inactive    = theme.basedir .. "/titlebar/ontop_inactive.xpm"
theme.titlebar_ontop_button_normal_active      = theme.basedir .. "/titlebar/ontop_unfocused.xpm"
theme.titlebar_sticky_button_focus_inactive    = theme.basedir .. "/titlebar/sticky_inactive.xpm"
theme.titlebar_sticky_button_focus_active      = theme.basedir .. "/titlebar/sticky_active.xpm"
theme.titlebar_sticky_button_normal_inactive   = theme.basedir .. "/titlebar/unfocused_inactive.xpm"
theme.titlebar_sticky_button_normal_active     = theme.basedir .. "/titlebar/unfocused_active.xpm"
theme.titlebar_floating_button_focus_inactive  = theme.basedir .. "/titlebar/floating_inactive.xpm"
theme.titlebar_floating_button_focus_active    = theme.basedir .. "/titlebar/floating_active.xpm"
theme.titlebar_floating_button_normal_inactive = theme.basedir .. "/titlebar/unfocused_inactive.xpm"
theme.titlebar_floating_button_normal_active   = theme.basedir .. "/titlebar/unfocused_active.xpm"

-- HOST-SPECIFIC SETTINGS

if hostname == "desktop" then
    theme.useless_gap_width         = 25
end

return theme
