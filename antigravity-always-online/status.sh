#!/usr/bin/env bash
#
# status.sh - A compact, mobile-friendly script showing system and service status.
#

set -Eeuo pipefail

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${CYAN}=== Antigravity Instance Status ===${NC}"

# Uptime
UPTIME=$(uptime -p)
echo -e "${GREEN}Uptime:${NC} ${UPTIME}"

# RAM Usage
RAM_USAGE=$(free -m | awk 'NR==2{printf "%s/%sMB (%.2f%%)", $3,$2,$3*100/$2 }')
echo -e "${GREEN}RAM:${NC}    ${RAM_USAGE}"

# Disk Usage
DISK_USAGE=$(df -h / | awk '$NF=="/"{printf "%s/%s (%s)", $3,$2,$5}')
echo -e "${GREEN}Disk:${NC}   ${DISK_USAGE}"

# Service State
if systemctl --user is-active --quiet antigravity-remote.service; then
    SERVICE_STATE="${GREEN}Active (Running)${NC}"
else
    SERVICE_STATE="${RED}Inactive (Stopped)${NC}"
fi
echo -e "${GREEN}Daemon:${NC} ${SERVICE_STATE}"

echo -e "\n${CYAN}--- Last 10 Health Log Entries ---${NC}"
LOG_FILE="${HOME}/antigravity-logs/health.log"
if [[ -f "${LOG_FILE}" ]]; then
    tail -n 10 "${LOG_FILE}" | while IFS= read -r line; do
        if [[ "${line}" == *"[OK]"* ]]; then
            echo -e "${GREEN}${line}${NC}"
        elif [[ "${line}" == *"[WARN]"* ]]; then
            echo -e "${YELLOW}${line}${NC}"
        elif [[ "${line}" == *"[ERROR]"* ]]; then
            echo -e "${RED}${line}${NC}"
        else
            echo -e "${line}"
        fi
    done
else
    echo -e "${YELLOW}No health log found yet. It takes up to 5 minutes to generate.${NC}"
fi
echo -e "${CYAN}===================================${NC}"
