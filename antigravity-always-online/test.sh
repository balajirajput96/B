#!/usr/bin/env bash
#
# test.sh - Validates the syntax of bash scripts and runs shellcheck.
#

set -Eeuo pipefail

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Ensure shellcheck is installed for testing (in case this is run in a CI or dev environment without it)
if ! command -v shellcheck &> /dev/null; then
    echo -e "${CYAN}shellcheck not found. Installing...${NC}"
    sudo DEBIAN_FRONTEND=noninteractive apt-get update -yq >/dev/null
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -yq shellcheck >/dev/null
fi

SCRIPTS=(
    "setup.sh"
    "enable-service.sh"
    "healthcheck.sh"
    "status.sh"
    "uninstall.sh"
    "test.sh"
)

ERRORS=0

echo -e "${CYAN}Running syntax check (bash -n)...${NC}"
for script in "${SCRIPTS[@]}"; do
    if [[ -f "${script}" ]]; then
        if bash -n "${script}"; then
            echo -e "${GREEN}[OK] ${script} syntax is valid.${NC}"
        else
            echo -e "${RED}[ERROR] ${script} failed syntax check.${NC}"
            ERRORS=$((ERRORS + 1))
        fi
    else
        echo -e "${RED}[ERROR] Script ${script} not found!${NC}"
        ERRORS=$((ERRORS + 1))
    fi
done

echo -e "\n${CYAN}Running ShellCheck...${NC}"
for script in "${SCRIPTS[@]}"; do
    if [[ -f "${script}" ]]; then
        if shellcheck -x "${script}"; then
            echo -e "${GREEN}[OK] ${script} passed ShellCheck.${NC}"
        else
            echo -e "${RED}[ERROR] ${script} failed ShellCheck.${NC}"
            ERRORS=$((ERRORS + 1))
        fi
    fi
done

if (( ERRORS > 0 )); then
    echo -e "\n${RED}[FAIL] Tests failed with ${ERRORS} errors.${NC}"
    exit 1
else
    echo -e "\n${GREEN}[SUCCESS] All tests passed!${NC}"
    exit 0
fi
