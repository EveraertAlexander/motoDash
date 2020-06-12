# Imports
from repositories.DataRepository import DataRepository
from flask import Flask, request, jsonify
import random
from flask_socketio import SocketIO
from flask_cors import CORS

import threading
import time

#FLASK SOCKETIO
app = Flask(__name__)
app.config['SECRET_KEY'] = 'Hier mag je om het even wat schrijven, zolang het maar geheim blijft en een string is'

socketio = SocketIO(app, cors_allowed_origins="*")
CORS(app)

endpoint='/api/v1'


#SENSORS
from helpers.DS18B20 import DS18B20
from helpers.MCP3008 import Mcp
from helpers.MPU6050 import MPU6050
from helpers.PWM_led import PWM_led

sensor_id = '28-011927a957ea'
temp_sensor = DS18B20(sensor_id)
oil_temp = 0

adc=Mcp(0,1)
ldr = 0
get_light_intensity = 0

accel_addr = 0x68
accel_res = 2
accelerometer = MPU6050(accel_addr, accel_res)


start_time_temp = time.time()
write_speed_temp = 5                     #LOG TEMPERATURE EVERY X SECONDS

start_time_ldr = start_time_temp
write_speed_ldr = 20                     #LOG LDR VALUE EVERY X SECONDS

start_time_accel = start_time_temp  
write_speed_accel = 0.5                  #LOG ACCELERATION VALUE EVERY X SECONDS
threshold_accel = 0.5

start_time_angle = start_time_temp
write_speed_angle = 0.5                  #LOG ANGLE VALUE EVERY X SECONDS
threshold_angle = 10

rgb_led = PWM_led(27,22,23)


logging = False
rideid = 1

counter = 0
temp_rot_x = 0
temp_accel_y = 0

#APP
def log_data():
    global light_intensity, start_time_ldr, write_speed_ldr, start_time_accel, start_time_angle

    while logging:
        currentTime = time.time()

        if start_time_ldr + write_speed_ldr < currentTime:
            start_time_ldr = currentTime
            print('writing light intensity to database...')
            DataRepository.create_log_light(light_intensity, rideid)

        if threshold_accel < abs(avg_accel_y) and start_time_accel + write_speed_accel < currentTime:
            start_time_accel = currentTime
            print('writing acceleration to database...')
            DataRepository.create_log_accel(avg_accel_y, rideid)
        
        if threshold_angle < abs(avg_rot_x) and start_time_angle + write_speed_angle < currentTime:
            start_time_angle = currentTime
            print('writing angle to database...')
            DataRepository.create_log_angle(avg_rot_x, rideid)

def get_accel_values():
    global rotation_x, rotation_y, accel_x, accel_y, light_intensity, start_time_ldr, write_speed_ldr, start_time_accel, start_time_angle, accelerometer, counter, ride_duration
    global temp_rot_x, temp_accel_y, avg_rot_x, avg_accel_y
    while True:
        try:
            rotation_x = round(accelerometer.get_x_rotation())
            rotation_y = round(accelerometer.get_y_rotation())
            accel_x = round(accelerometer.read_axis(0),2)
            accel_y = round(accelerometer.read_axis(1),2)
            ldr_out = adc.read_channel(ldr)
            light_intensity = round(100 - map_value(ldr_out, 1024, 100), 2)

            if counter < 10:
                counter +=1
                temp_rot_x += rotation_x
                temp_accel_y += accel_y
            else:
                avg_rot_x = round(temp_rot_x/10)
                avg_accel_y = round(temp_accel_y/10,2)
                temp_rot_x = 0
                temp_accel_y = 0
                counter =  0

        except Exception as e:
            print(f'Fout bij het inlezen: {e}')



def get_temp():
    global oil_temp, start_time_temp, write_speed_temp
    while True:
        try:
            oil_temp = temp_sensor.geef_temp()
            currentTime = time.time()
            rgb_led.change_color(oil_temp, 20,30)

            if start_time_temp + write_speed_temp < currentTime and logging:
                start_time_temp = currentTime
                print('writing oil temp to database...')
                DataRepository.create_log_temp(oil_temp, rideid)

            if oil_temp > 70:
                write_speed_temp = 20
            else:
                write_speed_temp = 5
        except Exception as e:
            print(e)


