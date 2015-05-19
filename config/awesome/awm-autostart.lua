local programs = {
   'start-pulseaudio-x11',
   'mpd',
   'kupfer --no-splash',
   'compton -b',
   os.getenv("HOME") .. '/.bin/redshift.sh',
}

for _, cmd in ipairs(programs) do
    os.execute(cmd .. ' &')
end
