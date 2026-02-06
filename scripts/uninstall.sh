#!/bin/bash
# Uninstall self-driving-codebases plugin
# Removes symlink from ~/.claude/plugins/

set -e

PLUGINS_DIR="$HOME/.claude/plugins"
LINK_PATH="$PLUGINS_DIR/self-driving-codebases"

if [ -L "$LINK_PATH" ]; then
    rm "$LINK_PATH"
    echo "✓ Uninstalled self-driving-codebases plugin"
    echo "  Removed: $LINK_PATH"
    echo ""
    echo "Note: Source files are preserved. Restart Claude Code to apply changes."
elif [ -e "$LINK_PATH" ]; then
    echo "Warning: $LINK_PATH exists but is not a symlink."
    echo "Please remove it manually if needed."
    exit 1
else
    echo "Plugin not installed (symlink not found)."
fi
