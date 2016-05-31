theme                               = {}

local basedir                       = os.getenv("HOME") .. "/.config/awesome"
if high_dpi then
    xpm_folder                      = basedir .. "/xpm_175"
else
    xpm_folder                      = basedir .. "/xpm_100"
end

theme.statusbar_height              = dpi(16)
theme.statusbar_position            = "top"

-- FG, BG COLORS

theme.bg_normal                     = "#212d45"
theme.bg_focus                      = "#304366"
theme.bg_urgent                     = "#aa0000"
theme.fg_normal                     = "#aaaaaa"
theme.fg_focus                      = "#ffffff"
theme.fg_urgent                     = "#ffffff"

theme.border_width                  = 0

theme.useless_gap_normal            = 0 -- dpi(vres/150)
theme.useless_gap_compact           = 0 -- dpi(vres/200)

if compact_display then
    theme.useless_gap = theme.useless_gap_compact
else
    theme.useless_gap = theme.useless_gap_normal
end

-- NOTIFICATIONS (NAUGHTY)

theme.naughty_font                  = "Fira Sans Medium 8"
theme.naughty_padding               = dpi(18)
theme.naughty_spacing               = dpi(18)
theme.naughty_border_width          = dpi(4)
theme.naughty_timeout               = 6
theme.naughty_position              = "top_right"

theme.naughty_defaults_fg           = theme.fg_focus
theme.naughty_defaults_bg           = theme.bg_focus
theme.naughty_defaults_border_color = theme.naughty_defaults_bg

theme.naughty_critical_fg           = '#ffffff'
theme.naughty_critical_bg           = '#F05F4D'
theme.naughty_critical_border_color = theme.naughty_critical_bg


-- WIDGETS

theme.font                          = "cure.se 8"
theme.taglist_font                  = "cure.se 6"
theme.show_tag_names                = true
-- theme.taglist_squares_unsel         = xpm_folder .. "/indicator.xpm"

if high_dpi then
    theme.font = "Monospace 7"
    theme.taglist_font = "Monospace 7"
end

theme.tasklist_font                 = theme.font
theme.tasklist_fg                   = theme.fg_focus
theme.tasklist_bg                   = theme.bg_normal
theme.tasklist_disable_icon         = true

theme.bg_systray                    = theme.bg_normal
theme.widget_music_fg               = theme.fg_focus
theme.widget_date_fg                = "#cccccc"
theme.widget_time_fg                = "#eeeeee"
theme.widget_pulse_fg               = "#96b7e2"
theme.widget_pulse_mute_fg          = "#666666"

theme.widget_speed_down             = "#ff8a5a"
theme.widget_speed_up               = theme.widget_speed_down
theme.widget_cpu_fg                 = "#ff6997"
theme.widget_cpu_graph_fg           = theme.widget_cpu_fg
theme.widget_cpu_graph_bg           = theme.bg_normal
theme.widget_cpu_freq_fg            = "#9f96ff"
theme.widget_mem_fg                 = "#71ee5c"
theme.widget_load_fg                = "#80d9d8"
theme.widget_disk_read_fg           = "#ffc350"
theme.widget_disk_write_fg          = theme.widget_disk_read_fg

-- LAYOUT ICONS

theme.layout_tile                   = xpm_folder .. "/layout/tile.xpm"
theme.layout_tileleft               = xpm_folder .. "/layout/tileleft.xpm"
theme.layout_tilebottom             = xpm_folder .. "/layout/tilebottom.xpm"
theme.layout_tiletop                = xpm_folder .. "/layout/tiletop.xpm"
theme.layout_spiral                 = xpm_folder .. "/layout/spiral.xpm"
theme.layout_floating               = xpm_folder .. "/layout/floating.xpm"
theme.layout_fairv                  = xpm_folder .. "/layout/fairv.xpm"
theme.layout_fairh                  = xpm_folder .. "/layout/fairh.xpm"

-- TITLEBAR

theme.titlebar_height                          = dpi(24)
theme.titlebar_font                            = "Fira Sans Medium 8"

theme.titlebar_fg_normal                       = theme.fg_normal
theme.titlebar_fg_focus                        = theme.fg_focus
theme.titlebar_bg_normal                       = theme.bg_normal
theme.titlebar_bg_focus                        = theme.bg_normal

theme.titlebar_close_button_focus              = xpm_folder .. "/titlebar/close.xpm"
theme.titlebar_close_button_normal             = xpm_folder .. "/titlebar/unfocused_inactive.xpm"
theme.titlebar_ontop_button_focus_inactive     = xpm_folder .. "/titlebar/ontop_inactive.xpm"
theme.titlebar_ontop_button_focus_active       = xpm_folder .. "/titlebar/ontop_active.xpm"
theme.titlebar_ontop_button_normal_inactive    = xpm_folder .. "/titlebar/ontop_inactive.xpm"
theme.titlebar_ontop_button_normal_active      = xpm_folder .. "/titlebar/ontop_unfocused.xpm"
theme.titlebar_sticky_button_focus_inactive    = xpm_folder .. "/titlebar/sticky_inactive.xpm"
theme.titlebar_sticky_button_focus_active      = xpm_folder .. "/titlebar/sticky_active.xpm"
theme.titlebar_sticky_button_normal_inactive   = xpm_folder .. "/titlebar/unfocused_inactive.xpm"
theme.titlebar_sticky_button_normal_active     = xpm_folder .. "/titlebar/unfocused_active.xpm"
theme.titlebar_floating_button_focus_inactive  = xpm_folder .. "/titlebar/floating_inactive.xpm"
theme.titlebar_floating_button_focus_active    = xpm_folder .. "/titlebar/floating_active.xpm"
theme.titlebar_floating_button_normal_inactive = xpm_folder .. "/titlebar/unfocused_inactive.xpm"
theme.titlebar_floating_button_normal_active   = xpm_folder .. "/titlebar/unfocused_active.xpm"

return theme
