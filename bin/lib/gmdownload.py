#!/home/alex/dev/venvs/gmusicapi/bin/python2
# -*- coding: utf-8 -*-

from __future__ import print_function
from gmusicapi import Mobileclient
from gmusicapi import Musicmanager
from gmusicapi import exceptions
import eyed3
import urllib2
import os
import shutil
import codecs
import sys
import re
import time
import locale
from colorama import init, Fore, Style
from ConfigParser import SafeConfigParser
from requests.packages import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)
from urllib import quote

CONFIG_FILE = os.path.expanduser("~/.config/gmdownload.config")
CACHE_FILE = os.path.expanduser("~/.config/gmdownload.cache")
OAUTH_FILE = os.path.expanduser("~/.config/gmdownload.oauth")

config = SafeConfigParser()
config.read(CONFIG_FILE)

mobileId = config.get('config', 'mobileId')
email = config.get('config', 'email')
password = config.get('config', 'password')
uploader_id = config.get('config', 'uploader_id')
main_dir = os.path.expanduser(config.get('config', 'directory'))
pl_dir = os.path.expanduser(config.get('config', 'playlist_directory'))
pl_dir_mpd = os.path.expanduser(config.get('config', 'playlist_directory_mpd'))
pl_dir_mopidy = os.path.expanduser(config.get('config', 'playlist_directory_mopidy'))

CACHE = None

mobileclient = Mobileclient(debug_logging=False)
musicmanager = Musicmanager(debug_logging=False)


def pretty_song(path):
    path = path.replace(main_dir + "/", '')
    artist = path.split('/')[0]

    title = os.path.splitext(path.split('/')[-1])[0]
    pattern = re.compile('^([0-9][0-9]*)\..*$')
    if pattern.match(title):
        title = title.split('.', 1)[1].strip()

    return artist + " - " + title


def get_own_song(id):
    # skip if file is listed in cache already
    if id in CACHE.keys():
        print(Fore.YELLOW + pretty_song(CACHE[id]))
        return False, None

    tmp_file, audio = musicmanager.download_song(id)
    with open("/tmp/" + tmp_file.encode('utf-8'), 'wb') as f:
        f.write(audio)

    e = eyed3.load("/tmp/" + tmp_file)

    if e.tag.album and e.tag.track_num != (None, None):
        filename = main_dir + "/" + e.tag.artist.replace('/', '-') + "/" + e.tag.album.replace('/', '-') + "/" + '{:02d}'.format(e.tag.track_num[0]) + ". " + e.tag.title.replace('/', '-') + ".mp3"
    else:
        filename = main_dir + "/" + e.tag.artist.replace('/', '-') + "/" + e.tag.title.replace('/', '-') + ".mp3"

    if not os.path.exists(os.path.dirname(filename)):
        os.makedirs(os.path.dirname(filename))

    shutil.move("/tmp/" + tmp_file, filename)

    print(Fore.GREEN + e.tag.artist + " - " + e.tag.title)
    return True, filename


def tag(filename, info):
    eyed3.log.setLevel("ERROR")
    f = eyed3.load(filename)
    if f.tag is None:
        f.tag = eyed3.id3.Tag()
        f.tag.file_info = eyed3.id3.FileInfo(filename)
    if 'artist' in info:
        f.tag.artist = info['artist']
    if 'albumArtist' in info and 'album_artist' in dir(f.tag):
        f.tag.album_artist = info['albumArtist']
    if 'album' in info:
        f.tag.album = info['album']
    if 'title' in info:
        f.tag.title = info['title']
    if 'trackNumber' in info:
        f.tag.track_num = info['trackNumber']
    if 'discNumber' in info:
        f.tag.disc_num = info['discNumber']
    if 'genre' in info:
        f.tag.genre = eyed3.id3.Genre(info['genre'])
    if 'albumArtRef' in info:
        albumArt = urllib2.urlopen(info['albumArtRef'][0]['url']).read()
        f.tag.images.set(3, albumArt, "image/jpeg")
    f.tag.save()


