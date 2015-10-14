from queue import Queue
from threading import Timer, Thread
from PyQt5.QtCore import pyqtProperty, QObject, pyqtSignal, pyqtSlot
from PyQt5.QtCore import QVariant
from directnet import KSClient
from traceback import print_exc


class IOThread(Thread):
    queue = Queue()

    TEMPERATURES = (
        'V2162',
        'V2166',
        'V2172',
    )

    BITS = (
        'C30',
        'C31',
        'C32',
    )

    def __init__(self, datasource=None, **kwargs):
        """

        :type datasource: DataSource
        """
        super().__init__(**kwargs)
        self.datasource = datasource
        self.directnet = KSClient('rfc2217://10.0.0.6:12345')
        self.stopped = False

    def run(self):
        while not self.stopped:
            function, kwargs = self.queue.get()
            try:
                function(**kwargs)
            except Exception:
                print_exc()

            self.queue.task_done()

    def stop(self):
        self.queue.join()
        self.stopped = True
        self.join()

    def read_temperatures(self):
        print("Reading temperatures")

        for index, address in enumerate(self.TEMPERATURES):
            self.datasource.temperatures[index] = self.directnet.read_int(address)

        print("Read temperatures", self.datasource.temperatures)

        self.datasource.temperatures_changed.emit()

    def read_bits(self):
        print("Reading bits")

        for index, address in enumerate(self.BITS):
            self.datasource.bits[index] = self.directnet.read_bit(address)

        print("Read bits", self.datasource.bits)

        self.datasource.bits_changed.emit()

    def write_bit(self, index, value):
        print("Writing bit", index, value)

        self.directnet.write_bit(self.BITS[index], value)


class DataSource(QObject):
    temperatures_changed = pyqtSignal()
    bits_changed = pyqtSignal()

    def __init__(self, parent=None):
        super().__init__(parent)

        # Values
        self._temperatures = [0, 0, 0, 0, 0]
        self._bits = [False, False, False, False]

        # Ticking
        self.running = True
        self.timer = None
        self.io = IOThread(datasource=self)

        # Start thread
        self.io.start()
        self.on_timer()

    def on_timer(self):
        print("Timer ticking ...")
        self.io.queue.put([self.io.read_temperatures, {}])
        self.io.queue.put([self.io.read_bits, {}])

        if self.running:
            self.timer = Timer(2, self.on_timer)
            self.timer.start()

    @pyqtSlot()
    def stop(self):
        self.running = False
        self.io.stop()

    @pyqtSlot(int, bool)
    def set_bit(self, index, value):
        self.io.queue.put([self.io.write_bit, {'index': index, 'value': value}])
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
