import random
import time
import sys
import os

def generate_heart_rate():
    return random.randint(60, 100)

def main():
    if len(sys.argv) != 2 or sys.argv[1] != 'start':
        print("Usage: python heart_monitor.py start")
        sys.exit(1)

    # Create logs directory if it doesn't exist
    os.makedirs("hospital_data/active_logs", exist_ok=True)

    # Open log file
    with open("hospital_data/active_logs/heart_rate_log.log", "a") as f:
        # Simulate two heart rate monitors
        devices = ["Monitor1", "Monitor2"]
        
        while True:
            for device in devices:
                timestamp = time.strftime("%Y-%m-%d %H:%M:%S")
                heart_rate = generate_heart_rate()
                log_entry = f"{device} {timestamp} Heart Rate: {heart_rate} BPM\n"
                f.write(log_entry)
                f.flush()  # Ensure immediate write
                print(log_entry.strip())  # Print to console
            time.sleep(1)  # Wait 1 second between readings

if __name__ == "__main__":
    main()
