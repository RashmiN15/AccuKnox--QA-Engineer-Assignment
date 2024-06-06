#Objective 1: System Health Monitoring Script
#!/bin/bash

# Thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80
LOG_FILE="/var/log/system_health.log"

# Function to check CPU usage
check_cpu() {
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    if (( $(echo "$CPU_USAGE > $CPU_THRESHOLD" | bc -l) )); then
        echo "$(date): CPU usage is above threshold: ${CPU_USAGE}%" >> $LOG_FILE
    fi
}

# Function to check memory usage
check_memory() {
    MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    if (( $(echo "$MEMORY_USAGE > $MEMORY_THRESHOLD" | bc -l) )); then
        echo "$(date): Memory usage is above threshold: ${MEMORY_USAGE}%" >> $LOG_FILE
    fi
}

# Function to check disk usage
check_disk() {
    DISK_USAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
    if (( DISK_USAGE > DISK_THRESHOLD )); then
        echo "$(date): Disk usage is above threshold: ${DISK_USAGE}%" >> $LOG_FILE
    fi
}

# Function to check running processes
check_processes() {
    TOP_PROCESS=$(ps -eo %cpu,%mem,comm --sort=-%cpu | head -n 2 | tail -n 1)
    echo "$(date): Top process: ${TOP_PROCESS}" >> $LOG_FILE
}

# Main function to run all checks
check_system_health() {
    check_cpu
    check_memory
    check_disk
    check_processes
}

# Run the system health check
check_system_health
