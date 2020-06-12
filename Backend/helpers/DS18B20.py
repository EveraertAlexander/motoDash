class DS18B20:

    def __init__(self, par_sensorid):
        self.filepath = f'/sys/bus/w1/devices/w1_bus_master1/{par_sensorid}/w1_slave'

    def geef_temp(self):
        try:
            with open(self.filepath, 'r') as f:
                data = f.readlines()
        except IOError:
            data = [
                '7e 01 4b 46 7f ff 0c 10 f9 : crc=f9 YES\n', 
                '7e 01 4b 46 7f ff 0c 10 f9 t=23875\n'
                ]
        temp = float(data[1].rstrip('\\n').split('t=')[1]) * 0.001

        return temp