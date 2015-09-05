theme                               = {}

theme.basedir                       = os.getenv("HOME") .. "/.config/awesome"
if high_dpi then
    xpm_folder                      = theme.basedir .. "/xpm_175"
else
    xpm_folder                      = theme.basedir .. "/xpm_100"
end

theme.statusbar_height              = dpi(24)
theme.statusbar_position            = "top"

-- FG, BG COLORS

theme.bg_normal                     = "#2c3643f3"
theme.bg_focus                      = "#3c4b5df3"
theme.bg_urgent                     = "#aa0000"
theme.fg_normal                     = "#aaaaaa"
theme.fg_focus                      = "#ffffff"
theme.fg_urgent                     = "#af1d18"

theme.border_width                  = dpi(0)
theme.border_normal                 = theme.bg_normal
theme.border_focus                  = theme.bg_focus

theme.useless_gap_normal            = dpi(vres/150)
theme.useless_gap_compact           = 0

if compact_display then
    theme.useless_gap = theme.useless_gap_compact
else
    theme.useless_gap = theme.useless_gap_normal
end

-- NOTIFICATIONS (NAUGHTY)

theme.naughty_font                  = "Roboto Medium 8"
theme.naughty_padding               = dpi(12)
theme.naughty_spacing               = dpi(12)
theme.naughty_border_width          = dpi(6)
theme.naughty_timeout               = 4
theme.naughty_position              = "top_right"

theme.naughty_defaults_fg           = '#aaaaaa'
theme.naughty_defaults_bg           = '#222a34'
theme.naughty_defaults_border_color = theme.naughty_defaults_bg

theme.naughty_critical_fg           = '#ffffff'
theme.naughty_critical_bg           = '#fa5641'
theme.naughty_critical_border_color = theme.naughty_critical_bg


-- WIDGETS

theme.font                          = "Ubuntu 8"
theme.taglist_font                  = "Roboto Medium 10"
theme.show_tag_names                = true
--theme.taglist_squares_unsel         = xpm_folder .. "/indicator.xpm"

theme.bg_systray                    = theme.bg_normal
theme.widget_mpd_fg                 = "#cfcfcf"
theme.widget_mpd_bg                 = theme.bg_normal
theme.widget_mpd_font               = "Roboto 8"
theme.widget_calendar_font          = "Input"
theme.widget_calendar_font_size     = 8
theme.widget_calendar_fg            = theme.fg_normal
theme.widget_calendar_bg            = "#222a34"
theme.widget_date_fg                = "#dfdfdf"
theme.widget_alsa_fg                = "#96b7e2"
theme.widget_alsa_mute_fg           = "#666666"
theme.widget_yawn_fg                = "#ababab"
theme.widget_speed_down             = "#ff8a5a"
theme.widget_speed_up               = theme.widget_speed_down
theme.widget_cpu_fg                 = "#ff6997"
theme.widget_cpu_graph_fg           = theme.widget_cpu_fg
theme.widget_cpu_graph_bg           = "#3d4b5c"
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
theme.titlebar_font                            = "Roboto Bold 8"

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
