home_bin = os.getenv("HOME") .. "/.bin/"

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
    "lxpolkit",
    "redshift",
    hostname == "desktop" and "mpd",
    hostname == "desktop" and "x2godesktopsharing",
    hostname == "desktop" and "synergyc",
    hostname == "desktop" and "numlockx",
    hostname == "desktop" and "ethtool",
    hostname == "desktop" and "kodi",
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
    'parcellite --no-icon',
    'start-pulseaudio-x11',
    'kupfer --no-splash',
    'killall compton ; compton -b',
    'dropbox-cli start',
    'bash -c "pgrep -x lxpolkit || lxpolkit"',
    'bash -c "pgrep -x redshift || redshift"',
    'mkdir -p ' .. os.getenv("HOME") .. '/.thumbnails',
    'ln -sf ' .. os.getenv("HOME") .. '/.thumbnails ' .. os.getenv("HOME") .. '/.cache/thumbnails',
    'ln -sf ' .. os.getenv("HOME") .. '/.rofi-2.runcache ' .. os.getenv("HOME") .. '/.cache/rofi-2.runcache',
    'xset -dpms ; xset s off',
    hostname == "desktop" and 'pgrep -x mpd || mpd',
    hostname == "desktop" and 'bash -c "pgrep x2godesktopshar || x2godesktopsharing"',
    hostname == "desktop" and 'bash -c "pgrep synergyc || synergyc -d ERROR dell"',
    hostname == "desktop" and 'numlockx',
    hostname == "desktop" and 'sh -c \'sleep 10; sudo ethtool -s eth0 wol g\'',
    hostname == "desktop" and 'bash -c \"pgrep kodi || ' .. home_bin .. "wait-for-srv.sh kodi" .. "\"",
}
for _, cmd in ipairs(programs) do
    if cmd then
        os.execute(cmd .. ' &')
    end
end
