local programs = {
   'start-pulseaudio-x11',
   'mpd',
   'kupfer --no-splash',
   'compton -b',
   'dropbox-cli start',
   os.getenv("HOME") .. '/.bin/redshift.sh',
   'ponymix set-volume 15',
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
