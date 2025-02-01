#!/bin/bash

# File paths
USER_FILE="users.txt"
GROUP_FILE="groups.txt"
AUDIT_LOG="audit.log"
PASSWORD_FILE="passwords.txt"

# Function to log actions
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$AUDIT_LOG"
}

# Ensure user file exists
if [[ ! -f "$USER_FILE" ]]; then
    log_action "Error: users.txt not found. Exiting."
    exit 1
fi

# Ensure group file exists, create with defaults if missing
if [[ ! -f "$GROUP_FILE" ]]; then
    log_action "Warning: groups.txt not found. Creating default groups."
    touch "$GROUP_FILE"
    for i in {1..5}; do
        echo "group$i:$((1000 + i))" >> "$GROUP_FILE"
    done
fi

# Read and create groups
declare -A GROUPS
while IFS=: read -r group group_id; do
    [[ -z "$group" ]] && continue

    # Generate a group ID if missing
    [[ -z "$group_id" ]] && group_id=$((1000 + RANDOM % 8999)) && echo "$group:$group_id" >> "$GROUP_FILE"

    GROUPS["$group"]=$group_id

    # Create group if it doesn't exist
    if ! getent group "$group" &> /dev/null; then
        sudo groupadd "$group" -g "$group_id"
        log_action "Created group: $group (ID: $group_id)"
    else
        log_action "Group already exists: $group"
    fi
done < "$GROUP_FILE"

# Read and create users
while IFS=: read -r username full_name groups sudo_privilege; do
    [[ -z "$username" ]] && continue
    log_action "Processing user: $username ($full_name)"

    # Delete existing user
    if id "$username" &> /dev/null; then
        sudo userdel -r "$username"
        log_action "Deleted existing user: $username"
    fi

    # Create new user
    sudo useradd -m -s /bin/bash -c "$full_name" "$username"
    
    # Set random password
    password=$(openssl rand -base64 12)
    echo "$username:$password" | sudo chpasswd
    echo "$username:$password" >> "$PASSWORD_FILE"
    log_action "Created user: $username ($full_name) and set password (Stored in passwords.txt)"

    # Assign user to groups
    IFS=, read -r -a user_groups <<< "$groups"
    for group in "${user_groups[@]}"; do
        [[ -z "$group" ]] && continue

        # Auto-create missing groups
        if [[ -z "${GROUPS[$group]}" ]]; then
            group_id=$((1000 + RANDOM % 8999))
            echo "$group:$group_id" >> "$GROUP_FILE"
            GROUPS["$group"]=$group_id
            sudo groupadd "$group" -g "$group_id"
            log_action "Auto-created missing group: $group (ID: $group_id)"
        fi

        # Add user to the group
        sudo usermod -a -G "$group" "$username"
        log_action "Added user $username to group: $group"
    done

    # Assign sudo privileges
    if [[ "$sudo_privilege" == "yes" ]]; then
        sudo usermod -aG sudo "$username"
        log_action "Granted sudo to: $username"
    fi
done < "$USER_FILE"

log_action "Script execution completed."
