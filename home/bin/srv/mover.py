#!/usr/bin/env python3

import sys
import re
import os
import glob
import pathlib
import shutil
from typing import Callable, List, Optional

import argparse

C_BLUE = '\033[94m'
C_GREEN = '\033[92m'
C_YELLOW = '\033[93m'
C_RED = '\033[91m'
C_RESET = '\033[0m'


class Parser():

    def __init__(self, release_name: str, preset: dict, interactive=True) -> None:
        # clean release name
        self.release_name = release_name.replace(' ', '.').strip()

        # FIXME: hide for tests
        print(f'{C_GREEN}{release_name}{C_RESET}')
        print(f'{C_GREEN}{"-" * len(release_name)}{C_RESET}')

        # set all values from preset (usually command line arguments
        for key, value in preset.items():
            if value:
                setattr(self, key, value)

        # try to extract all attributes, prompt for manual entry when empty
        self.title = self.ask_or_set(self.get_title, 'TITLE', r'\w+', interactive=interactive)
        if not hasattr(self, 'year'):
            self.year = self.ask_or_set(self.get_year, 'YEAR', r'\d\d\d\d', interactive=interactive)
        else:
            # TODO: implement for all other possible presets
            print(f'{C_BLUE}YEAR{C_RESET} {self.year}')
        self.video_size = self.ask_or_set(self.get_video_size, 'VIDEO', r'\w+', interactive=interactive)
        self.source = self.ask_or_set(self.get_source, 'SOURCE', r'\w+', interactive=interactive)
        self.langs = self.ask_or_set(self.get_langs, 'LANGS', r'[A-Z,]+', interactive=interactive)

        # put prefixes to the back of the title
        title_prefixes = ['Der', 'Die', 'Das', 'Ein', 'Eine', 'The', 'A', 'An']
        for p in title_prefixes:
            if self.title.startswith(p + ' '):
                self.title = self.title[len(p + ' '):] + ', ' + p
                break

    def ask_or_set(self, get_func: Callable[[str], Optional[str]], key: str, rex=False, interactive=True) -> str:
        value = get_func(self.release_name)

        was_prompted = False
        if not interactive:
            if value:
                return value
            else:
                return "FIXME"

        while not value or (rex and not re.match(rex, value)):
            was_prompted = True
            value = input(f'{C_BLUE}{key}{C_YELLOW} ')
        if not was_prompted:
            # FIXME: hide for tests
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
            return m.group(1).lower()
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
            if re.search(key, s, flags=re.IGNORECASE):
                return val
        else:
            return default


class MovieParser(Parser):
    pass


class TvParser(Parser):

    def __init__(self, release_name: str, preset: dict, interactive=True) -> None:
        super().__init__(release_name, preset, interactive)
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

    def __init__(self, run: bool, source: str, dest: str, title: str, release_name: str) -> None:
        self.run = run
        self.source = pathlib.Path(source)
        self.dest = pathlib.Path(dest)
        self.title = title
        self.release_name = release_name

    def move(self) -> None:
        print(f'{C_BLUE}DEST: {C_RESET}{self.dest}\n')
        self.remove_unneeded([
            "proof", "Proof", "*-proof.*", "*-Proof.*", "proof.???", "*.proof.???"
            "sample", "Sample", "*-sample.*", "*-Sample.*", "sample.???",
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
                if self.run:
                    os.rmdir(d)
                else:
                    print("DRY RUN remove_empty_folders")

    def remove_unneeded(self, mask: List[str]) -> None:
        files = self._get_glob(mask)
        for f in files:
            print(f'{C_RED}{f}{C_RESET} deleted.')
            if self.run:
                if pathlib.Path(f).is_dir():
                    shutil.rmtree(f)
                else:
                    os.unlink(f)
            else:
                print("DRY RUN remove_unneeded")

    def move_nfo(self, mask: List[str]) -> None:
        files = self._get_glob(mask)

        dest = self.dest / str('#' + self.release_name)
        if files:
            source = pathlib.Path(files[0])
            self.do_move(source, dest)
        else:
            if self.run:
                dest.touch()
            else:
                print("DRY RUN move_nfo")

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
            if self.run:
                shutil.move(source, dest)
            else:
                print("DRY RUN do_move")


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
    available_categories = ', '.join(CONFIG['categories'].keys())

    parser = argparse.ArgumentParser(description='Moves and sorts video files.')
    parser.add_argument('category', type=str, help=available_categories)
    parser.add_argument('dirs', type=str, nargs=argparse.ONE_OR_MORE)
    parser.add_argument('--year', type=int)
    parser.add_argument('--run', default=False, action='store_true')

    args = parser.parse_args()
    preset = {
        'year': args.year
    }

    if args.category not in CONFIG['categories'].keys():
        print('ERROR: first arg has to be one of: {}'.format(available_categories))
        sys.exit(1)

    for d in args.dirs:
        if not os.path.isdir(d):
            print(f"Error with argument '{d}': Can only handle directories.")
            sys.exit(1)

    config = CONFIG['categories'].get(args.category)
    for source_dir in args.dirs:
        print()

        # parse, set additional keys
        parsed = config['parser_class'](release_name=os.path.basename(source_dir), preset=preset)
        additional_keys = {
            'first_letter': '0' if parsed.title[0] in '0123456789' else parsed.title[0].upper(),
            # 'xxx': "abc"
        }

        # move
        dest_dir = config['dest'].format(**vars(parsed), **additional_keys)
        title = config['title'].format(**vars(parsed), **additional_keys)
        m = Mover(run=args.run, source=source_dir, dest=dest_dir, title=title, release_name=parsed.release_name)
        m.move()


if __name__ == "__main__":
    main()
