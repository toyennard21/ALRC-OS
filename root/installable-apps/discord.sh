#!/bin/bash
set -euo pipefail

echo "**** install discord ****"

APT_UPDATE_OPTS="-qq -o APT::Install-Suggests=false -o APT::Install-Recommends=false"
DEBIAN_FRONTEND=noninteractive apt-get update ${APT_UPDATE_OPTS} || true
DEBIAN_FRONTEND=noninteractive apt-get install -y ${APT_UPDATE_OPTS} libatomic1 wget

# Download Discord with retries
DISCORD_URL="https://discord.com/api/download?platform=linux&format=deb"
DISCORD_DEB="/tmp/discord.deb"

echo "Downloading Discord from ${DISCORD_URL}..."
wget -q --show-progress --tries=3 --timeout=10 -O "${DISCORD_DEB}" "${DISCORD_URL}" || {
    echo "Error: Failed to download Discord" >&2
    exit 1
}

if [ ! -f "${DISCORD_DEB}" ]; then
    echo "Error: Discord DEB file not found after download" >&2
    exit 1
fi

# Install Discord
echo "Installing Discord..."
DEBIAN_FRONTEND=noninteractive dpkg -i "${DISCORD_DEB}" || {
    echo "Warning: dpkg install had issues, attempting to fix broken dependencies..."
    DEBIAN_FRONTEND=noninteractive apt-get install -f -y ${APT_UPDATE_OPTS} || true
}

# Cleanup
rm -f "${DISCORD_DEB}"
echo "**** discord installation complete ****"
