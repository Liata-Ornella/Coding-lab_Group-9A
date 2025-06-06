import random
import time
import sys
import os

def generate_water_usage():
    return round(random.uniform(0.0, 10.0), 1)

def main():
    if len(sys.argv) != 2 or sys.argv[1] != 'start':
        print("Usage: python water_meter.py start")
        sys.exit(1)

    # Create logs directory if it doesn't exist
    os.makedirs("hospital_data/active_logs", exist_ok=True)

    # Open log file
    with open("hospital_data/active_logs/water_usage_log.log", "a") as f:
        # Simulate water usage meter
        device = "WaterMeter"
        
        while True:
            timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
            usage = generate_water_usage()
            log_entry = f"{device} {timestamp} Water Usage: {usage} liters\n"
            f.write(log_entry)
            f.flush()  # Ensure immediate write
            print(log_entry.strip())  # Print to console
            time.sleep(5)  # Wait 5 seconds between readings

if __name__ == "__main__":
    main()
