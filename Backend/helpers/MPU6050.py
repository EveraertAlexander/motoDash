from smbus import SMBus
import math

class MPU6050:
    accel_resolutions = [
        16384,
        8192,
        4096,
        2048
    ]

    gyro_resolutions = [
        131,
        65.5,
        32.8,
        16.4
    ]

    def __init__(self, par_addr, par_accel_range = 0, par_gyro_range = 0):

        self.addr = par_addr
        self.i2c = SMBus()
        self.i2c.open(1)
        self.accel_range = par_accel_range
        self.gyro_range = par_gyro_range
        self.__setup()


    @property
    def accel_range(self):
        """The accel_range property."""
        return self._accel_range
    @accel_range.setter
    def accel_range(self, value):
        if 0 <= value < 4:
            self.i2c.write_byte_data(self.addr, 0x1C, value<<3) #accel scale range 2g
            self._accel_range = value
        else:
            raise ValueError('Ongeldige range')

    @property
    def gyro_range(self):
        """The gyro_range property."""
        return self._gyro_range
    @gyro_range.setter
    def gyro_range(self, value):
        if 0 <= value < 4:
            self.i2c.write_byte_data(self.addr, 0x1B, value<<3) #accel scale range 2g
            self._gyro_range = value
    
    def __setup(self):
        self.i2c.write_byte_data(self.addr, 0x6B, 0x1)  #uit slaap modus halen

        self.i2c.write_byte_data(self.addr, 0x1C, self.accel_range<<3) #accel scale range 2g
        self.i2c.write_byte_data(self.addr, 0x1B, self.gyro_range<<3) #Gyro scale range 250

    def __read_data(self, gyro:bool = False):
        calculated = []
        if gyro:
            res = MPU6050.gyro_resolutions[self.gyro_range]
            register = 0x43
        else:
            res = MPU6050.accel_resolutions[self.accel_range]
            register = 0x3B

        raw_data = self.i2c.read_i2c_block_data(self.addr, register, 6)

        XOUT = self.merge_bytes(raw_data[0], raw_data[1])/res
        YOUT = self.merge_bytes(raw_data[2], raw_data[3])/res
        ZOUT = self.merge_bytes(raw_data[4], raw_data[5])/res

        return XOUT, YOUT, ZOUT

    def __dist(self,a,b):
        return math.sqrt((a*a)+(b*b))
    
    def get_x_rotation(self):
        values = self.__read_data()
        radians = math.atan2(values[0], self.__dist(values[1],values[2]))
        return math.degrees(radians)
    
    def get_y_rotation(self):
        values = self.__read_data()
        radians = math.atan2(values[1], self.__dist(values[0],values[2]))
        return math.degrees(radians)
    
    def read_axis(self, axis, gyro:bool = False):
        res = 0
        if gyro:
            res = MPU6050.gyro_resolutions[self.gyro_range]
            register = 0x43 + (axis * 2)
        else:
            res = MPU6050.accel_resolutions[self.accel_range]
            register = 0x3b + (axis *2)
        
        raw_data = self.i2c.read_i2c_block_data(self.addr, register, 2)
        OUT = self.merge_bytes(raw_data[0], raw_data[1])/res
        return OUT

    def get_temp(self):
        raw_data = self.i2c.read_i2c_block_data(self.addr, 0x41, 2)
        data = self.merge_bytes(raw_data[0], raw_data[1])
        temp = data/340 + 36.53

        return temp

    @staticmethod
    def merge_bytes(MSB, LSB):
        mask = 0x8000
        val = (MSB<<8)|LSB
        if val & mask:
            val = val - (2**16)
        return val
        

