#!/usr/bin/env python3

import sys
import re
import os
import glob
import pathlib
import shutil
from typing import Callable, List, Optional

C_BLUE = '\033[94m'
C_GREEN = '\033[92m'
C_YELLOW = '\033[93m'
C_RED = '\033[91m'
C_RESET = '\033[0m'


class Parser():

    def __init__(self, release_name: str) -> None:
        # clean release name
        self.release_name = release_name.replace(' ', '.').strip()

        print(f'{C_GREEN}{release_name}{C_RESET}')
        print(f'{C_GREEN}{"-" * len(release_name)}{C_RESET}')

        # try to extract all attributes, prompt for manual entry when empty
        self.title = self.ask_or_set(self.get_title, 'TITLE', r'\w+')
        self.year = self.ask_or_set(self.get_year, 'YEAR', r'\d\d\d\d')
        self.video_size = self.ask_or_set(self.get_video_size, 'VIDEO', r'\w+')
        self.source = self.ask_or_set(self.get_source, 'SOURCE', r'\w+')
        self.langs = self.ask_or_set(self.get_langs, 'LANGS', r'[A-Z,]+')

        # put prefixes to the back of the title
        title_prefixes = ['Der', 'Die', 'Das', 'Ein', 'Eine', 'The', 'A', 'An']
        for p in title_prefixes:
            if self.title.startswith(p + ' '):
                self.title = self.title[len(p + ' '):] + ', ' + p
                break

    def ask_or_set(self, get_func: Callable[[str], Optional[str]], key: str, rex=False) -> str:
        value = get_func(self.release_name)

        was_prompted = False
        while not value or (rex and not re.match(rex, value)):
            was_prompted = True
            value = input(f'{C_BLUE}{key}{C_YELLOW} ')
        if not was_prompted:
            print(f'{C_BLUE}{key}{C_RESET} {value}')

        return value

    def get_year(self, s: str) -> Optional[str]:
        # FIXME: reverse, to get the last match. better option?
        rex = r'\.([0-9][0-9](91|02))\.'
        m = re.search(rex, s[::-1])
        if m:
            return m.group(1)[::-1]
        return None

    def get_title(self, s: str) -> Optional[str]:
        rex = r'^(.*)\.(19|20)[0-9][0-9]'
        m = re.search(rex, s)
        if m:
            return m.group(1).replace('.', ' ')
        return None

    def get_video_size(self, s: str) -> Optional[str]:
        rex = r'\.(240(p|i)|360(p|i)|480(p|i)|720(p|i)|1080(p|i))\.'
        m = re.search(rex, s, flags=re.IGNORECASE)
        if m:
            return m.group(1)
        return None

    def get_source(self, s: str) -> Optional[str]:
        normalize = {
            r'\.bd-?rip\.': "BDRip",
            r'\.br-?rip\.': "BRRip",
            r'\.blu-?ray\.': "BluRay",
            r'\.dvd-?rip\.': "DVDRip",
            r'\.dvd\.': "DVD",
            r'\.hd-?rip\.': "HDRip",
            r'\.hd-?tv\.': "HDTV",
            r'\.web-?dl\.': "WEB-DL",
            r'\.web-?rip\.': "WEBRip",
        }
        for key, val in normalize.items():
            if re.search(key, s, flags=re.IGNORECASE):
                return val
        return None

    def get_langs(self, s: str, default="EN") -> str:
        normalize = {
            r'\.German\.DL\.': "EN,DE",
            r'\.German\.(DTS|AC3)(D|HD)?\.DL\.': "EN,DE",
            r'\.German\.': "DE",
        }
        for key, val in normalize.items():
            if re.search(key, s):
                return val
        else:
            return default


class MovieParser(Parser):
    pass


class TvParser(Parser):

    def __init__(self, release_name: str) -> None:
        super().__init__(release_name)
        self.season = self.ask_or_set(self.get_season, 'SEASON', r'S[0-9][0-9]')
        self.episode = self.ask_or_set(self.get_episode, 'EPISODE', r'E[0-9][0-9]')

    def get_title(self, s: str) -> Optional[str]:
        rex = r'^(.*)\.S[0-9][0-9]E[0-9][0-9]'
        m = re.search(rex, s)
        if m:
            return m.group(1).replace('.', ' ')
        return None

    def get_season(self, s: str) -> Optional[str]:
        rex = r'\.(S[0-9][0-9])(E[0-9][0-9]|\.)'
        m = re.search(rex, s)
        if m:
            return m.group(1)
        return None

    def get_episode(self, s: str) -> Optional[str]:
        rex = r'\.S[0-9][0-9](E[0-9][0-9])\.'
        m = re.search(rex, s)
        if m:
            return m.group(1)
        return None


