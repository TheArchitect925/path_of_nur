#!/usr/bin/env bash
# Takes the Apple TV screenshots the App Store asks for, in every language
# the app ships.
#
#   bash scripts/capture_tvos_store_screenshots.sh [simulator-udid]
#
# The App Store takes Apple TV screenshots at 1920x1080 or 3840x2160, without
# an alpha channel. These are 3840x2160 JPEGs, nine to a language, written to
# build/store/tvos/<language>/. Nothing is uploaded.
#
# A television cannot be driven from a script, so each screen is reached with
# the app's simulator-only launch overrides (TV_SAMPLE_ROUTE and the rest).
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

BUNDLE_ID="$(sed -n 's/^APP_BUNDLE_ID_BASE = //p' ios/Flutter/AppConfig.xcconfig | head -n1 | tr -d '[:space:]')"
DERIVED="$ROOT_DIR/build/tvos/derived"
OUTPUT="$ROOT_DIR/build/store/tvos"

DEVICE="${1:-}"
if [[ -z "$DEVICE" ]]; then
  DEVICE="$(xcrun simctl list devices available | sed -n 's/.*Apple TV 4K[^(]*(\([0-9A-F-]\{36\}\)).*/\1/p' | head -n1)"
fi
[[ -n "$DEVICE" ]] || { echo "No Apple TV 4K simulator is installed" >&2; exit 1; }

echo "== Build =="
xcodebuild \
  -project ios/Runner.xcodeproj \
  -scheme PathOfNurTV \
  -configuration Debug \
  -destination "platform=tvOS Simulator,id=$DEVICE" \
  -derivedDataPath "$DERIVED" \
  build >/dev/null

echo "== Simulator =="
# A restart clears any permission alert a previous run left on the screen.
xcrun simctl shutdown "$DEVICE" 2>/dev/null || true
xcrun simctl boot "$DEVICE"
xcrun simctl bootstatus "$DEVICE" >/dev/null
xcrun simctl uninstall "$DEVICE" "$BUNDLE_ID" 2>/dev/null || true
xcrun simctl install "$DEVICE" "$DERIVED/Build/Products/Debug-appletvsimulator/PathOfNurTV.app"
xcrun simctl privacy "$DEVICE" grant location "$BUNDLE_ID"

# language  locale  city
PLACES=(
  "en en_US toronto"
  "de de_DE berlin"
  "fr fr_FR paris"
  "ar ar_SA makkah"
  "ur ur_PK karachi"
)

# name  route  then any further overrides as KEY=value
SHOTS=(
  "01-home home TV_SAMPLE_THEME=midnight"
  "02-prayer prayer TV_SAMPLE_THEME=midnight"
  "03-quran quran TV_SAMPLE_THEME=midnight TV_SAMPLE_SURAH=1 TV_SAMPLE_SECTION=quran.reader"
  "04-listening quran TV_SAMPLE_THEME=midnight TV_SAMPLE_SURAH=1 TV_SAMPLE_LISTENING=1"
  "05-dhikr dhikr TV_SAMPLE_THEME=midnight"
  "06-routine dhikr TV_SAMPLE_THEME=midnight TV_SAMPLE_ROUTINE=after-salah"
  "07-settings settings TV_SAMPLE_THEME=midnight TV_SAMPLE_SECTION=settings.prayer"
  "08-daylight home TV_SAMPLE_THEME=noorGlass TV_SAMPLE_PHASE=day"
  "09-cities settings TV_SAMPLE_THEME=midnight TV_SAMPLE_CITY_PICKER=1"
)

rm -rf "$OUTPUT"
for place in "${PLACES[@]}"; do
  read -r language locale city <<<"$place"
  mkdir -p "$OUTPUT/$language"
  for shot in "${SHOTS[@]}"; do
    read -r name route overrides <<<"$shot"
    xcrun simctl terminate "$DEVICE" "$BUNDLE_ID" >/dev/null 2>&1 || true
    environment=("SIMCTL_CHILD_TV_SAMPLE_ROUTE=$route" "SIMCTL_CHILD_TV_SAMPLE_CITY=$city")
    for override in $overrides; do
      environment+=("SIMCTL_CHILD_$override")
    done
    env "${environment[@]}" xcrun simctl launch "$DEVICE" "$BUNDLE_ID" \
      -AppleLanguages "($language)" -AppleLocale "$locale" >/dev/null
    sleep 6
    raw="$(mktemp -t tv-shot).png"
    xcrun simctl io "$DEVICE" screenshot "$raw" >/dev/null 2>&1
    # JPEG carries no alpha channel, which the App Store refuses.
    sips -s format jpeg -s formatOptions 92 "$raw" --out "$OUTPUT/$language/$name.jpg" >/dev/null
    rm -f "$raw"
    echo "$language/$name.jpg"
  done
done

xcrun simctl terminate "$DEVICE" "$BUNDLE_ID" >/dev/null 2>&1 || true
xcrun simctl shutdown "$DEVICE" 2>/dev/null || true
echo "Screenshots: $OUTPUT"
