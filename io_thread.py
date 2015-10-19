from directnet import KSClient
from traceback import print_exc
from queue import Queue
from threading import Thread


class IOThread(Thread):
    queue = Queue()

    TEMPERATURES = (
        'V2162',  # za TC
        'V2166',  # do topeni
        'V2172',  # v akumulacce
        'V2156',  # venku
        'V2216',  # tlak vody
    )

    BITS = (
        'C30',  # TC
        'C31',  # Podlahy
        'C32',  # Topeni

        'C24',  # do podlah
        'C26',  # do akumulacky
        'C25',  # z akumulacky
    )

    def __init__(self, datasource=None, **kwargs):
        """

        :type datasource: DataSource
        """
        super().__init__(**kwargs)
        self.datasource = datasource
        self.stopped = False
        self.stopping = False
        self.directnet = None

    def run(self):
        while not self.stopped or not self.queue.empty():
            function, kwargs = self.queue.get()
            try:
                function(**kwargs)
            except Exception:
                print_exc()

            self.queue.task_done()

    def connect(self):
        self.directnet = KSClient('rfc2217://10.0.0.6:12345')

    def make_stop(self):
        self.stopped = True

    def stop(self):
        self.queue.put([self.make_stop, {}])
        self.queue.join()
        self.stopping = True
        self.join()

    def add(self, method, **kwargs):
        if not self.stopping:
            self.queue.put([method, kwargs])

    def read_temperatures(self):
        #print("Reading temperatures")

        temperatures = self.datasource.temperatures

        if self.directnet:
            for index, address in enumerate(self.TEMPERATURES):
                temperatures[index] = self.directnet.read_int(address)

        #print("Read temperatures", self.datasource.temperatures)
        self.datasource.temperatures = temperatures
        self.datasource.temperatures_changed.emit()

    def read_bits(self):
        #print("Reading bits")

        bits = self.datasource.bits

        for index, address in enumerate(self.BITS):
            bits[index] = self.directnet.read_bit(address)

        #print("Read bits", self.datasource.bits)
        self.datasource.bits = bits
        self.datasource.bits_changed.emit()

    def measured(self):
        self.datasource.measured.emit()

    def write_bit(self, index, value):
        #print("Writing bit", index, value)

        self.directnet.write_bit(self.BITS[index], value)
