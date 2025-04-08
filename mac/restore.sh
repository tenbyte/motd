#!/bin/bash

echo "🔁 Uninstalling TENBYTE MOTD..."

MOTD_SCRIPT="$HOME/.tenbyte_motd.sh"
ZPROFILE="$HOME/.zprofile"
BASH_PROFILE="$HOME/.bash_profile"

for PROFILE in "$ZPROFILE" "$BASH_PROFILE"; do
    if [[ -f "$PROFILE" ]]; then
        echo "🧹 Cleaning TENBYTE entries from $PROFILE..."
        sed -i '' "/TENBYTE MOTD/d" "$PROFILE" 2>/dev/null || true
        sed -i '' "\|$MOTD_SCRIPT|d" "$PROFILE" 2>/dev/null || true
    fi
done

if [[ -f "$MOTD_SCRIPT" ]]; then
    echo "🗑️  Deleting $MOTD_SCRIPT..."
    rm "$MOTD_SCRIPT"
else
    echo "ℹ️  MOTD script not found – already removed?"
fi

echo "✅ TENBYTE MOTD uninstalled!"
echo "🧹 Cleaning up..."
rm -- "$0"
