#!/bin/bash
set -euo pipefail

echo "**** install chrome ****"

# Update package manager
APT_UPDATE_OPTS="-qq -o APT::Install-Suggests=false -o APT::Install-Recommends=false"
DEBIAN_FRONTEND=noninteractive apt-get update ${APT_UPDATE_OPTS} || true
DEBIAN_FRONTEND=noninteractive apt-get install -y ${APT_UPDATE_OPTS} wget curl gnupg2

# Add Google Chrome repository using keyring (modern approach, replaces apt-key)
mkdir -p /etc/apt/keyrings
wget -q -O- https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor --yes --output /etc/apt/keyrings/google-chrome.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | tee /etc/apt/sources.list.d/google-chrome.list >/dev/null

# Update and install Chrome
DEBIAN_FRONTEND=noninteractive apt-get update ${APT_UPDATE_OPTS} || true
DEBIAN_FRONTEND=noninteractive apt-get install -y ${APT_UPDATE_OPTS} google-chrome-stable || {
    echo "Error: Failed to install google-chrome-stable" >&2
    exit 1
}

echo "**** chrome installation complete ****"
