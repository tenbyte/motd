#!/bin/bash

CYAN="\033[36m"
BLUE="\033[0;34m"
WHITE="\033[37m"
BOLD="\033[1m"
DIM="\033[2m"
RESET="\033[0m"

LABEL_WIDTH=11
VALUE_WIDTH=22

HOSTNAME=$(scutil --get LocalHostName 2>/dev/null || hostname)
OS_NAME=$(sw_vers -productName)
OS_VERSION=$(sw_vers -productVersion)
DISTRO="${OS_NAME} ${OS_VERSION}"
CPU=$(sysctl -n machdep.cpu.brand_string 2>/dev/null)
MEM_BYTES=$(sysctl -n hw.memsize 2>/dev/null)
SHELL_NAME=$(basename "${SHELL:-unknown}")

LOCALIP4=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null)
WANIP4=$(curl -s --connect-timeout 1 --max-time 2 https://ipv4.tenbyte.dev/plain)
WANIP6=$(curl -s --connect-timeout 1 --max-time 2 https://ipv6.tenbyte.dev/plain)

UPTIME=$(uptime | awk -F'( |,|:)+' '{print $6 "h " $7 "m"}')

if [ -n "$MEM_BYTES" ]; then
	MEM_GB=$((MEM_BYTES / 1024 / 1024 / 1024))
	RAM="${MEM_GB} GB"
else
	RAM="unknown"
fi

print_row() {
	local icon="$1"
	local label="$2"
	local value="$3"
	value=$(printf "%s" "$value" | tr '\n\t' '  ')
	printf "${WHITE}| ${BLUE}%-2s ${CYAN}%-*.*s   ${WHITE}| ${WHITE}%-*.*s ${WHITE}|${RESET}\n" \
		"$icon" "$LABEL_WIDTH" "$LABEL_WIDTH" "$label" "$VALUE_WIDTH" "$VALUE_WIDTH" "$value"
}

repeat_char() {
	local count="$1"
	local char="$2"
	printf '%*s' "$count" '' | sed "s/ /$char/g"
}

print_top_border() {
	printf "${WHITE}+"
	repeat_char $((LABEL_WIDTH + 6)) "-"
	printf "+"
	repeat_char $((VALUE_WIDTH + 2)) "-"
	printf "+${RESET}\n"
}

print_bottom_border() {
	printf "${WHITE}+"
	repeat_char $((LABEL_WIDTH + 6)) "-"
	printf "+"
	repeat_char $((VALUE_WIDTH + 2)) "-"
	printf "+${RESET}\n"
}

echo -e "${CYAN}  __ ${RESET}${WHITE}    _             _           _       "
echo -e "${CYAN}  \ \ ${RESET}${WHITE}  | |_ ___ _ __ | |__  _   _| |_ ___ "
echo -e "${CYAN}   \ \ ${RESET}${WHITE} | __/ _ \ '_ \| '_ \| | | | __/ _ \\"
echo -e "${CYAN}   / / ${RESET}${WHITE} | ||  __/ | | | |_) | |_| | ||  __/"
echo -e "${CYAN}  /_/ ${RESET}${WHITE}   \__\___|_| |_|_.__/ \\__, |\\__\\___|"
echo -e "                              |___/         ${RESET}"
echo -e "${BOLD}${CYAN}       POWERED BY TENBYTE ${RESET}\n"

print_top_border

print_row "" "OS" "$DISTRO"
print_row "󰌢" "Host" "$HOSTNAME"
print_row "" "CPU+RAM" "$CPU | $RAM"
print_row "" "Shell" "$SHELL_NAME"
print_row "󰔟" "Uptime" "$UPTIME"

[ -n "$LOCALIP4" ] && print_row "󰩟" "Local IPv4" "$LOCALIP4"
[ -n "$WANIP4" ] && print_row "󰖟" "WAN IPv4" "$WANIP4"
[ -n "$WANIP6" ] && print_row "󰖟" "WAN IPv6" "$WANIP6"

print_bottom_border
