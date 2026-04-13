#!/usr/bin/env bash

set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DRY_RUN="${DRY_RUN:-true}"
DELETE_CONFIRMED="${DELETE_CONFIRMED:-false}"

delete_count=0
keep_count=0
review_count=0
error_count=0
total_png=0

log() {
  printf '%s\n' "$1"
}

normalize_bool() {
  local value
  value="$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"
  case "$value" in
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

escape_path() {
  printf '%q' "$1"
}

category_for_path() {
  local rel="$1"
  case "$rel" in
    assets/*) printf 'flutter_asset' ;;
    ios/*|macos/*|android/*|web/*|apple_tv_app/*) printf 'platform_native' ;;
    test/*) printf 'test_fixture' ;;
    *) printf 'other' ;;
  esac
}

is_platform_required_png() {
  local rel="$1"
  case "$rel" in
    ios/*.xcassets/*|macos/*.xcassets/*|android/app/src/main/res/*|web/*|apple_tv_app/*|ios/Pods/*|macos/Pods/*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

has_matching_webp() {
  local abs="$1"
  local webp="${abs%.*}.webp"
  [[ -f "$webp" ]]
}

has_live_reference() {
  local rel="$1"
  if rg -n -F "$rel" \
    "$ROOT_DIR/lib" \
    "$ROOT_DIR/test" \
    "$ROOT_DIR/pubspec.yaml" \
    "$ROOT_DIR/ios" \
    "$ROOT_DIR/android" \
    "$ROOT_DIR/macos" \
    "$ROOT_DIR/web" \
    "$ROOT_DIR/apple_tv_app" \
    --glob '!**/*.g.dart' \
    --glob '!**/*.freezed.dart' \
    --glob '!**/Pods/**' >/dev/null 2>&1; then
    return 0
  fi
  return 1
}

should_delete_flutter_asset() {
  local abs="$1"
  local rel="$2"
  if ! has_matching_webp "$abs"; then
    return 1
  fi
  if has_live_reference "$rel"; then
    return 1
  fi
  return 0
}

delete_if_enabled() {
  local abs="$1"
  local rel="$2"
  if ! normalize_bool "$DELETE_CONFIRMED"; then
    log "[DELETE] candidate $(escape_path "$rel")"
    return 0
  fi
  if normalize_bool "$DRY_RUN"; then
    log "[DELETE] dry-run $(escape_path "$rel")"
    return 0
  fi
  rm -f "$abs"
  log "[DELETE] removed $(escape_path "$rel")"
}

validate() {
  normalize_bool "$DRY_RUN" >/dev/null
  normalize_bool "$DELETE_CONFIRMED" >/dev/null
  require_command find
  require_command rg
}

process_png() {
  local abs="$1"
  local rel="${abs#$ROOT_DIR/}"
  local category
  category="$(category_for_path "$rel")"

  total_png=$((total_png + 1))

  case "$category" in
    platform_native)
      keep_count=$((keep_count + 1))
      log "[KEEP] platform-required $(escape_path "$rel")"
      return 0
      ;;
    test_fixture)
      if has_matching_webp "$abs" && ! has_live_reference "$rel"; then
        delete_count=$((delete_count + 1))
        delete_if_enabled "$abs" "$rel"
      else
        keep_count=$((keep_count + 1))
        log "[KEEP] test fixture or still referenced $(escape_path "$rel")"
      fi
      return 0
      ;;
    flutter_asset)
      if should_delete_flutter_asset "$abs" "$rel"; then
        delete_count=$((delete_count + 1))
        delete_if_enabled "$abs" "$rel"
      else
        if has_matching_webp "$abs"; then
          review_count=$((review_count + 1))
          log "[REVIEW] matching webp exists but reference cleanup is incomplete $(escape_path "$rel")"
        else
          keep_count=$((keep_count + 1))
          log "[KEEP] no matching webp $(escape_path "$rel")"
        fi
      fi
      return 0
      ;;
    *)
      review_count=$((review_count + 1))
      log "[REVIEW] uncategorized $(escape_path "$rel")"
      return 0
      ;;
  esac
}

main() {
  validate
  log "== PNG Cleanup Audit =="
  log "root_dir=$ROOT_DIR"
  log "dry_run=$DRY_RUN"
  log "delete_confirmed=$DELETE_CONFIRMED"

  while IFS= read -r -d '' file; do
    if ! process_png "$file"; then
      error_count=$((error_count + 1))
      log "[ERROR] failed to process $(escape_path "$file")"
    fi
  done < <(find "$ROOT_DIR/assets" "$ROOT_DIR/ios" "$ROOT_DIR/android" "$ROOT_DIR/macos" "$ROOT_DIR/web" "$ROOT_DIR/apple_tv_app" -type f -iname '*.png' -print0 2>/dev/null | sort -z)

  log "== Cleanup Summary =="
  log "total_png=$total_png"
  log "safe_delete_candidates=$delete_count"
  log "kept=$keep_count"
  log "manual_review=$review_count"
  log "errors=$error_count"
}

main "$@"
