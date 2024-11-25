#!/bin/bash

# Log file location
LOG_FILE="/var/log/monitor.log"

# Function to log messages with timestamps
log_message() {
    echo "$(date): $1" | tee -a "$LOG_FILE"
}

# Display system uptime
UPTIME=$(uptime -p)
log_message "System Uptime: $UPTIME"

# Check and log disk space usage
DISK_USAGE=$(df -h | grep '^/dev')
log_message "Disk Space Usage:"
log_message "$DISK_USAGE"

# Show memory usage
MEMORY_USAGE=$(free -h)
log_message "Memory Usage:"
log_message "$MEMORY_USAGE"

log_message "------------------------------------"

