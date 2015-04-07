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
from colorama import init, Fore, Style
from ConfigParser import SafeConfigParser
from requests.packages import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

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

CACHE = None

mobileclient = Mobileclient(debug_logging=False)
musicmanager = Musicmanager(debug_logging=False)


def pretty_song(path):
    path = path.replace(main_dir + "/mp3/", '')
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
        filename = main_dir + "/mp3/" + e.tag.artist.replace('/', '-') + "/" + e.tag.album.replace('/', '-') + "/" + '{:02d}'.format(e.tag.track_num[0]) + ". " + e.tag.title.replace('/', '-') + ".mp3"
    else:
        filename = main_dir + "/mp3/" + e.tag.artist.replace('/', '-') + "/" + e.tag.title.replace('/', '-') + ".mp3"

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

    info = mobileclient.get_track_info(store_track_id=id)
    if 'album' in info and 'trackNumber' in info:
        filename = main_dir + "/mp3/" + info['artist'].replace('/', '-') + "/" + info['album'].replace('/', '-') + "/" + '{:02d}'.format(info['trackNumber']) + ". " + info['title'].replace('/', '-') + ".mp3"
    else:
        filename = main_dir + "/mp3/" + info['artist'].replace('/', '-') + "/" + info['title'].replace('/', '-') + ".mp3"

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
    filename = main_dir + "/playlist/" + playlist_name.replace('/', '-') + ".m3u"
    if os.path.isfile(filename):
        os.remove(filename)


def build_playlist(trackId, playlist_name):
    filename = main_dir + "/playlist/" + playlist_name.replace('/', '-') + ".m3u"
    with codecs.open(filename, 'a', 'utf-8') as f:
        # append the path of the trackId to m3u
        if trackId in CACHE:
            f.write(CACHE[trackId] + '\n')


def init_cache():
    cache = {}
    with codecs.open(CACHE_FILE, "r", 'utf-8') as c:
        for line in c:
            if line.strip() != "":
                cache[line.split('|')[0]] = line.split('|')[1].strip()
    return cache


def writeback_cache():
    with codecs.open('/tmp/new_cache', 'w', 'utf-8') as new_cache:
        for hash, path in CACHE.iteritems():
            new_cache.write(hash + "|" + path + '\n')
    shutil.move("/tmp/new_cache", CACHE_FILE)


def whatisthis(s):
    if isinstance(s, str):
        print("ordinary string")
    elif isinstance(s, unicode):
        print("unicode string")
    else:
        print("not a string")


def check_cache():
    global CACHE

    # create list of mp3s
    mp3s = []
    for root, dirs, fs in os.walk(main_dir + "/mp3"):
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
    for i, s in enumerate(songs):
        print("    " + str(i + 1).zfill(len(str(len(songs)))) + "/" + str(len(songs)) + " ", end='')
        get_song(s['storeId'])
        build_playlist(s['storeId'], 'ThumbsUp')
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
    mobileclient.login(email, password)
    musicmanager.login(OAUTH_FILE)

    # reverse (as the most recently modified playlists appear at the end normally)
    all_playlists = mobileclient.get_all_user_playlist_contents()
    total_count = len(all_playlists)

    print(str(1).zfill(len(str(total_count))) + "/" + str(total_count + 1) + ": " + Fore.MAGENTA + Style.BRIGHT + "ThumbsUp" + "\n")
    get_thumbsup()

    for i, p in enumerate(reversed(all_playlists)):
        print(str(i + 2).zfill(len(str(total_count))) + "/" + str(total_count + 1) + ": " + Fore.MAGENTA + Style.BRIGHT + p['name'] + "\n")

        remove_playlist(p['name'])

        # save the songs and build a m3u for each playlist
        all_tracks = p['tracks']
        for i, t in enumerate(all_tracks):
            print("    " + str(i + 1).zfill(len(str(len(all_tracks)))) + "/" + str(len(all_tracks)) + " ", end='')
            get_song(t['trackId'])
            build_playlist(t['trackId'], p['name'])
        print('')


def main():
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
