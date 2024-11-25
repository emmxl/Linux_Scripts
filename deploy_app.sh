#!/bin/bash

# Define variables
DEPLOY_DIR="/home/ec2-user/app"
APP_FILE="app.java"
LOG_FILE="$DEPLOY_DIR/app_output.log"

# Create deployment directory
echo "Creating deployment directory..."
mkdir -p "$DEPLOY_DIR" || { echo "Failed to create directory"; exit 1; }

# Copy app.java to the deployment directory
echo "Copying $APP_FILE to $DEPLOY_DIR..."
if [[ -f "$APP_FILE" ]]; then
    cp "$APP_FILE" "$DEPLOY_DIR" || { echo "Failed to copy $APP_FILE"; exit 1; }
else
    echo "Error: $APP_FILE not found!"
    exit 1
fi

# Change to the deployment directory
cd "$DEPLOY_DIR" || { echo "Failed to change directory"; exit 1; }

# Compile app.java
echo "Compiling $APP_FILE..."
javac "$APP_FILE" || { echo "Compilation failed"; exit 1; }

# Find the generated .class file
CLASS_FILE="${APP_FILE%.java}.class"

# Set execute permissions for the .class file
echo "Setting execute permissions for $CLASS_FILE..."
chmod +x "$CLASS_FILE" || { echo "Failed to set permissions"; exit 1; }

# Execute the application and log output
echo "Executing the application..."
java "${APP_FILE%.java}" > "$LOG_FILE" 2>&1 || { echo "Execution failed"; exit 1; }

echo "Application executed successfully. Check the log file at $LOG_FILE."

