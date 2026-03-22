#!/bin/bash

set -euo pipefail

echo "[TENBYTE] Uninstalling MOTD..."

MOTD_SCRIPT="$HOME/.tenbyte_motd.sh"
ZPROFILE="$HOME/.zprofile"
BASH_PROFILE="$HOME/.bash_profile"

for PROFILE in "$ZPROFILE" "$BASH_PROFILE"; do
    if [[ -f "$PROFILE" ]]; then
        sed -i '' "/TENBYTE MOTD/d" "$PROFILE" 2>/dev/null || true
        sed -i '' "\|$MOTD_SCRIPT|d" "$PROFILE" 2>/dev/null || true
    fi
done

if [[ -f "$MOTD_SCRIPT" ]]; then
    rm -f "$MOTD_SCRIPT"
fi

echo "[TENBYTE] MOTD uninstalled."