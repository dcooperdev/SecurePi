#!/bin/bash

# Ask the user for the new username
read -p "Enter the new username: " NEW_USER

# Change the default password
echo "Change the current password for $NEW_USER"
passwd

# Change the default username
sudo useradd -m "$NEW_USER" -G sudo
sudo passwd "$NEW_USER"

# Configure sudoers for the new user
sudo visudo

# Remove the "pi" user
sudo deluser pi
sudo deluser --remove-home pi