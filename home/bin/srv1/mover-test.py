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
            'expect': {'title': 'Aguirre der Zorn Gottes', 'year': '1972', 'video_size': '1080p', 'source': 'BluRay', 'langs': 'EN,DE'}
        },
        '2001.Odyssee.Im.Weltraum.1968.German.Dl.AC3.1080P.BluRay.x264-movieaddicts': {
            'preset': {},
            'expect': {'title': '2001 Odyssee Im Weltraum', 'year': '1968', 'video_size': '1080p', 'source': 'BluRay', 'langs': 'EN,DE'}
        },
        'Schindlers.Liste.-.20th.Anniversary.Edition.1993.German.DTS.DL.1080p.BluRay.x264-HDS': {
            'preset': {},
            'expect': {'title': 'Schindlers Liste - 20th Anniversary Edition', 'year': '1993', 'video_size': '1080p', 'source': 'BluRay', 'langs': 'EN,DE'}
        }
    }

    TV = {
        'The.Office.S05E12.720p.HDTV.x265.Farda.DL': {
            'preset': {'year': '2005'},
            'expect': {'title': 'Office, The', 'video_size': '720p', 'year': '2005', 'source': 'HDTV', 'langs': "EN", 'season': 'S05', 'episode': 'E12'}
        },
        'Anthony.Bourdain.Parts.Unknown.S04E06.Iran.720p.NF.WEB-DL.DDP2.0.X264-SOIL': {
            'preset': {'year': '2013'},
            'expect': {'title': 'Anthony Bourdain Parts Unknown', 'video_size': '720p', 'year': '2013', 'source': 'WEB-DL', 'langs': "EN", 'season': 'S04', 'episode': 'E06'}
        },
        'Futurama.S05E01.Crimes.of.the.Hot.720p.HULU.WEB-DL.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S05E01.Crimes.of.the.Hot.720p.HULU.WEB-DL.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'WEB-DL', 'langs': 'EN', 'season': 'S05', 'episode': 'E01'},
        },
        'Futurama.S05E02.Jurassic.Bark.720p.HULU.WEB-DL.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S05E02.Jurassic.Bark.720p.HULU.WEB-DL.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'WEB-DL', 'langs': 'EN', 'season': 'S05', 'episode': 'E02'},
        },
        'Futurama.S05E03.The.Route.of.All.Evil.720p.HULU.WEB-DL.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S05E03.The.Route.of.All.Evil.720p.HULU.WEB-DL.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'WEB-DL', 'langs': 'EN', 'season': 'S05', 'episode': 'E03'},
        },
        'Futurama.S05E04.A.Taste.of.Freedom.720p.HULU.WEB-DL.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S05E04.A.Taste.of.Freedom.720p.HULU.WEB-DL.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'WEB-DL', 'langs': 'EN', 'season': 'S05', 'episode': 'E04'},
        },
        'Futurama.S05E05.Kif.Gets.Knocked.up.a.Notch.720p.HULU.WEB-DL.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S05E05.Kif.Gets.Knocked.up.a.Notch.720p.HULU.WEB-DL.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'WEB-DL', 'langs': 'EN', 'season': 'S05', 'episode': 'E05'},
        },
        'Futurama.S05E06.Less.Than.Hero.720p.HULU.WEB-DL.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S05E06.Less.Than.Hero.720p.HULU.WEB-DL.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'WEB-DL', 'langs': 'EN', 'season': 'S05', 'episode': 'E06'},
        },
        'Futurama.S05E07.Teenage.Mutant.Leelas.Hurdles.720p.HULU.WEB-DL.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S05E07.Teenage.Mutant.Leelas.Hurdles.720p.HULU.WEB-DL.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'WEB-DL', 'langs': 'EN', 'season': 'S05', 'episode': 'E07'},
        },
        'Futurama.S05E08.The.Why.of.Fry.720p.HULU.WEB-DL.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S05E08.The.Why.of.Fry.720p.HULU.WEB-DL.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'WEB-DL', 'langs': 'EN', 'season': 'S05', 'episode': 'E08'},
        },
        'Futurama.S05E09.The.Sting.720p.HULU.WEB-DL.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S05E09.The.Sting.720p.HULU.WEB-DL.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'WEB-DL', 'langs': 'EN', 'season': 'S05', 'episode': 'E09'},
        },
        'Futurama.S05E10.The.Farnsworth.Parabox.720p.HULU.WEB-DL.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S05E10.The.Farnsworth.Parabox.720p.HULU.WEB-DL.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'WEB-DL', 'langs': 'EN', 'season': 'S05', 'episode': 'E10'},
        },
        'Futurama.S05E11.Three.Hundred.Big.Boys.720p.HULU.WEB-DL.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S05E11.Three.Hundred.Big.Boys.720p.HULU.WEB-DL.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'WEB-DL', 'langs': 'EN', 'season': 'S05', 'episode': 'E11'},
        },
        'Futurama.S05E12.Spanish.Fry.720p.HULU.WEB-DL.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S05E12.Spanish.Fry.720p.HULU.WEB-DL.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'WEB-DL', 'langs': 'EN', 'season': 'S05', 'episode': 'E12'},
        },
        'Futurama.S05E13.Bend.Her.720p.HULU.WEB-DL.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S05E13.Bend.Her.720p.HULU.WEB-DL.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'WEB-DL', 'langs': 'EN', 'season': 'S05', 'episode': 'E13'},
        },
        'Futurama.S05E14.Obsoletely.Fabulous.720p.HULU.WEB-DL.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S05E14.Obsoletely.Fabulous.720p.HULU.WEB-DL.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'WEB-DL', 'langs': 'EN', 'season': 'S05', 'episode': 'E14'},
        },
        'Futurama.S05E15.Bender.Should.Not.Be.Allowed.On.Television.720p.HULU.WEB-DL.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S05E15.Bender.Should.Not.Be.Allowed.On.Television.720p.HULU.WEB-DL.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'WEB-DL', 'langs': 'EN', 'season': 'S05', 'episode': 'E15'},
        },
        'Futurama.S05E16.The.Devils.Hands.Are.Idle.Playthings.720p.HULU.WEB-DL.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S05E16.The.Devils.Hands.Are.Idle.Playthings.720p.HULU.WEB-DL.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'WEB-DL', 'langs': 'EN', 'season': 'S05', 'episode': 'E16'},
        },
        'Futurama.S06E01.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E01.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E01'},
        },
        'Futurama.S06E02.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E02.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E02'},
        },
        'Futurama.S06E03.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E03.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E03'},
        },
        'Futurama.S06E04.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E04.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E04'},
        },
        'Futurama.S06E05.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E05.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E05'},
        },
        'Futurama.S06E06.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E06.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E06'},
        },
        'Futurama.S06E07.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E07.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E07'},
        },
        'Futurama.S06E08.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E08.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E08'},
        },
        'Futurama.S06E09.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E09.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E09'},
        },
        'Futurama.S06E10.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E10.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E10'},
        },
        'Futurama.S06E11.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E11.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E11'},
        },
        'Futurama.S06E12.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E12.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E12'},
        },
        'Futurama.S06E13.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E13.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E13'},
        },
        'Futurama.S06E14.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E14.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E14'},
        },
        'Futurama.S06E15.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E15.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E15'},
        },
        'Futurama.S06E16.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E16.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E16'},
        },
        'Futurama.S06E17.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E17.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E17'},
        },
        'Futurama.S06E18.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E18.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E18'},
        },
        'Futurama.S06E19.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E19.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E19'},
        },
        'Futurama.S06E20.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E20.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E20'},
        },
        'Futurama.S06E21.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E21.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E21'},
        },
        'Futurama.S06E22.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E22.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E22'},
        },
        'Futurama.S06E23.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E23.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E23'},
        },
        'Futurama.S06E24.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E24.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E24'},
        },
        'Futurama.S06E25.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E25.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E25'},
        },
        'Futurama.S06E26.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S06E26.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S06', 'episode': 'E26'},
        },
        'Futurama.S07E01.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E01.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E01'},
        },
        'Futurama.S07E02.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E02.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E02'},
        },
        'Futurama.S07E03.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E03.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E03'},
        },
        'Futurama.S07E04.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E04.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E04'},
        },
        'Futurama.S07E05.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E05.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E05'},
        },
        'Futurama.S07E06.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E06.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E06'},
        },
        'Futurama.S07E07.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E07.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E07'},
        },
        'Futurama.S07E08.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E08.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E08'},
        },
        'Futurama.S07E09.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E09.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E09'},
        },
        'Futurama.S07E10.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E10.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E10'},
        },
        'Futurama.S07E11.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E11.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E11'},
        },
        'Futurama.S07E12.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E12.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E12'},
        },
        'Futurama.S07E13.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E13.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E13'},
        },
        'Futurama.S07E14.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E14.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E14'},
        },
        'Futurama.S07E15.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E15.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E15'},
        },
        'Futurama.S07E16.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E16.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E16'},
        },
        'Futurama.S07E17.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E17.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E17'},
        },
        'Futurama.S07E18.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E18.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E18'},
        },
        'Futurama.S07E19.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E19.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E19'},
        },
        'Futurama.S07E20.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E20.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E20'},
        },
        'Futurama.S07E21.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E21.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E21'},
        },
        'Futurama.S07E22.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E22.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E22'},
        },
        'Futurama.S07E23.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E23.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E23'},
        },
        'Futurama.S07E24.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E24.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E24'},
        },
        'Futurama.S07E25.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E25.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E25'},
        },
        'Futurama.S07E26.720p.BluRay.x265-HETeam': {
            'preset': {'year': 1999},
            'expect': {'release_name': 'Futurama.S07E26.720p.BluRay.x265-HETeam', 'year': 1999, 'title': 'Futurama', 'video_size': '720p', 'source': 'BluRay', 'langs': 'EN', 'season': 'S07', 'episode': 'E26'},
        },


    }

    def test_movies(self):
        for release_name, v in self.MOVIES.items():
            parser = mover.MovieParser(release_name, preset=v['preset'])
            self.assertEqual(parser.title, v['expect']['title'])
            self.assertEqual(parser.year, v['expect']['year'])
            self.assertEqual(parser.video_size, v['expect']['video_size'])
            self.assertEqual(parser.source, v['expect']['source'])
            self.assertEqual(parser.langs, v['expect']['langs'])

    def test_tv(self):
        for release_name, v in self.TV.items():
            parser = mover.TvParser(release_name, preset=v['preset'])
            self.assertEqual(parser.title, v['expect']['title'])
            self.assertEqual(parser.video_size, v['expect']['video_size'])
            self.assertEqual(parser.source, v['expect']['source'])
            self.assertEqual(parser.langs, v['expect']['langs'])
            self.assertEqual(parser.episode, v['expect']['episode'])
            self.assertEqual(parser.season, v['expect']['season'])
            self.assertEqual(parser.year, v['expect']['year'])


if __name__ == '__main__':
    unittest.main(verbosity=2)
