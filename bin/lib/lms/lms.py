#!/usr/bin/env python

import time
from prettytable import PrettyTable
from pylms.server import Server

def parse_type(s):
    if s.startswith("spotify"):
        return "Spotify"
    elif s.startswith("file"):
        return "Local"
    elif s.startswith("yt"):
        return "YouTube"
    else:
        return s

def init_table():
    table = PrettyTable(['#', 'title', 'artist', 'album', 'time'])
    table.align = 'l'
    table.align['#'] = 'r'
    table.align['time'] = 'r'
    table.border = True
    table.header = True
    table.padding_width = 1
#     table.add_row(['','','','',''])
    return table

def main():
    sc = Server(hostname="srv.home", port=9090)
    sc.connect()

    print("server version: %s" % sc.get_version())
    players = sc.get_players()
    if len(players) > 0:
        player = players[0].get_ref()
        print("player:  %s\n" % player)
    sq = sc.get_player(player)

    table = init_table()

    playlist = sq.playlist_get_info()
    for item in playlist:

        t = time.strftime('%M:%S', time.gmtime(item['duration']))
        is_playing = False
        if item['title'] == sq.get_track_title() and item['artist'] == sq.get_track_artist():
            is_playing = True
        table.add_row([('\033[1;32m▶\033[0m ' if is_playing else '') + str(item['position'] + 1),
                       item['title'], item['artist'], item['album'], str(t)])

    print(table)

if __name__ == '__main__':
    main()
