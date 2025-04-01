#!/bin/bash

CYAN="\033[36m"
WHITE="\033[37m"
BOLD="\033[1m"
RESET="\033[0m"

DISTRO=$(awk -F= '/^PRETTY_NAME/ {print $2}' /etc/os-release | tr -d '"')

echo -e "${CYAN}  __ ${RESET}${WHITE}    _             _           _       "
echo -e "${CYAN}  \ \ ${RESET}${WHITE}  | |_ ___ _ __ | |__  _   _| |_ ___ "
echo -e "${CYAN}   \ \ ${RESET}${WHITE} | __/ _ \ '_ \| '_ \| | | | __/ _ \\"
echo -e "${CYAN}   / / ${RESET}${WHITE} | ||  __/ | | | |_) | |_| | ||  __/"
echo -e "${CYAN}  /_/ ${RESET}${WHITE}   \__\___|_| |_|_.__/ \\__, |\\__\\___|"
echo -e "                            |___/         ${RESET}"
echo -e ""
echo -e "${BOLD}${CYAN}       POWERED BY TENBYTE ${RESET}\n"

IP=$(hostname -I | awk '{print $1}')
UPTIME=$(uptime -p)
MEMORY=$(free -h | awk '/Mem/ {print $3 "/" $2}')
LOAD=$(awk '{print $1", "$2", "$3}' /proc/loadavg)
WANIP6=$(curl -s -k -m 5 -6 https://api64.ipify.org)
WANIP4=$(curl -s -k -m 5 -4 https://api64.ipify.org)

echo -e "${WHITE}-----------------------------------------${RESET}"
echo -e "${CYAN}  Hostname:   ${WHITE}$(hostname)${RESET}"
echo -e "${CYAN}  Server IP:  ${WHITE}$IP${RESET}"
echo -e "${CYAN}  WAN IPv4:   ${WHITE}${WANIP4:-N/A}${RESET}"
echo -e "${CYAN}  WAN IPv6:   ${WHITE}${WANIP6:-N/A}${RESET}"
echo -e "${CYAN}  Distro:     ${WHITE}$DISTRO${RESET}"
echo -e "${CYAN}  Uptime:     ${WHITE}$UPTIME${RESET}"
echo -e "${CYAN}  RAM Usage:  ${WHITE}$MEMORY${RESET}"
echo -e "${CYAN}  Load Avg:   ${WHITE}$LOAD${RESET}"
echo -e "${WHITE}-----------------------------------------${RESET}"