class Mover():

    def __init__(self, source: str, dest: str, title: str, release_name: str) -> None:
        self.source = pathlib.Path(source)
        self.dest = pathlib.Path(dest)
        self.title = title
        self.release_name = release_name

    def move(self) -> None:
        print(f'{C_BLUE}DEST: {C_RESET}{self.dest}\n')
        self.remove_unneeded([
            "proof", "Proof", "*-proof.*", "*-Proof.*", "proof.???"
            "sample", "Sample", "*-sample.*", "*-Sample.*", "sample.???"
            "*.nzb", "*.url", "*.srr", "*.srs", "*.txt"
        ])
        self.move_video(["*.mkv", "*.mp4", "*.avi", "*.m4v"])
        self.move_subtitles(["*.srt", "*.sub", "*.idx"])
        self.move_nfo(["*.nfo"])
        self.remove_empty_folders()

    def _get_glob(self, globs: List[str]) -> List[str]:
        result = []
        for g in globs:
            result.extend(glob.glob(str(self.source / '**' / g), recursive=True))
        return result

    def remove_empty_folders(self) -> None:
        directories = [e[0] for e in os.walk(self.source)]
        for d in reversed(directories):
            if not os.listdir(d):
                os.rmdir(d)

    def remove_unneeded(self, mask: List[str]) -> None:
        files = self._get_glob(mask)
        for f in files:
            print(f'{C_RED}{f}{C_RESET} deleted.')
            if pathlib.Path(f).is_dir():
                shutil.rmtree(f)
            else:
                os.unlink(f)

    def move_nfo(self, mask: List[str]) -> None:
        files = self._get_glob(mask)

        dest = self.dest / str('#' + self.release_name)
        if files:
            source = pathlib.Path(files[0])
            self.do_move(source, dest)
        else:
            dest.touch()

    def move_subtitles(self, mask: List[str]) -> None:
        pass
        # files = self._get_glob(mask)
        # TODO: check that there is only one subtitle of every format
        # 1x srt -> ok
        # 1x idx + 1x sub -> ok
        # 2x srt -> not ok

    def move_video(self, mask: List[str]) -> None:
        files = self._get_glob(mask)
        if len(files) == 1:
            source = pathlib.Path(files[0])
            dest = self.dest / str(self.title + source.suffix)
            self.do_move(source, dest)
        elif len(files) > 1:
            print("ERROR: more than one video file found: {}".format(files))
            sys.exit(1)
        else:
            print("ERROR: no video file found")
            sys.exit(1)

    def do_move(self, source: pathlib.Path, dest: pathlib.Path) -> None:
        dest.parent.mkdir(parents=True, exist_ok=True)

        print(f'{source.name} --> {C_YELLOW}{dest.name}{C_RESET}')

        if dest.exists():
            print(f'ERROR: {C_RED}{dest}{C_RESET} already exists.')
        else:
            shutil.move(source, dest)


CONFIG = {
    'categories': {
        'tv': {
            'parser_class': TvParser,
            'dest': '/media/data/videos/tv/{title} ({year})/{season} [{langs}] [{video_size} {source}]',
            'title': '{season}.{episode}'
        },
        'documentary_tv': {
            'parser_class': TvParser,
            'dest': '/media/data/videos/documentaries_tv/{title} ({year})/{season} [{langs}] [{video_size} {source}]',
            'title': '{season}.{episode}'
        },
        'movie': {
            'parser_class': MovieParser,
            'dest': '/media/data/videos/movies/{first_letter}/{title} ({year}) [{langs}] [{video_size} {source}]',
            'title': '{title}'
        },
        'documentary': {
            'parser_class': MovieParser,
            'dest': '/media/data/videos/documentaries/{title} ({year}) [{langs}] [{video_size} {source}]',
            'title': '{title}'
        }
    }
}


def main():
    if len(sys.argv) < 2:
        print('usage: mover.py [category] [dir1] [dir2] [dir3] [...]')
        sys.exit(1)

    CATEGORY = sys.argv[1]
    DIRS = sys.argv[2:]

    if CATEGORY not in CONFIG['categories'].keys():
        print('ERROR: first arg has to be one of: {}'.format(', '.join(CONFIG['categories'].keys())))
        sys.exit(1)
    if not DIRS:
        print('ERROR: no directories given.')
        sys.exit(1)

    for d in DIRS:
        if not os.path.isdir(d):
            print(f"Error with argument '{d}': Can only handle directories.")
            sys.exit(1)

    config = CONFIG['categories'].get(CATEGORY)
    for source_dir in DIRS:
        print()

        # parse, set additional keys
        parsed = config['parser_class'](release_name=os.path.basename(source_dir))
        additional_keys = {
            'first_letter': '0' if parsed.title[0] in '0123456789' else parsed.title[0].upper(),
            # 'xxx': "abc"
        }

        # move
        dest_dir = config['dest'].format(**vars(parsed), **additional_keys)
        title = config['title'].format(**vars(parsed), **additional_keys)
        m = Mover(source_dir, dest_dir, title, parsed.release_name)
        m.move()


if __name__ == "__main__":
    main()
