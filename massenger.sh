#!/bin/bash

# --- Configuration ---
# নিচের লাইনে আপনার কপি করা Webhook URL পেস্ট করুন
WEBHOOK_URL="https://discord.com/api/webhooks/1464868830651089021/3WX6UFa4rS9rWhAIVPRoNqtqpz9zdQrer-_1C3Sy8GciThv5Iwu0t_PFNj0xP4MOZBCH"

# --- Colors ---
GREEN='\033[0;32m'
NC='\033[0m'

# --- The Logic ---
echo -e "${GREEN}Sending alert to Discord Headquarters...${NC}"

# মেসেজ সেট করা
MESSAGE="🚨 **SECURITY ALERT** 🚨\nSomeone is trying to access the server!\nTime: $(date)"

# JSON Payload বানানো (Discord JSON format বোঝে)
# আমরা এখানে sed ব্যবহার করছি যাতে মেসেজের ভেতরের স্পেস বা লাইন ব্রেক নিয়ে ঝামেলা না হয়
JSON_PAYLOAD=$(jq -n --arg content "$MESSAGE" '{content: $content}')

# Curl দিয়ে POST রিকোয়েস্ট পাঠানো
curl -H "Content-Type: application/json" \
     -X POST \
     -d "$JSON_PAYLOAD" \
     $WEBHOOK_URL

echo -e "\n${GREEN}Message Sent! Check your Discord.${NC}"
