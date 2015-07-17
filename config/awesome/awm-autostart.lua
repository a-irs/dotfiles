function file_exists(name)
    local f = io.open("/usr/bin/" .. name, "r")
    if f ~= nil then io.close(f) return true else return false end
end

local needed = {
    "nitrogen",
    "parcellite",
    "start-pulseaudio-x11",
    "kupfer",
    "compton",
    "dropbox-cli",
    "thunar",
    "lxpolkit",
    "redshift",
    hostname == "desktop" and "mpd",
    hostname == "desktop" and "x2godesktopsharing",
    hostname == "desktop" and "syncergyc",
}

for _, cmd in ipairs(needed) do
    if cmd then
        if not file_exists(cmd) then
            dbg_crit("Missing: /usr/bin/" .. cmd)
        end
    end
end


local programs = {
    'nitrogen --restore',
    'parcellite --daemon --no-icon',
    'start-pulseaudio-x11',
    'kupfer --no-splash',
    'killall compton ; compton -b',
    'dropbox-cli start',
    'pgrep -x thunar || thunar --daemon',
    'bash -c "pgrep -x lxpolkit || lxpolkit"',
    'bash -c "pgrep -x redshift || redshift"',
    'mkdir -p ' .. os.getenv("HOME") .. '/.thumbnails',
    'ln -sf ' .. os.getenv("HOME") .. '/.thumbnails ' .. os.getenv("HOME") .. '/.cache/thumbnails',
    'ln -sf ' .. os.getenv("HOME") .. '/.rofi-2.runcache ' .. os.getenv("HOME") .. '/.cache/rofi-2.runcache',
    'xset -dpms ; xset s off',
    hostname == "desktop" and 'pgrep -x mpd || mpd',
    hostname == "desktop" and 'bash -c "pgrep x2godesktopshar || x2godesktopsharing"',
    hostname == "desktop" and 'bash -c "pgrep synergyc || synergyc -d WARNING dell"',
    hostname == "desktop" and os.getenv("HOME") .. '/.bin/wait-for-srv.sh gvfs-mount smb://srv/data',
    hostname == "desktop" and os.getenv("HOME") .. '/.bin/wait-for-srv.sh gvfs-mount sftp://root@srv',
}
for _, cmd in ipairs(programs) do
    if cmd then
        os.execute(cmd .. ' &')
    end
end
