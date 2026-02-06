#!/bin/bash
# Install self-driving-codebases plugin
# Creates symlink in ~/.claude/plugins/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_DIR="$(dirname "$SCRIPT_DIR")"
PLUGINS_DIR="$HOME/.claude/plugins"

# Create plugins directory if it doesn't exist
mkdir -p "$PLUGINS_DIR"

# Create symlink
if [ -L "$PLUGINS_DIR/self-driving-codebases" ]; then
    echo "Removing existing symlink..."
    rm "$PLUGINS_DIR/self-driving-codebases"
fi

ln -sf "$PLUGIN_DIR" "$PLUGINS_DIR/self-driving-codebases"

echo "✓ Installed self-driving-codebases plugin"
echo "  Source: $PLUGIN_DIR"
echo "  Target: $PLUGINS_DIR/self-driving-codebases"
echo ""
echo "Restart Claude Code to load the plugin."
