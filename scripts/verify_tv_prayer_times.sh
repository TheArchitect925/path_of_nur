#!/usr/bin/env bash
# The television's prayer times against the phone's, to the minute.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

BUILD_DIR="$(mktemp -d)"
trap 'rm -rf "$BUILD_DIR"' EXIT

# `main.swift` is the one file allowed top-level code when two are compiled.
cp tooling/scripts/verify_tv_prayer_times.swift "$BUILD_DIR/main.swift"
env -u TOOLCHAINS xcrun swiftc -O \
  ios/PathOfNurTV/Data/TVPrayerCalculator.swift \
  "$BUILD_DIR/main.swift" \
  -o "$BUILD_DIR/verify"

"$BUILD_DIR/verify" tools/tv_prayer_reference.json
