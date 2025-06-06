#!/bin/bash

# Ensure script has execution permissions
chmod +x "$0"

# Directory paths
ACTIVE_LOGS_DIR="hospital_data/active_logs"
REPORT_DIR="reports"
REPORT_FILE="$REPORT_DIR/analysis_report.txt"

# Create reports directory if it doesn't exist
mkdir -p "$REPORT_DIR"

# Main menu
echo "Select log file to analyze:"
echo "1) Heart Rate (heart_rate_log.log)"
echo "2) Temperature (temperature_log.log)"
echo "3) Water Usage (water_usage_log.log)"

read -p "Enter choice (1-3): " choice

# Validate input
if [[ ! $choice =~ ^[1-3]$ ]]; then
    echo "Error: Invalid choice. Please enter a number between 1 and 3."
    exit 1
fi

# Determine log type and file name
LOG_TYPES=("heart_rate" "temperature" "water_usage")
LOG_TYPE=${LOG_TYPES[$((choice-1))]}_log.log
LOG_FILE="$ACTIVE_LOGS_DIR/$LOG_TYPE"

# Check if log file exists
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: Log file $LOG_TYPE not found."
    exit 1
fi

# Get current timestamp for report
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

# Start report section
echo "" >> "$REPORT_FILE"
echo "Analysis Report - $TIMESTAMP" >> "$REPORT_FILE"
echo "Log Type: $LOG_TYPE" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

# Count occurrences of each device
echo "Device Occurrences:" >> "$REPORT_FILE"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | while read count device; do
    echo "Device $device: $count occurrences" >> "$REPORT_FILE"
done

# Get first and last timestamps (bonus)
FIRST_TIMESTAMP=$(awk '{print $2}' "$LOG_FILE" | sort | head -n 1)
LAST_TIMESTAMP=$(awk '{print $2}' "$LOG_FILE" | sort | tail -n 1)

echo "" >> "$REPORT_FILE"
echo "Time Range:" >> "$REPORT_FILE"
echo "First Entry: $FIRST_TIMESTAMP" >> "$REPORT_FILE"
echo "Last Entry: $LAST_TIMESTAMP" >> "$REPORT_FILE"

echo "Analysis completed. Results have been appended to $REPORT_FILE"
