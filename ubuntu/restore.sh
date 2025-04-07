#!/bin/bash

echo "Restoring default Ubuntu MOTD..."

MOTD_SCRIPT="/etc/update-motd.d/99-tenbyte-motd"

if [[ -f "$MOTD_SCRIPT" ]]; then
    echo "Removing TENBYTE MOTD script..."
    sudo rm -f "$MOTD_SCRIPT"
else
    echo "No TENBYTE MOTD script found to remove."
fi

echo "Re-enabling default MOTD scripts..."
sudo chmod +x /etc/update-motd.d/00-header 2>/dev/null
sudo chmod +x /etc/update-motd.d/10-help-text 2>/dev/null
sudo chmod +x /etc/update-motd.d/50-motd-news 2>/dev/null

echo "Applying restored MOTD..."
run-parts /etc/update-motd.d/

echo "Cleanup complete. TENBYTE MOTD has been removed."
echo "Changes will be visible on next login."
