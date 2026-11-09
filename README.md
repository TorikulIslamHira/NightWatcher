<div align="center">

# 👁️ NightWatcher

**A digital sentry for Linux servers: detects SSH attacks, traces the attacker and alerts you on Discord.**

![Bash](https://img.shields.io/badge/Bash-4EAA25?logo=gnubash&logoColor=white) ![Linux](https://img.shields.io/badge/Linux-FCC624?logo=linux&logoColor=black) ![Discord](https://img.shields.io/badge/Discord-Webhooks-5865F2?logo=discord&logoColor=white) ![License](https://img.shields.io/badge/License-MIT-blue)

</div>

NightWatcher is an automated Intrusion Detection System (IDS) for Linux. It watches your system logs in real time, spots unauthorized access attempts such as SSH brute force, looks up where the attacker is connecting from, and sends a colour-coded rich-embed alert to your Discord channel within seconds.

## 📌 Table of Contents

[🎯 What it does](#-what-it-does) · [🧠 Architecture](#-architecture--at-a-glance) · [🛠️ Tech stack](#️-tech-stack) · [🚀 Getting started](#-getting-started) · [🏃 Usage](#-usage) · [📸 Alert preview](#-alert-preview) · [🗂️ Project status](#️-project-status) · [🧭 Design principles](#-design-principles)

## 🎯 What it does

| Capability | Description |
|---|---|
| ⚡ Real-time monitoring | Continuously watches `auth.log` or the systemd journal for suspicious activity |
| 🌍 Geo-IP tracking | Traces the attacker's country, city, ISP and map coordinates |
| 🔔 Instant alerts | Sends professional, colour-coded notifications to a Discord webhook |
| 🧠 Automated response | Starts the tracking routine the moment a failed login is detected |
| 🔎 Manual lookup | A standalone tool to investigate any IP address from the terminal |

## 🧠 Architecture: at a glance

```
auth.log / journal  ->  sentry.sh  ->  watchman_core.sh  ->  messenger.sh  ->  Discord
                        (detect)       (Geo-IP lookup)       (format + send)
```

| Module | Role |
|---|---|
| `sentry.sh` | **The monitor.** Runs in the background, parses `auth.log` and detects intrusion patterns with regex |
| `watchman_core.sh` | **The brain.** Receives IP data from Sentry, queries ip-api and builds the intelligence report |
| `messenger.sh` | **The alert system.** Formats the report as a JSON payload and posts a rich embed to Discord |
| `tracker.sh` | **Manual tool.** Standalone utility to track any IP address from the terminal |

## 🛠️ Tech stack

| Layer | Technology |
|---|---|
| Language | Bash |
| Parsing | Regex on `auth.log` / systemd journal |
| Data | ip-api (Geo-IP lookup) |
| JSON and HTTP | `jq` and `curl` |
| Alerts | Discord webhooks (rich embeds) |

## 🚀 Getting started

Install the dependencies:

```bash
sudo apt update && sudo apt install jq curl -y
```

Clone the repository:

```bash
git clone https://github.com/TorikulIslamHira/NightWatcher.git
cd NightWatcher
chmod +x *.sh
```

Configure your notification channel. Open `watchman_core.sh` (and `messenger.sh` if you use it separately), find the `WEBHOOK_URL` variable and replace the placeholder with your Discord webhook:

```bash
WEBHOOK_URL="https://discord.com/api/webhooks/YOUR_UNIQUE_ID"
```

## 🏃 Usage

**1. Start the automated sentry (IDS).** Run it with root privileges for real-time protection:

```bash
sudo ./sentry.sh
```

The system is now live and waiting for attacks.

**2. Track an IP manually.** To investigate a suspicious address:

```bash
./tracker.sh
```

## 📸 Alert preview

NightWatcher sends alerts in this format:

```
🕵️ INTRUDER LOCATED

Target IP : 192.168.x.x
Location  : Moscow, Russia
ISP       : Example Telecom
Time      : 2026-01-25 14:00:00
```

## 🗂️ Project status

| Item | Status |
|---|---|
| SSH brute-force detection | ✅ Done |
| Geo-IP tracking | ✅ Done |
| Discord rich-embed alerts | ✅ Done |
| Manual IP tracker | ✅ Done |
| Auto-block attackers (firewall) | ⏳ Planned |
| Telegram alerts | ⏳ Planned |

## 🧭 Design principles

| Principle | Meaning |
|---|---|
| Lightweight | Pure Bash with two small dependencies, runs on any Linux server |
| Fast feedback | An alert reaches you within seconds of the attack |
| Modular | Detect, enrich and notify live in separate scripts that can be reused alone |

## 👨‍💻 Author

Built by **Torikul Islam Hira**, passionate about DevOps, Linux automation and cyber security. See also [hellbox-sentinel](https://github.com/TorikulIslamHira/hellbox-sentinel), a Linux server health monitor with self-healing.

## 📄 License

Released under the [MIT License](LICENSE).
