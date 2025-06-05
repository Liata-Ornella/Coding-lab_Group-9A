#!/bin/bash

# Define log types and their corresponding files
LOG_TYPES=(
    "1) Heart Rate"
    "2) Temperature"
    "3) Water Usage"
)
LOG_FILES=(
    "heart_rate.log"
    "temperature.log"
    "water_usage.log"
)

# Function to get current timestamp
get_timestamp() {
    date +"%Y-%m-%d_%H:%M:%S"
}

# Function to archive a log file
archive_log() {
    local choice=$1
    local log_file=${LOG_FILES[$choice-1]}
    local active_log="hospital_data/active_logs/$log_file"
    local archive_dir="hospital_data/archive"
    local timestamp=$(get_timestamp)
    
    # Check if log file exists
    if [ ! -f "$active_log" ]; then
        echo "Error: Log file $active_log not found"
        return 1
    fi
    
    # Create archive directory if it doesn't exist
    mkdir -p "$archive_dir"
    
    # Create new archive filename with timestamp
    local archive_file="$archive_dir/${log_file%.*}_$timestamp.log"
    
    # Move and rename the log file
    mv "$active_log" "$archive_file"
    
    # Create new empty log file
    touch "$active_log"
    
    echo "Successfully archived to $archive_file"
}

# Main script
while true; do
    echo "Select log to archive:" 
    for log in "${LOG_TYPES[@]}"; do
        echo "$log"
    done
    
    read -p "Enter choice (1-3): " choice
    
    # Validate input
    if [[ $choice =~ ^[1-3]$ ]]; then
        archive_log $choice
        break
    else
        echo "Invalid choice. Please enter a number between 1 and 3."
    fi
done