def map_value(value, left_end, right_end, left_start=0, right_start=0):
    mapped = (value - left_start)/ (left_end - left_start) * (right_end-right_start) + right_start
    return mapped

#API ENDPOINTS
@app.route('/')
def hallo():
    return "Server is running, ga naar een API endpoint."

@app.route(endpoint + '/started')
def started():
    if request.method == 'GET':
        return jsonify(started = not logging)


@app.route(endpoint + '/rides')
def rides():
    if request.method == "GET":
        data = DataRepository.get_rides()

        if data:
            return jsonify(rides = data), 200
        else:
            return jsonify(error= 'Not found'), 500

@app.route(endpoint + '/rides/summary')
def ride_summary():
    if request.method == 'GET':
        data = DataRepository.get_ride_summaries()

        if data:
            return jsonify(summary = data), 200
        else:
            return jsonify(status= 'Error'), 500

@app.route(endpoint + '/rides/<rideid>', methods = ['GET' ,'PUT', 'DELETE'])
def ride(rideid):
    if request.method == 'DELETE':
        data = DataRepository.delete_ride(rideid)
        if data > 0:
            return jsonify(status = 'succes', row_count=data), 200
        else:
            return jsonify(status = 'no update', row_count=data), 400

    elif request.method == 'PUT':
        gegevens = DataRepository.json_or_formdata(request)
        print(gegevens)
        data = DataRepository.update_ride(rideid, gegevens['ridename'], gegevens['ridedescription'])

        if data:
            return jsonify(status= 'success'), 200
        else:
            return jsonify(status= 'no update'), 400
    
    elif request.method == 'GET':
        data = DataRepository.get_ride_stats(rideid)

        if data:
            return jsonify(stats = data), 200
        else:
            return jsonify(status = "error"), 404

@app.route(endpoint + '/rides/<rideid>/history', methods = ['GET'])
def get_ride_history(rideid):
    data = DataRepository.get_ride_history(rideid)
    if data:
        return jsonify(history = data), 200
    else:
        return jsonify(status= 'not found'), 404

@app.route(endpoint + '/summary/<month>')
def month_summary(month):
    if request.method == 'GET':
        data = DataRepository.get_month_summary(month)
        
        if data:
            return jsonify(month_summary = data), 200
        else:
            return jsonify(status= "error"), 404

@app.route(endpoint + '/months')
def months():
    if request.method == 'GET':
        data = DataRepository.get_months()

        if data:
            return jsonify(months = data)
        else:
            return jsonify(status='error'), 404

@app.route(endpoint + "/currentride")
def get_current_ride():
    if request.method == 'GET':
        data = DataRepository.get_current_ride()

        if data:
            return jsonify(data), 200
        else:
            return jsonify(status='error'), 500


@app.route(endpoint + '/sensorvalues')
def get_current_sensorvalues():
    sensorvalues = {'ldr': light_intensity, 'temp': oil_temp, 'rot_x': avg_rot_x, 'rot_y': rotation_y, 'accel_x': accel_x, 'accel_y': accel_y}

    return jsonify(sensorvalues), 200

#SOCKET IO
@socketio.on("connect")
def connect_message():
    time.sleep(0.1)
    print('Client connected')
    client_id = request.sid
    socketio.emit("B2F_client_connected", f'client id {client_id}', broadcast=False)
    socketio.emit("B2F_status_logging", {"started": logging}, broadcast=True)

@socketio.on("F2B_start_logging")
def start_logging(_):
    global logging, rideid
    rideid = DataRepository.create_new_ride()
    logging = True
    threading.Thread(target=log_data).start()
    socketio.emit("B2F_status_logging", {"started": logging}, broadcast=True)

@socketio.on("F2B_stop_logging")
def stop_logging(_):
    global logging
    logging = False
    socketio.emit("B2F_status_logging", {"started": logging}, broadcast=True)

if __name__ == '__main__':
    threading.Thread(target=get_accel_values).start()
    threading.Thread(target=get_temp).start()
    socketio.run(app, debug=False, host='0.0.0.0')




    