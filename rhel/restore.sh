#!/bin/bash

echo "Restoring default RHEL MOTD..."

MOTD_SCRIPT="/etc/profile.d/tenbyte-motd.sh"

if [[ -f "$MOTD_SCRIPT" ]]; then
    echo "Removing TENBYTE MOTD script..."
    sudo rm -f "$MOTD_SCRIPT"
else
    echo "No TENBYTE MOTD script found to remove."
fi

echo "TENBYTE MOTD has been removed."
echo "Changes will be visible on next login."

echo "Cleaning up..."
rm -- "$0"
