from RPi import GPIO


class PWM_led:

    def __init__(self, par_R_pin, par_G_pin, par_B_pin):

        self.pin_R = par_R_pin
        self.pin_G = par_G_pin
        self.pin_B = par_B_pin

        self.__initGPIO()

    @property
    def pin_R(self):
        """The pin_R property."""
        return self._pin_R
    @pin_R.setter
    def pin_R(self, value):
        self._pin_R = value
    
    @property
    def pin_G(self):
        """The pin_G property."""
        return self._pin_G
    @pin_G.setter
    def pin_G(self, value):
        self._pin_G = value
    
    @property
    def pin_B(self):
        """The pin_B property."""
        return self._pin_B
    @pin_B.setter
    def pin_B(self, value):
        self._pin_B = value
        

    def __initGPIO(self):
        GPIO.setwarnings(False)
        GPIO.setmode(GPIO.BCM)
        GPIO.setup(self.pin_R, GPIO.OUT)
        GPIO.setup(self.pin_G, GPIO.OUT)
        GPIO.setup(self.pin_B, GPIO.OUT)

        self.pwm_R = GPIO.PWM(self.pin_R, 200)
        self.pwm_G = GPIO.PWM(self.pin_G, 200)
        self.pwm_B = GPIO.PWM(self.pin_B, 200)

        self.pwm_R.start(0)
        self.pwm_G.start(0)
        self.pwm_B.start(0)

    def change_color(self, temp, min, max):
        rgb = PWM_led.convert_to_rgb(min, max, temp)
        if rgb is not None:
            duty_r = rgb[0]/2.55
            duty_g = rgb[1]/2.55
            duty_b = rgb[2]/2.55

            self.changeDutyCycle(duty_r, duty_g, duty_b)  
    
    def changeDutyCycle(self, R, G, B):
        self.pwm_R.ChangeDutyCycle(R)
        self.pwm_G.ChangeDutyCycle(G)
        self.pwm_B.ChangeDutyCycle(B)
    
    @staticmethod
    def convert_to_rgb(minimum, maximum, value):
        minimum, maximum = float(minimum), float(maximum)    
        halfmax = (minimum + maximum) / 2
        if minimum <= value <= halfmax:
            r = 0
            g = int( 255./(halfmax - minimum) * (value - minimum))
            b = int( 255. + -255./(halfmax - minimum)  * (value - minimum))
            return (r,g,b)    
        elif halfmax < value <= maximum:
            r = int( 255./(maximum - halfmax) * (value - halfmax))
            g = int( 255. + -255./(maximum - halfmax)  * (value - halfmax))
            b = 0
            return r,g,b
