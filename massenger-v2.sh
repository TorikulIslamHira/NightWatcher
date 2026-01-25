#!/bin/bash

# --- Configuration ---
WEBHOOK_URL="https://discord.com/api/webhooks/1464868830651089021/3WX6UFa4rS9rWhAIVPRoNqtqpz9zdQrer-_1C3Sy8GciThv5Iwu0t_PFNj0xP4MOZBCH"

# ডাইনামিক তথ্য (Testing এর জন্য)
SERVER_NAME=$(hostname)
CURRENT_USER=$(whoami)
DATE=$(date '+%Y-%m-%d %H:%M:%S')
IP_ADDRESS="192.168.1.105" # পরে আমরা এটা অটোমেটিক বের করব

# --- Colors for Terminal ---
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}Constructing Rich Embed Payload...${NC}"

# --- The Payload Logic (Advanced JSON) ---
# Discord Embed Structure ব্যবহার করা হচ্ছে
# Color: 16711680 (Decimal for Red)
# Fields: টেবিলের মতো তথ্য সাজানোর জন্য

JSON_PAYLOAD=$(jq -n \
  --arg title "🛑 SECURITY INTRUSION DETECTED" \
  --arg desc "The Sentinel System has blocked a suspicious login attempt." \
  --arg color 16711680 \
  --arg server "$SERVER_NAME" \
  --arg user "$CURRENT_USER" \
  --arg ip "$IP_ADDRESS" \
  --arg time "$DATE" \
  '{
    username: "Night Watchman",
    avatar_url: "https://cdn-icons-png.flaticon.com/512/2991/2991195.png",
    embeds: [{
      title: $title,
      description: $desc,
      color: ($color | tonumber),
      thumbnail: {
        url: "https://cdn-icons-png.flaticon.com/512/10309/10309204.png"
      },
      fields: [
        {
          name: "📡 Server Host",
          value: $server,
          inline: true
        },
        {
          name: "👤 Target User",
          value: $user,
          inline: true
        },
        {
          name: "🏴‍☠️ Suspicious IP",
          value: $ip,
          inline: true
        },
        {
          name: "⏰ Incident Time",
          value: $time,
          inline: false
        }
      ],
      footer: {
        text: "HellBox Sentinel • Automated Security System"
      }
    }]
  }'
)

# --- Sending Request ---
echo -e "${GREEN}Sending Alert to Discord...${NC}"

curl -s -H "Content-Type: application/json" \
     -X POST \
     -d "$JSON_PAYLOAD" \
     $WEBHOOK_URL

echo -e "\n${GREEN}✔ Alert Sent Successfully!${NC}"
