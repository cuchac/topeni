import datetime
from threading import Timer
from PyQt5.QtCore import pyqtProperty, QObject, pyqtSignal, pyqtSlot, QDateTime
from PyQt5.QtCore import QVariant
from database import Database
from io_thread import IOThread


class DataSource(QObject):
    temperatures_changed = pyqtSignal()
    variables_changed = pyqtSignal()
    bits_changed = pyqtSignal()
    measured = pyqtSignal()

    def __init__(self, parent=None):
        super().__init__(parent)

        # Values
        self._temperatures = [10, 20, 30, 40, 50, 60, 70]
        self._bits = [False, False, False, False, False, False, False, False, False, False]
        self._variables = [10, 20]

        # Ticking
        self.running = True
        self.timer = None
        self.io = IOThread(datasource=self)
        self.database = Database(datasource=self)

        # Start thread
        self.io.start()
        self.io.add(self.io.connect)
        self.io.add(self.io.connect_power)
        self.on_timer()

    def on_timer(self):
        #print("Timer ticking ...")
        self.io.add(self.io.read_temperatures)
        self.io.add(self.io.read_bits)
        self.io.add(self.io.measured)

        if self.running:
            self.timer = Timer(10, self.on_timer)
            self.timer.start()


    @pyqtSlot()
    def stop(self):
        self.running = False
        self.timer.cancel()
        self.io.stop()

    @pyqtSlot(int, bool)
    def set_bit(self, index, value):
        self.io.add(self.io.write_bit, index=index, value=value)
        self._bits[index] = value
        self.bits_changed.emit()

    @pyqtSlot(int, bool)
    def set_variable(self, index, value):
        self.io.add(self.io.write_variable, index=index, value=value)
        self._variables[index] = value
        self.variables_changed.emit()

    @pyqtProperty(QVariant, notify=temperatures_changed)
    def temperatures(self):
        return self._temperatures

    @temperatures.setter
    def temperatures(self, temperatures):
        self._temperatures = temperatures

    @pyqtProperty(QVariant, notify=variables_changed)
    def variables(self):
        return self._variables

    @variables.setter
    def variables(self, variables):
        self._variables = variables

    @pyqtProperty(QVariant, notify=bits_changed)
    def bits(self):
        return self._bits

    @bits.setter
    def bits(self, bits):
        self._bits = bits

    @pyqtSlot(result=QVariant)
    def get_temperatures_history(self):
        return self.database.get_temperatures()

    @pyqtSlot(QDateTime, result=QVariant)
    def get_date_history(self, date):
        history = self.database.get_history(date)

        duration = datetime.timedelta()
        power = 0

        if len(history) > 0:
            last = history[0]
            first = history[-1]
            
            if len(last) > 6 and len(first) > 6:
                power = first[6] - last[6]

            for sample in history:
                if sample[4] > 10 and last[4] > 10:
                    duration += datetime.datetime.strptime(sample[-1], '%Y-%m-%d %H:%M:%S') - datetime.datetime.strptime(last[-1], '%Y-%m-%d %H:%M:%S')
                last = sample

        stats = {
            'duration': str(duration),
            'power': power,
        }

        return [history, stats]
