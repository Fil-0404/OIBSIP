#!/bin/bash

# Basic UFW Firewall Configuration
# Oasis Infobyte - Security Analyst Task 2

echo "Configuring UFW firewall..."

# Set default policies
sudo ufw default deny incoming
sudo ufw default allow outgoing

# Allow SSH traffic on port 22
sudo ufw allow ssh

# Deny HTTP traffic on port 80
sudo ufw deny http

# Allow HTTPS traffic on TCP port 443
sudo ufw allow 443/tcp

# Deny TCP traffic from the Kali VM to port 8080
sudo ufw deny from 192.168.122.166 to any port 8080 proto tcp

# Enable the firewall
sudo ufw --force enable

echo "Firewall configuration complete."

# Display the active firewall configuration
sudo ufw status verbose
