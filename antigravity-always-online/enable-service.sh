#!/usr/bin/env bash
#
# enable-service.sh - Installs and starts systemd user services for the Antigravity daemon
#

set -Eeuo pipefail

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}Installing systemd user units...${NC}"

# Define the user systemd directory
SYSTEMD_USER_DIR="${HOME}/.config/systemd/user"
mkdir -p "${SYSTEMD_USER_DIR}"

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Copy unit files
cp "${SCRIPT_DIR}/systemd/antigravity-remote.service" "${SYSTEMD_USER_DIR}/"
cp "${SCRIPT_DIR}/systemd/antigravity-health.service" "${SYSTEMD_USER_DIR}/"
cp "${SCRIPT_DIR}/systemd/antigravity-health.timer" "${SYSTEMD_USER_DIR}/"

echo -e "${GREEN}[OK] Copied unit files to ${SYSTEMD_USER_DIR}.${NC}\n"

# Reload systemd user daemon to recognize new files
systemctl --user daemon-reload

echo -e "${CYAN}Enabling user linger (requires sudo)...${NC}"
# Enable linger so user services run even when not logged in via SSH
sudo loginctl enable-linger "${USER}"
echo -e "${GREEN}[OK] Linger enabled for user ${USER}.${NC}\n"

echo -e "${CYAN}Enabling and starting services...${NC}"
# Enable and start the main remote service
systemctl --user enable --now antigravity-remote.service

# Enable and start the healthcheck timer
systemctl --user enable --now antigravity-health.timer

echo -e "${GREEN}[OK] Services enabled and started.${NC}\n"

echo -e "${CYAN}Current status of antigravity-remote.service:${NC}"
systemctl --user status antigravity-remote.service --no-pager || true

echo -e "\n${GREEN}All done! The daemon is now running in the background.${NC}"
echo -e "Use ${CYAN}./status.sh${NC} to monitor it."
