#!/usr/bin/env python3

from urllib.request import urlopen
import urllib
import datetime
import csv
from prettytable import PrettyTable
import time
import os
import sys
import colorama

###############################################################################

CONFIG_FAVORITES = ['pizza', 'döner', 'gulasch', 'gyros', 'kabeljau']
CONFIG_IGNORE = ['suppe', 'nachspeise']
CONFIG_MONOCHROME = False

ERR = []

###############################################################################

class Dates(object):

    FORMAT = "%d.%m.%Y"

    WEEKDAYS = {
        'Mo': 0,
        'Di': 1,
        'Mi': 2,
        'Do': 3,
        'Fr': 4,
        'Sa': 5,
        'So': 6,
    }

    RELATIVE = {
        'Vorgestern':-2,
        'Gestern':-1,
        'Heute': 0,
        'Morgen': 1,
        'Übermorgen': 2,
    }

    @staticmethod
    def next_workday_delta(days_delta):
        next_date = datetime.date.today() + datetime.timedelta(days=days_delta)
        if next_date.weekday() == 5:
            return days_delta + 2
        elif next_date.weekday() == 6:
            return days_delta + 1
        else:
            return days_delta

    @staticmethod
    def pretty_date(date):
        today = datetime.date.today()

        inv_relative = {Dates.RELATIVE[k] : k for k in Dates.RELATIVE}
        result = inv_relative.get((date - today).days)

        inv_weekdays = {Dates.WEEKDAYS[k] : k for k in Dates.WEEKDAYS}

        if result is not None:
            result += ', ' + inv_weekdays.get(date.weekday())
        else:
            result = inv_weekdays.get(date.weekday())

        return Color.BOLD + result + ', ' + date.strftime(Dates.FORMAT) + Color.RESET

    @staticmethod
    def find_next_weekday(weekday):
        today = datetime.date.today()

        if (today.weekday() <= weekday):
            delta = weekday - today.weekday()
        else:
            delta = 7 - today.weekday() + weekday
        return (today + datetime.timedelta(days=delta))

    @staticmethod
    def str_to_date(inp):
        today = datetime.date.today()

        # -1, 0, 1, +3, ...
        try:
            return today + datetime.timedelta(days=int(inp))
        except ValueError:
            pass

        # 31.12., ... -> 31.12.2014
        if inp.endswith('.'):
            inp += today.strftime("%Y")

        # 31.12.2014, ...
        try:
            conv_date = time.strptime(inp, Dates.FORMAT)
            return datetime.date.fromtimestamp(time.mktime(conv_date))
        except ValueError:
            pass

        # 31.12.14, ...
        try:
            conv_date = time.strptime(inp, Dates.FORMAT)
            return datetime.date.fromtimestamp(time.mktime(conv_date))
        except ValueError:
            pass

        # heute, morgen, ...
        try:
            return today + datetime.timedelta(days=Dates.RELATIVE[inp.capitalize()])
        except KeyError:
            pass

        # donnerstag, freitag, ...
        try:
            return Dates.find_next_weekday(Dates.WEEKDAYS[inp.capitalize()[0:2]])
        except KeyError:
            pass

        ERR.append(inp + ' ist kein gültiges Datum.')

###############################################################################

class Table(object):

    BLANK = ['', '', '']
    FAV_SYMBOL = '♥'
    CURRENCY = '€'

    def __init__(self):
        self.table = PrettyTable(['group', 'name', 'price'])
        self.table.align = 'l'
        self.table.border = False
        self.table.header = False
        self.list = []

    def __str__(self):
        # remove duplicates and sort
        dates = sorted(list(set(self.list)))

        has_rows = False
        if dates:
            for counter, date in enumerate(dates):
                self.table.add_row([Dates.pretty_date(date), '', ''])
                self.table.add_row(Table.BLANK)
                was_successful = Table.add_to_table(self, date)
                has_rows = was_successful or has_rows
                if counter != len(dates):
                    self.table.add_row(Table.BLANK)

        if has_rows:
            return '\n' + self.table.get_string()
        else:
            return ''

    @staticmethod
    def parse_group(group):
        if group.startswith("HG"):
            return "Hauptgericht"
        elif group.startswith("B"):
            return "Beilage"
        elif group.startswith("N"):
            return "Nachspeise"
        else:
            return group

    @staticmethod
    def parse_row(row):
        group = Table.parse_group(row[2])
        name = row[3]

        is_fav = False
        for fav in CONFIG_FAVORITES:
            if fav.lower() in name.lower():
                is_fav = True
                name = Table.FAV_SYMBOL + ' ' + name

        is_ignored = False
        for ignore in CONFIG_IGNORE:
            if ignore.lower() in name.lower() or ignore.lower() in group.lower():
                is_ignored = True

        if is_fav:
            color = Color.FAVORITE
        elif is_ignored:
            color = Color.IGNORED
        else:
            color = Color.GROUP_COLORS.get(group)

        group = color + group
        price = row[6] + ' ' + Table.CURRENCY + Color.RESET

        return ([group, name, price])

    def add_to_table(self, date):
        cache = Model.cache_csv(date.year, date.isocalendar()[1]-1)
        if cache == None:
            ERR.append('Der Speiseplan vom ' + date.strftime(Dates.FORMAT) + ' konnte nicht abgerufen werden.')
            return False

        with open(cache, 'r', encoding='utf-8') as csvfile:
            reader = csv.reader(csvfile, delimiter=';', quotechar='|')
            next(reader)
            for row in reader:
                if row[0] == date.strftime(Dates.FORMAT):
                    self.table.add_row(Table.parse_row(row))
            return True

    def add(self, date_input):
        date = Dates.str_to_date(date_input)
        if date != None:
            if date.weekday() == 5:
                ERR.append('Der ' + date.strftime(Dates.FORMAT) + ' ist ein Samstag.')
            elif date.weekday() == 6:
                ERR.append('Der ' + date.strftime(Dates.FORMAT) + ' ist ein Sonntag.')
            else:
                self.list.append(date)

    def add_defaults(self):
        # default: add next two days
        self.add(Dates.next_workday_delta(0))
        self.add(Dates.next_workday_delta(1))

