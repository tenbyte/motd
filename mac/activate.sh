#!/bin/bash

echo "🔧 Checking for existing TENBYTE MOTD..."

MOTD_URL="https://raw.githubusercontent.com/tenbyte/motd/refs/heads/main/mac/tenbyte-motd.sh"
MOTD_SCRIPT="$HOME/.tenbyte_motd.sh"
ZPROFILE="$HOME/.zprofile"
BASH_PROFILE="$HOME/.bash_profile"

for PROFILE in "$ZPROFILE" "$BASH_PROFILE"; do
    if [[ -f "$PROFILE" ]]; then
        echo "🧹 Cleaning old TENBYTE entries from $PROFILE..."
        sed -i '' "/TENBYTE MOTD/d" "$PROFILE" 2>/dev/null || true
        sed -i '' "\|$MOTD_SCRIPT|d" "$PROFILE" 2>/dev/null || true
    fi
done

echo "⬇️  Downloading latest TENBYTE MOTD..."
curl -fsSL "$MOTD_URL" -o "$MOTD_SCRIPT"

chmod +x "$MOTD_SCRIPT"

for PROFILE in "$ZPROFILE" "$BASH_PROFILE"; do
    echo "➕ Adding TENBYTE MOTD to $PROFILE..."
    touch "$PROFILE"
    echo -e "\n# TENBYTE MOTD\n$MOTD_SCRIPT" >> "$PROFILE"
done

echo "✅ TENBYTE MOTD installed!"
echo "➡️  Restart your Terminal or run:"
echo "   $MOTD_SCRIPT"

echo "🧹 Cleaning up..."
rm -- "$0"