def get_all_access_song(id):
    # skip if file is listed in cache already
    if id in CACHE.keys():
        print(Fore.YELLOW + pretty_song(CACHE[id]))
        return False, None

    try:
        info = mobileclient.get_track_info(store_track_id=id)
    except exceptions.CallFailure:
        print(Fore.RED + "ERROR: " + id)
        return False, None

    if 'album' in info and 'trackNumber' in info:
        filename = main_dir + "/" + info['artist'].replace('/', '-') + "/" + info['album'].replace('/', '-') + "/" + '{:02d}'.format(info['trackNumber']) + ". " + info['title'].replace('/', '-') + ".mp3"
    else:
        filename = main_dir + "/" + info['artist'].replace('/', '-') + "/" + info['title'].replace('/', '-') + ".mp3"

    if not os.path.exists(os.path.dirname(filename)):
        os.makedirs(os.path.dirname(filename))

    with open(filename, 'wb') as f:
        try:
            url = mobileclient.get_stream_url(id, mobileId)
            f.write(urllib2.urlopen(url).read())
        except (exceptions.CallFailure, urllib2.HTTPError):
            print(Fore.RED + "ERROR: " + info['artist'] + " - " + info['title'])
            os.remove(filename)
            return False, None

    # the downloaded stream has no metadata yet
    # set tags of downloaded mp3 according to the information acquired
    tag(filename, info)

    print(Fore.GREEN + info['artist'] + " - " + info['title'])

    return True, filename


def get_song(id):
    global CACHE
    success = False
    filename = None
    if len(id) == 27:     # e.g. Tgf4od74e6kqp56sjxawis4e3yq
        success, filename = get_all_access_song(id)
    elif len(id) == 36:   # e.g. b7ea84c8-6d0b-3859-ae29-a514d16e0a1e
        success, filename = get_own_song(id)

    if success and filename:
        CACHE[id] = filename
        writeback_cache()


def remove_playlist(playlist_name):
    filename = pl_dir + "/" + playlist_name.replace('/', '-') + ".m3u"
    if os.path.isfile(filename):
        os.remove(filename)

    filename = pl_dir_mpd + "/" + playlist_name.replace('/', '-') + ".m3u"
    if os.path.isfile(filename):
        os.remove(filename)

    filename = pl_dir_mopidy + "/" + playlist_name.replace('/', '-') + ".m3u"
    if os.path.isfile(filename):
        os.remove(filename)


def init_mopidy_playlist(playlist_name):
    if not os.path.exists(pl_dir_mopidy):
        os.makedirs(pl_dir_mopidy)
    filename = pl_dir_mopidy + "/" + playlist_name.replace('/', '-') + ".m3u"
    with codecs.open(filename, 'w', 'utf-8') as f:
        f.write('#EXTM3U\n')


def append_playlist(trackId, playlist_name, playlist_type='absolute'):
    d = pl_dir
    if playlist_type == 'mpd':
        d = pl_dir_mpd
    elif playlist_type == 'mopidy':
        d = pl_dir_mopidy

    if not os.path.exists(d):
        os.makedirs(d)

    filename = d + "/" + playlist_name.replace('/', '-') + ".m3u"
    with codecs.open(filename, 'a', 'utf-8') as f:
        # append the path of the trackId to m3u
        if trackId in CACHE:
            if playlist_type == 'mopidy':
                uri = 'local:track:' + quote(CACHE[trackId].encode('utf-8').replace(main_dir + '/', ''))
                f.write("#EXTINF:-1," + pretty_song(CACHE[trackId]) + '\n')
                f.write(uri + '\n')
            elif playlist_type == 'mpd':
                f.write(CACHE[trackId].replace(main_dir + '/', 'gmusic/') + '\n')
            else:
                f.write(CACHE[trackId] + '\n')


def init_cache():
    cache = {}
    with codecs.open(CACHE_FILE, "r", 'utf-8') as c:
        for line in c:
            if line.strip() != "":
                cache[line.split('|||')[0]] = line.split('|||')[1].strip()
    return cache


