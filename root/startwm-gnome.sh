#!/bin/bash
set -euo pipefail

# Disable screen blanking and power management
setterm blank 0
setterm powerdown 0

# Set GNOME environment variables
export XDG_CURRENT_DESKTOP=GNOME
export XDG_SESSION_TYPE=x11

# Ensure dbus is running (use systemctl if available, fallback to service)
if command -v systemctl &>/dev/null; then
    systemctl --user start dbus.socket 2>/dev/null || true
else
    service dbus start 2>/dev/null || true
fi

# Start GNOME Shell
if command -v gnome-shell &>/dev/null; then
    exec /usr/bin/gnome-shell --x11 -r > /dev/null 2>&1
else
    echo "Error: gnome-shell not found" >&2
    exit 1
fi
