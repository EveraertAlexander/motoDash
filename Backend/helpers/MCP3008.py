import spidev

class Mcp:
    
    def __init__(self, parbus=0, pardevice=0):
        
        self.bus = parbus
        self.device = pardevice
        self.spi()

    def read_channel(self, channel):

        channel_select = ((128 >> 4) | channel) << 4
        bytes_out = [
            1,
            channel_select,
            0
        ]
        bytes_in = self.spi.xfer2(bytes_out)
        value = (bytes_in[1] << 8) | bytes_in[2]

        return value
    

    def spi(self):

        self.spi = spidev.SpiDev()
        self.spi.open(self.bus, self.device) # Bus SPI0, slave op CE 0
        self.spi.max_speed_hz = 10 ** 5 # 100 kHz


    def close_spi(self):

        self.spi.close()