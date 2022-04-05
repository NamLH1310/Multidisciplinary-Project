import serial.tools.list_ports
import time
import sys
from Adafruit_IO import MQTTClient, Client, Data
from threading import Thread, Event
import firebase_admin
from firebase_admin import credentials, firestore
import requests
import json
from time import sleep

AIO_FEED_IDS = [
    "microbit-temp",
    "microbit-humid",
    "microbit-soil-moisture",
    "microbit-pump",
    "microbit-light"
]
AIO_USERNAME = "Long1961"
AIO_KEY = "aio_whrR18HSoEZGxO5FJTA0UPgiO3no"

aio_client = Client(AIO_USERNAME, AIO_KEY)

cred = credentials.Certificate("./serviceAccountKey.json")
default_app = firebase_admin.initialize_app(cred)
db = firestore.client()

collection_ref = { 
    'light_data': db.collection(u'light_data'),
    'humid_data': db.collection(u'humid_data'),
    'temperature_data': db.collection(u'temperature_data'),
    'soil_moisture_data': db.collection(u'soil_moisture_data'),
    'sensors': db.collection(u'sensors'),
}

document_ref = {
    'pump': db.collection(u'sensors').document(u'pump'),
    'light': db.collection(u'sensors').document(u'light'),
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
            commPort = (splitPort[0])
    return commPort

isMicrobitConnected = False
if getPort() != "None":
    ser = serial.Serial( port=getPort(), baudrate=115200)
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
    if(payload == "0"):
        ser.write(bytes("!1:LED:LOFF#", "UTF8"))
    if(payload == "1"):
        ser.write(bytes("!1:LED:LON#", "UTF8"))
    if(payload == "2"):
        ser.write(bytes("!1:PUMP:POFF#", "UTF8"))
    if(payload == "3"):
        ser.write(bytes("!1:PUMP:PON#", "UTF8"))

    if isMicrobitConnected:
        ser.write((str(payload) + "#").encode())

client = MQTTClient(AIO_USERNAME , AIO_KEY)
client.on_connect = connected
client.on_disconnect = disconnected
client.on_message = message
client.on_subscribe = subscribe
client.connect()
# client.loop_background()

def processData(data):
    data = data.replace("!", "")
    data = data.replace("#", "")
    splitData = data.split(":")
    print(splitData)
    push_data = splitData[2]
    try: 
        match splitData[1]:
            case "TEMP":
                client.publish(AIO_FEED_IDS[0], push_data)
                collection_ref['light_data'].add({
                    'value': push_data
                })
            case  "HUMI":
                client.publish(AIO_FEED_IDS[1], push_data)
                collection_ref['humid_data'].add({
                    'value': push_data
                })
            case "SOIL":
                client.publish(AIO_FEED_IDS[2], push_data)
                collection_ref['soil_moisture_data'].add({
                    'value': push_data
                })
    except:
        pass

mess = ""
def readSerial():
    bytesToRead = ser.inWaiting()
    if bytesToRead > 0:
        global mess
        mess = mess + ser.read(bytesToRead).decode("UTF-8")
        print(mess)
        while "#" in mess and "!" in mess:
            start = mess.find("!")
            end = mess.find("#")
            processData(mess[start:end + 1])
            if (end == len(mess)):
                mess = ""
            else:
                mess = mess[end+1:]

def on_snapshot_light(doc_snapshot, changes, read_time):
    state = 'ON'
    for doc in doc_snapshot:
        state = doc.to_dict().get('state')
    try:
        ser.write(bytes(f"!1:LED:L{state}#", "UTF8"))
    except:
        print("Write failed")

flag = False
def on_snapshot_pump(doc_snapshot, changes, read_time):
    global flag
    state = 'ON'
    for doc in doc_snapshot:
        state = doc.to_dict().get('state')
    try:
        flag = True
        requests.post(
            f'https://io.adafruit.com/api/v2/{AIO_USERNAME}/feeds/{AIO_FEED_IDS[3]}/data',
            headers={
                "X-AIO-Key": AIO_KEY,
            },
            data={
                "value": "2" if state == "OFF" else "3"
            }
        )
    except:
        print("Write failed")
    finally:
        flag = False

def firebase_watcher():
    light_sensor_snapshot = document_ref['light'].on_snapshot(on_snapshot_light)
    pump_sensor_snapshot = document_ref['pump'].on_snapshot(on_snapshot_pump)
    callback_done.wait()
    light_sensor_snapshot.unsubscribe()
    pump_sensor_snapshot.unsubscribe()

def pump_feed_watcher():
    current_value = "0"
    while True:
        sleep(2)
        while flag:
            ...
        x = requests.get(f'https://io.adafruit.com/api/v2/{AIO_USERNAME}/feeds/{AIO_FEED_IDS[3]}/data?limit=1', headers={
            "X-AIO-Key": AIO_KEY
        })
        value = json.loads(x.text)[0]['value']
        if current_value == value:
            continue
        current_value = value
        document_ref['pump'].update({ 'state': "ON" if value == "3" else "OFF" })
        print(value)

def main():
    Thread(target=firebase_watcher).start()
    Thread(target=pump_feed_watcher).start()
    while True:
        if isMicrobitConnected:
            readSerial()

        time.sleep(2)

if __name__ == "__main__":
    main()