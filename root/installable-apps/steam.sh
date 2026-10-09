#!/bin/bash
set -euo pipefail

echo "**** install steam ****"

APT_UPDATE_OPTS="-qq -o APT::Install-Suggests=false -o APT::Install-Recommends=false"
DEBIAN_FRONTEND=noninteractive apt-get update ${APT_UPDATE_OPTS} || true
DEBIAN_FRONTEND=noninteractive apt-get install -y ${APT_UPDATE_OPTS} wget

# Download Steam with retries
STEAM_URL="https://steamcdn-a.akamaihd.net/client/installer/steam.deb"
STEAM_DEB="/tmp/steam.deb"

echo "Downloading Steam from ${STEAM_URL}..."
wget -q --show-progress --tries=3 --timeout=30 -O "${STEAM_DEB}" "${STEAM_URL}" || {
    echo "Error: Failed to download Steam" >&2
    exit 1
}

if [ ! -f "${STEAM_DEB}" ]; then
    echo "Error: Steam DEB file not found after download" >&2
    exit 1
fi

# Install Steam
echo "Installing Steam..."
DEBIAN_FRONTEND=noninteractive dpkg -i "${STEAM_DEB}" || {
    echo "Warning: dpkg install had issues, attempting to fix broken dependencies..."
    DEBIAN_FRONTEND=noninteractive apt-get install -f -y ${APT_UPDATE_OPTS} || true
}

# Cleanup
rm -f "${STEAM_DEB}"
echo "**** steam installation complete ****"
