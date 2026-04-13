#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="${ROOT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
DRY_RUN="${DRY_RUN:-true}"
OVERWRITE_EXISTING="${OVERWRITE_EXISTING:-false}"
DELETE_ORIGINAL="${DELETE_ORIGINAL:-false}"

TARGETS=(
  "assets/icons/home_lantern_cropped.png"
  "assets/icons/learn_quran_cropped.png"
  "assets/icons/brotherlogo.PNG"
  "assets/icons/sisterlogo.png"
)

log() {
  printf '%s\n' "$1"
}

size_bytes() {
  stat -f '%z' "$1"
}

convert_file() {
  local png_path="$1"
  local webp_path="${png_path%.*}.webp"
  local original_bytes
  local new_bytes
  local delta

  if [[ -f "$webp_path" && "$OVERWRITE_EXISTING" != "true" ]]; then
    log "[SKIP_EXISTING] $png_path -> $webp_path"
    return 0
  fi

  original_bytes="$(size_bytes "$png_path")"

  if [[ "$DRY_RUN" == "true" ]]; then
    log "[DRY_RUN_LOSSLESS] $png_path -> $webp_path :: original_bytes=$original_bytes"
    return 0
  fi

  cwebp -lossless -z 9 "$png_path" -o "$webp_path" >/dev/null
  new_bytes="$(size_bytes "$webp_path")"
  delta=$((original_bytes - new_bytes))
  log "[CONVERT_LOSSLESS] $png_path -> $webp_path :: original_bytes=$original_bytes :: webp_bytes=$new_bytes :: bytes_saved=$delta"

  if [[ "$DELETE_ORIGINAL" == "true" ]]; then
    log "[INFO] DELETE_ORIGINAL=true requested, but this script never deletes source PNGs."
  fi
}

main() {
  cd "$ROOT_DIR"
  command -v cwebp >/dev/null 2>&1 || {
    log "[ERROR] cwebp is not available."
    exit 1
  }

  for target in "${TARGETS[@]}"; do
    if [[ ! -f "$target" ]]; then
      log "[ERROR] Missing source PNG: $target"
      continue
    fi
    convert_file "$target"
  done
}

main "$@"
