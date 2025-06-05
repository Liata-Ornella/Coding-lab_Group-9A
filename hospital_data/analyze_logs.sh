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

# Function to analyze a log file
analyze_log() {
    local choice=$1
    local log_file=${LOG_FILES[$choice-1]}
    local active_log="hospital_data/active_logs/$log_file"
    local report_file="reports/analysis_report.txt"
    
    # Check if log file exists
    if [ ! -f "$active_log" ]; then
        echo "Error: Log file $active_log not found"
        return 1
    fi
    
    # Create reports directory if it doesn't exist
    mkdir -p "reports"
    
    # Get current timestamp
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")
    
    # Analyze the log file
    echo "" >> "$report_file"
    echo "Analysis Report for $log_file - $timestamp" >> "$report_file"
    echo "=========================================" >> "$report_file"
    
    # Get device statistics
    echo "\nDevice Statistics:" >> "$report_file"
    echo "-----------------" >> "$report_file"
    
    # Count occurrences of each device
    awk '{print $2}' "$active_log" | sort | uniq -c | sort -nr | while read count device; do
        echo "$device: $count entries" >> "$report_file"
        
        # Get first and last timestamp for bonus
        first_timestamp=$(grep "$device" "$active_log" | head -1 | awk '{print $1}')
        last_timestamp=$(grep "$device" "$active_log" | tail -1 | awk '{print $1}')
        echo "  First Entry: $first_timestamp" >> "$report_file"
        echo "  Last Entry: $last_timestamp" >> "$report_file"
    done
    
    echo "" >> "$report_file"
    echo "Analysis complete. Results appended to $report_file"
}

# Main script
while true; do
    echo "Select log file to analyze:" 
    for log in "${LOG_TYPES[@]}"; do
        echo "$log"
    done
    
    read -p "Enter choice (1-3): " choice
    
    # Validate input
    if [[ $choice =~ ^[1-3]$ ]]; then
        analyze_log $choice
        break
    else
        echo "Invalid choice. Please enter a number between 1 and 3."
    fi
done
