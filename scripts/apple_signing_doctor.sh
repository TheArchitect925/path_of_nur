#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

DEBUG_ENTITLEMENTS="ios/Runner/RunnerDebug.entitlements"
RELEASE_ENTITLEMENTS="ios/Runner/Runner.entitlements"
PBXPROJ="ios/Runner.xcodeproj/project.pbxproj"

fail() {
  echo "$1" >&2
  exit 1
}

require_file() {
  [[ -f "$1" ]] || fail "Missing required file: $1"
}

require_file "$DEBUG_ENTITLEMENTS"
require_file "$RELEASE_ENTITLEMENTS"
require_file "$PBXPROJ"

debug_contents="$(cat "$DEBUG_ENTITLEMENTS")"
release_contents="$(cat "$RELEASE_ENTITLEMENTS")"

if grep -q "com.apple.developer.icloud-container-environment" <<<"$debug_contents"; then
  fail "RunnerDebug.entitlements must not include com.apple.developer.icloud-container-environment"
fi

if grep -q "CloudKit" <<<"$debug_contents"; then
  fail "RunnerDebug.entitlements must not include CloudKit"
fi

if ! grep -q "<key>aps-environment</key>" <<<"$debug_contents" || ! grep -q "<string>development</string>" <<<"$debug_contents"; then
  fail "RunnerDebug.entitlements must keep aps-environment=development"
fi

if grep -q "com.apple.developer.icloud-container-environment" <<<"$release_contents"; then
  fail "Runner.entitlements must not include CloudKit-only iCloud container environment"
fi

if grep -q "CloudKit" <<<"$release_contents"; then
  fail "Runner.entitlements must not include CloudKit"
fi

if ! grep -q "com.apple.developer.ubiquity-kvstore-identifier" <<<"$release_contents"; then
  fail "Runner.entitlements must include com.apple.developer.ubiquity-kvstore-identifier"
fi

if ! rg -F 'CODE_SIGN_ENTITLEMENTS = Runner/RunnerDebug.entitlements;' "$PBXPROJ" >/dev/null; then
  fail "Debug config is not pointing at RunnerDebug.entitlements"
fi

if ! rg -F 'CODE_SIGN_ENTITLEMENTS = Runner/Runner.entitlements;' "$PBXPROJ" >/dev/null; then
  fail "Release/Profile config is not pointing at Runner.entitlements"
fi

echo "Apple signing doctor passed"
