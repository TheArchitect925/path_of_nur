#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="${ROOT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
DRY_RUN="${DRY_RUN:-true}"
DELETE_CONFIRMED="${DELETE_CONFIRMED:-false}"

candidates=(
  "assets/icons/creative_palette.png"
  "assets/icons/journey_tree_cropped.png"
  "assets/icons/knowledge_globe.png"
  "assets/icons/map_location.png"
  "assets/icons/notification_bell.png"
  "assets/icons/quran_moon.png"
  "assets/icons/secure_lock.png"
  "assets/icons/worship_hands_cropped.png"
)

log() {
  printf '%s\n' "$1"
}

runtime_reference_count() {
  local rel="$1"
  rg -F --count-matches --glob '!**/*.g.dart' --glob '!**/*.freezed.dart' \
    -- "$rel" \
    "$ROOT_DIR/lib" \
    "$ROOT_DIR/test" \
    "$ROOT_DIR/pubspec.yaml" 2>/dev/null | awk -F: '{sum += $NF} END {print sum + 0}'
}

main() {
  local rel abs ref_count safe_count keep_count
  safe_count=0
  keep_count=0

  log "[AUDIT] remove_unreferenced_runtime_icon_pngs"
  log "[AUDIT] root_dir=$ROOT_DIR"
  log "[AUDIT] dry_run=$DRY_RUN delete_confirmed=$DELETE_CONFIRMED"

  for rel in "${candidates[@]}"; do
    abs="$ROOT_DIR/$rel"
    if [[ ! -f "$abs" ]]; then
      log "[KEEP] $rel :: already absent"
      keep_count=$((keep_count + 1))
      continue
    fi

    ref_count="$(runtime_reference_count "$rel")"
    if [[ "$ref_count" != "0" ]]; then
      log "[KEEP] $rel :: live_refs=$ref_count"
      keep_count=$((keep_count + 1))
      continue
    fi

    if [[ "$DRY_RUN" == "true" || "$DELETE_CONFIRMED" != "true" ]]; then
      log "[SAFE_TO_DELETE] $rel :: live_refs=0"
    else
      rm -f "$abs"
      log "[DELETE] $rel :: live_refs=0"
    fi
    safe_count=$((safe_count + 1))
  done

  log "[SUMMARY] candidates=${#candidates[@]} safe_to_delete=$safe_count kept=$keep_count"
}

main "$@"
