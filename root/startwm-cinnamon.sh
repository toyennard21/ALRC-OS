#!/bin/bash
set -euo pipefail

# Disable screen blanking and power management
setterm blank 0
setterm powerdown 0

# Start Cinnamon session
if command -v cinnamon-session &>/dev/null; then
    exec /usr/bin/cinnamon-session > /dev/null 2>&1
else
    echo "Error: cinnamon-session not found" >&2
    exit 1
fi
