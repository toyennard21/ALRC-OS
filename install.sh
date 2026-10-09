#!/bin/bash
set -euo pipefail

# ALRC OS Codespace Installer
# This script prepares the Codespace environment and creates the necessary configuration

echo "=== ALRC OS Installer ==="
echo "Setting up your virtual machine..."

# Check if Python and required packages are available
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is required but not installed" >&2
    exit 1
fi

# Create default options.json if it doesn't exist
if [ ! -f "options.json" ]; then
    echo "Creating default configuration..."
    cat > options.json << 'EOF'
{
  "defaultapps": [0, 1, 2, 3, 4, 5],
  "programming": [0, 1, 2],
  "apps": [0, 1, 2, 3, 4],
  "enablekvm": true,
  "DE": "KDE Plasma (Heavy)"
}
EOF
fi

echo "Configuration created at options.json"
echo ""
echo "To customize your installation, you can:"
echo "1. Edit options.json manually, or"
echo "2. Run: python3 installer.py (for interactive setup)"
echo ""
echo "Then build the Docker image with:"
echo "docker build -t alrc-os ."
echo ""
echo "Setup complete!"
