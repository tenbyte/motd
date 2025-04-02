#!/bin/bash

echo "🔧 Checking for existing TENBYTE MOTD..."

MOTD_URL="https://raw.githubusercontent.com/tenbyte/motd/refs/heads/main/mac/tenbyte-motd.sh"
MOTD_SCRIPT="$HOME/.tenbyte_motd.sh"
ZPROFILE="$HOME/.zprofile"

sed -i '' "/TENBYTE MOTD/d" "$ZPROFILE" 2>/dev/null || true
sed -i '' "\|$MOTD_SCRIPT|d" "$ZPROFILE" 2>/dev/null || true

echo "⬇️  Downloading latest TENBYTE MOTD..."
curl -fsSL "$MOTD_URL" -o "$MOTD_SCRIPT"

chmod +x "$MOTD_SCRIPT"

echo -e "\n# TENBYTE MOTD\n$MOTD_SCRIPT" >> "$ZPROFILE"

echo "✅ TENBYTE MOTD installed!"
echo "➡️  Restart your Terminal or run:"
echo "   $MOTD_SCRIPT"

echo "🧹 Cleaning up..."
rm -- "$0"
