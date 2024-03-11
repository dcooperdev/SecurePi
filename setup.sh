#!/bin/bash

change_status() {
    rm -f status.txt
    echo $1 > status.txt
}

currentPath=$(pwd)

# Directory where the files are located
directory="$currentPath/src"

# Filter files that follow the "number-name.sh" format
files=$(find "$directory" -type f -name '[0-9]*-*.sh')

# Sort the file names alphabetically
sorted_names=$(echo "$files" | tr ' ' '\n' | sort)

# Print the sorted list
# echo "$sorted_names"

if [ ! -f status.txt ]; then
    change_status start
fi

status=$(<status.txt)

case $status in
    start)
        echo "Starting configuration"
        change_status 'update'
        ;;
    update)
        echo "Resuming in step update configuration"
        change_status 'user'
        # Agrega aquí los comandos que deseas ejecutar para la opción 2
        ;;
    user)
        echo "Resuming in user configuration"
        change_status 'firewall'
        # Agrega aquí los comandos que deseas ejecutar para la opción 3
        ;;
    firewall)
        echo "Resuming in firewall configuration"
        change_status 'ap'
        # Agrega aquí los comandos que deseas ejecutar para la opción 4
        ;;
    ap)
        echo "Resuming in step ap configuration"
        change_status 'configured'
        ;;
    configured)
        echo "All is configured; Remove the configured file to reset script."
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