def writeback_cache():
    with codecs.open('/tmp/new_cache', 'w', 'utf-8') as new_cache:
        for hash, path in CACHE.iteritems():
            new_cache.write(hash + "|||" + path + '\n')
    shutil.move("/tmp/new_cache", CACHE_FILE)


def check_cache():
    global CACHE

    # create list of mp3s
    mp3s = []
    for root, dirs, fs in os.walk(main_dir):
        for file in fs:
            if file.endswith(".mp3"):
                mp3s.append(os.path.join(root, file))

    # files that are empty and files that are not in cache but in filesystem
    for file in mp3s:
        if os.stat(file).st_size == 0:
            os.remove(file)
            print("blank mp3 -> removed: " + file)
        elif file.decode('utf-8') not in CACHE.values():
            print(Fore.RED + "not in cache: " + file)

    # remove cache-entries when not in filesystem
    CACHE = {id: path for id, path in CACHE.iteritems() if path.encode('utf-8') in mp3s}

    # TODO: Remove files from fs and cache which are not any more in any playlist


def get_thumbsup():
    remove_playlist('ThumbsUp')
    songs = mobileclient.get_thumbs_up_songs()
    init_mopidy_playlist('ThumbsUp')
    for i, s in enumerate(songs):
        print(str(i + 1).zfill(len(str(len(songs)))) + "/" + str(len(songs)) + " ", end='')
        get_song(s['storeId'])
        append_playlist(s['storeId'], 'ThumbsUp')
        append_playlist(s['storeId'], 'ThumbsUp', 'mpd')
        append_playlist(s['storeId'], 'ThumbsUp', 'mopidy')
    print('')


def opt_upload():
    musicmanager.login(OAUTH_FILE, uploader_id=uploader_id)
    for arg in sys.argv[1:]:
        if not os.path.isfile(arg):
            print("not found:    " + arg)
        else:
            uploaded, matched, not_uploaded = musicmanager.upload(arg, enable_matching=False)
            if uploaded:
                print("uploaded:     " + arg)
            if matched:
                print("matched:      " + arg)
            if not_uploaded:
                print("not uploaded: " + arg)


def opt_download():
    assert mobileclient.login(email, password)
    assert musicmanager.login(OAUTH_FILE)

    # reverse (as the most recently modified playlists appear at the end normally)
    all_playlists = mobileclient.get_all_user_playlist_contents()
    total_count = len(all_playlists)

    print(str(1).zfill(len(str(total_count))) + "/" + str(total_count + 1) + " " + Fore.MAGENTA + Style.BRIGHT + "ThumbsUp" + "\n")

    for i, p in enumerate(reversed(all_playlists)):

        if p['name'] == "001":
            continue

        last_modified = time.strftime('%a, %d.%m.%Y %H:%M', time.localtime(float(p['lastModifiedTimestamp'])/1000000))
        print(str(i + 2).zfill(len(str(total_count))) + "/" + str(total_count + 1) + " " + Fore.MAGENTA + Style.BRIGHT + p['name'], end='')
        print(" (" + last_modified + ")\n")

        remove_playlist(p['name'])

        # save the songs and build a m3u for each playlist
        all_tracks = p['tracks']
        init_mopidy_playlist(p['name'])
        for i, t in enumerate(all_tracks):
            print(str(i + 1).zfill(len(str(len(all_tracks)))) + "/" + str(len(all_tracks)) + " ", end='')
            get_song(t['trackId'])
            append_playlist(t['trackId'], p['name'])
            append_playlist(t['trackId'], p['name'], 'mpd')
            append_playlist(t['trackId'], p['name'], 'mopidy')
        print('')


def main():
    locale.setlocale(locale.LC_TIME, "de_DE.utf-8")

    # init colorama for terminal colors
    init(autoreset=True)

    global CACHE
    CACHE = init_cache()
    check_cache()

    if len(sys.argv) > 1:
        opt_upload()
    else:
        opt_download()


if __name__ == '__main__':
    main()
