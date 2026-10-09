#!/bin/bash
set -euo pipefail

# Disable screen blanking and power management
setterm blank 0
setterm powerdown 0

# Start LXQt session
if command -v lxqt-session &>/dev/null; then
    exec /usr/bin/lxqt-session > /dev/null 2>&1
else
    echo "Error: lxqt-session not found" >&2
    exit 1
fi
