import sqlite3
import os
import sys

class Database(object):

    DB_FILE = os.path.expanduser("~") + os.sep + '.config' + os.sep + 'pycash' + os.sep + 'data.db'

    @staticmethod
    def get_connection():
        return sqlite3.connect(Database.DB_FILE)

    @staticmethod
    def init_database():
        c = Database.get_connection()
        c.execute('''CREATE TABLE units (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT COLLATE NOCASE,
            category_id INTEGER,
            amount REAL NOT NULL,
            date DATE NOT NULL,
            FOREIGN KEY (category_id) REFERENCES categories(id)
            )''')
        c.execute('''CREATE TABLE categories (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT UNIQUE NOT NULL COLLATE NOCASE
            )''')
        c.execute('''CREATE VIEW totals_by_month AS
            SELECT strftime('%Y-%m', date) AS month, sum(amount) from units GROUP BY month ORDER BY month;''')
        c.execute('''CREATE VIEW totals_by_category AS
            SELECT sum(units.amount), categories.title from units, categories WHERE units.category_id = categories.id GROUP BY categories.title ORDER BY categories.title;''')
        c.execute('''CREATE VIEW totals_date_groups AS SELECT strftime('%Y-%m', units.date) AS month, categories.title, sum(units.amount) from units, categories WHERE units.category_id = categories.id GROUP BY categories.title, month ORDER BY month, categories.title;''')
        #c.execute('''CREATE TRIGGER delete_categories AFTER DELETE
        #    ON units
        #    BEGIN
        #        DELETE FROM categories WHERE id NOT IN (SELECT id FROM units);
        #    END;''')
        c.commit()
        c.close()
