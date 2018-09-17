from time import sleep
import serial
import re


class PowerLink(object):
    line_re = re.compile(r'(.+)\((.+)\)')
    float_re = re.compile(r'(-?[0-9\.]+)')

    def __init__(self):
#        self.serial = serial.serial_for_url('rfc2217://10.0.0.6:12346',
        self.serial = serial.serial_for_url('/dev/topeni_power',
                                            timeout=5,
                                            parity=serial.PARITY_EVEN,
                                            baudrate=300,
                                            bytesize=serial.SEVENBITS)

    def read_data(self):
        self.serial.baudrate = 300
        self.serial.reset_input_buffer()
        self.serial.write(b'/?!\r\n')
        self.serial.read_until(terminator=b'\r\n')

        # Set baudrate to 4800
        self.serial.write(b'\x06040\r\n')
        self.serial.flush()
        sleep(0.1)
        self.serial.baudrate = 4800

        data = self.serial.read_until(terminator=b'\r\n!\r\n')
        self.serial.read(2)

        return data[1:-5]

    def parse_line(self, line):
        line = line.decode('ascii')
        match = self.line_re.match(line)
        return match.groups()

    def read(self):
        data = self.read_data()

        result = {}
        for line in data.split(b'\r\n'):
            line_data = self.parse_line(line)
            result[line_data[0]] = self.parse_value(line_data[1])

        return result

    def parse_value(self, data):
        match = self.float_re.match(data)
        if match:
            return float(match.group(1))
        return data
