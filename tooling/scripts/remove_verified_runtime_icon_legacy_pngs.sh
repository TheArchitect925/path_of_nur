#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="${ROOT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
DRY_RUN="${DRY_RUN:-true}"
DELETE_CONFIRMED="${DELETE_CONFIRMED:-false}"

TARGETS=(
  "assets/icons/home_lantern_cropped.png"
  "assets/icons/learn_quran_cropped.png"
  "assets/icons/brotherlogo.PNG"
  "assets/icons/sisterlogo.png"
)

log() {
  printf '%s\n' "$1"
}

has_live_png_reference() {
  local asset_path="$1"
  local matches
  matches="$(rg -n -F --glob '!**/*.g.dart' --glob '!**/*.freezed.dart' -- "$asset_path" lib test pubspec.yaml || true)"
  [[ -n "$matches" ]]
}

audit_target() {
  local png_path="$1"
  local webp_path="${png_path%.*}.webp"

  if [[ ! -f "$png_path" ]]; then
    log "[KEEP] $png_path :: png_missing_already"
    return 0
  fi

  if [[ ! -f "$webp_path" ]]; then
    log "[KEEP] $png_path :: missing_webp_sibling"
    return 0
  fi

  if has_live_png_reference "$png_path"; then
    log "[KEEP] $png_path :: live_png_reference_still_present"
    return 0
  fi

  if [[ "$DRY_RUN" == "true" || "$DELETE_CONFIRMED" != "true" ]]; then
    log "[SAFE_TO_DELETE] $png_path -> $webp_path"
    return 0
  fi

  rm "$png_path"
  log "[DELETE] $png_path -> $webp_path"
}

main() {
  cd "$ROOT_DIR"
  for target in "${TARGETS[@]}"; do
    audit_target "$target"
  done
}

main "$@"
