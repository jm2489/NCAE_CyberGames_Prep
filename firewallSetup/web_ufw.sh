#!/bin/bash

echo "NJIT NCAE 2025 Web UFW Script"
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

echo -n "Please enter in SQL server IP Address Ex. 192.168.x.x"
read SQL

echo -n "Please enter the port # for SQL server"
read SQL_PORT

ufw enable
ufw allow port 80
ufw allow port 443
ufw allow $JUMPHOST to any port 22/tcp
ufw allow $BACKUP to any port 22/tcp
ufw allow $SQL to any port $SQL_PORT
ufw deny out to 172.16.0.0/12
ufw deny out to 192.168.0.0/16
ufw status
