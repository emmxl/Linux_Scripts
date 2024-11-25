#!/bin/bash

# Log file
LOG_FILE="/var/log/apache_setup.log"

# Function to log actions
log_action() {
    echo "$(date): $1" | tee -a "$LOG_FILE"
}

# Log script start
log_action "Starting Apache setup script..."

# Define project directories and content
ROOT_DIR="/var/www/html"
PROJECTS=("project1" "project2")
DEFAULT_HTML="Welcome to the default Apache server!"
PROJECT_HTML=("Welcome to Project 1!" "Welcome to Project 2!")

# Install Apache HTTP server (httpd)
log_action "Installing Apache HTTP server..."
if yum install -y httpd >> "$LOG_FILE" 2>&1; then
    log_action "Apache installed successfully."
else
    log_action "Failed to install Apache. Please check your package manager."
    exit 1
fi

# Start and enable Apache to run on boot
log_action "Starting Apache service..."
if systemctl start httpd >> "$LOG_FILE" 2>&1; then
    log_action "Apache service started successfully."
else
    log_action "Failed to start Apache service."
    exit 1
fi

log_action "Enabling Apache service on boot..."
if systemctl enable httpd >> "$LOG_FILE" 2>&1; then
    log_action "Apache service enabled on boot."
else
    log_action "Failed to enable Apache service on boot."
    exit 1
fi

# Create project directories and add unique content
log_action "Creating directories and adding HTML content..."
for i in "${!PROJECTS[@]}"; do
    PROJECT_DIR="$ROOT_DIR/${PROJECTS[$i]}"
    mkdir -p "$PROJECT_DIR" >> "$LOG_FILE" 2>&1
    echo "${PROJECT_HTML[$i]}" > "$PROJECT_DIR/index.html"
    log_action "Directory '$PROJECT_DIR' created with content."
done

# Add content to the default root directory
log_action "Adding content to the default root directory..."
echo "$DEFAULT_HTML" > "$ROOT_DIR/index.html"
log_action "Default root directory content added."

# Set proper permissions
log_action "Setting permissions for /var/www/html..."
chown -R apache:apache "$ROOT_DIR" >> "$LOG_FILE" 2>&1
chmod -R 755 "$ROOT_DIR" >> "$LOG_FILE" 2>&1
log_action "Permissions set successfully."

# Final message
log_action "Apache setup complete. Visit your server's IP address or the directories: ${PROJECTS[*]}"

# Log script end
log_action "Apache setup script completed."

