#!/bin/bash

# Input files
USER_FILE="users.txt"
GROUP_FILE="groups.txt"
AUDIT_LOG="audit.log"

# Function to log actions
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$AUDIT_LOG"
}

# Check if input files exist
if [[ ! -f "$USER_FILE" || ! -f "$GROUP_FILE" ]]; then
    log_action "Error: Input files (users.txt or groups.txt) not found."
    exit 1
fi

# Read groups from groups.txt
GROUPS=()
while IFS= read -r group; do
    GROUPS+=("$group")
    # Create group if it doesn't exist
    if ! getent group "$group" > /dev/null; then
        groupadd "$group"
        log_action "Created group: $group"
    fi
done < "$GROUP_FILE"

# Read users from users.txt
while IFS=: read -r username groups sudo_privilege; do
    # Create user if they don't exist
    if ! id "$username" &> /dev/null; then
        useradd -m -s /bin/bash "$username"
        log_action "Created user: $username"
        # Set a secure password (randomly generated)
        password=$(openssl rand -base64 12)
        echo "$username:$password" | chpasswd
        log_action "Set password for user: $username"
    fi

    # Assign user to groups
    IFS=, read -r -a user_groups <<< "$groups"
    for group in "${user_groups[@]}"; do
        if [[ " ${GROUPS[@]} " =~ " ${group} " ]]; then
            usermod -aG "$group" "$username"
            log_action "Added user $username to group: $group"
        else
            log_action "Error: Group $group does not exist for user $username"
        fi
    done

    # Grant sudo privileges if specified
    if [[ "$sudo_privilege" == "yes" ]]; then
        usermod -aG sudo "$username"
        log_action "Granted sudo privileges to user: $username"
    fi
done < "$USER_FILE"

# Verify and display results
echo "Users created:"
cut -d: -f1 /etc/passwd | grep -f <(cut -d: -f1 "$USER_FILE")

echo -e "\nGroups created:"
cut -d: -f1 /etc/group | grep -f <(cut -d: -f1 "$GROUP_FILE")

echo -e "\nUser group membership:"
while IFS=: read -r username groups _; do
    echo "User: $username"
    groups "$username"
    echo
done < "$USER_FILE"

log_action "Script execution completed."