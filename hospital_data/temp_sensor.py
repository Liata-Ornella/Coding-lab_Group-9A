import random
import time
import sys
import os
from datetime import datetime
import psutil
import atexit

class TempSensorDaemon:
    def __init__(self):
        self.LOG_DIR = "hospital_data/active_logs"
        self.LOG_FILE = os.path.join(self.LOG_DIR, "temperature.log")
        self.PID_FILE = os.path.join(self.LOG_DIR, "temp_sensor.pid")
        self.DEVICES = ["TEMP-01", "TEMP-02"]
        
    def ensure_log_dir(self):
        if not os.path.exists(self.LOG_DIR):
            os.makedirs(self.LOG_DIR)

    def log_data(self):
        self.ensure_log_dir()
        while True:
            timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            for device in self.DEVICES:
                temp = round(random.uniform(36.0, 39.5), 1)
                with open(self.LOG_FILE, "a") as f:
                    f.write(f"{timestamp} {device} Temperature: {temp}°C\n")
            time.sleep(1)

    def start(self):
        if self.is_running():
            print("Temperature sensor daemon is already running!")
            return
            
        with open(self.PID_FILE, "w") as f:
            f.write(str(os.getpid()))
            
        print(f"Temperature sensor daemon started. PID: {os.getpid()}")
        self.log_data()

    def stop(self):
        if not self.is_running():
            print("Temperature sensor daemon is not running!")
            return
            
        pid = self.get_pid()
        try:
            process = psutil.Process(pid)
            process.terminate()
            process.wait()
            os.remove(self.PID_FILE)
            print("Temperature sensor daemon stopped successfully.")
        except psutil.NoSuchProcess:
            print("Process already terminated.")
            if os.path.exists(self.PID_FILE):
                os.remove(self.PID_FILE)

    def is_running(self):
        if not os.path.exists(self.PID_FILE):
            return False
            
        pid = self.get_pid()
        try:
            process = psutil.Process(pid)
            return True
        except psutil.NoSuchProcess:
            return False
            
    def get_pid(self):
        with open(self.PID_FILE, "r") as f:
            return int(f.read().strip())

    def cleanup(self):
        if os.path.exists(self.PID_FILE):
            os.remove(self.PID_FILE)

def main():
    daemon = TempSensorDaemon()
    atexit.register(daemon.cleanup)
    
    if len(sys.argv) < 2:
        print("Usage: python temp_sensor_daemon.py [start|stop]")
        sys.exit(1)
    
    command = sys.argv[1]
    if command == "start":
        daemon.start()
    elif command == "stop":
        daemon.stop()
    else:
        print("Invalid command. Use 'start' or 'stop'")
        sys.exit(1)

if __name__ == "__main__":
    main()
