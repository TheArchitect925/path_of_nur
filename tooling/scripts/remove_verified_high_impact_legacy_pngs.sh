#!/usr/bin/env bash

set -u

ROOT_DIR="${ROOT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
ARCHIVE_ROOT="${ARCHIVE_ROOT:-/Users/shahabmansoor/Developer/Path of Nur Deleted and Cleaned Items/2026-04-13/high-impact-legacy-png-cleanup}"
DRY_RUN="${DRY_RUN:-true}"
DELETE_CONFIRMED="${DELETE_CONFIRMED:-false}"

TARGET_DIRS=(
  "assets/images/backgrounds"
  "assets/images/wudu"
  "assets/images/prophets"
)

INTENTIONAL_HOLDOUTS=(
  "assets/images/backgrounds/Loading.png"
)

safe_delete_count=0
keep_count=0
manual_review_count=0
deleted_count=0
archive_count=0
error_count=0

log() {
  printf '%s\n' "$1"
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    log "[ERROR] Missing required command: $1"
    exit 1
  fi
}

is_holdout() {
  local rel="$1"
  local holdout
  for holdout in "${INTENTIONAL_HOLDOUTS[@]}"; do
    [[ "$rel" == "$holdout" ]] && return 0
  done
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

audit_png() {
  local rel="$1"
  local abs="$ROOT_DIR/$rel"
  local webp_rel="${rel%.*}.webp"
  local webp_abs="$ROOT_DIR/$webp_rel"

  if is_holdout "$rel"; then
    keep_count=$((keep_count + 1))
    log "[KEEP] $rel intentional runtime holdout"
    return 1
  fi

  if [[ ! -f "$webp_abs" ]]; then
    manual_review_count=$((manual_review_count + 1))
    log "[MANUAL_REVIEW] $rel missing sibling $webp_rel"
    return 1
  fi

  if has_live_runtime_reference "$rel"; then
    manual_review_count=$((manual_review_count + 1))
    log "[MANUAL_REVIEW] $rel still referenced in live runtime sources"
    return 1
  fi

  safe_delete_count=$((safe_delete_count + 1))
  log "[SAFE_TO_DELETE] $rel -> $webp_rel live refs already migrated"

  if [[ "$DRY_RUN" == "true" || "$DELETE_CONFIRMED" != "true" ]]; then
    return 0
  fi

  local archive_path="$ARCHIVE_ROOT/$rel"
  mkdir -p "$(dirname "$archive_path")"
  if cp "$abs" "$archive_path"; then
    archive_count=$((archive_count + 1))
  else
    error_count=$((error_count + 1))
    log "[ERROR] Failed to archive $rel"
    return 1
  fi

  if rm "$abs"; then
    deleted_count=$((deleted_count + 1))
    log "[DELETE] $rel archived at $archive_path"
  else
    error_count=$((error_count + 1))
    log "[ERROR] Failed to delete $rel after archive copy"
    return 1
  fi
}

validate() {
  require_command find
  require_command rg
  require_command cp
  require_command rm
  require_command mkdir
}

main() {
  validate
  log "[AUDIT] root_dir=$ROOT_DIR"
  log "[AUDIT] archive_root=$ARCHIVE_ROOT"
  log "[AUDIT] dry_run=$DRY_RUN delete_confirmed=$DELETE_CONFIRMED"

  local dir abs file rel
  for dir in "${TARGET_DIRS[@]}"; do
    abs="$ROOT_DIR/$dir"
    [[ -d "$abs" ]] || continue
    while IFS= read -r -d '' file; do
      rel="${file#$ROOT_DIR/}"
      audit_png "$rel"
    done < <(find "$abs" -type f -iname '*.png' -print0 | sort -z)
  done

  log "[SUMMARY] safe_to_delete=$safe_delete_count"
  log "[SUMMARY] kept=$keep_count"
  log "[SUMMARY] manual_review=$manual_review_count"
  log "[SUMMARY] archived=$archive_count"
  log "[SUMMARY] deleted=$deleted_count"
  log "[SUMMARY] errors=$error_count"

  if (( error_count > 0 )); then
    exit 1
  fi
}

main "$@"
