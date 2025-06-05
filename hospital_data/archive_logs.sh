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
    date +"%Y-%m-%d_%H-%M-%S"
}

# Function to show help
show_help() {
    echo "Usage:"
    echo "./archive_logs_advanced.sh [1|2|3]"
    echo ""
    echo "Options:"
    echo "1 - Archive Heart Rate log"
    echo "2 - Archive Temperature log"
    echo "3 - Archive Water Usage log"
    echo ""
    echo "If no argument is provided, interactive mode will be used."
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
    return 0
}

# Main script
if [ $# -eq 1 ]; then
    # Command-line argument provided
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        show_help
        exit 0
    fi
    
    if [[ $1 =~ ^[1-3]$ ]]; then
        archive_log "$1"
        exit $?
    else
        echo "Invalid argument. Use -h or --help for usage."
        exit 1
    fi
fi

# Interactive mode
while true; do
    echo "\nSelect log to archive:"
    for log in "${LOG_TYPES[@]}"; do
        echo "$log"
    done
    echo "q) Quit"
    
    read -p "Enter your choice: " choice
    
    case $choice in
        1|2|3)
            if archive_log "$choice"; then
                break
            fi
            ;;
        q)
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter a number between 1 and 3 or 'q' to quit."
            ;;
    esac
done
