#!/bin/bash

currentPath=$(pwd)

# Directory where the files are located
directory="$currentPath/src"

# Filter files that follow the "number-name.sh" format
files=$(find "$directory" -type f -name '[0-9]*-*.sh')

# Sort the file names alphabetically
sorted_names=$(echo "$files" | tr ' ' '\n' | sort)

# Print the sorted list
echo "$sorted_names"

touch start

if [ -f "start" ]; then
/bin/bash $sorted_names[0]
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

# Other security configurations (optional):
# - SELinux or AppArmor
# - More specific firewall rules
# - Security monitoring tools

# Done! The system is now configured with enhanced security.