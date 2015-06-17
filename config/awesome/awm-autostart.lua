local programs = {
   'nitrogen --restore',
   'start-pulseaudio-x11',
   'kupfer --no-splash',
   'compton -b',
   'dropbox-cli start',
   'mpd',
   'bash -c "pgrep -x lxpolkit || lxpolkit"',
   'bash -c "pgrep -x redshift || redshift"',
   'mkdir -p ' .. os.getenv("HOME") .. '.thumbnails',
   'ln -sf ' .. os.getenv("HOME") .. '/.thumbnails ' .. os.getenv("HOME") .. '/.cache/thumbnails',
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
