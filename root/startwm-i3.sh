#!/bin/bash
set -euo pipefail

# Disable screen blanking and power management
setterm blank 0
setterm powerdown 0

# Start i3 window manager
if command -v i3 &>/dev/null; then
    exec /usr/bin/i3 > /dev/null 2>&1
else
    echo "Error: i3 window manager not found" >&2
    exit 1
fi
