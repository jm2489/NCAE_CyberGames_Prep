#!/bin/bash

echo "NJIT NCAE 2025 Web IPTABLES Script"
echo

# Checks if user is root
if [ "$EUID" ne 0 ]
    then echo "This script must be ran as root!"
    exit 1
fi

echo -n "Please enter you ROUTER Ex. 172.x.x.x"
read ROUTER

echo -n "Please enter in backup server IP Address Ex. 192.168.x.x"
read BACKUP

echo -n "Please enter in SQL server IP Address Ex. 192.168.x.x"
read SQL

echo -n "Please enter the port # for SQL server"
read SQL_PORT

#Checks to see if conntrack is enabled
modprobe ip_conntrack
modprobe ip_conntrack_ftp

iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

#OUTPUT Connections
iptables -I OUTPUT -d $SQL -m conntrack --ctstate NEW, ESTABLISHED -j ACCEPT
iptables -A OUTPUT -d 172.16.0.0/12 -m  --ctstate  NEW,INVALID -j REJECT
iptables -A OUTPUT -d 192.168.0.0/16 -m  --ctstate  NEW,INVALID -j REJECT

iptables -I INPUT -p tcp --dport 80 -m  --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -I INPUT -p tcp --dport 443 -m --ctstate NEW,ESTABLISHED -j ACCEPT

iptables -I INPUT -s $POINT_SERVER -m conntrack --ctstate NEW, ESTABLISHED -j ACCEPT
iptables -I INPUT -s $ROUTER -p tcp --dport 22 --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -I INPUT -s $BACKUP -p tcp --dport 22 --ctstate NEW,ESTABLISHED -j ACCEPT

iptables -P FORWARD DROP
iptables -P INPUT DROP