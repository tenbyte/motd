#!/bin/bash

set -euo pipefail

echo "[TENBYTE] Uninstalling MOTD..."

MOTD_SCRIPT="$HOME/.tenbyte_motd.sh"
ZPROFILE="$HOME/.zprofile"
BASH_PROFILE="$HOME/.bash_profile"
ZSHRC="$HOME/.zshrc"
PROMPT_LINE="PROMPT='%F{cyan}󰄾%f %F{white}%n%f %F{blue}❯%f '"

for PROFILE in "$ZPROFILE" "$BASH_PROFILE"; do
    if [[ -f "$PROFILE" ]]; then
        sed -i '' "/TENBYTE MOTD/d" "$PROFILE" 2>/dev/null || true
        sed -i '' "\|$MOTD_SCRIPT|d" "$PROFILE" 2>/dev/null || true
    fi
done

if [[ -f "$ZSHRC" ]]; then
    sed -i '' "/TENBYTE PROMPT/d" "$ZSHRC" 2>/dev/null || true
    sed -i '' "\|$PROMPT_LINE|d" "$ZSHRC" 2>/dev/null || true
fi

if [[ -f "$MOTD_SCRIPT" ]]; then
    rm -f "$MOTD_SCRIPT"
fi

echo "[TENBYTE] MOTD uninstalled."