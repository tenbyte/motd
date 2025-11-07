#!/bin/bash

CYAN="\033[36m"
WHITE="\033[0m"
BOLD="\033[1m"
RESET="\033[0m"

DISTRO=$(sw_vers -productName)" "$(sw_vers -productVersion)
LOCALIP4=$(ipconfig getifaddr en0 2>/dev/null) # Holt lokale IPv4 (en0 auf Mac)
WANIP4=$(curl -s --connect-timeout 1 --max-time 2 https://ipv4.tenbyte.dev/plain || echo "N/A")
WANIP6=$(curl -s --connect-timeout 1 --max-time 2 https://ipv6.tenbyte.dev/plain || echo "N/A")
UPTIME=$(uptime | awk -F'( |,|:)+' '{print $6 "h " $7 "m"}')
LOAD=$(uptime | awk -F'load averages?: ' '{print $2}')

echo -e "${CYAN}  __ ${RESET}${WHITE}    _             _           _       "
echo -e "${CYAN}  \ \ ${RESET}${WHITE}  | |_ ___ _ __ | |__  _   _| |_ ___ "
echo -e "${CYAN}   \ \ ${RESET}${WHITE} | __/ _ \ '_ \| '_ \| | | | __/ _ \\"
echo -e "${CYAN}   / / ${RESET}${WHITE} | ||  __/ | | | |_) | |_| | ||  __/"
echo -e "${CYAN}  /_/ ${RESET}${WHITE}   \__\___|_| |_|_.__/ \\__, |\\__\\___|"
echo -e "                            |___/         ${RESET}"
echo -e ""
echo -e "${BOLD}${CYAN}       POWERED BY TENBYTE ${RESET}\n"

echo -e "${WHITE}-----------------------------------------${RESET}"
echo -e "${CYAN}  Hostname:   ${WHITE}$(scutil --get LocalHostName)${RESET}"
echo -e "${CYAN}  WAN IPv4:   ${WHITE}${WANIP4:-N/A}${RESET}"
echo -e "${CYAN}  WAN IPv6:   ${WHITE}${WANIP6:-N/A}${RESET}"
echo -e "${CYAN}  Local IPv4: ${WHITE}${LOCALIP4:-N/A}${RESET}"
echo -e "${CYAN}  Distro:     ${WHITE}${DISTRO}${RESET}"
echo -e "${CYAN}  Uptime:     ${WHITE}${UPTIME}${RESET}"
echo -e "${CYAN}  Load Avg:   ${WHITE}${LOAD}${RESET}"
echo -e "${WHITE}-----------------------------------------${RESET}"
