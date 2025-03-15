#!/bin/bash

echo "NJIT NCAE 2025 FTP IPTABLES Script"
echo

# Checks if user is root
if [ "$EUID" ne 0 ]
    then echo "This script must be ran as root!"
    exit 1
fi

ROUTER="192.168.4.1"
BACKUP="192.168.4.15"

#Checks to see if conntrack is enabled
modprobe ip_conntrack
modprobe ip_conntrack_ftp

iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

#OUTPUT Connections
iptables -A OUTPUT -d 172.16.0.0/12 -m conntrack --ctstate NEW,INVALID -j REJECT
iptables -A OUTPUT -d 192.168.0.0/16 -m conntrack --ctstate NEW,INVALID -j REJECT

iptables -A OUTPUT -p tcp --sport 20 -j ACCEPT

iptables -I INPUT -p tcp --dport 21 -j ACCEPT
    
iptables -I INPUT -s $ROUTER -p tcp --dport 22 -j ACCEPT
iptables -I INPUT -s $BACKUP -p tcp --dport 22 -j ACCEPT

iptables -P FORWARD DROP
iptables -P INPUT DROP