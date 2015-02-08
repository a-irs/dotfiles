class Unit(object):
    def __init__(self, title, category, amount, date, id=0):
        self.title = title
        self.category = category
        self.amount = amount
        self.date  = date
        self.id = id
    def __str__(self):
        return str(self.id) + ', ' + self.title + ', ' + self.category + ', ' + str(self.amount) + ', ' + self.date.strftime("%Y-%m-%d %H:%M:%S")
    def sort_key(self):
        return self.date
