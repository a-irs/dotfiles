#!/usr/bin/env python

import mover

import unittest

class TestParser(unittest.TestCase):

    MOVIES = {
        'Aguirre.der.Zorn.Gottes.1972.German.DTS.DL.1080p.BluRay.x264-Pate': {
            'title': 'Aguirre der Zorn Gottes',
            'year': '1972',
            'video_size': '1080p',
            'source': 'BluRay',
            'langs': 'EN,DE'
        },
        '2001.Odyssee.Im.Weltraum.1968.German.Dl.AC3.1080P.BluRay.x264-movieaddicts': {
            'title': '2001 Odyssee Im Weltraum',
            'year': '1968',
            'video_size': '1080p',
            'source': 'BluRay',
            'langs': 'EN,DE'
        },
        'Schindlers.Liste.-.20th.Anniversary.Edition.1993.German.DTS.DL.1080p.BluRay.x264-HDS': {
            'title': 'Schindlers Liste - 20th Anniversary Edition',
            'year': '1993',
            'video_size': '1080p',
            'source': 'BluRay',
            'langs': 'EN,DE'
        }
    }

    TV = {
        'The.Office.S05E12.720p.HDTV.x265.Farda.DL': {
            'title': 'Office, The',
            'video_size': '720p',
            # TODO
            # 'year': '2005',
            'source': 'HDTV',
            'langs': "EN",
            'season': 'S05',
            'episode': 'E12'
        }
    }

    def test_movies(self):
        for release_name, v in self.MOVIES.items():
            parser = mover.MovieParser(release_name, interactive=False)
            self.assertEqual(parser.title, v['title'])
            self.assertEqual(parser.year, v['year'])
            self.assertEqual(parser.video_size, v['video_size'])
            self.assertEqual(parser.source, v['source'])
            self.assertEqual(parser.langs, v['langs'])

    def test_tv(self):
        for release_name, v in self.TV.items():
            parser = mover.TvParser(release_name, interactive=False)
            self.assertEqual(parser.title, v['title'])
            self.assertEqual(parser.video_size, v['video_size'])
            self.assertEqual(parser.source, v['source'])
            self.assertEqual(parser.langs, v['langs'])
            self.assertEqual(parser.episode, v['episode'])
            self.assertEqual(parser.season, v['season'])


if __name__ == '__main__':
    unittest.main()
