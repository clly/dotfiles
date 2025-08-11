#!/usr/bin/env bash
set -euo pipefail

# Install and setup mise-en-place package manager
# This script uses the vendored mise.run installer and completes the setup

echo "Setting up mise-en-place..."

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if mise is already installed
if command -v mise >/dev/null 2>&1; then
    echo "mise is already installed: $(mise --version)"
else
    echo "Installing mise using vendored installer..."
    
    # Execute the vendored mise.run script
    "$SCRIPT_DIR/vendor/mise.run"
    
    # Verify installation
    if [[ -f "$HOME/.local/bin/mise" ]]; then
        echo "✅ mise installed successfully"
    else
        echo "❌ Installation failed: mise binary not found"
        exit 1
    fi
fi

# Ensure ~/.local/bin is in PATH for this session
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
fi

# Install configured tools from .mise.toml if it exists
if [[ -f "$SCRIPT_DIR/.mise.toml" ]]; then
    echo "Installing tools from .mise.toml..."
    
    # Use the mise binary (either system or newly installed)
    MISE_BIN="mise"
    if ! command -v mise >/dev/null 2>&1; then
        MISE_BIN="$HOME/.local/bin/mise"
    fi
    
    # Run mise commands in subshell to avoid changing parent directory
    (
        cd "$SCRIPT_DIR"
        # Trust the configuration before installing
        "$MISE_BIN" trust
        "$MISE_BIN" install
    )
    echo "✅ Tools installed successfully"
else
    echo "⚠️  .mise.toml not found in $SCRIPT_DIR, skipping tool installation"
fi

echo ""
echo "🎉 mise-en-place setup complete!"
echo ""
echo "To activate mise in your current shell:"
echo "  eval \"\$(mise activate bash)\""
echo ""
echo "To make this permanent, the activate script will handle this automatically."
