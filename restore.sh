#!/bin/bash

# Set the backup file and restore directory
BACKUP_FILE="/backup/backup_$(date +%Y%m%d).tar.gz"
RESTORE_DIR="/restore_test"

# Create the restore directory if it doesn't exist
mkdir -p "$RESTORE_DIR"

# Extract the backup into the restore directory
echo "Restoring the backup to $RESTORE_DIR"
tar -xzf "$BACKUP_FILE" -C "$RESTORE_DIR"

# Verify the restored files
echo "Verifying the restored files..."
if [ "$(diff -r /etc/ "$RESTORE_DIR")" ]; then
  echo "The restored files do not match the original structure."
  exit 1
else
  echo "Restored files match the original structure."
fi

