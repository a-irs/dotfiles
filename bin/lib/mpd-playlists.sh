#!/usr/bin/env zsh

set -e
setopt extended_glob

cd ~/music/playlists
sort -fu -- *.m3u\
~*_ALL.m3u\
~*0s\ Rap.m3u\
~African.m3u\
~Atari.m3u\
~Blues.m3u\
~Corey\ Taylor.m3u\
~Downtempo.m3u\
~Guardians*\
~Hard.m3u\
~Herr\ von\ Grau.m3u\
~Hotline\ Miami.m3u\
~Instrumental.m3u\
~Minus.m3u\
~Palindrome*\
~Redemption.m3u\
~Run\ The\ Jewels.m3u\
~Running.m3u\
~Spaghetti.m3u\
~Stones\ Throw.m3u\
~Surf.m3u\
~The\ Bees\ Made*.m3u\
~Todo.m3u\
~Unsortiert*.m3u\
~Brain*.m3u\
~Chinoi*.m3u\
> ~/music/playlists/000_ALL.m3u

cd ~/music/playlists_mpd
sort -fu -- *.m3u\
~*_ALL.m3u\
~*0s\ Rap.m3u\
~African.m3u\
~Atari.m3u\
~Blues.m3u\
~Corey\ Taylor.m3u\
~Downtempo.m3u\
~Guardians*\
~Hard.m3u\
~Herr\ von\ Grau.m3u\
~Hotline\ Miami.m3u\
~Instrumental.m3u\
~Minus.m3u\
~Palindrome*\
~Redemption.m3u\
~Run\ The\ Jewels.m3u\
~Running.m3u\
~Spaghetti.m3u\
~Stones\ Throw.m3u\
~Surf.m3u\
~The\ Bees\ Made*.m3u\
~Todo.m3u\
~Unsortiert*.m3u\
~Brain*.m3u\
~Chinoi*.m3u\
> ~/music/playlists_mpd/000_ALL.m3u

cd ~/music/playlists_mopidy
grep -v --no-filename '#EXTM3U' -- *.m3u\
~*_ALL.m3u\
~*0s\ Rap.m3u\
~African.m3u\
~Atari.m3u\
~Blues.m3u\
~Corey\ Taylor.m3u\
~Downtempo.m3u\
~Guardians*\
~Hard.m3u\
~Herr\ von\ Grau.m3u\
~Hotline\ Miami.m3u\
~Instrumental.m3u\
~Minus.m3u\
~Palindrome*\
~Redemption.m3u\
~Run\ The\ Jewels.m3u\
~Running.m3u\
~Spaghetti.m3u\
~Stones\ Throw.m3u\
~Surf.m3u\
~The\ Bees\ Made*.m3u\
~Todo.m3u\
~Unsortiert*.m3u\
~Brain*.m3u\
~Chinoi*.m3u\
> ~/music/playlists_mopidy/000_ALL.m3u
sed -i '1s/^/#EXTM3U\n/' ~/music/playlists_mopidy/000_ALL.m3u

#find ~/music/albums | grep -E ".mp3$" | sort -fu \
#> ~/music/playlists/000_ALBUMS.m3u
