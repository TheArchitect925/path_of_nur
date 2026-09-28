#!/usr/bin/env bash
# Builds the signed Apple TV package for App Store Connect.
#
#   bash scripts/build_apple_tv_ipa.sh
#
# The archive is made unsigned and the package is signed at export. An archive
# signs with a development profile, and a tvOS development profile needs an
# Apple TV registered on the team; the App Store profile that export uses
# needs none. Export asks Xcode to create or refresh that profile
# (-allowProvisioningUpdates), so the Apple ID must be signed in under
# Xcode > Settings > Accounts.
#
# Nothing is uploaded. Send build/ios/ipa/path_of_nur_tv.ipa with Transporter.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

ARCHIVE="$ROOT_DIR/build/tvos/archive/PathOfNurTV.xcarchive"
EXPORT_DIR="$ROOT_DIR/build/tvos/export"
OUTPUT="$ROOT_DIR/build/ios/ipa/path_of_nur_tv.ipa"
team_id="$(sed -n 's/^APPLE_DEVELOPMENT_TEAM = //p' ios/Flutter/AppConfig.xcconfig | head -n1 | tr -d '[:space:]')"

echo "== Guards =="
bash scripts/ci_apple_bundle_consistency.sh
bash scripts/verify_tv_prayer_times.sh
bash scripts/verify_tv_quran_library.sh

echo "== Archive =="
rm -rf "$ARCHIVE" "$EXPORT_DIR"
xcodebuild \
  -project ios/Runner.xcodeproj \
  -scheme PathOfNurTV \
  -configuration Release \
  -destination 'generic/platform=tvOS' \
  -archivePath "$ARCHIVE" \
  CODE_SIGNING_ALLOWED=NO \
  archive

echo "== Export =="
OPTIONS="$(mktemp -t tv-export-options).plist"
trap 'rm -f "$OPTIONS"' EXIT
cat > "$OPTIONS" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>method</key>
	<string>app-store-connect</string>
	<key>destination</key>
	<string>export</string>
	<key>signingStyle</key>
	<string>automatic</string>
	<key>teamID</key>
	<string>${team_id}</string>
	<key>manageAppVersionAndBuildNumber</key>
	<false/>
</dict>
</plist>
PLIST
xcodebuild -exportArchive \
  -archivePath "$ARCHIVE" \
  -exportOptionsPlist "$OPTIONS" \
  -exportPath "$EXPORT_DIR" \
  -allowProvisioningUpdates

echo "== Inspect =="
# The package is what ships, so the package is what is checked.
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK" "$OPTIONS"' EXIT
unzip -q "$EXPORT_DIR/PathOfNurTV.ipa" -d "$WORK"
APP="$WORK/Payload/PathOfNurTV.app"

codesign --verify --deep --strict "$APP"
authority="$(codesign -dvvv "$APP" 2>&1 | sed -n 's/^Authority=//p' | head -n1)"
case "$authority" in
  "Apple Distribution:"*) ;;
  *) echo "Signed by '$authority', not a distribution certificate" >&2; exit 1 ;;
esac

read_plist() { /usr/bin/plutil -extract "$1" raw "$APP/Info.plist"; }
base_bundle_id="$(sed -n 's/^APP_BUNDLE_ID_BASE = //p' ios/Flutter/AppConfig.xcconfig | head -n1 | tr -d '[:space:]')"
[[ "$(read_plist CFBundleIdentifier)" == "$base_bundle_id" ]] \
  || { echo "Package bundle identifier is not $base_bundle_id" >&2; exit 1; }
read_plist CFBundleIcons.CFBundlePrimaryIcon >/dev/null \
  || { echo "Package has no app icon" >&2; exit 1; }
read_plist TVTopShelfImage.TVTopShelfPrimaryImageWide >/dev/null \
  || { echo "Package has no Top Shelf image" >&2; exit 1; }
[[ -f "$APP/PrivacyInfo.xcprivacy" ]] \
  || { echo "Package has no privacy manifest" >&2; exit 1; }

mkdir -p "$(dirname "$OUTPUT")"
cp "$EXPORT_DIR/PathOfNurTV.ipa" "$OUTPUT"
echo "Signed by: $authority"
echo "Version:   $(read_plist CFBundleShortVersionString) ($(read_plist CFBundleVersion))"
echo "Package:   $OUTPUT"
