#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

echo "== Flutter pub get =="
flutter pub get

echo "== iOS simulator build =="
flutter build ios --debug --simulator

echo "== watchOS simulator build =="
xcodebuild \
  -project ios/Runner.xcodeproj \
  -scheme "PathOfNurWatch Watch App" \
  -configuration Debug \
  -sdk watchsimulator \
  -destination 'generic/platform=watchOS Simulator' \
  CODE_SIGNING_ALLOWED=NO \
  build

echo "== Apple signing doctor =="
bash scripts/apple_signing_doctor.sh

echo "== iOS archive graph validation =="
xcodebuild \
  -workspace ios/Runner.xcworkspace \
  -scheme Runner \
  -configuration Release \
  -destination 'generic/platform=iOS' \
  -archivePath "$ROOT_DIR/build/ios/archive/Runner.xcarchive" \
  CODE_SIGNING_ALLOWED=NO \
  archive

echo "== Apple archive packaging validation =="
bash scripts/validate_apple_archive.sh "$ROOT_DIR/build/ios/archive/Runner.xcarchive"
