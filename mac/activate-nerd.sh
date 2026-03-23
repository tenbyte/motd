#!/bin/bash

set -euo pipefail

echo "[TENBYTE] Installing Nerd MOTD..."

MOTD_URL="https://raw.githubusercontent.com/tenbyte/motd/refs/heads/main/mac/tenbyte-motd-nerd.sh"
MOTD_SCRIPT="$HOME/.tenbyte_motd.sh"
ZPROFILE="$HOME/.zprofile"
BASH_PROFILE="$HOME/.bash_profile"
ZSHRC="$HOME/.zshrc"
PROMPT_LINE="PROMPT='%F{cyan}󰄾%f %F{white}%n%f %F{blue}%~%f %F{blue}❯%f '"

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

curl -fsSL "$MOTD_URL" -o "$MOTD_SCRIPT"
chmod +x "$MOTD_SCRIPT"

for PROFILE in "$ZPROFILE" "$BASH_PROFILE"; do
    touch "$PROFILE"
    {
        echo ""
        echo "# TENBYTE MOTD"
        echo "$MOTD_SCRIPT"
    } >> "$PROFILE"
done

touch "$ZSHRC"
{
    echo ""
    echo "# TENBYTE PROMPT"
    echo "$PROMPT_LINE"
} >> "$ZSHRC"

if command -v brew >/dev/null 2>&1; then
    if brew list --cask font-hack-nerd-font >/dev/null 2>&1; then
        echo "[TENBYTE] Nerd Font already installed (font-hack-nerd-font)."
    else
        echo "[TENBYTE] Installing Nerd Font (font-hack-nerd-font)..."
        brew install --cask font-hack-nerd-font || echo "[TENBYTE] Could not install font automatically."
    fi
else
    echo "[TENBYTE] Homebrew not found. Install a Nerd Font manually for best icon support."
fi

echo "[TENBYTE] Nerd MOTD installed."
echo "[TENBYTE] Restart terminal or run: $MOTD_SCRIPT"