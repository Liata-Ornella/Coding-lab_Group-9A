# Hospital Log Management System

This system manages and analyzes patient health metrics and resource usage data through two main scripts:

## Archive Logs Script (archive_logs.sh)

The archive_logs.sh script allows you to archive specific log files. It:
- Presents a menu to select which log type to archive
- Moves the active log to the archive directory with a timestamp
- Creates a new empty log file for continued monitoring

## Analyze Logs Script (analyze_logs.sh)

The analyze_logs.sh script provides analysis of log files. It:
- Presents a menu to select which log to analyze
- Counts occurrences of each device in the log
- Records first and last entry timestamps
- Appends results to reports/analysis_report.txt

## Error Handling

Both scripts include error handling for:
- Invalid user input
- Missing log files
- Directory creation issues

## Required Tools

- bash shell
- awk
- grep
- sort
- uniq
- date
- mv
- touch
