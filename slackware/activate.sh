#!/bin/bash

echo "Checking for an existing TENBYTE MOTD..."

MOTD_URL="https://raw.githubusercontent.com/tenbyte/motd/refs/heads/main/slackware/tenbyte-motd.sh"
MOTD_SCRIPT="/etc/profile.d/tenbyte-motd.sh"

if [[ -f "$MOTD_SCRIPT" ]]; then
    echo "Existing TENBYTE MOTD found. Overwriting..."
else
    echo "No TENBYTE MOTD found. Adding a new one..."
fi

wget -O "$MOTD_SCRIPT" "$MOTD_URL"

echo "Making the TENBYTE MOTD script executable..."
chmod +x "$MOTD_SCRIPT"

echo "TENBYTE MOTD setup complete!"
echo "Changes will be visible on next login."

echo "Cleaning up..."
rm -- "$0"