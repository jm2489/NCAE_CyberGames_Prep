#!/bin/bash

echo "NJIT NCAE 2025 FTP UFW Script"
echo

# Checks if user is root
if [ "$EUID" ne 0 ]
    then echo "This script must be ran as root!"
    exit 1
fi

echo -n "Please enter you jump host Ex. 172.x.x.x"
read JUMPHOST

echo -n "Please enter in backup server IP Address Ex. 192.168.x.x"
read BACKUP

ufw enable
ufw allow port 21/tcp
ufw allow $JUMPHOST to any port 22/tcp
ufw allow $BACKUP to any port 22/tcp
ufw allow 40000:50000/tcp
ufw allow 990/tcp
ufw deny out to 172.16.0.0/12
ufw deny out to 192.168.0.0/16
ufw status


