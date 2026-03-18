#!/bin/zsh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENGINE_REPO="${CODEX_ENGINE_REPO:-$(cd "$SCRIPT_DIR/.." && pwd)}"
DEFAULT_PROJECTS_DIR="$HOME/projects"
if [ -d "$HOME/Documents/projects" ]; then
  DEFAULT_PROJECTS_DIR="$HOME/Documents/projects"
fi
PROJECTS_DIR="${CODEX_PROJECTS_DIR:-$DEFAULT_PROJECTS_DIR}"
RUBY_BIN="${RUBY_BIN:-$(command -v ruby)}"
LABEL="${CODEX_LAUNCH_AGENT_LABEL:-com.santi.codex-context-engine.projects}"
PLIST_PATH="$HOME/Library/LaunchAgents/$LABEL.plist"
LOG_DIR="$ENGINE_REPO/.context_metrics/launchd"
STDOUT_LOG="$LOG_DIR/stdout.log"
STDERR_LOG="$LOG_DIR/stderr.log"
USER_DOMAIN="gui/$(id -u)"

mkdir -p "$HOME/Library/LaunchAgents" "$LOG_DIR"

cat > "$PLIST_PATH" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>$LABEL</string>
  <key>ProgramArguments</key>
  <array>
    <string>$RUBY_BIN</string>
    <string>$ENGINE_REPO/scripts/install_cross_project_for_all_repos.rb</string>
  </array>
  <key>EnvironmentVariables</key>
  <dict>
    <key>CODEX_ENGINE_REPO</key>
    <string>$ENGINE_REPO</string>
    <key>CODEX_PROJECTS_DIR</key>
    <string>$PROJECTS_DIR</string>
  </dict>
  <key>RunAtLoad</key>
  <true/>
  <key>StartInterval</key>
  <integer>300</integer>
  <key>WatchPaths</key>
  <array>
    <string>$PROJECTS_DIR</string>
  </array>
  <key>StandardOutPath</key>
  <string>$STDOUT_LOG</string>
  <key>StandardErrorPath</key>
  <string>$STDERR_LOG</string>
</dict>
</plist>
PLIST

launchctl bootout "$USER_DOMAIN" "$PLIST_PATH" >/dev/null 2>&1 || true
launchctl bootstrap "$USER_DOMAIN" "$PLIST_PATH"
launchctl enable "$USER_DOMAIN/$LABEL"
launchctl kickstart -k "$USER_DOMAIN/$LABEL"

echo "Installed LaunchAgent: $LABEL"
echo "Plist: $PLIST_PATH"
echo "Projects dir: $PROJECTS_DIR"
echo "Engine repo: $ENGINE_REPO"
