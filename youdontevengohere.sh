#!/bin/bash

# Get the user's username
USER=$(whoami)

# Get the current date and time
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Log file location - somewhere that it can be written to.
LOGFILE="/var/log/hellothere.log"

# This will append every command the user types to the log file
# Format: user: command (date and time)
trap 'echo "${USER}: $(history 1 | sed "s/^[ ]*[0-9]\+[ ]*//") (${TIMESTAMP})" >> ${LOGFILE}' DEBUG
