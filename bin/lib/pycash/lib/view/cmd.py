import cmd
import locale
import os
from datetime import datetime

from lib.unit import Unit
from lib.dao import DAO
from prettytable import PrettyTable

class Color(object):
    p = '\033['

    RESET   = p +  str(0) + 'm'
    BOLD    = p +  str(1) + 'm'
    DIM     = p +  str(2) + 'm'

    MAGENTA = p + str(35) + 'm'
    CYAN    = p + str(36) + 'm'
    BLUE    = p + str(34) + 'm'
    GREEN   = p + str(32) + 'm'
    YELLOW  = p + str(33) + 'm'
    RED     = p + str(31) + 'm'
    WHITE   = p + str(37) + 'm'
    BLACK   = p + str(30) + 'm'

    NONE    = ""

    BOLD_MAGENTA = BOLD + MAGENTA
    BOLD_CYAN    = BOLD + CYAN
    BOLD_BLUE    = BOLD + BLUE
    BOLD_GREEN   = BOLD + GREEN
    BOLD_YELLOW  = BOLD + YELLOW
    BOLD_RED     = BOLD + RED
    BOLD_WHITE   = BOLD + WHITE
    BOLD_BLACK   = BOLD + BLACK

class UnitTable(object):

    FORMAT = "%d.%m.%Y"

    RELATIVE = {
        -2: 'Vorgestern',
        -1: 'Gestern',
         0: 'Heute',
         1: 'Morgen',
         2: 'Übermorgen'
    }

    WEEKDAYS = {
        0: 'Montag',
        1: 'Dienstag',
        2: 'Mittwoch',
        3: 'Donnerstag',
        4: 'Freitag',
        5: 'Samstag',
        6: 'Sonntag'
    }

    def __init__(self):
        locale.setlocale(locale.LC_ALL, 'de_DE')
        self.table = PrettyTable(['id', 'title', 'amount', 'category', 'date'])
        self.table.align = 'l'
        self.table.align['amount'] = 'r'
        self.table.border = False
        self.table.header = False
        self.table.padding_width = 1

    def __str__(self):
        return self.table.get_string()

    def add(self, unit):
        self.table.add_row([UnitTable.parse_id(unit.id), UnitTable.parse_title(unit.title), UnitTable.parse_amount(unit.amount), UnitTable.parse_category(unit.category), UnitTable.parse_date(unit.date)])

    def add_header(self, title):
        self.table.add_row([Color.BOLD_BLUE + title + Color.RESET, '', '', '', ''])

    def add_blank(self):
        self.table.add_row(['', '', '', '', ''])

    @staticmethod
    def parse_amount(amount):
        if amount < 0:
            return Color.BOLD_RED + locale.currency(amount) + Color.RESET
        else:
            return Color.BOLD_GREEN + '+' + locale.currency(amount) + Color.RESET

    @staticmethod
    def parse_id(id):
        return Color.BOLD_BLACK + '[' + str(id) + ']' + Color.RESET

    @staticmethod
    def parse_title(title):
        return Color.BOLD + title + Color.RESET

    @staticmethod
    def parse_category(category):
        return category

    @staticmethod
    def parse_date(date):
        today = datetime.today()

        result = UnitTable.RELATIVE.get((UnitTable.strip_time(date) - UnitTable.strip_time(today)).days)

        if result is None:
            result = UnitTable.WEEKDAYS.get(date.weekday()) + ', ' + date.strftime(UnitTable.FORMAT)

        return Color.BOLD + result + Color.RESET

    @staticmethod
    def strip_time(date):
        return datetime(date.year, date.month, date.day, 0, 0)



class TotalsTable():

    MONTHS = {
        1: 'Januar',
        2: 'Februar',
        3: 'März',
        4: 'April',
        5: 'Mai',
        6: 'Juni',
        7: 'Juli',
        8: 'August',
        9: 'September',
       10: 'Oktober',
       11: 'November',
       12: 'Dezember',
    }

    def __init__(self):
        locale.setlocale(locale.LC_ALL, 'de_DE')
        self.table = PrettyTable(['title', 'amount', 'x'])
        self.table.align = 'l'
        self.table.align['amount'] = 'r'
        self.table.border = False
        self.table.header = False
        self.table.padding_width = 1

    def __str__(self):
        return self.table.get_string()

    def add(self, title, amount):
        self.table.add_row([TotalsTable.parse_title(title), UnitTable.parse_amount(amount), ''])

    def add_right(self, title, amount):
        self.table.add_row(['', UnitTable.parse_amount(amount), TotalsTable.parse_title(title)])

    def add_blank(self):
        self.table.add_row(["", "", ""])

    @staticmethod
    def parse_title(title):
        try:
            s = title.split('-')
            return Color.BOLD_BLUE + TotalsTable.MONTHS[int(s[1])] + ' ' + s[0] + Color.RESET
        except IndexError:
            return title


