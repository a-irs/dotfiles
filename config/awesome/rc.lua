local naughty = require 'naughty'
local awful   = require 'awful'

function dbg(text)
    naughty.notify({ text = text, timeout = 0 })
end

user_terminal    = "terminator"
user_browser     = "firefox"
user_editor      = "subl3"
user_filemanager = "thunar"

hostname = io.popen("uname -n"):read()

require 'awm-error-handling'
require 'awm-autostart'
require 'awm-beautiful'
require 'awm-layouts'
require 'awm-tags'
require 'awm-bindings'
require 'awm-statusbar'
require 'awm-rules'
require 'awm-notify-settings'

awful.tag.viewonly(awful.tag.gettags(mouse.screen)[2])
