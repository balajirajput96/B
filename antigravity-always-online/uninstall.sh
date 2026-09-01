#!/usr/bin/env bash
#
# uninstall.sh - Stops and removes services, timers, unit files, and PATH edits.
#

set -Eeuo pipefail

CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${CYAN}Stopping and disabling services...${NC}"

# Stop and disable timer and service (ignore errors if they are not running or don't exist)
systemctl --user disable --now antigravity-health.timer || true
systemctl --user disable --now antigravity-remote.service || true

echo -e "${CYAN}Removing systemd unit files...${NC}"
SYSTEMD_USER_DIR="${HOME}/.config/systemd/user"
rm -f "${SYSTEMD_USER_DIR}/antigravity-remote.service"
rm -f "${SYSTEMD_USER_DIR}/antigravity-health.service"
rm -f "${SYSTEMD_USER_DIR}/antigravity-health.timer"

# Reload systemd daemon
systemctl --user daemon-reload

echo -e "${CYAN}Disabling user linger (requires sudo)...${NC}"
sudo loginctl disable-linger "${USER}" || true

echo -e "${CYAN}Cleaning up PATH in ~/.bashrc...${NC}"
# Use sed to safely remove the PATH export line added during setup
# shellcheck disable=SC2016
sed -i '/export PATH="$HOME\/.local\/bin:$PATH"/d' "${HOME}/.bashrc"

echo -e "${GREEN}[OK] Uninstallation complete. The antigravity daemon has been removed from your user profile.${NC}"
