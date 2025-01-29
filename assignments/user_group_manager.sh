#!/bin/bash

# Input files
USER_FILE="users.txt"
GROUP_FILE="groups.txt"
AUDIT_LOG="audit.log"

# Function to log actions
log_action() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$AUDIT_LOG"
}

# Debug: Print input files
echo "Contents of users.txt:"
cat "$USER_FILE"
echo -e "\nContents of groups.txt:"
cat "$GROUP_FILE"
echo

# Check if input files exist
if [[ ! -f "$USER_FILE" || ! -f "$GROUP_FILE" ]]; then
    log_action "Error: Input files (users.txt or groups.txt) not found."
    exit 1
fi

# Read groups from groups.txt
GROUPS=()
while IFS=: read -r group group_id; do
    GROUPS+=("$group")
    # Create group if it doesn't exist
    if ! dscl . -read /Groups/"$group" &> /dev/null; then
        echo "Creating group: $group with ID: $group_id"
        sudo dscl . -create /Groups/"$group"
        sudo dscl . -create /Groups/"$group" PrimaryGroupID "$group_id"
        if [ $? -eq 0 ]; then
            log_action "Created group: $group"
        else
            log_action "Error: Failed to create group: $group"
        fi
    else
        log_action "Group already exists: $group"
    fi
done < "$GROUP_FILE"

# Read users from users.txt
while IFS=: read -r username full_name groups sudo_privilege; do
    # Debug: Print user details
    echo "Processing user: $username (Full Name: $full_name)"
    echo "Groups: $groups"
    echo "Sudo: $sudo_privilege"

    # Create user if they don't exist
    if ! dscl . -read /Users/"$username" &> /dev/null; then
        sudo dscl . -create /Users/"$username"
        sudo dscl . -create /Users/"$username" UserShell /bin/bash
        sudo dscl . -create /Users/"$username" RealName "$full_name"
        sudo dscl . -create /Users/"$username" UniqueID $((1000 + RANDOM % 10000))
        sudo dscl . -create /Users/"$username" PrimaryGroupID 20 # Default staff group
        sudo dscl . -create /Users/"$username" NFSHomeDirectory /Users/"$username"
        password=$(openssl rand -base64 12)
        sudo dscl . -passwd /Users/"$username" "$password"
        log_action "Created user: $username (Full Name: $full_name)"
        log_action "Set password for user: $username"
    else
        log_action "User already exists: $username"
    fi

    # Assign user to groups
    IFS=, read -r -a user_groups <<< "$groups"
    for group in "${user_groups[@]}"; do
        if [[ " ${GROUPS[@]} " =~ " ${group} " ]]; then
            sudo dscl . -append /Groups/"$group" GroupMembership "$username"
            log_action "Added user $username to group: $group"
        else
            log_action "Error: Group $group does not exist for user $username"
        fi
    done

    # Grant sudo privileges if specified
    if [[ "$sudo_privilege" == "yes" ]]; then
        sudo dscl . -append /Groups/admin GroupMembership "$username"
        log_action "Granted sudo privileges to user: $username"
    fi
done < "$USER_FILE"

# Verify and display results
echo -e "\nUsers created:"
dscl . -list /Users | grep -f <(cut -d: -f1 "$USER_FILE")

echo -e "\nGroups created:"
dscl . -list /Groups | grep -f <(cut -d: -f1 "$GROUP_FILE")

echo -e "\nUser group membership:"
while IFS=: read -r username full_name groups _; do
    echo "User: $username (Full Name: $full_name)"
    if dscl . -read /Users/"$username" &> /dev/null; then
        echo "Groups: $(dscl . -read /Users/"$username" GroupMembership | cut -d' ' -f2-)"
    else
        echo "Error: User $username does not exist."
    fi
    echo
done < "$USER_FILE"

log_action "Script execution completed."