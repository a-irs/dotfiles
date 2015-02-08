#!/usr/bin/env python3

import os

from lib.database import Database
from lib.view import cmd

if __name__ == '__main__':
    if not os.path.isfile(Database.DB_FILE):
        Database.init_database()
    cmd.init()
