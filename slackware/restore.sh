#!/bin/bash

echo "Restoring default Slackware/unRAID MOTD..."

MOTD_SCRIPT="/etc/profile.d/tenbyte-motd.sh"

if [[ -f "$MOTD_SCRIPT" ]]; then
    echo "Removing TENBYTE MOTD script..."
    rm -f "$MOTD_SCRIPT"
else
    echo "No TENBYTE MOTD script found to remove."
fi

echo "Cleanup complete. TENBYTE MOTD has been removed."
echo "Changes will be visible on next login."