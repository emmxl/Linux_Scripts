#!/bin/bash

# Set the date format for the timestamp
DATE=$(date +%Y%m%d)

# Define the source and backup directory
SOURCE_DIR="/etc"
BACKUP_DIR="/backup"
BACKUP_FILE="$BACKUP_DIR/backup_$DATE.tar.gz"

# Create the backup directory if it does not exist
mkdir -p "$BACKUP_DIR"

# Compress the /etc directory
echo "Compressing the /etc directory into $BACKUP_FILE"
tar -czf "$BACKUP_FILE" -C "$SOURCE_DIR" .

# Verify the integrity of the backup
echo "Verifying the integrity of the backup file..."
tar -tzf "$BACKUP_FILE" > /dev/null

if [ $? -eq 0 ]; then
  echo "Backup successfully created and verified."
else
  echo "Error: Backup integrity check failed."
  exit 1
fi

