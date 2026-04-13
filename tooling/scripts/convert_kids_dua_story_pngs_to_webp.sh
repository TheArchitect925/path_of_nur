#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="${ROOT_DIR:-$(pwd)}"
TARGET_DIR="${TARGET_DIR:-assets/images/kids_dua_stories}"
DRY_RUN="${DRY_RUN:-true}"
OVERWRITE_EXISTING="${OVERWRITE_EXISTING:-false}"
DELETE_ORIGINAL="${DELETE_ORIGINAL:-false}"

log() {
  printf '%s\n' "$1"
}

bool_true() {
  case "$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')" in
    1|true|yes|y|on) return 0 ;;
    0|false|no|n|off) return 1 ;;
    *)
      log "[ERROR] Invalid boolean value: $1"
      exit 1
      ;;
  esac
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log "[ERROR] Required command not found: $1"
    exit 1
  fi
}

size_bytes() {
  stat -f '%z' "$1"
}

validate_precheck() {
  require_command cwebp
  require_command find
  if bool_true "$DELETE_ORIGINAL"; then
    log "[ERROR] DELETE_ORIGINAL=true is not allowed in this phase."
    exit 1
  fi
  if [[ ! -d "$ROOT_DIR/$TARGET_DIR" ]]; then
    log "[ERROR] Target directory not found: $TARGET_DIR"
    exit 1
  fi
  log "[PRECHECK] root_dir=$ROOT_DIR"
  log "[PRECHECK] target_dir=$TARGET_DIR"
  log "[PRECHECK] dry_run=$DRY_RUN"
  log "[PRECHECK] overwrite_existing=$OVERWRITE_EXISTING"
  log "[PRECHECK] delete_original=$DELETE_ORIGINAL"
  log "[PRECHECK] cwebp_version=$(cwebp -version)"
}

total_scanned=0
total_converted=0
total_skipped=0
total_failed=0
original_total=0
webp_total=0

convert_one() {
  local source_path="$1"
  local destination_path="${source_path%.*}.webp"
  local original_bytes
  local new_bytes
  local delta

  total_scanned=$((total_scanned + 1))

  if [[ -f "$destination_path" ]] && ! bool_true "$OVERWRITE_EXISTING"; then
    total_skipped=$((total_skipped + 1))
    log "[SKIP_EXISTING] $source_path -> $destination_path"
    return 0
  fi

  original_bytes="$(size_bytes "$source_path")"
  original_total=$((original_total + original_bytes))

  if bool_true "$DRY_RUN"; then
    total_converted=$((total_converted + 1))
    log "[CONVERT_LOSSY] $source_path -> $destination_path original_bytes=$original_bytes dry_run=true"
    return 0
  fi

  if ! cwebp -q 85 -m 6 -af "$source_path" -o "$destination_path" >/dev/null 2>&1; then
    total_failed=$((total_failed + 1))
    log "[ERROR] $source_path conversion_failed mode=lossy_q85"
    return 1
  fi

  if [[ ! -s "$destination_path" ]]; then
    total_failed=$((total_failed + 1))
    log "[ERROR] $destination_path missing_or_empty_after_conversion"
    return 1
  fi

  new_bytes="$(size_bytes "$destination_path")"
  webp_total=$((webp_total + new_bytes))
  delta=$((original_bytes - new_bytes))
  total_converted=$((total_converted + 1))
  log "[CONVERT_LOSSY] $source_path -> $destination_path original_bytes=$original_bytes new_bytes=$new_bytes bytes_saved=$delta"
}

main() {
  validate_precheck
  cd "$ROOT_DIR"

  local source_path
  while IFS= read -r source_path; do
    [[ -z "$source_path" ]] && continue
    convert_one "$source_path"
  done < <(find "$TARGET_DIR" -type f -iname '*.png' | LC_ALL=C sort)

  log "[SUMMARY] scanned=$total_scanned"
  log "[SUMMARY] converted=$total_converted"
  log "[SUMMARY] skipped=$total_skipped"
  log "[SUMMARY] failed=$total_failed"
  log "[SUMMARY] original_total_bytes=$original_total"
  log "[SUMMARY] webp_total_bytes=$webp_total"
  if (( total_failed > 0 )); then
    exit 1
  fi
}

main "$@"
