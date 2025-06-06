#!/bin/bash

# Ensure script has execution permissions
chmod +x "$0"

# Directory paths
ACTIVE_LOGS_DIR="hospital_data/active_logs"
ARCHIVE_DIR="hospital_data/archive"

# Create directories if they don't exist
mkdir -p "$ACTIVE_LOGS_DIR" "$ARCHIVE_DIR"

# Function to get current timestamp
get_timestamp() {
    date +"%Y-%m-%d_%H:%M:%S"
}

# Main menu
echo "Select log to archive:"
echo "1) Heart Rate"
echo "2) Temperature"
echo "3) Water Usage"

read -p "Enter choice (1-3): " choice

# Validate input
if [[ ! $choice =~ ^[1-3]$ ]]; then
    echo "Error: Invalid choice. Please enter a number between 1 and 3."
    exit 1
fi

# Determine log type and file name
LOG_TYPES=("heart_rate" "temperature" "water_usage")
LOG_TYPE=${LOG_TYPES[$((choice-1))]}_log.log
ACTIVE_LOG="$ACTIVE_LOGS_DIR/$LOG_TYPE"

# Check if log file exists
if [ ! -f "$ACTIVE_LOG" ]; then
    echo "Error: Log file $LOG_TYPE not found in active logs directory."
    exit 1
fi

# Create timestamp for archive
TIMESTAMP=$(get_timestamp)
ARCHIVE_FILE="$ARCHIVE_DIR/${LOG_TYPE%.log}_$TIMESTAMP.log"

# Move active log to archive
echo "Archiving $LOG_TYPE..."
mv "$ACTIVE_LOG" "$ARCHIVE_FILE"

# Create new empty log file
touch "$ACTIVE_LOG"

echo "Successfully archived to $ARCHIVE_FILE"
