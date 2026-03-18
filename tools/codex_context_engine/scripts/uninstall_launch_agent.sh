#!/bin/zsh
set -euo pipefail

LABEL="${CODEX_LAUNCH_AGENT_LABEL:-com.santi.codex-context-engine.projects}"
PLIST_PATH="$HOME/Library/LaunchAgents/$LABEL.plist"
USER_DOMAIN="gui/$(id -u)"

launchctl bootout "$USER_DOMAIN" "$PLIST_PATH" >/dev/null 2>&1 || true
rm -f "$PLIST_PATH"

echo "Removed LaunchAgent: $LABEL"
