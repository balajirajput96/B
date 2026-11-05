#!/usr/bin/env bash
#
# healthcheck.sh - Checks the status of antigravity-remote.service and restarts it if inactive.
# Logs to ~/antigravity-logs/health.log and rotates it at 5MB.
#

set -Eeuo pipefail

LOG_DIR="${HOME}/antigravity-logs"
LOG_FILE="${LOG_DIR}/health.log"
MAX_LOG_SIZE=$(( 5 * 1024 * 1024 )) # 5 MB in bytes

# Ensure log directory exists
mkdir -p "${LOG_DIR}"

# Function to rotate log if it exceeds 5MB
rotate_log_if_needed() {
    if [[ -f "${LOG_FILE}" ]]; then
        local size
        size=$(stat -c%s "${LOG_FILE}")
        if (( size > MAX_LOG_SIZE )); then
            mv "${LOG_FILE}" "${LOG_FILE}.old"
            echo "$(date -u +'%Y-%m-%dT%H:%M:%SZ') - Log rotated." > "${LOG_FILE}"
        fi
    fi
}

rotate_log_if_needed

TIMESTAMP=$(date -u +'%Y-%m-%dT%H:%M:%SZ')

# Check if the service is active
if systemctl --user is-active --quiet antigravity-remote.service; then
    echo "${TIMESTAMP} - [OK] antigravity-remote.service is active." >> "${LOG_FILE}"
else
    echo "${TIMESTAMP} - [WARN] antigravity-remote.service is inactive! Attempting restart..." >> "${LOG_FILE}"
    if systemctl --user restart antigravity-remote.service; then
        echo "${TIMESTAMP} - [INFO] Successfully restarted antigravity-remote.service." >> "${LOG_FILE}"
    else
        echo "${TIMESTAMP} - [ERROR] Failed to restart antigravity-remote.service." >> "${LOG_FILE}"
    fi
fi
