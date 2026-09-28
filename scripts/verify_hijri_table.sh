#!/usr/bin/env bash
# The Umm al-Qura table the phone and the television read, against the
# system's own calendar. With --write, writes the table from the calendar.
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

BUILD_DIR="$(mktemp -d)"
trap 'rm -rf "$BUILD_DIR"' EXIT

cp tooling/scripts/umm_al_qura_table.swift "$BUILD_DIR/main.swift"
env -u TOOLCHAINS xcrun swiftc -O "$BUILD_DIR/main.swift" -o "$BUILD_DIR/table"

"$BUILD_DIR/table" "$@"
