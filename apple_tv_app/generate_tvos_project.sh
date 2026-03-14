#!/usr/bin/env bash
set -euo pipefail

if ! command -v xcodegen >/dev/null 2>&1; then
  echo "xcodegen is required to generate the PathOfNurTV.xcodeproj from apple_tv_app/project.yml"
  echo "Install it with: brew install xcodegen"
  exit 1
fi

cd "$(dirname "$0")"
xcodegen generate
echo "Generated apple_tv_app/PathOfNurTV.xcodeproj"
