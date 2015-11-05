from threading import Timer
from PyQt5.QtCore import pyqtProperty, QObject, pyqtSignal, pyqtSlot, QDateTime
from PyQt5.QtCore import QVariant
from database import Database
from io_thread import IOThread


class DataSource(QObject):
    temperatures_changed = pyqtSignal()
    bits_changed = pyqtSignal()
    measured = pyqtSignal()

    def __init__(self, parent=None):
        super().__init__(parent)

        # Values
        self._temperatures = [10, 20, 30, 40, 50]
        self._bits = [False, False, False, False, False, False, False, False]

        # Ticking
        self.running = True
        self.timer = None
        self.io = IOThread(datasource=self)
        self.database = Database(datasource=self)

        # Start thread
        self.io.start()
        self.io.add(self.io.connect)
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

    @pyqtProperty(QVariant, notify=temperatures_changed)
    def temperatures(self):
        return self._temperatures

    @temperatures.setter
    def temperatures(self, temperatures):
        self._temperatures = temperatures

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
        return self.database.get_history(date)
