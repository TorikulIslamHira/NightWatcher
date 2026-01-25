# 👁️ NightWatcher - Linux Intrusion Detection System (IDS)

![Platform](https://img.shields.io/badge/Platform-Linux-linux?style=flat-square)
![Language](https://img.shields.io/badge/Language-Bash-4EAA25?style=flat-square)
![Security](https://img.shields.io/badge/Security-IDS-red?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-blue?style=flat-square)

**NightWatcher** is an advanced, automated security suite designed for Linux servers. It acts as a digital sentry, monitoring system logs in real-time to detect unauthorized access attempts (SSH Brute Force), tracking the attacker's physical location using Geo-IP technology, and dispatching instant rich-embed alerts to **Discord**.

---

## 🚀 Key Features

* **⚡ Real-time Monitoring:** Continuously watches `auth.log` or Systemd Journal for suspicious activities.
* **🌍 Geo-IP Tracking:** Automatically traces the attacker's Country, City, ISP, and Map Coordinates.
* **🔔 Instant Alerts:** Sends professional, color-coded security notifications to Discord Webhooks.
* **🧠 Automated Response:** Triggers tracking protocols immediately upon detecting a failed login attempt.

---

## 📂 Module Architecture

| Module Name | Function |
| :--- | :--- |
| **`sentry.sh`** | **The Monitor:** Runs in the background, parses logs (`auth.log`), and detects intrusion patterns using Regex. |
| **`watchman_core.sh`** | **The Brain:** Receives IP data from Sentry, queries the `ip-api`, and constructs the intelligence report. |
| **`messenger.sh`** | **The Alert System:** Formats the intelligence data into a JSON Payload and sends a Rich-Embed message to Discord. |
| **`tracker.sh`** | **Manual Tool:** A standalone utility to manually track any IP address directly from the terminal. |

---

## 🛠️ Prerequisites

NightWatcher relies on **JSON processing** and **API requests**. Please install the following dependencies:

```bash
sudo apt update && sudo apt install jq curl -y

⚙️ Configuration
Before running the system, you must configure your notification channel.

Open watchman_core.sh (and messenger.sh if used separately).

Find the variable WEBHOOK_URL.

Replace the placeholder with your Discord Webhook URL.

Bash
# Example inside the script:
WEBHOOK_URL="[https://discord.com/api/webhooks/YOUR_UNIQUE_ID](https://discord.com/api/webhooks/YOUR_UNIQUE_ID)"
🏃‍♂️ Usage Guide
1. Start the Automated Sentry (IDS)
To enable real-time protection, run the Sentry script with root privileges:

Bash
chmod +x *.sh
sudo ./sentry.sh
The system is now live and waiting for attacks.

2. Manual IP Tracking
To investigate a specific suspicious IP address manually:

Bash
./tracker.sh
📸 Alert Preview
NightWatcher sends alerts in the following format:

🕵️‍♂️ INTRUDER LOCATED

Target IP: 192.168.x.x

Location: Moscow, Russia

ISP: Example Telecom

Time: 2026-01-25 14:00:00

👨‍💻 Author
Developed by Torikul Islam Hira Passionate about DevOps, Linux Automation, and Cyber Security.
