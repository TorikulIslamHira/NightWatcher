#!/bin/bash

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

# --- Check for jq ---
if ! command -v jq &> /dev/null; then
    echo -e "${RED}[Error] jq is not installed!${NC}"
    echo "Please run: sudo apt install jq -y"
    exit 1
fi

clear
echo -e "${CYAN}=======================================${NC}"
echo -e "${CYAN}   🛰️  NIGHT WATCHMAN: GEO-TRACKER    ${NC}"
echo -e "${CYAN}=======================================${NC}"

# 1. Ask for IP Input
echo -e "${YELLOW}Enter a Suspicious IP Address to track:${NC}"
read -p "IP > " TARGET_IP

if [ -z "$TARGET_IP" ]; then
    echo -e "${RED}[!] No IP provided. Exiting.${NC}"
    exit 1
fi

echo -e "\n${GREEN}[*] Tracking signal sent to satellite...${NC}"
sleep 1

# 2. Fetch Data using API (curl)
# -s = Silent (প্রোগ্রেস বার দেখাবে না)
RESPONSE=$(curl -s "http://ip-api.com/json/$TARGET_IP")

# 3. Check Status using jq
STATUS=$(echo $RESPONSE | jq -r '.status')

if [ "$STATUS" == "fail" ]; then
    echo -e "${RED}[!] Tracking Failed. Invalid IP or Private Network.${NC}"
else
    # 4. Extract Info using jq
    COUNTRY=$(echo $RESPONSE | jq -r '.country')
    CITY=$(echo $RESPONSE | jq -r '.city')
    ISP=$(echo $RESPONSE | jq -r '.isp')
    LAT=$(echo $RESPONSE | jq -r '.lat')
    LON=$(echo $RESPONSE | jq -r '.lon')
    
    # 5. Display Report
    echo -e "\n${YELLOW}--- 🎯 TARGET LOCATED ---${NC}"
    echo -e "Location : ${RED}$CITY, $COUNTRY${NC}"
    echo -e "ISP      : $ISP"
    echo -e "Coords   : $LAT, $LON"
    echo -e "${CYAN}-------------------------${NC}"
fi
