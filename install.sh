#!/bin/bash
# Fixed and optimized ALRCVM / BlobeVM Installer for GitHub Codespaces using KasmVNC

set -e

echo "=== [1/5] Updating Packages & Core Dependencies ==="
sudo apt-get update -y
sudo apt-get install -y wget curl jq xfce4 xfce4-goodies dbus-x11 ssl-cert chromium-browser mesa-utils

echo "=== [2/5] Downloading and Installing Latest KasmVNC ==="
# Fetch latest stable debian package architecture amd64 matching current Ubuntu version (usually Jammy/Noble)
# To remain robust, we grab the latest Ubuntu package from GitHub releases via API
KASMVNC_URL=$(curl -s https://api.github.com/repos/kasmtech/KasmVNC/releases/latest | jq -r '.assets[] | select(.name | contains("ubuntu-noble_amd64.deb") or contains("ubuntu-jammy_amd64.deb")) | .url' | head -1)

if [ -z "$KASMVNC_URL" ] || [ "$KASMVNC_URL" == "null" ]; then
    echo "Falling back to hardcoded stable KasmVNC URL..."
    KASMVNC_URL="https://github.com/kasmtech/KasmVNC/releases/download/v1.3.3/kasmvncserver_noble_1.3.3_amd64.deb"
fi

wget -O kasmvnc.deb "$KASMVNC_URL"
sudo apt-get install -y ./kasmvnc.deb || sudo apt-get install -f -y

echo "=== [3/5] Assigning User Groups ==="
# KasmVNC requires the user to belong to the kasmvnc-cert group
sudo usermod -aG kasmvnc-cert $USER || true
sudo usermod -aG ssl-cert $USER || true

echo "=== [4/5] Configuring KasmVNC & XFCE Backend ==="
mkdir -p ~/.vnc

# Set up the VNC startup script to drop directly into XFCE
cat << 'EOF' > ~/.vnc/xstartup
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export XDG_CURRENT_DESKTOP="XFCE"
export XDG_SESSION_DESKTOP="xfce"
export DISPLAY=:1
exec startxfce4
EOF
chmod +x ~/.vnc/xstartup

# Pre-generate KasmVNC user profile configuration avoiding standard manual prompt roadblocks
mkdir -p ~/.kasmentry || true
# Configure YAML default setup or generic configuration overrides if required by vncserver setup
# KasmVNC uses a central yaml file for runtime arguments. Let's make sure it defaults smoothly.
mkdir -p ~/.vnc
cat << 'EOF' > ~/.vnc/kasmvnc.yaml
network:
  protocol: http
  interface: 0.0.0.0
  websocket_port: 8443
  use_ipv4: true
  use_ipv6: false
ssl:
  require_ssl: false
security:
  brute_force_protection:
    blacklist_threshold: 0
EOF

echo "=== [5/5] Installation Complete! ==="
echo ""
echo "To initialize your virtual machine environment, execute the following command:"
echo "    vncserver -select-de xfce"
echo ""
echo "Note: Ensure you change visibility of Port 8443 to 'Public' under your Codespaces configuration panel!"
