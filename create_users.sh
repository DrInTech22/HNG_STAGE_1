#!/bin/bash

# Log file and secure password storage file
LOGFILE="/var/log/user_management.log"
PASSWORD_FILE="/var/secure/user_passwords.txt"

# Ensure log directory and password storage directory exist
mkdir -p /var/log /var/secure
touch $LOGFILE
touch $PASSWORD_FILE

# Function to log messages
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> $LOGFILE
}

# Ensure script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

# Read and process the input file
if [ $# -ne 1 ]; then
    echo "Usage: $0 <input_file>"
    exit 1
fi

INPUT_FILE="$1"
if [ ! -f "$INPUT_FILE" ]; then
    echo "Input file not found."
    exit 1
fi

# Function to create users and groups
create_user() {
    IFS=';' read -r username groups <<< "$1"
    groups=$(echo $groups | tr -d ' ')  # Remove all whitespace

    # Check if user already exists
    if id "$username" &>/dev/null; then
        log_message "User $username already exists."
        return 1
    fi

    # Create personal group
    groupadd "$username"

    # Create user with home directory and personal group
    useradd -m -g "$username" "$username" 
    if [ $? -eq 0 ]; then
        log_message "User $username created."
    else
        log_message "Failed to create user $username."
        return 1
    fi

   
    #usermod -g "$username" "$username"

    # Create additional groups and add user to them
    IFS=',' read -ra GROUP_ARRAY <<< "$groups"
    for group in "${GROUP_ARRAY[@]}"; do
        getent group "$group" &>/dev/null || groupadd "$group"
        usermod -aG "$group" "$username"
        log_message "Added $username to group $group."
    done

    # Set up permissions for home directory
    chmod 700 "/home/$username"
    chown "$username:$username" "/home/$username"
    log_message "Set permissions for home directory of $username."

    # Generate random password
    password=$(openssl rand -base64 12)
    echo "$username:$password" | chpasswd
    log_message "Password set for user $username."

    # Store password securely
    echo "$username:$password" >> $PASSWORD_FILE
}

while IFS= read -r line; do
    # Ignore empty lines and lines starting with #
    [[ -z "$line" || "$line" =~ ^# ]] && continue
    create_user "$line"
done < "$INPUT_FILE"

log_message "User creation script completed."
echo "User creation script completed. Check $LOGFILE for details."
