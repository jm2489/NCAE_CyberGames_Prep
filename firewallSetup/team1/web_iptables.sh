#!/bin/bash

echo "NJIT NCAE 2025 Web IPTABLES Script"
echo

# Checks if user is root
if [ "$EUID" ne 0 ]
    then echo "This script must be ran as root!"
    exit 1
fi

ROUTER="192.168.4.1"

BACKUP="192.168.4.15"

SQL="192.168.4.7"

SQL_PORT="5432"

CERT_SRV="172.18.0.38"

DNS="192.168.4.12"

#Checks to see if conntrack is enabled
modprobe ip_conntrack

iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

#OUTPUT Connections
iptables -I OUTPUT -d $SQL -m conntrack --ctstate NEW, ESTABLISHED -j ACCEPT
iptables -I OUTPUT -d $DNS -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -I OUTPUT -d $CERT_SRV -m conntrack --ctstate NEW,ESTABLISHED -j ACCECPT
iptables -A OUTPUT -d 172.16.0.0/12 -m  --ctstate  NEW,INVALID -j REJECT
iptables -A OUTPUT -d 192.168.0.0/16 -m  --ctstate  NEW,INVALID -j REJECT

iptables -I INPUT -p tcp --dport 80 -m  --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -I INPUT -p tcp --dport 443 -m --ctstate NEW,ESTABLISHED -j ACCEPT

iptables -I INPUT -s $ROUTER -p tcp --dport 22 --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -I INPUT -s $BACKUP -p tcp --dport 22 --ctstate NEW,ESTABLISHED -j ACCEPT

iptables -P FORWARD DROP
iptables -P INPUT DROP