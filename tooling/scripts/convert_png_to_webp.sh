#!/usr/bin/env bash

set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
ASSETS_DIR="${ASSETS_DIR:-$ROOT_DIR/assets}"
DRY_RUN="${DRY_RUN:-true}"
DELETE_ORIGINAL="${DELETE_ORIGINAL:-false}"
SMALL_FILE_THRESHOLD_KB="${SMALL_FILE_THRESHOLD_KB:-200}"
LOSSY_QUALITY="${LOSSY_QUALITY:-85}"
LOSSLESS_METHOD="${LOSSLESS_METHOD:-6}"

total_png=0
total_webp=0
total_pairs=0
converted=0
skipped=0
failed=0

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

is_lossless_candidate() {
  local file_kb="$1"
  if (( file_kb < SMALL_FILE_THRESHOLD_KB )); then
    return 0
  fi
  return 1
}

run_conversion() {
  local input_path="$1"
  local output_path="$2"
  local file_kb="$3"

  if is_lossless_candidate "$file_kb"; then
    if normalize_bool "$DRY_RUN"; then
      log "[CONVERT] lossless $(escape_path "$input_path") -> $(escape_path "$output_path")"
      return 0
    fi
    cwebp -lossless -m "$LOSSLESS_METHOD" "$input_path" -o "$output_path" >/dev/null 2>&1
    return $?
  fi

  if normalize_bool "$DRY_RUN"; then
    log "[CONVERT] lossy q=$LOSSY_QUALITY $(escape_path "$input_path") -> $(escape_path "$output_path")"
    return 0
  fi
  cwebp -q "$LOSSY_QUALITY" "$input_path" -o "$output_path" >/dev/null 2>&1
}

confirm_output() {
  local output_path="$1"
  [[ -f "$output_path" && -s "$output_path" ]]
}

delete_original_if_enabled() {
  local input_path="$1"
  if ! normalize_bool "$DELETE_ORIGINAL"; then
    return 0
  fi
  if normalize_bool "$DRY_RUN"; then
    log "[SKIP] delete disabled in dry run for $(escape_path "$input_path")"
    return 0
  fi
  rm -f "$input_path"
  log "[DELETE] $(escape_path "$input_path")"
}

print_audit() {
  local pairs_output
  pairs_output="$(find "$ASSETS_DIR" -type f \( -iname '*.png' -o -iname '*.webp' \) | python3 -c 'import sys, os; from collections import defaultdict; by_stem=defaultdict(set); [by_stem[os.path.splitext(line.strip())[0]].add(os.path.splitext(line.strip())[1].lower()) for line in sys.stdin if line.strip()]; pairs=sorted(stem for stem, exts in by_stem.items() if ".png" in exts and ".webp" in exts); print(len(pairs))')"
  total_pairs="${pairs_output:-0}"
  total_png="$(find "$ASSETS_DIR" -type f -iname '*.png' | wc -l | tr -d ' ')"
  total_webp="$(find "$ASSETS_DIR" -type f -iname '*.webp' | wc -l | tr -d ' ')"

  log "== Audit Summary =="
  log "assets_dir=$ASSETS_DIR"
  log "png_files=$total_png"
  log "webp_files=$total_webp"
  log "existing_png_webp_pairs=$total_pairs"
  log "dry_run=$DRY_RUN"
  log "delete_original=$DELETE_ORIGINAL"
  log "small_file_threshold_kb=$SMALL_FILE_THRESHOLD_KB"
  log "lossy_quality=$LOSSY_QUALITY"
  log "lossless_method=$LOSSLESS_METHOD"
}

validate_configuration() {
  if [[ ! -d "$ASSETS_DIR" ]]; then
    log "[ERROR] Assets directory not found: $ASSETS_DIR"
    exit 1
  fi
  if ! [[ "$SMALL_FILE_THRESHOLD_KB" =~ ^[0-9]+$ ]]; then
    log "[ERROR] SMALL_FILE_THRESHOLD_KB must be an integer."
    exit 1
  fi
  if ! [[ "$LOSSY_QUALITY" =~ ^[0-9]+$ ]] || (( LOSSY_QUALITY < 0 || LOSSY_QUALITY > 100 )); then
    log "[ERROR] LOSSY_QUALITY must be an integer between 0 and 100."
    exit 1
  fi
  if ! [[ "$LOSSLESS_METHOD" =~ ^[0-9]+$ ]]; then
    log "[ERROR] LOSSLESS_METHOD must be an integer."
    exit 1
  fi
  normalize_bool "$DRY_RUN" >/dev/null
  normalize_bool "$DELETE_ORIGINAL" >/dev/null
  require_command find
  require_command python3
}

validate_converter_ready() {
  require_command cwebp
}

process_pngs() {
  while IFS= read -r -d '' png_path; do
    local webp_path="${png_path%.*}.webp"
    local file_kb

    if [[ -e "$webp_path" ]]; then
      skipped=$((skipped + 1))
      log "[SKIP] existing output $(escape_path "$webp_path")"
      continue
    fi

    file_kb="$(du -k "$png_path" | awk '{print $1}')"
    if [[ -z "$file_kb" ]]; then
      failed=$((failed + 1))
      log "[ERROR] failed to measure $(escape_path "$png_path")"
      continue
    fi

    if run_conversion "$png_path" "$webp_path" "$file_kb"; then
      if normalize_bool "$DRY_RUN" || confirm_output "$webp_path"; then
        converted=$((converted + 1))
        delete_original_if_enabled "$png_path"
      else
        failed=$((failed + 1))
        log "[ERROR] missing or empty output $(escape_path "$webp_path")"
      fi
    else
      failed=$((failed + 1))
      log "[ERROR] conversion failed for $(escape_path "$png_path")"
    fi
  done < <(find "$ASSETS_DIR" -type f -iname '*.png' -print0 | sort -z)
}

print_validation() {
  local final_pairs
  local final_png
  local final_webp

  final_pairs="$(find "$ASSETS_DIR" -type f \( -iname '*.png' -o -iname '*.webp' \) | python3 -c 'import sys, os; from collections import defaultdict; by_stem=defaultdict(set); [by_stem[os.path.splitext(line.strip())[0]].add(os.path.splitext(line.strip())[1].lower()) for line in sys.stdin if line.strip()]; print(sum(1 for exts in by_stem.values() if ".png" in exts and ".webp" in exts))')"
  final_png="$(find "$ASSETS_DIR" -type f -iname '*.png' | wc -l | tr -d ' ')"
  final_webp="$(find "$ASSETS_DIR" -type f -iname '*.webp' | wc -l | tr -d ' ')"

  log "== Validation Summary =="
  log "png_files_after=$final_png"
  log "webp_files_after=$final_webp"
  log "png_webp_pairs_after=$final_pairs"
  log "folder_structure_status=unchanged_by_script"
  log "overwrites_prevented=true"
  log "== Conversion Summary =="
  log "converted=$converted"
  log "skipped=$skipped"
  log "failed=$failed"
}

main() {
  validate_configuration
  print_audit
  if ! normalize_bool "$DRY_RUN"; then
    validate_converter_ready
  fi
  process_pngs
  print_validation
}

main "$@"
