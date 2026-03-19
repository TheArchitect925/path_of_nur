#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

ARCHIVE_PATH="${1:-$ROOT_DIR/build/ios/archive/Runner.xcarchive}"
APP_PATH="$ARCHIVE_PATH/Products/Applications/Runner.app"
WATCH_APP_PATH="$APP_PATH/Watch/PathOfNurWatch Watch App.app"
WATCH_ICON_SOURCE="ios/PathOfNurWatch Watch App/Assets.xcassets/AppIcon.appiconset/Contents.json"
RUNNER_ENTITLEMENTS_SOURCE="ios/Runner/Runner.entitlements"
RUNNER_DEBUG_ENTITLEMENTS_SOURCE="ios/Runner/RunnerDebug.entitlements"

fail() {
  echo "$1" >&2
  exit 1
}

require_file() {
  [[ -f "$1" ]] || fail "Missing required file: $1"
}

require_dir() {
  [[ -d "$1" ]] || fail "Missing required directory: $1"
}

plist_value() {
  local plist_path="$1"
  local key="$2"
  /usr/libexec/PlistBuddy -c "Print :$key" "$plist_path" 2>/dev/null || true
}

require_dir "$ARCHIVE_PATH"
require_dir "$APP_PATH"
require_file "$APP_PATH/Info.plist"
require_file "$RUNNER_ENTITLEMENTS_SOURCE"
require_file "$RUNNER_DEBUG_ENTITLEMENTS_SOURCE"
require_dir "$WATCH_APP_PATH"
require_file "$WATCH_APP_PATH/Info.plist"
require_file "$WATCH_ICON_SOURCE"

if [[ "$(plist_value "$WATCH_APP_PATH/Info.plist" "CFBundleIconName")" != "AppIcon" ]]; then
  fail "Watch app archive is missing CFBundleIconName=AppIcon"
fi

if [[ ! -f "$WATCH_APP_PATH/Assets.car" ]]; then
  fail "Watch app archive is missing Assets.car"
fi

if ! plutil -extract images raw "$WATCH_ICON_SOURCE" >/dev/null 2>&1; then
  fail "Watch icon asset catalog Contents.json is malformed"
fi

watch_image_count="$(plutil -extract images json -o - "$WATCH_ICON_SOURCE" | python3 -c 'import json,sys; print(len(json.load(sys.stdin)))')"
if [[ "${watch_image_count}" -lt 8 ]]; then
  fail "Watch icon asset catalog is incomplete"
fi

if ! rg -F '<key>com.apple.developer.ubiquity-kvstore-identifier</key>' "$RUNNER_ENTITLEMENTS_SOURCE" >/dev/null; then
  fail "Runner.entitlements is missing com.apple.developer.ubiquity-kvstore-identifier"
fi

if rg -F 'com.apple.developer.icloud-container-environment' "$RUNNER_ENTITLEMENTS_SOURCE" >/dev/null; then
  fail "Runner.entitlements must not include CloudKit-only iCloud container environment"
fi

if rg -F 'com.apple.developer.icloud-container-environment' "$RUNNER_DEBUG_ENTITLEMENTS_SOURCE" >/dev/null; then
  fail "RunnerDebug.entitlements must not include com.apple.developer.icloud-container-environment"
fi

signed_entitlements_tmp="$(mktemp)"
signed_entitlements_ok=0

if codesign -d --entitlements :- "$APP_PATH" >"$signed_entitlements_tmp" 2>/dev/null; then
  signed_entitlements_ok=1
  if ! grep -q 'com.apple.developer.ubiquity-kvstore-identifier' "$signed_entitlements_tmp"; then
    fail "Signed archive entitlements are missing com.apple.developer.ubiquity-kvstore-identifier"
  fi
  if grep -q 'com.apple.developer.icloud-container-environment' "$signed_entitlements_tmp"; then
    fail "Signed archive entitlements still include CloudKit-only iCloud container environment"
  fi
fi

rm -f "$signed_entitlements_tmp"

if [[ "$signed_entitlements_ok" -eq 1 ]]; then
  echo "Apple archive validation passed (signed entitlements checked)"
else
  echo "Apple archive validation passed (unsigned archive; source entitlements and archive packaging checked)"
fi
