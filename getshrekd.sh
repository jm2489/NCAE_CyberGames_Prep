#!/bin/bash

# Define a list of accepted usernames
GOOD_USERS=""

# Convert exported usernames into an array
IFS=' ' read -r -a accepted_usernames <<< "$GOOD_USERS"

# Get a list of currently logged in users, including duplicates
current_users=$(who | awk '{print $1}')

# Loop through each username in the current_users list
while read -r username; do
    # Check if the username is in the accepted usernames list
    if [[ ! " ${accepted_usernames[*]} " =~ " ${username} " ]]; then
        # Prepare the message
        # Note: Removed ANSI color codes as 'wall' cannot display them
        message="*ANGRY OGRE NOISES*        ${username}!!!                     GET OUT OF MY SWAMP!!!"
        timestamp=$(date "+%Y-%m-%d %H:%M:%S")
        # Echo the message to all users and save the log
        echo "$message" | wall
        echo "${timestamp} [SHREK ALERT]    ${username} spotted and they should not have been here">> /var/log/shreklog.log
    fi
done <<< "$current_users"
