#!/usr/bin/env bash

set -u

ROOT_DIR="${ROOT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
ALLOWLIST_FILE="${ALLOWLIST_FILE:-$ROOT_DIR/tooling/config/runtime_png_allowlist.txt}"
RUNTIME_ASSET_DIRS="${RUNTIME_ASSET_DIRS:-assets}"
NATIVE_SCAN_PATHS="${NATIVE_SCAN_PATHS:-ios android macos web apple_tv_app}"

approved_native_count=0
approved_exception_count=0
approved_migrated_legacy_count=0
violation_count=0
info_count=0

allowlist_exact_paths=()
allowlist_prefix_paths=()

log() {
  printf '%s\n' "$1"
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log "[INFO] Missing required command: $1"
    exit 1
  fi
}

escape_path() {
  printf '%q' "$1"
}

trim() {
  local value="$1"
  value="${value#"${value%%[![:space:]]*}"}"
  value="${value%"${value##*[![:space:]]}"}"
  printf '%s' "$value"
}

load_allowlist() {
  local line trimmed
  if [[ ! -f "$ALLOWLIST_FILE" ]]; then
    log "[INFO] Allowlist file not found at $(escape_path "$ALLOWLIST_FILE"); continuing with no approved runtime exceptions."
    return 0
  fi

  while IFS= read -r line || [[ -n "$line" ]]; do
    trimmed="$(trim "$line")"
    [[ -z "$trimmed" ]] && continue
    [[ "${trimmed#\#}" != "$trimmed" ]] && continue

    case "$trimmed" in
      path:*)
        allowlist_exact_paths+=("${trimmed#path:}")
        ;;
      prefix:*)
        allowlist_prefix_paths+=("${trimmed#prefix:}")
        ;;
      *)
        log "[INFO] Ignoring unrecognized allowlist entry: $trimmed"
        ;;
    esac
  done < "$ALLOWLIST_FILE"
}

is_allowlisted_runtime_png() {
  local rel="$1"
  local entry
  if ((${#allowlist_exact_paths[@]} > 0)); then
    for entry in "${allowlist_exact_paths[@]}"; do
      [[ "$rel" == "$entry" ]] && return 0
    done
  fi
  if ((${#allowlist_prefix_paths[@]} > 0)); then
    for entry in "${allowlist_prefix_paths[@]}"; do
      case "$rel" in
        "$entry"*) return 0 ;;
      esac
    done
  fi
  return 1
}

has_live_runtime_reference() {
  local rel="$1"
  local count
  count="$(rg -F --count-matches --glob '!**/*.g.dart' --glob '!**/*.freezed.dart' \
    -- "$rel" \
    "$ROOT_DIR/lib" \
    "$ROOT_DIR/test" \
    "$ROOT_DIR/pubspec.yaml" 2>/dev/null | awk -F: '{sum += $NF} END {print sum + 0}')"
  [[ "${count:-0}" -gt 0 ]]
}

is_migrated_legacy_runtime_png() {
  local rel="$1"
  local webp_rel="${rel%.*}.webp"
  local webp_abs="$ROOT_DIR/$webp_rel"

  [[ -f "$webp_abs" ]] || return 1
  has_live_runtime_reference "$rel" && return 1
  return 0
}

check_runtime_assets() {
  local dir abs rel
  for dir in $RUNTIME_ASSET_DIRS; do
    abs="$ROOT_DIR/$dir"
    [[ -d "$abs" ]] || continue
    while IFS= read -r -d '' file; do
      rel="${file#$ROOT_DIR/}"
      if is_allowlisted_runtime_png "$rel"; then
        approved_exception_count=$((approved_exception_count + 1))
        log "[APPROVED_EXCEPTION] $rel"
      elif is_migrated_legacy_runtime_png "$rel"; then
        approved_migrated_legacy_count=$((approved_migrated_legacy_count + 1))
        log "[APPROVED_MIGRATED_LEGACY] $rel"
      else
        violation_count=$((violation_count + 1))
        log "[VIOLATION] $rel"
      fi
    done < <(find "$abs" -type f -iname '*.png' -print0 | sort -z)
  done
}

check_native_assets() {
  local dir abs rel
  for dir in $NATIVE_SCAN_PATHS; do
    abs="$ROOT_DIR/$dir"
    [[ -d "$abs" ]] || continue
    while IFS= read -r -d '' file; do
      rel="${file#$ROOT_DIR/}"
      approved_native_count=$((approved_native_count + 1))
      log "[APPROVED_NATIVE] $rel"
    done < <(find "$abs" -type f -iname '*.png' -print0 | sort -z)
  done
}

report_runtime_png_references() {
  local matches
  matches="$(rg -n "assets/.*\\.(png|PNG)\\b" \
    "$ROOT_DIR/lib" \
    "$ROOT_DIR/test" \
    "$ROOT_DIR/pubspec.yaml" \
    --glob '!**/*.g.dart' \
    --glob '!**/*.freezed.dart' 2>/dev/null || true)"
  if [[ -n "$matches" ]]; then
    info_count=1
    log "[INFO] Source references to runtime .png assets still exist under lib/test/pubspec.yaml."
  fi
}

validate() {
  require_command find
  require_command rg
}

main() {
  validate
  load_allowlist
  log "== Runtime PNG Policy Check =="
  log "root_dir=$ROOT_DIR"
  log "allowlist_file=$ALLOWLIST_FILE"
  log "runtime_asset_dirs=$RUNTIME_ASSET_DIRS"
  log "native_scan_paths=$NATIVE_SCAN_PATHS"

  check_runtime_assets
  check_native_assets
  report_runtime_png_references

  log "== Policy Summary =="
  log "approved_native=$approved_native_count"
  log "approved_exceptions=$approved_exception_count"
  log "approved_migrated_legacy=$approved_migrated_legacy_count"
  log "violations=$violation_count"
  log "info_messages=$info_count"

  if (( violation_count > 0 )); then
    exit 1
  fi
}

main "$@"
