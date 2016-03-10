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
    "pcmanfm",
    hostname == "dell" and "nm-applet",
    hostname == "desktop" and "mpd",
    hostname == "desktop" and "numlockx",
    hostname == "desktop" and "ethtool",
}

for _, cmd in ipairs(needed) do
    if cmd then
        if not file_exists(cmd) then
            dbg_crit("Missing: /usr/bin/" .. cmd)
        end
    end
end


local programs = {
    'killall -USR1 termite',
    'nitrogen --restore',
    'parcellite --no-icon',
    'start-pulseaudio-x11',
    'kupfer --no-splash',
    'killall compton ; compton -b',
    'dropbox-cli start',
    'bash -c "if ! pgrep -x pcmanfm; then pcmanfm --daemon-mode& fi"',
    'bash -c "if ! pgrep -x lxpolkit; then lxpolkit& fi"',
    'bash -c "if ! pgrep -x redshift; then redshift& fi"',
    'mkdir -p ' .. os.getenv("HOME") .. '/.thumbnails',
    'ln -sf ' .. os.getenv("HOME") .. '/.thumbnails ' .. os.getenv("HOME") .. '/.cache/thumbnails',
    'xset -dpms ; xset s off',
    hostname == "dell" and 'bash -c "if ! pgrep -x nm-applet; then nm-applet& fi"',
    hostname == "desktop" and 'pgrep -x mpd || mpd',
    hostname == "desktop" and 'numlockx',
    hostname == "desktop" and 'sh -c \'sleep 10; sudo ethtool -s eth0 wol g\'',
}
for _, cmd in ipairs(programs) do
    if cmd then
        os.execute(cmd .. ' &')
    end
end
