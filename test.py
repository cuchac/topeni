from pprint import pprint
import unittest
from power_link import PowerLink


class MeasurementCase(unittest.TestCase):
    def test_power(self):
        powerlink = PowerLink()

        data = powerlink.read()
        pprint(data)

        print(data['1.8.0'])
        print(data['31.7']*data['32.7'] + data['51.7']*data['52.7'] + data['71.7']*data['72.7'])

if __name__ == '__main__':
    unittest.main()
