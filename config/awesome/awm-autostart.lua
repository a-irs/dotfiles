local programs = {
   'start-pulseaudio-x11',
   'mpd',
   'kupfer --no-splash',
   'compton -b',
   'redshift -l 48.7:13.0 -t 5800:3200 -m vidmode -r',
}

for _, cmd in ipairs(programs) do
    os.execute(cmd .. ' &')
end
