import json
import sqlite3
import datetime

class Database(object):
    datasource = None

    def __init__(self, datasource):
        super().__init__()
        self.datasource = datasource
        self.datasource.measured.connect(self.on_measured)
        self.last_store = None

        self.db = sqlite3.connect('database.sqlite', isolation_level=None)
        self.upgrade()

    def upgrade(self):
        try:
            version = int(self.get_settings('db_version')[0])
        except sqlite3.OperationalError:
            version = 0

        if version < 1:
            self.db.execute('CREATE TABLE settings ('
                            '`name` VARCHAR(50) NOT NULL UNIQUE, '
                            '`value` VARCHAR(100) NULL'
                            ')')

            self.db.execute('CREATE TABLE temperatures ('
                            '`date` DATETIME NOT NULL PRIMARY KEY,'
                            '`value` TEXT NOT NULL'
                            ')')

            version = 1

        self.set_settings('db_version', version)

    def set_temperatures(self, temperatures):
        try:
            self.db.execute('INSERT INTO temperatures VALUES (datetime("now"), ?)', (json.dumps(temperatures), ))
        except sqlite3.IntegrityError as e:
            print(e)

    def set_settings(self, name, value):
        self.db.execute('REPLACE INTO settings VALUES (?, ?)', (name, value))

    def get_settings(self, name):
        return self.db.execute('SELECT value FROM settings WHERE name=?', (name,)).fetchone()

    def on_measured(self):
        print('measured - check')
        now = datetime.datetime.now()
        if self.last_store is not None and (now - self.last_store).seconds < 120:
            return
        
        self.last_store = now
        print('measured - store in database')
        
        self.set_temperatures(self.datasource.temperatures)

    def get_temperatures(self):
        history = self.db.execute('SELECT value FROM temperatures ORDER BY date DESC LIMIT 300')
        return list(reversed(list(json.loads(row[0]) for row in history)))

    def get_history(self, date):
        date_formated = date.toString('yyyy-MM-dd') + ' 00:00:00'

        history = self.db.execute('SELECT date, value '
                                  'FROM temperatures '
                                  'WHERE (date BETWEEN ? AND DATETIME(?, "+1 day"))'
                                  'ORDER BY date', (date_formated, date_formated))
        history = list(json.loads(row[1]) + [row[0]] for row in history)

        return history
