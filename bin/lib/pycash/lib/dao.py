from datetime import datetime
from collections import OrderedDict

from lib.database import Database
from lib.unit import Unit

class DAO(object):

    @staticmethod
    def get_units(reverse=False):
        c = Database.get_connection()
        result = c.execute("SELECT * FROM units")
        units = []
        c.commit()
        for r in result.fetchall():
            date = datetime.strptime(r[4], "%Y-%m-%d %H:%M:%S")
            category = DAO.get_category_title(r[2])
            u = Unit(id=r[0], title=r[1], category=category, amount=r[3], date=date)
            units.append(u)
        c.close()
        return sorted(units, key=Unit.sort_key, reverse=reverse)

    @staticmethod
    def delete_unit(unit_id):
        """returns False if the unit was not found"""
        c = Database.get_connection()
        x = c.execute("DELETE FROM units WHERE id=?", (unit_id,))
        c.commit()
        c.close()
        return x.rowcount

    @staticmethod
    def create_unit(u):
        c = Database.get_connection()
        category_id = DAO.create_category(u.category)
        c.execute("INSERT INTO units(title, category_id, amount, date) VALUES (?, ?, ?, ?);",
            (u.title, category_id, u.amount, u.date.strftime("%Y-%m-%d %H:%M:%S")))
        c.commit()
        c.close()

    @staticmethod
    def create_category(title):
        """returns the id"""
        c = Database.get_connection()
        c.execute("INSERT OR IGNORE INTO categories(title) VALUES (?);", (title,))
        cat_id = c.execute("SELECT last_insert_rowid()").fetchone()[0]
        if cat_id is 0:   # category already existed, thus counter has not incremented
            cat_id = c.execute("SELECT id FROM categories WHERE title = ?", (title,)).fetchone()[0]
        c.commit()
        c.close()
        return cat_id

    @staticmethod
    def get_category_title(category_id):
        c = Database.get_connection()
        title = c.execute("SELECT title FROM categories WHERE id=?", (category_id,)).fetchone()[0]
        c.commit()
        c.close()
        return title

    @staticmethod
    def rename_category(old_title, new_title):
        c = Database.get_connection()
        c.execute("UPDATE categories SET title=? WHERE title=?", (new_title, old_title))
        c.commit()
        c.close()

    @staticmethod
    def get_unit_ids():
        c = Database.get_connection()
        result = []
        for r in c.execute("SELECT id FROM units").fetchall():
            result.append(r[0])
        c.commit()
        c.close()
        return result

    @staticmethod
    def get_totals_by_month():
        c = Database.get_connection()
        result = {}
        for r in c.execute("SELECT * FROM totals_by_month").fetchall():
            result[r[0]] = round(r[1], 2)
        c.commit()
        c.close()
        return result

#    @staticmethod
#    def get_totals_by_category():
#        c = Database.get_connection()
#        result = {}
#        for r in c.execute("SELECT * FROM totals_by_category").fetchall():
#            result[r[1]] = round(r[0], 2)
#        c.commit()
#        c.close()
#        return result

    @staticmethod
    def get_totals_date_groups():
        c = Database.get_connection()
        result = OrderedDict()
        ex = c.execute('''SELECT * FROM totals_date_groups''')
        for r in ex.fetchall():
            existing = result.get(r[0])
            if existing is None:
                result[r[0]] = [(r[1], r[2])]
            else:
                existing.append((r[1], r[2]))
        c.commit()
        c.close()
        return result