class View(cmd.Cmd):
    intro = 'Welcome to PyCash.'
    prompt = '\n' + Color.BOLD + '$$$ ' + Color.RESET

    def do_list(self, arg):
        """Lists all units"""
        os.system('cls' if os.name=='nt' else 'clear')
        t = UnitTable()
        for m in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]:
            has_header = False
            for u in DAO.get_units():
                if u.date.month == m:
                    if not has_header:
                        t.add_blank()
                        t.add_header(TotalsTable.MONTHS[u.date.month] + ' ' + str(u.date.year))
                        t.add_blank()
                        has_header = True
                    t.add(u)
        if len(t.__str__()) > 0:
            print(t)

    def do_ls(self, arg):
        self.do_list(arg)

    def do_l(self, arg):
        self.do_list(arg)

    def do_sum(self, arg):
        os.system('cls' if os.name=='nt' else 'clear')
        t = TotalsTable()
        d = DAO.get_totals_by_month()
        d3 = DAO.get_totals_date_groups()
        for m in d:
            t.add_blank()
            t.add(m, d.get(m))
            for x in d3.get(m):
                t.add_right(x[0], x[1])
        print(t)

    def do_s(self, arg):
        self.do_sum(arg)

    def do_add(self, arg):
        os.system('cls' if os.name=='nt' else 'clear')
        """Adds a unit"""
        u = parse_add(arg)
        if u is not None:
            DAO.create_unit(u)
            self.do_list(arg)

    def do_a(self, arg):
        self.do_add(arg)

    def do_delete(self, arg):
        os.system('cls' if os.name=='nt' else 'clear')
        """Deletes the unit with the given ID"""
        for i in parse_del(arg):
            success = DAO.delete_unit(i)
            if success:
                print("deleted unit with ID " + str(i))
            else:
                print("*** unit with ID " + str(i) + " not found ***")

    def do_del(self, arg):
        self.do_delete(arg)

    def do_d(self, arg):
        self.do_delete(arg)

    def complete_delete(self, text, line, start_index, end_index):
        l = list(map(str, DAO.get_unit_ids()))
        return [i for i in l if i.startswith(text)]

    def complete_del(self, text, line, start_index, end_index):
        return self.complete_delete(text, line, start_index, end_index)

    def complete_d(self, text, line, start_index, end_index):
        return self.complete_delete(text, line, start_index, end_index)

    def do_exit(self, arg):
        """Exit the program"""
        print("Ciao")
        return True

    def do_EOF(self, arg):
        """CTRL+D"""
        return self.do_exit(arg)

    def emptyline(self):
        """disable repetition of the last command when entering a blank line"""
        pass

def parse_del(arg):
    try:
        return tuple(map(int, arg.split()))
    except ValueError:
        print("*** " + arg + " is not an integer ***")
        return []

def parse_add(arg):
    a = arg.split()

    if len(a) < 2:
        print("*** invalid command usage ***")
    else:
        amount = 0
        try:
            if not a[1].startswith("-") and not a[1].startswith("+"):
                a[1] = "-" + a[1]
            amount = float(a[1].replace(",", "."))
        except ValueError:
            print("*** " + a[1] + " is not a number ***")
            return

        if amount != -0.0:
            print(amount)
            title = a[0]
            date = datetime.today()
            category = "Sonstiges"
            if len(a) > 3:
                date = a[3]
            if len(a) > 2:
                category = a[2]
            return Unit(title=title, category=category, amount=amount, date=date)
        else:
            print("*** amount has to be bigger than 0 ***")
            return None

def init():
    try:
        View().cmdloop()
    except KeyboardInterrupt:
        print("Ciao")
