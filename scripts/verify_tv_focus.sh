#!/usr/bin/env bash
# How the focus travels in the Apple TV app, checked by pressing the remote's
# buttons in a simulator and reading back where the focus is.
#
#   bash scripts/verify_tv_focus.sh [simulator-udid] [test ...]
#
# With no test named, every test in
# tooling/tv_focus_harness/UITests/QuranFocusTests.swift is run, which takes
# about a quarter of an hour. Name one or more to run those alone:
#
#   bash scripts/verify_tv_focus.sh "" test10_aLongAyahIsReadPartByPart
#
# The log and the screenshots are left in build/tvos/focus/. Two tests play
# the recitation, which is streamed, so they need the network.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

BUNDLE_ID="com.shahab.pathOfNur"
OUTPUT="$ROOT_DIR/build/tvos/focus"
DERIVED="$ROOT_DIR/build/tvos/focus-derived"

DEVICE="${1:-}"
if [[ $# -gt 0 ]]; then shift; fi
if [[ -z "$DEVICE" ]]; then
  DEVICE="$(xcrun simctl list devices available | sed -n 's/.*Apple TV 4K[^(]*(\([0-9A-F-]\{36\}\)).*/\1/p' | head -n1)"
fi
[[ -n "$DEVICE" ]] || { echo "No Apple TV 4K simulator is installed" >&2; exit 1; }

only=()
for name in "$@"; do
  only+=("-only-testing:TVFocusTests/QuranFocusTests/$name")
done

echo "== Build =="
mkdir -p "$DERIVED"
xcodebuild \
  -project ios/Runner.xcodeproj \
  -scheme PathOfNurTV \
  -configuration Debug \
  -sdk appletvsimulator \
  -destination "platform=tvOS Simulator,id=$DEVICE" \
  -derivedDataPath "$DERIVED/app" \
  CODE_SIGNING_ALLOWED=NO \
  build >"$DERIVED/build.log" 2>&1 || {
    grep -E "error: |BUILD" "$DERIVED/build.log" | head -n 20 >&2
    exit 1
  }

echo "== Install =="
xcrun simctl boot "$DEVICE" 2>/dev/null || true
xcrun simctl bootstatus "$DEVICE" >/dev/null
xcrun simctl install "$DEVICE" "$DERIVED/app/Build/Products/Debug-appletvsimulator/PathOfNurTV.app"

echo "== Focus =="
rm -rf "$OUTPUT"
mkdir -p "$OUTPUT"
status=0
TEST_RUNNER_TV_FOCUS_OUT="$OUTPUT" xcodebuild test \
  -project tooling/tv_focus_harness/TVFocusHarness.xcodeproj \
  -scheme TVFocusTests \
  -destination "platform=tvOS Simulator,id=$DEVICE" \
  -derivedDataPath "$DERIVED/harness" \
  ${only[@]+"${only[@]}"} >"$OUTPUT/xcodebuild.log" 2>&1 || status=$?

xcrun simctl terminate "$DEVICE" "$BUNDLE_ID" >/dev/null 2>&1 || true

if [[ ! -f "$OUTPUT/focus.log" ]]; then
  grep -E "error: |\*\* TEST" "$OUTPUT/xcodebuild.log" | cut -c1-300 | head -n 20 >&2
  echo "No test ran. See $OUTPUT/xcodebuild.log" >&2
  exit 1
fi

grep -E "^(==|FAIL)" "$OUTPUT/focus.log" || true
passed="$(grep -c "^PASS" "$OUTPUT/focus.log" || true)"
failed="$(grep -c "^FAIL" "$OUTPUT/focus.log" || true)"
echo "Apple TV focus: $passed steps held, $failed did not. Log and screenshots: $OUTPUT"
[[ "$failed" -eq 0 && "$status" -eq 0 ]]
