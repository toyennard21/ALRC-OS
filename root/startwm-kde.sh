#!/bin/bash
set -euo pipefail

# Disable screen blanking and power management
setterm blank 0
setterm powerdown 0

# Configure KDE Plasma without requiring manual intervention
if [ ! -f "${HOME}/.config/kwinrc" ]; then
    mkdir -p "${HOME}/.config"
    kwriteconfig5 --file "${HOME}/.config/kwinrc" --group Compositing --key Enabled false || true
fi

if [ ! -f "${HOME}/.config/kscreenlockerrc" ]; then
    mkdir -p "${HOME}/.config"
    kwriteconfig5 --file "${HOME}/.config/kscreenlockerrc" --group Daemon --key Autolock false || true
fi

# Start KDE Plasma with dbus session
if command -v dbus-launch &>/dev/null && command -v startplasma-x11 &>/dev/null; then
    exec /usr/bin/dbus-launch /usr/bin/startplasma-x11 > /dev/null 2>&1
else
    echo "Error: dbus-launch or startplasma-x11 not found" >&2
    exit 1
fi
