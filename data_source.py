from threading import Timer
from time import sleep
from PyQt5.QtCore import pyqtProperty, QObject
from PyQt5.QtCore import pyqtSignal


class DataSource(QObject):
    update = pyqtSignal()

    changed = pyqtSignal()

    def __init__(self, parent=None):
        super().__init__(parent)

        self._temperature = 15

        self.update.connect(self.on_update)

        self.on_timer()

    def on_timer(self):
        self.on_update()

        self.timer = Timer(10, self.on_timer)
        self.timer.start()

    def on_update(self):
        print("Timer ticking ...", self.temperature)

        self.temperature = self.temperature + 1

        sleep(3)
        print("Timer ticked", self.temperature)

        self.changed.emit()

    @pyqtProperty(int, notify=changed)
    def temperature(self):
        return self._temperature

    @temperature.setter
    def temperature(self, temperature):
        self._temperature = temperature
