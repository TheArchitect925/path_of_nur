#!/usr/bin/env bash
# The television's Qur'an reader against the files it reads, surah by surah,
# and the parts it sets a long ayah in against the ayah, word by word.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

BUILD_DIR="$(mktemp -d)"
trap 'rm -rf "$BUILD_DIR"' EXIT

# `main.swift` is the one file allowed top-level code when several are compiled.
cp tooling/scripts/verify_tv_quran_library.swift "$BUILD_DIR/main.swift"
env -u TOOLCHAINS xcrun swiftc -O \
  ios/PathOfNurTV/Models/TVModels.swift \
  ios/PathOfNurTV/Models/TVNavigationModels.swift \
  ios/PathOfNurTV/Support/TVLocalized.swift \
  ios/PathOfNurTV/Support/TVQuranAyahLayout.swift \
  ios/PathOfNurTV/Data/TVQuranLibrary.swift \
  ios/PathOfNurTV/Data/TVQuranData.swift \
  "$BUILD_DIR/main.swift" \
  -o "$BUILD_DIR/verify"

"$BUILD_DIR/verify" ios/PathOfNurTV/Data/Quran assets/fonts
