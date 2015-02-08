#!/usr/bin/env python3

import sys
from datetime import datetime, timedelta
import locale

locale.setlocale(locale.LC_ALL, 'de_DE.UTF-8')

class DateTotal(object):

    def __init__(self, date, times=None):
        self.date = date
        self.times = times

    def __str__(self):
        total = timedelta()
        for u in self.times:
            total += u
        return self.date.strftime('%a, %d. %b %Y') + " | " + DateTotal.strfdelta(total)

    def strfdelta(delta):
        h, rem = divmod(delta.seconds, 3600)
        m, _ = divmod(rem, 60)
        return str(h).rjust(2) + ":" + str(m).zfill(2)

class Line(object):

    def __init__(self, line=None):
        if line:
            self.date = datetime.strptime(line.split(' ')[0], '%Y-%m-%d')
            self.time = datetime.strptime(line.split(' ')[1], '%H:%M')
            self.load1 = float(line.split(' ')[2])
            self.load5 = float(line.split(' ')[3])
            self.load15 = float(line.split(' ')[4])
            u = line.split(' ')[5]
            uhour = int(u.split(':')[0])
            umin = int(u.split(':')[1])
            self.uptime = timedelta(hours=uhour, minutes=umin)
            self.temp = float(line.split(' ')[6])
        else:
            self.date = datetime(1900, 1, 1)
            self.time = datetime(1900, 1, 1)
            self.uptime = timedelta()

    def __str__(self):
        return datetime.strftime(self.date, '%Y-%m-%d') + ' ' + datetime.strftime(self.time, '%H:%M') + ' ' + str(self.load1) + ' ' + str(self.load5) + ' ' + str(self.load15) + ' ' + str(self.uptime) + ' ' + str(self.temp)

def belongs_to_last_day(datetime_time, timedelta_time):
    date_after = datetime_time - timedelta_time
    return date_after.day != datetime_time.day

def main():
    relevant_lines = []

    with open(sys.argv[1], 'r') as f:
        last_line = None

        for line in f.readlines():
            l = Line(line)
            if last_line and l.uptime < last_line.uptime:
                if last_line:
                    if belongs_to_last_day(last_line.time, last_line.uptime):
                        last_line.date = last_line.date - timedelta(days=1)
                        relevant_lines.append(last_line)
                    else:
                        relevant_lines.append(last_line)
            last_line = l

        # always append total last line
        if belongs_to_last_day(last_line.time, last_line.uptime):
            last_line.date = last_line.date - timedelta(days=1)
            relevant_lines.append(last_line)
        else:
            relevant_lines.append(last_line)

    d = {}
    for l in relevant_lines:
        if not d.get(l.date):
            d[l.date] = [ l.uptime ]
        else:
            d[l.date].append(l.uptime)

    for key, val in sorted(d.items()):
        print(DateTotal(key, val))

if __name__ == '__main__':
    main()