###############################################################################

class Model(object):

    url = 'http://www.stwno.de/infomax/daten-extern/csv/UNI-P'

    @staticmethod
    def cache_csv(year, week_number):
        cache_dir = os.path.dirname(os.path.realpath(__file__)) + os.sep + 'cache'
        os.makedirs(cache_dir, exist_ok=True)
        cachefile = cache_dir + os.sep + str(year) + '-' + str(week_number) + '.csv'

        if os.path.isfile(cachefile):
            return cachefile

        try:
            h = urlopen(Model.url + '/' + str(week_number) + '.csv')
        except (urllib.error.HTTPError, urllib.error.URLError):
            return None

        if h.status == 200:
            f = open(cachefile, "w", encoding='utf-8')
            content = h.read().decode('latin1')
            f.write(content)
            return f.name
        else:
            print("HTTP ERROR " + str(h.status))

###############################################################################

class Color(object):

    BOLD = colorama.Style.BRIGHT
    DIM = colorama.Style.DIM
    RESET = colorama.Fore.RESET + colorama.Style.RESET_ALL

    MAGENTA = colorama.Fore.MAGENTA
    CYAN = colorama.Fore.CYAN
    BLUE = colorama.Fore.BLUE
    GREEN = colorama.Fore.GREEN
    YELLOW = colorama.Fore.YELLOW
    RED = colorama.Fore.RED
    WHITE = colorama.Fore.WHITE
    BLACK = colorama.Fore.BLACK

    BOLD_MAGENTA = BOLD + MAGENTA
    BOLD_CYAN = BOLD + CYAN
    BOLD_BLUE = BOLD + BLUE
    BOLD_GREEN = BOLD + GREEN
    BOLD_YELLOW = BOLD + YELLOW
    BOLD_RED = BOLD + RED
    BOLD_WHITE = BOLD + WHITE
    BOLD_BLACK = BOLD + BLACK

    GROUP_COLORS = {
        "Hauptgericht": BOLD_YELLOW,
        "Beilage": BOLD_CYAN,
        "Suppe": BOLD_BLUE,
        "Nachspeise": BOLD_GREEN,
    }

    FAVORITE = BOLD_RED
    IGNORED = BOLD_BLACK

###############################################################################

def print_help():

    print(Color.BOLD + 'Benutzung:' + Color.RESET + ' mensa.py [Datum] [Datum] [Datum] ...')
    print()
    print(Color.BOLD + '[Datum]            := [Wochentag] oder [relativer Tag] oder [in/vor x Tagen]' + Color.RESET)
    print()
    print(Color.BOLD + 'nächster Wochentag' + Color.RESET + ' := Montag, Mo, Dienstag, Di, ...')
    print(Color.BOLD + 'relativer Tag' + Color.RESET + '      := heute, morgen, übermorgen, gestern, ...')
    print(Color.BOLD + 'in/vor x Tagen' + Color.RESET + '     := ..., -2, -1, 0, 1, 2, ...')
    print()
    print('Standard: Anzeige des Speiseplans von ' + Color.BOLD + 'heute und morgen' + Color.RESET)

def main():

    colorama.init(autoreset=False, strip=CONFIG_MONOCHROME)
    table = Table()

    if len(sys.argv) < 2:
        table.add_defaults()
    elif sys.argv[1] == '-h' or sys.argv[1] == '--help':
        print_help()
    else:
        for arg in sys.argv[1:]:
            table.add(arg)

    print(table)

    if ERR:
        print()
        for e in ERR:
            print(Color.BOLD_RED + 'Fehler: ' + Color.RESET + e)


if __name__ == '__main__':
    main()
