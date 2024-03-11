#!/bin/bash

# Install and configure UFW (firewall)
sudo apt install -y ufw
sudo ufw allow ssh

# Ask the user if they want to enable HTTP
read -p "Do you want to enable HTTP? (y/n): " ENABLE_HTTP
if [[ "$ENABLE_HTTP" == "y" ]]; then
    sudo ufw allow http
fi

# Ask the user if they want to enable HTTPS
read -p "Do you want to enable HTTPS? (y/n): " ENABLE_HTTPS
if [[ "$ENABLE_HTTPS" == "y" ]]; then
    sudo ufw allow https
fi

sudo ufw enable