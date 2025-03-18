#!/bin/bash

echo "Checking for an existing TENBYTE MOTD..."

MOTD_URL="https://raw.githubusercontent.com/tenbyte/motd/refs/heads/main/ubuntu/motd"
MOTD_SCRIPT="/etc/update-motd.d/99-tenbyte-motd"

if [[ -f "$MOTD_SCRIPT" ]] && grep -q "POWERED BY TENBYTE" "$MOTD_SCRIPT"; then
    echo "Existing TENBYTE MOTD found. Overwriting..."
    sudo wget -O "$MOTD_SCRIPT" "$MOTD_URL"
else
    echo "No existing TENBYTE MOTD found or another MOTD is in use. No changes made."
    exit 0
fi

echo "Making the TENBYTE MOTD script executable..."
sudo chmod +x "$MOTD_SCRIPT"

echo "Disabling Ubuntu's default MOTD messages..."
sudo chmod -x /etc/update-motd.d/00-header
sudo chmod -x /etc/update-motd.d/10-help-text
sudo chmod -x /etc/update-motd.d/50-motd-news

echo "Applying the new MOTD..."
run-parts /etc/update-motd.d/

echo "Cleaning up..."
rm -- "$0"

echo "TENBYTE MOTD setup complete!"
echo "Changes will be visible on next login."
