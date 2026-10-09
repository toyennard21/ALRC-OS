#!/bin/bash
set -euo pipefail

echo "**** install wine ****"

APT_UPDATE_OPTS="-qq -o APT::Install-Suggests=false -o APT::Install-Recommends=false"

# Enable 32-bit architecture support
echo "Enabling 32-bit architecture support..."
sudo dpkg --add-architecture i386 || true

DEBIAN_FRONTEND=noninteractive apt-get update ${APT_UPDATE_OPTS} || true
DEBIAN_FRONTEND=noninteractive apt-get install -y ${APT_UPDATE_OPTS} wget gnupg2

# Add WineHQ repository using modern keyring approach
echo "Adding WineHQ repository..."
mkdir -p /etc/apt/keyrings
wget -q -O- https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor --yes --output /etc/apt/keyrings/winehq.gpg || {
    echo "Error: Failed to download WineHQ GPG key" >&2
    exit 1
}

# Use proper .sources file format for modern Ubuntu (22.04+)
echo "deb [arch=amd64,i386 signed-by=/etc/apt/keyrings/winehq.gpg] https://dl.winehq.org/wine-builds/ubuntu/ jammy main" | \
    tee /etc/apt/sources.list.d/winehq-jammy.sources >/dev/null

DEBIAN_FRONTEND=noninteractive apt-get update ${APT_UPDATE_OPTS} || true

# Install Wine Staging
echo "Installing Wine Staging..."
DEBIAN_FRONTEND=noninteractive apt-get install -y ${APT_UPDATE_OPTS} --install-recommends winehq-staging || {
    # Fallback to basic Wine if Staging is unavailable
    echo "Warning: winehq-staging unavailable, installing basic wine..."
    DEBIAN_FRONTEND=noninteractive apt-get install -y ${APT_UPDATE_OPTS} wine wine32 wine64 || {
        echo "Error: Failed to install wine packages" >&2
        exit 1
    }
}

echo "**** wine installation complete ****"
