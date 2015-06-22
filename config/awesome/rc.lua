local naughty = require 'naughty'
local awful   = require 'awful'

user_terminal    = "terminator"
user_browser     = "firefox"
user_editor      = "subl3"
user_filemanager = "thunar"

hostname = io.popen("uname -n"):read()

require 'awm-beautiful'
require 'awm-notify-settings'

function dbg(text)
    naughty.notify({ text = text, timeout = 0 })
end

function dbg_crit(text)
    naughty.notify({ preset = naughty.config.presets.critical, text = text, timeout = 0 })
end

require 'awm-error-handling'
require 'awm-autostart'
require 'awm-layouts'
require 'awm-tags'
require 'awm-bindings'
require 'awm-statusbar'
require 'awm-rules'
