#!/bin/bash

next_step() {
    rm -f status.txt
    echo $1 > status.txt
}

configure_user() {
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
}

configure_firewall() {
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
}

configure_ap() {
    # Ask the user if they want to enable RaspAP
    read -p "Do you want to enable RaspAP? (y/n): " ENABLE_RASPAP
    if [[ "$ENABLE_RASPAP" == "y" ]]; then
        curl -sL https://install.raspap.com | bash
    fi
}

if [ ! -f status.txt ]; then
    next_step start
fi

status=$(<status.txt)

case $status in
    start)
        echo "Starting configuration"
        next_step 'update'
        sudo apt update
        sudo apt full-upgrade
        sudo reboot
        ;;
    update)
        echo "Resuming in step update configuration"
        next_step 'user'
        configure_user
        ;;
    user)
        echo "Resuming in user configuration"
        next_step 'firewall'
        configure_firewall
        ;;
    firewall)
        echo "Resuming in ap configuration"
        next_step 'ap'
        configure_ap
        ;;
    ap)
        echo "All is configured; Remove the configured file to reset script."
        next_step 'configured'
        ;;
    *)
        echo "Status not found or corrupted. Delete status.txt file and re run the script."
        ;;
esac

: <<'END_COMMENT'

if [ -f "start" ]; then

sudo apt update
sudo apt full-upgrade

touch update

#sudo reboot

touch user
rm start
echo "Resuming in user configuration"
fi

if [ -f "user" ]; then
touch firewall
rm user
echo "Resuming in firewall configuration"
fi

if [ -f "firewall" ]; then
touch ap
rm firewall
echo "Resuming in step ap configuration"
fi

if [ -f "ap" ]; then
rm ap
touch configured
echo "All is configured; Remove the configured file to reset script."
fi

END_COMMENT

# Other security configurations (optional):
# - SELinux or AppArmor
# - More specific firewall rules
# - Security monitoring tools

# Done! The system is now configured with enhanced security.