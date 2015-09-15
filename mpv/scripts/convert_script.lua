local msg = require 'mp.msg'
local opt = require 'mp.options'
local mputils = require 'mp.utils'

-----------------
-- Main script --
-----------------

function convert_script_hotkey_call()

	width = mp.get_property("dwidth")
	height = mp.get_property("dheight")
	mp.set_osd_ass(width, height, "")

	if timepos1 then
		timepos2 = mp.get_property("time-pos")

		if tonumber(timepos1) > tonumber(timepos2) then
    		length = timepos1-timepos2
    		start = timepos2
    		msg.info("END")

	    elseif tonumber(timepos2) > tonumber(timepos1) then
    	    length = timepos2-timepos1
    		start = timepos1
    	    msg.info("END")

        else
        	msg.error("Both frames are the same, ignoring the second one")
	        mp.osd_message("Both frames are the same, ignoring the second one")
	        timepos2 = nil
	        return

        end

        timepos1 = nil
        mp.enable_key_bindings("draw_rectangle")

        mp.resume_all()
        mp.disable_key_bindings("draw_rectangle")
        mp.set_osd_ass(width, height, "")

        encode("webm")

	else

		timepos1 = mp.get_property("time-pos")
		msg.info("START")
		mp.osd_message("START")

	end

end


function encode(codec)

    local input = mp.get_property("path", "")
	local command = 'mpv ' .. input .. ' -profile webm --start ' .. start .. ' -length ' .. length .. ' -o ' .. os.getenv("HOME") .. "/output.webm > /dev/null && notify-send 'ENCODING FINISHED' &"
	msg.info('EXECUTE: ' .. command)
    os.execute([[bash -c "]] .. command .. [["]])
    os.exit()

end

mp.add_key_binding("alt+w", "convert_script", convert_script_hotkey_call)
