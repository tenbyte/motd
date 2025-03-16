#!/bin/bash

echo "Setting up TENBYTE custom MOTD..."
echo ""

CYAN="\033[36m"
BLUE="\033[34m"
WHITE="\033[37m"
BOLD="\033[1m"
RESET="\033[0m"

MOTD_SCRIPT="/etc/update-motd.d/99-tenbyte-motd"

echo "Creating new MOTD script at $MOTD_SCRIPT..."

cat << 'EOF' | sudo tee $MOTD_SCRIPT > /dev/null
#!/bin/bash

CYAN="\033[36m"
BLUE="\033[34m"
WHITE="\033[37m"
BOLD="\033[1m"
RESET="\033[0m"

echo -e "${CYAN}  __ ${RESET}${WHITE}    _             _           _       "
echo -e "${CYAN}  \ \ ${RESET}${WHITE}  | |_ ___ _ __ | |__  _   _| |_ ___ "
echo -e "${CYAN}   \ \ ${RESET}${WHITE} | __/ _ \ '_ \| '_ \| | | | __/ _ \\"
echo -e "${CYAN}   / / ${RESET}${WHITE} | ||  __/ | | | |_) | |_| | ||  __/"
echo -e "${CYAN}  /_/ ${RESET}${WHITE}   \__\___|_| |_|_.__/ \\__, |\\__\\___|"
echo -e "                            |___/         ${RESET}"
echo -e ""
echo -e "${BOLD}${BLUE}       POWERED BY TENBYTE ${RESET}\n"

IP=$(hostname -I | awk '{print $1}')
UPTIME=$(uptime -p)
MEMORY=$(free -h | grep Mem | awk '{print $3 "/" $2}')
LOAD=$(cat /proc/loadavg | awk '{print $1", "$2", "$3}')
USERS=$(who | wc -l)

echo -e "${WHITE}-----------------------------------------${RESET}"
echo -e "${BLUE}  Hostname:   ${WHITE}$(hostname)${RESET}"
echo -e "${BLUE}  Server IP:  ${WHITE}$IP${RESET}"
echo -e "${BLUE}  Uptime:     ${WHITE}$UPTIME${RESET}"
echo -e "${BLUE}  RAM Usage:  ${WHITE}$MEMORY${RESET}"
echo -e "${BLUE}  Load Avg:   ${WHITE}$LOAD${RESET}"
echo -e "${WHITE}-----------------------------------------${RESET}"
EOF

echo "Making the MOTD script executable..."
sudo chmod +x $MOTD_SCRIPT

echo "Disabling Ubuntu's default MOTD messages..."
sudo chmod -x /etc/update-motd.d/00-header
sudo chmod -x /etc/update-motd.d/10-help-text
sudo chmod -x /etc/update-motd.d/50-motd-news

echo "Applying the new MOTD..."
run-parts /etc/update-motd.d/

echo ""
echo "TENBYTE MOTD setup complete!"
echo "ℹChanges will be visible on next login."
