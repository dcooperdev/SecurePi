#!/bin/bash

# Ask the user if they want to enable RaspAP
read -p "Do you want to enable RaspAP? (y/n): " ENABLE_RASPAP
if [[ "$ENABLE_RASPAP" == "y" ]]; then
    curl -sL https://install.raspap.com | bash
fi

touch ap