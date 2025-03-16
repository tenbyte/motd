#!/bin/bash

echo "Setting up TENBYTE custom MOTD..."

MOTD_URL="https://raw.githubusercontent.com/tenbyte/modt/refs/heads/main/ubuntu/modt"
MOTD_SCRIPT="/etc/update-motd.d/99-tenbyte-motd"

echo "Downloading MOTD script..."
sudo wget -O "$MOTD_SCRIPT" "$MOTD_URL"

echo "Making the MOTD script executable..."
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
