#Objective 2: Log File Analyzer

#!/bin/bash

LOG_FILE="/var/log/apache2/access.log"
REPORT_FILE="/var/log/apache2/log_report.txt"

# Function to count 404 errors
count_404_errors() {
    COUNT=$(grep " 404 " $LOG_FILE | wc -l)
    echo "Number of 404 errors: $COUNT" >> $REPORT_FILE
}

# Function to find the most requested pages
most_requested_pages() {
    echo "Most requested pages:" >> $REPORT_FILE
    awk '{print $7}' $LOG_FILE | sort | uniq -c | sort -nr | head -10 >> $REPORT_FILE
}

# Function to find the IP addresses with the most requests
top_ip_addresses() {
    echo "Top IP addresses:" >> $REPORT_FILE
    awk '{print $1}' $LOG_FILE | sort | uniq -c | sort -nr | head -10 >> $REPORT_FILE
}

# Main function to generate report
generate_report() {
    echo "Log Analysis Report - $(date)" > $REPORT_FILE
    count_404_errors
    most_requested_pages
    top_ip_addresses
}

# Run the log file analysis
generate_report
