#!/bin/bash

LOG_FILE="/var/log/auth.log"
WATCHMAN_SCRIPT="./watcherman.sh"

echo -e "\033[0;36m=== DEBUG MODE: SENTRY IS WATCHING ===\033[0m"

# লগ ফাইল আছে কিনা চেক
if [ ! -f "$LOG_FILE" ]; then
    echo "Error: $LOG_FILE not found!"
    echo "Run: sudo touch $LOG_FILE && sudo systemctl restart rsyslog"
    exit 1
fi

sudo tail -Fn0 "$LOG_FILE" | while read LINE; do
    
    # [DEBUG] যা পড়ছে তা স্ক্রিনে প্রিন্ট করবে
    echo "[READING] $LINE"

    if echo "$LINE" | grep -q "Failed password"; then
        echo -e "\033[0;31m[!] Failed Password Match Found!\033[0m"
        
        # IPv4 এবং IPv6 দুটোই খোঁজার জন্য আপডেট করা Regex
        TARGET_IP=$(echo "$LINE" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b")

        if [ -z "$TARGET_IP" ]; then
            # যদি IPv4 না পায়, তখন ধরে নেব এটা Localhost (::1) বা অন্য কিছু
            echo "Warning: Could not extract IPv4. Might be localhost (::1)."
            TARGET_IP="127.0.0.1"
        fi

        echo "Triggering Watchman for IP: $TARGET_IP"
        bash "$WATCHMAN_SCRIPT" "$TARGET_IP"
    fi
done
