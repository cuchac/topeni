from directnet import KSClient
from traceback import print_exc
from queue import Queue
from threading import Thread
from power_link import PowerLink


class IOThread(Thread):
    queue = Queue()

    TEMPERATURES = (
        'V2162',  # za TC
        'V2166',  # do topeni
        'V2172',  # v akumulacce
        'V2156',  # venku
        'V2216',  # tlak vody
    )

    VARIABLES = (
        'V1773',  # pozadovana teplota
        'V1776',  # maximalni teplota
    )

    BITS = (
        'C30',  # TC
        'C31',  # Podlahy
        'C32',  # Topeni

        'C24',  # do podlah
        'C26',  # do akumulacky
        'C25',  # z akumulacky

        'C40',  # plna automatika
        'C41',  # automatika topi do nadrze
        'S14',  # temperovani
        'C15',  # HDO
        'C33',  # Nautila
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
        self.powerlink = None

    def run(self):
        while not self.stopped:
            function, kwargs = self.queue.get()
            try:
                function(**kwargs)
            except Exception:
                print_exc()

            self.queue.task_done()

    def connect(self):
        self.directnet = KSClient('/dev/topeni_plc')

    def connect_power(self):
        self.powerlink = PowerLink()

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
        variables = self.datasource.variables

        if self.directnet:
            for index, address in enumerate(self.TEMPERATURES):
                temperatures[index] = self.directnet.read_int(address)

            for index, address in enumerate(self.VARIABLES):
                variables[index] = self.directnet.read_int(address)

        if self.powerlink:
            power = self.read_power()
            temperatures[len(self.TEMPERATURES):] = power

        #print("Read temperatures", self.datasource.temperatures)
        self.datasource.temperatures = temperatures
        self.datasource.variables = variables
        self.datasource.temperatures_changed.emit()
        self.datasource.variables_changed.emit()

    def read_bits(self):
        #print("Reading bits")

        bits = self.datasource.bits

        if self.directnet:
            for index, address in enumerate(self.BITS):
                bits[index] = self.directnet.read_bit(address)

        #print("Read bits", self.datasource.bits)
        self.datasource.bits = bits
        self.datasource.bits_changed.emit()

    def read_power(self):
        data = self.powerlink.read()

        total = data['1.8.0']
        try:
            actual = data['31.7']*data['32.7']*data['33.7'] + data['51.7']*data['52.7']*data['53.7'] + data['71.7']*data['72.7']*data['73.7']
        except Exception as e:
            print(e, data)
            raise e

        return [actual, total]

    def measured(self):
        self.datasource.measured.emit()

    def write_bit(self, index, value):
        self.directnet.write_bit(self.BITS[index], value)

    def write_variable(self, index, value):
        self.directnet.write_value(self.VARIABLES[index], value)
