import random
import time
import sys
import os

def generate_temperature():
    return round(random.uniform(36.5, 37.5), 1)

def main():
    if len(sys.argv) != 2 or sys.argv[1] != 'start':
        print("Usage: python temp_sensor.py start")
        sys.exit(1)

    # Create logs directory if it doesn't exist
    os.makedirs("hospital_data/active_logs", exist_ok=True)

    # Open log file
    with open("hospital_data/active_logs/temperature_log.log", "a") as f:
        # Simulate two temperature sensors
        devices = ["SensorA", "SensorB"]
        
        while True:
            for device in devices:
                timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
                temperature = generate_temperature()
                log_entry = f"{device} {timestamp} Temperature: {temperature}°C\n"
                f.write(log_entry)
                f.flush()  # Ensure immediate write
                print(log_entry.strip())  # Print to console
            time.sleep(2)  # Wait 2 seconds between readings

if __name__ == "__main__":
    main()
