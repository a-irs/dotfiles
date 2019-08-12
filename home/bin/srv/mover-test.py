#!/usr/bin/env python

import io
import sys
import unittest

import mover

# disable stdout
text_trap = io.StringIO()
sys.stdout = text_trap

class TestParser(unittest.TestCase):

    MOVIES = {
        'Aguirre.der.Zorn.Gottes.1972.German.DTS.DL.1080p.BluRay.x264-Pate': {
            'preset': {},
            'expect': {
                'title': 'Aguirre der Zorn Gottes',
                'year': '1972',
                'video_size': '1080p',
                'source': 'BluRay',
                'langs': 'EN,DE'
            }
        },
        '2001.Odyssee.Im.Weltraum.1968.German.Dl.AC3.1080P.BluRay.x264-movieaddicts': {
            'preset': {},
            'expect': {
                'title': '2001 Odyssee Im Weltraum',
                'year': '1968',
                'video_size': '1080p',
                'source': 'BluRay',
                'langs': 'EN,DE'
            }
        },
        'Schindlers.Liste.-.20th.Anniversary.Edition.1993.German.DTS.DL.1080p.BluRay.x264-HDS': {
            'preset': {},
            'expect': {
                'title': 'Schindlers Liste - 20th Anniversary Edition',
                'year': '1993',
                'video_size': '1080p',
                'source': 'BluRay',
                'langs': 'EN,DE'
            }
        }
    }

    TV = {
        'The.Office.S05E12.720p.HDTV.x265.Farda.DL': {
            'preset': {
                'year': '2005',
            },
            'expect': {
                'title': 'Office, The',
                'video_size': '720p',
                'year': '2005',
                'source': 'HDTV',
                'langs': "EN",
                'season': 'S05',
                'episode': 'E12'
            }
        },
        'Anthony.Bourdain.Parts.Unknown.S04E06.Iran.720p.NF.WEB-DL.DDP2.0.X264-SOIL': {
            'preset': {
                'year': '2013',
            },
            'expect': {
                'title': 'Anthony Bourdain Parts Unknown',
                'video_size': '720p',
                'year': '2013',
                'source': 'WEB-DL',
                'langs': "EN",
                'season': 'S04',
                'episode': 'E06'
            }
        }
    }

    def test_movies(self):
        for release_name, v in self.MOVIES.items():
            parser = mover.MovieParser(release_name, preset=v['preset'], interactive=False)
            self.assertEqual(parser.title, v['expect']['title'])
            self.assertEqual(parser.year, v['expect']['year'])
            self.assertEqual(parser.video_size, v['expect']['video_size'])
            self.assertEqual(parser.source, v['expect']['source'])
            self.assertEqual(parser.langs, v['expect']['langs'])

    def test_tv(self):
        for release_name, v in self.TV.items():
            parser = mover.TvParser(release_name, preset=v['preset'], interactive=False)
            self.assertEqual(parser.title, v['expect']['title'])
            self.assertEqual(parser.video_size, v['expect']['video_size'])
            self.assertEqual(parser.source, v['expect']['source'])
            self.assertEqual(parser.langs, v['expect']['langs'])
            self.assertEqual(parser.episode, v['expect']['episode'])
            self.assertEqual(parser.season, v['expect']['season'])
            self.assertEqual(parser.year, v['expect']['year'])


if __name__ == '__main__':
    unittest.main(verbosity=2)
