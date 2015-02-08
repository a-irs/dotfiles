import curses

class View:

    results = None

    def __init__(self, results):
        self.results = results

    def show(self):
        stdscr = curses.initscr()
        curses.noecho()
        curses.cbreak()
        stdscr.keypad(1)
        stdscr.refresh()

        curses.start_color()
        curses.init_pair(1, curses.COLOR_WHITE, curses.COLOR_BLACK)
        curses.init_pair(2, curses.COLOR_YELLOW, curses.COLOR_BLACK)

        stdscr.bkgd(curses.color_pair(1))
        stdscr.refresh()

        win = curses.newwin(5, 20, 5, 5)
        win.bkgd(curses.color_pair(2))
        win.box()

        for index, item in enumerate(self.results):
            ctx = item.context.strip()[0:200]
            s = item.filename + ":" + item.line_number + ":" + ctx
            stdscr.addstr(index, 0, s)

        win.refresh()

        c = stdscr.getch()

        curses.nocbreak()
        stdscr.keypad(0)
        curses.echo()
        curses.endwin()
