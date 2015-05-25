local programs = {
   'nitrogen --restore',
   os.getenv("HOME") .. '/.bin/redshift.sh',
   'start-pulseaudio-x11',
   'kupfer --no-splash',
   'ponymix set-volume 15',
   'compton -b',
   'dropbox-cli start',
   'mpd',
}
for _, cmd in ipairs(programs) do
    os.execute(cmd .. ' &')
end

-- start programs for desktop
local programs_desktop = {
    'bash -c \'pgrep x2godesktopshar &> /dev/null || x2godesktopsharing\'',
    os.getenv("HOME") .. '/.bin/wait-for-srv.sh gvfs-mount smb://srv/data',
    os.getenv("HOME") .. '/.bin/wait-for-srv.sh gvfs-mount sftp://root@srv',
}
if hostname == "desktop" then
    for _, cmd in ipairs(programs_desktop) do
        os.execute(cmd .. ' &')
    end
end
