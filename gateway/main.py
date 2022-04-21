from datetime import datetime
from random import random, randint
import serial.tools.list_ports
import sys
from Adafruit_IO import MQTTClient
from threading import Thread, Event
import firebase_admin
from firebase_admin import credentials, firestore
from requests import get, post
from json import loads
from time import sleep

AIO_FEED_IDS = [
    "microbit-temp", 
    "microbit-humid", 
    "microbit-soil-moisture", 
    "microbit-pump", 
    "microbit-light", 
    "microbit-co2", 
    "microbit-led"
]
AIO_USERNAME = "Long1961"
AIO_KEY = "aio_whrR18HSoEZGxO5FJTA0UPgiO3no"

cred = credentials.Certificate("./serviceAccountKey.json")
default_app = firebase_admin.initialize_app(cred)
db = firestore.client()

collection_ref = { 
    'light_data': db.collection(u'light_data'),
    'humid_data': db.collection(u'humid_data'),
    'temperature_data': db.collection(u'temperature_data'),
    'soil_moisture_data': db.collection(u'soil_moisture_data'),
    'sensors': db.collection(u'sensors'),
    'co2_data': db.collection(u'co2_data'),
    'led_data': db.collection(u'led_data'),
    
}

document_ref = {
    'pump': db.collection(u'sensors').document(u'pump'),
    'led': db.collection(u'sensors').document(u'led'),
}

callback_done = Event()

def getPort():
    ports = serial.tools.list_ports.comports()
    N = len(ports)
    commPort = "None"
    for i in range(0, N):
        port = ports[i]
        strPort = str(port)
        if "USB Serial Device" in strPort:
            splitPort = strPort.split(" ")
            commPort = splitPort[0]
    return commPort

isMicrobitConnected = False
if getPort() != "None":
    ser = serial.Serial(port=getPort(), baudrate=115200)
    isMicrobitConnected = True

def connected(client):
    print("Connected!")
    # client.subscribe(AIO_FEED_IDS)
    for feed in AIO_FEED_IDS:
        client.subscribe(feed)

def subscribe(client , userdata , mid , granted_qos):
    print("Subscribed!")

def disconnected(client):
    print("Disconnected!")
    sys.exit (1)

def message(client , feed_id , payload):
    print("Receive Data: " + payload)
    try:
        if isMicrobitConnected:
            ser.write((str(payload) + "#").encode())
    except Exception as e:
        print(e)

client = MQTTClient(AIO_USERNAME , AIO_KEY)
client.on_connect = connected
client.on_disconnect = disconnected
client.on_message = message
client.on_subscribe = subscribe
client.connect()
client.loop_background()

# ser = serial.Serial(port=getPort(), baudrate=115200)

def processData(data):
    data = data.replace("!", "")
    data = data.replace("#", "")
    splitData = data.split(":")
    print(splitData)
    push_data = splitData[2]
    try: 
        if splitData[1] == "TEMP":
            client.publish("microbit-temp", splitData[2])
            collection_ref['temperature_data'].add({
                'createAt': datetime.now(),
                'value': push_data,
            })
        elif splitData[1] == "HUMI":
            client.publish("microbit-humid", splitData[2])
            collection_ref['humid_data'].add({
                'createAt': datetime.now(),
                'value': push_data,
            })
        elif splitData[1] == "SOIL":
            client.publish("microbit-soil-moisture", splitData[2])
            collection_ref['soil_moisture_data'].add({
                'createAt': datetime.now(),
                'value': push_data,
            })
        elif splitData[1] == "CO2":
            client.publish("microbit-co2", splitData[2])
            collection_ref['co2_data'].add({
                'createAt': datetime.now(),
                'value': push_data,
            })
        elif splitData[1] == "LIGHT":
            client.publish("microbit-light", splitData[2])
            collection_ref['light_data'].add({
                'createAt': datetime.now(),
                'value': push_data,
            })  
        elif splitData[1] == "PUMP":
            client.publish("microbit-pump", splitData[2])
            document_ref['pump'].update({
                'state': 'ON' if splitData[2] == '3' else 'OFF'
            })  
        elif splitData[1] == "LED":
            client.publish("microbit-led", splitData[2])
            document_ref['pump'].update({
                'state': 'ON' if splitData[2] == '3' else 'OFF'
            })  
    except IndexError:
        print("Read failed")
        return
    except:
        pass

mess = ""
def readSerial():
    bytesToRead = ser.inWaiting()
    if (bytesToRead > 0):
        global mess
        mess = mess + ser.read(bytesToRead).decode("UTF-8")
        # print(mess)
        while ("#" in mess) and ("!" in mess):
            start = mess.find("!")
            end = mess.find("#")
            processData(mess[start:end + 1])
            if (end == len(mess)):
                mess = ""
            else:
                mess = mess[end+1:]

def on_snapshot_led(doc_snapshot, changes, read_time):
    global ser
    state = 'ON'
    for doc in doc_snapshot:
        state = doc.to_dict().get('state')
    try:
        post(
            f'https://io.adafruit.com/api/v2/{AIO_USERNAME}/feeds/{AIO_FEED_IDS[6]}/data',
            headers={ "X-AIO-Key": AIO_KEY, },
            data={ "value": "2" if state == "OFF" else "3" }
        )
        # ser.write(f"{1 if state == 'ON' else 0}#".encode())
    except Exception as e:
        print(e)

flag = False
def on_snapshot_pump(doc_snapshot, changes, read_time):
    global flag
    state = 'ON'
    for doc in doc_snapshot:
        state = doc.to_dict().get('state')
    try:
        flag = True
        post(
            f'https://io.adafruit.com/api/v2/{AIO_USERNAME}/feeds/{AIO_FEED_IDS[3]}/data',
            headers={ "X-AIO-Key": AIO_KEY, },
            data={ "value": "2" if state == "OFF" else "3" }
        )
    except Exception as e:
        print(e)
    finally:
        flag = False

def pump_feed_watcher():
    current_value = "0"
    while True:
        sleep(2)
        while flag:
            pass
        try:
            respone = get(f'https://io.adafruit.com/api/v2/{AIO_USERNAME}/feeds/{AIO_FEED_IDS[3]}/data?limit=1', headers={
                "X-AIO-Key": AIO_KEY
            })
            value = loads(respone.text)[0]['value']
            if current_value == value:
                continue
            current_value = value
            document_ref['pump'].update({ 'state': "ON" if value == "3" else "OFF" })
            print(value)
        except:
            pass


def firebase_watcher():
    light_sensor_snapshot = document_ref['led'].on_snapshot(on_snapshot_led)
    pump_sensor_snapshot = document_ref['pump'].on_snapshot(on_snapshot_pump)
    callback_done.wait()
    light_sensor_snapshot.unsubscribe()
    pump_sensor_snapshot.unsubscribe()


def main():
    Thread(target=firebase_watcher).start()
    Thread(target=pump_feed_watcher).start()
    while True:
        if isMicrobitConnected:
            readSerial()

        sleep(2)

if __name__ == "__main__":
    for i in range(0, 30):
        collection_ref['co2_data'].add({
            'createAt': datetime.now(),
            'value': randint(250, 550),
        })
    exit(0)
    main()