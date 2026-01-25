#!/bin/bash

# --- 🛰️ CONFIGURATION 🛰️ ---
WEBHOOK_URL="https://discord.com/api/webhooks/1464868830651089021/3WX6UFa4rS9rWhAIVPRoNqtqpz9zdQrer-_1C3Sy8GciThv5Iwu0t_PFNj0xP4MOZBCH"

# --- COLORS ---
GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

# --- 1. INPUT VALIDATION ---
# স্ক্রিপ্ট রান করার সময় আইপি না দিলে সে চাইবে
TARGET_IP=$1
if [ -z "$TARGET_IP" ]; then
    echo -e "${CYAN}Enter Suspicious IP Address:${NC}"
    read TARGET_IP
fi

echo -e "${CYAN}Analyzing Target: $TARGET_IP ...${NC}"

# --- 2. THE TRACKER (Data Gathering) ---
# ip-api থেকে তথ্য আনা হচ্ছে
API_DATA=$(curl -s "http://ip-api.com/json/$TARGET_IP")
STATUS=$(echo $API_DATA | jq -r '.status')

if [ "$STATUS" == "fail" ]; then
    echo -e "${RED}[Error] Could not track IP. Private or Invalid.${NC}"
    exit 1
fi

# jq দিয়ে তথ্য আলাদা করা (Extracting Data)
COUNTRY=$(echo $API_DATA | jq -r '.country')
CITY=$(echo $API_DATA | jq -r '.city')
ISP=$(echo $API_DATA | jq -r '.isp')
LAT=$(echo $API_DATA | jq -r '.lat')
LON=$(echo $API_DATA | jq -r '.lon')
MAPS_LINK="https://www.google.com/maps?q=$LAT,$LON"

echo -e "${GREEN}✔ Data Extracted. Building Report...${NC}"

# --- 3. THE MESSENGER (Sending Alert) ---

# Discord JSON Payload তৈরি (Dynamic Data দিয়ে)
JSON_PAYLOAD=$(jq -n \
  --arg title "🕵️‍♂️ INTRUDER LOCATED" \
  --arg desc "Night Watchman has traced a suspicious connection." \
  --arg ip "$TARGET_IP" \
  --arg loc "$CITY, $COUNTRY" \
  --arg isp "$ISP" \
  --arg maps "$MAPS_LINK" \
  --arg time "$(date '+%Y-%m-%d %H:%M:%S')" \
  '{
    username: "Night Watchman",
    avatar_url: "https://cdn-icons-png.flaticon.com/512/3067/3067788.png",
    embeds: [{
      title: $title,
      description: $desc,
      color: 16711680,
      fields: [
        { name: "🏴‍☠️ Target IP", value: $ip, inline: true },
        { name: "🌍 Location", value: $loc, inline: true },
        { name: "🏢 ISP/Org", value: $isp, inline: false },
        { name: "📍 Geo-Coordinates", value: $maps, inline: false },
        { name: "⏰ Detection Time", value: $time, inline: false }
      ],
      footer: { text: "HellBox Security Protocol v1.0" }
    }]
  }'
)

# Discord-এ পাঠানো
curl -s -H "Content-Type: application/json" \
     -X POST \
     -d "$JSON_PAYLOAD" \
     $WEBHOOK_URL > /dev/null

echo -e "\n${GREEN}🚀 ALERT SENT TO DISCORD! Check your channel.${NC}"
