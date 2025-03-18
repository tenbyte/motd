#!/bin/bash

echo "Checking for an existing TENBYTE MOTD..."

MOTD_URL="https://raw.githubusercontent.com/tenbyte/motd/refs/heads/main/ubuntu/motd"
MOTD_SCRIPT="/etc/update-motd.d/99-tenbyte-motd"

if [[ -f "$MOTD_SCRIPT" ]]; then
    echo "Existing TENBYTE MOTD found. Overwriting..."
else
    echo "No TENBYTE MOTD found. Adding a new one..."
fi

# Download oder Überschreiben des MOTD
sudo wget -O "$MOTD_SCRIPT" "$MOTD_URL"

echo "Making the TENBYTE MOTD script executable..."
sudo chmod +x "$MOTD_SCRIPT"

echo "Disabling Ubuntu's default MOTD messages..."
sudo chmod -x /etc/update-motd.d/00-header 2>/dev/null
sudo chmod -x /etc/update-motd.d/10-help-text 2>/dev/null
sudo chmod -x /etc/update-motd.d/50-motd-news 2>/dev/null

echo "Applying the new MOTD..."
run-parts /etc/update-motd.d/

echo "Cleaning up..."
rm -- "$0"

echo "TENBYTE MOTD setup complete!"
echo "Changes will be visible on next login."
