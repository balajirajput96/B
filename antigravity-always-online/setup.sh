#!/usr/bin/env bash
#
# setup.sh - Installs prerequisites and Google Antigravity CLI for the Always-Online setup.
#

set -Eeuo pipefail

# Define colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  Antigravity Always-Online Setup       ${NC}"
echo -e "${BLUE}========================================${NC}\n"

# 1. Detect CPU architecture
ARCH=$(uname -m)
echo -e "${CYAN}Detecting CPU Architecture...${NC}"
if [[ "$ARCH" == "aarch64" || "$ARCH" == "arm64" ]]; then
    echo -e "${GREEN}[OK] ARM64 detected (Oracle Cloud A1 compatible).${NC}\n"
elif [[ "$ARCH" == "x86_64" ]]; then
    echo -e "${GREEN}[OK] x86_64 detected (GCP e2-micro compatible).${NC}\n"
else
    echo -e "${YELLOW}[!] Warning: Unknown architecture '${ARCH}'. Installation may fail.${NC}\n"
fi

# 2. Install Prerequisites
echo -e "${CYAN}Installing prerequisites (requires sudo)...${NC}"
sudo DEBIAN_FRONTEND=noninteractive apt-get update -yq
sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq curl git tmux ca-certificates jq unzip
echo -e "${GREEN}[OK] Prerequisites installed.${NC}\n"

# 3. Install Antigravity CLI
echo -e "${CYAN}Installing Google Antigravity CLI...${NC}"
# Attempting to install via the official installer
if curl -fsSL https://antigravity.google/cli/install.sh | bash; then
    echo -e "${GREEN}[OK] CLI installed.${NC}\n"
else
    echo -e "${RED}[ERROR] CLI installation failed.${NC}\n"
    exit 1
fi

# 4. Add ~/.local/bin to PATH if missing
echo -e "${CYAN}Checking PATH...${NC}"
if [[ ":${PATH}:" != *":${HOME}/.local/bin:"* ]]; then
    echo -e "${YELLOW}~/.local/bin not in PATH. Adding to ~/.bashrc...${NC}"
    # shellcheck disable=SC2016
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "${HOME}/.bashrc"
    export PATH="${HOME}/.local/bin:${PATH}"
    echo -e "${GREEN}[OK] Added to PATH.${NC}\n"
else
    echo -e "${GREEN}[OK] ~/.local/bin is already in PATH.${NC}\n"
fi

# 5. Verify agy --version
echo -e "${CYAN}Verifying installation...${NC}"
if command -v agy >/dev/null 2>&1; then
    agy --version
    echo -e "${GREEN}[OK] agy CLI verified.${NC}\n"
else
    echo -e "${RED}[ERROR] 'agy' command not found after installation.${NC}\n"
    exit 1
fi

# 6. Detect SSH and Print Auth Instructions
if [[ -n "${SSH_CLIENT:-}" || -n "${SSH_TTY:-}" || -n "${SSH_CONNECTION:-}" ]]; then
    echo -e "${YELLOW}============================================================${NC}"
    echo -e "${YELLOW}                 AUTHENTICATION REQUIRED                    ${NC}"
    echo -e "${YELLOW}============================================================${NC}"
    echo -e "${CYAN}It looks like you are running this over an SSH session.${NC}"
    echo -e "To link this cloud VM to your account, please open the"
    echo -e "following URL in your phone's web browser and sign in"
    echo -e "with your Google account:"
    echo -e ""
    echo -e "${GREEN}   👉  https://antigravity.google/auth  👈${NC}"
    echo -e ""
    echo -e "Once you see the 'Success' screen on your phone, return here."
    echo -e "${YELLOW}============================================================${NC}\n"

    while true; do
        read -r -p "Type 'yes' to confirm authentication succeeded: " CONFIRM
        if [[ "$CONFIRM" == "yes" ]]; then
            echo -e "${GREEN}[OK] Authentication confirmed.${NC}\n"
            break
        fi
        echo -e "${RED}Please type 'yes' when you are done.${NC}"
    done
fi

# 7. Summary
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Setup Completed Successfully!         ${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "Next steps:"
echo -e "1. Run ${CYAN}./enable-service.sh${NC} to start the background daemon."
echo -e "2. Run ${CYAN}./status.sh${NC} anytime to check on your instance."
