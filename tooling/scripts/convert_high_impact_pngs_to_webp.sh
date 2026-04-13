#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="${ROOT_DIR:-$(pwd)}"
DRY_RUN="${DRY_RUN:-true}"
OVERWRITE_EXISTING="${OVERWRITE_EXISTING:-false}"
DELETE_ORIGINAL="${DELETE_ORIGINAL:-false}"

tmp_dir="$(mktemp -d)"
cleanup() {
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

cd "$ROOT_DIR"

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

report_file="$tmp_dir/converted.tsv"
printf 'wave\tmode\tsource\tdestination\toriginal_bytes\tnew_bytes\tbytes_delta\n' > "$report_file"

total_scanned=0
total_converted=0
total_skipped=0
total_excluded=0
total_failed=0

wave_background_scanned=0
wave_background_converted=0
wave_background_skipped=0
wave_background_excluded=0
wave_background_failed=0

wave_wudu_scanned=0
wave_wudu_converted=0
wave_wudu_skipped=0
wave_wudu_excluded=0
wave_wudu_failed=0

wave_prophets_scanned=0
wave_prophets_converted=0
wave_prophets_skipped=0
wave_prophets_excluded=0
wave_prophets_failed=0

validate_precheck() {
  require_command cwebp
  require_command file
  if bool_true "$DELETE_ORIGINAL"; then
    log "[ERROR] DELETE_ORIGINAL=true is not allowed in this phase."
    exit 1
  fi
  log "[PRECHECK] root_dir=$ROOT_DIR"
  log "[PRECHECK] dry_run=$DRY_RUN"
  log "[PRECHECK] overwrite_existing=$OVERWRITE_EXISTING"
  log "[PRECHECK] delete_original=$DELETE_ORIGINAL"
  log "[PRECHECK] cwebp_version=$(cwebp -version)"
}

record_result() {
  local wave="$1"
  local mode="$2"
  local source="$3"
  local destination="$4"
  local original_bytes="$5"
  local new_bytes="$6"
  local bytes_delta="$7"
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$wave" "$mode" "$source" "$destination" "$original_bytes" "$new_bytes" "$bytes_delta" >> "$report_file"
}

increment_wave_counter() {
  local counter_name="$1"
  case "$counter_name" in
    background_scanned) wave_background_scanned=$((wave_background_scanned + 1)) ;;
    background_converted) wave_background_converted=$((wave_background_converted + 1)) ;;
    background_skipped) wave_background_skipped=$((wave_background_skipped + 1)) ;;
    background_excluded) wave_background_excluded=$((wave_background_excluded + 1)) ;;
    background_failed) wave_background_failed=$((wave_background_failed + 1)) ;;
    wudu_scanned) wave_wudu_scanned=$((wave_wudu_scanned + 1)) ;;
    wudu_converted) wave_wudu_converted=$((wave_wudu_converted + 1)) ;;
    wudu_skipped) wave_wudu_skipped=$((wave_wudu_skipped + 1)) ;;
    wudu_excluded) wave_wudu_excluded=$((wave_wudu_excluded + 1)) ;;
    wudu_failed) wave_wudu_failed=$((wave_wudu_failed + 1)) ;;
    prophets_scanned) wave_prophets_scanned=$((wave_prophets_scanned + 1)) ;;
    prophets_converted) wave_prophets_converted=$((wave_prophets_converted + 1)) ;;
    prophets_skipped) wave_prophets_skipped=$((wave_prophets_skipped + 1)) ;;
    prophets_excluded) wave_prophets_excluded=$((wave_prophets_excluded + 1)) ;;
    prophets_failed) wave_prophets_failed=$((wave_prophets_failed + 1)) ;;
    *)
      log "[ERROR] Unknown counter: $counter_name"
      exit 1
      ;;
  esac
}

convert_one() {
  local wave_label="$1"
  local mode_label="$2"
  local source_path="$3"
  local destination_path="${source_path%.*}.webp"
  local original_bytes
  local new_bytes
  local bytes_delta
  local wave_key

  case "$wave_label" in
    WAVE_BACKGROUND) wave_key="background" ;;
    WAVE_WUDU) wave_key="wudu" ;;
    WAVE_PROPHETS) wave_key="prophets" ;;
    *)
      log "[ERROR] Unknown wave label: $wave_label"
      exit 1
      ;;
  esac

  total_scanned=$((total_scanned + 1))
  increment_wave_counter "${wave_key}_scanned"

  if [ -f "$destination_path" ] && ! bool_true "$OVERWRITE_EXISTING"; then
    total_skipped=$((total_skipped + 1))
    increment_wave_counter "${wave_key}_skipped"
    log "[SKIP_EXISTING] $source_path -> $destination_path"
    return 0
  fi

  original_bytes="$(size_bytes "$source_path")"

  if bool_true "$DRY_RUN"; then
    total_converted=$((total_converted + 1))
    increment_wave_counter "${wave_key}_converted"
    log "[${wave_label}] [${mode_label}] $source_path -> $destination_path original_bytes=$original_bytes dry_run=true"
    return 0
  fi

  if [ "$mode_label" = "CONVERT_LOSSY" ]; then
    if ! cwebp -q 85 -m 6 -af "$source_path" -o "$destination_path" >/dev/null 2>&1; then
      total_failed=$((total_failed + 1))
      increment_wave_counter "${wave_key}_failed"
      log "[ERROR] $source_path conversion_failed mode=lossy_q85"
      return 1
    fi
  else
    if ! cwebp -lossless -z 9 "$source_path" -o "$destination_path" >/dev/null 2>&1; then
      total_failed=$((total_failed + 1))
      increment_wave_counter "${wave_key}_failed"
      log "[ERROR] $source_path conversion_failed mode=lossless"
      return 1
    fi
  fi

  if [ ! -s "$destination_path" ]; then
    total_failed=$((total_failed + 1))
    increment_wave_counter "${wave_key}_failed"
    log "[ERROR] $destination_path missing_or_empty_after_conversion"
    return 1
  fi

  new_bytes="$(size_bytes "$destination_path")"
  bytes_delta=$((original_bytes - new_bytes))
  total_converted=$((total_converted + 1))
  increment_wave_counter "${wave_key}_converted"
  record_result "$wave_label" "$mode_label" "$source_path" "$destination_path" "$original_bytes" "$new_bytes" "$bytes_delta"
  log "[${mode_label}] $source_path -> $destination_path original_bytes=$original_bytes new_bytes=$new_bytes bytes_saved=$bytes_delta"
}

run_background_wave() {
  local source_path
  log "[WAVE_BACKGROUND] start folder=assets/images/backgrounds mode=lossy_q85 exclude=assets/images/backgrounds/Loading.png"
  while IFS= read -r source_path; do
    [ -z "$source_path" ] && continue
    if [ "$source_path" = "assets/images/backgrounds/Loading.png" ]; then
      total_excluded=$((total_excluded + 1))
      increment_wave_counter "background_excluded"
      log "[EXCLUDE_MANUAL_REVIEW] $source_path"
      continue
    fi
    convert_one "WAVE_BACKGROUND" "CONVERT_LOSSY" "$source_path"
  done < <(find assets/images/backgrounds -type f -iname '*.png' | LC_ALL=C sort)
}

run_wudu_wave() {
  local source_path
  log "[WAVE_WUDU] start folder=assets/images/wudu mode=lossless"
  while IFS= read -r source_path; do
    [ -z "$source_path" ] && continue
    convert_one "WAVE_WUDU" "CONVERT_LOSSLESS" "$source_path"
  done < <(find assets/images/wudu -type f -iname '*.png' | LC_ALL=C sort)
}

run_prophets_wave() {
  local source_path
  log "[WAVE_PROPHETS] start folder=assets/images/prophets mode=lossless note=adam_mismatch_nonblocking"
  while IFS= read -r source_path; do
    [ -z "$source_path" ] && continue
    convert_one "WAVE_PROPHETS" "CONVERT_LOSSLESS" "$source_path"
  done < <(find assets/images/prophets -type f -iname '*.png' | LC_ALL=C sort)
}

validate_outputs() {
  local wave sample_path sample_dest
  if bool_true "$DRY_RUN"; then
    log "[SUMMARY] validation_skipped_for_dry_run=true"
    return 0
  fi

  if [ ! -f "assets/images/backgrounds/Loading.png" ]; then
    log "[ERROR] Loading.png missing after conversion"
    exit 1
  fi
  if [ -f "assets/images/backgrounds/Loading.webp" ]; then
    log "[ERROR] Loading.webp should not have been created in this phase"
    exit 1
  fi

  for sample_path in \
    "assets/images/backgrounds/growth.png" \
    "assets/images/wudu/step_11_wash_feet_card.png" \
    "assets/images/prophets/24.png"; do
    sample_dest="${sample_path%.*}.webp"
    if [ ! -f "$sample_path" ]; then
      log "[ERROR] source_missing_after_conversion $sample_path"
      exit 1
    fi
    if [ ! -f "$sample_dest" ]; then
      log "[ERROR] expected_webp_missing $sample_dest"
      exit 1
    fi
    log "[SUMMARY] spot_check $(file "$sample_dest")"
  done
}

print_stats_for_wave() {
  local wave_label="$1"
  local friendly_name="$2"
  awk -F'\t' -v wave="$wave_label" -v name="$friendly_name" '
    NR > 1 && $1 == wave {
      original += $5;
      newer += $6;
      count += 1;
    }
    END {
      saved = original - newer;
      if (original > 0) {
        pct = (saved / original) * 100;
      } else {
        pct = 0;
      }
      printf("[SUMMARY] %s converted=%d original_bytes=%d new_bytes=%d bytes_saved=%d mb_saved=%.2f percent_saved=%.2f\n",
        name, count, original, newer, saved, saved / (1024 * 1024), pct);
    }
  ' "$report_file"
}

print_final_summary() {
  log "[SUMMARY] total_scanned_in_scope=$total_scanned"
  log "[SUMMARY] total_webps_created=$total_converted"
  log "[SUMMARY] total_skipped_due_to_existing=$total_skipped"
  log "[SUMMARY] total_manually_excluded=$total_excluded"
  log "[SUMMARY] total_failures=$total_failed"
  log "[SUMMARY] wave_background scanned=$wave_background_scanned converted=$wave_background_converted skipped=$wave_background_skipped excluded=$wave_background_excluded failed=$wave_background_failed"
  log "[SUMMARY] wave_wudu scanned=$wave_wudu_scanned converted=$wave_wudu_converted skipped=$wave_wudu_skipped excluded=$wave_wudu_excluded failed=$wave_wudu_failed"
  log "[SUMMARY] wave_prophets scanned=$wave_prophets_scanned converted=$wave_prophets_converted skipped=$wave_prophets_skipped excluded=$wave_prophets_excluded failed=$wave_prophets_failed"

  if ! bool_true "$DRY_RUN"; then
    awk -F'\t' '
      NR > 1 {
        original += $5;
        newer += $6;
        count += 1;
      }
      END {
        saved = original - newer;
        if (original > 0) {
          pct = (saved / original) * 100;
        } else {
          pct = 0;
        }
        printf("[SUMMARY] total_original_png_bytes=%d\n", original);
        printf("[SUMMARY] total_new_webp_bytes=%d\n", newer);
        printf("[SUMMARY] total_bytes_saved=%d\n", saved);
        printf("[SUMMARY] total_mb_saved=%.2f\n", saved / (1024 * 1024));
        printf("[SUMMARY] total_percent_saved=%.2f\n", pct);
      }
    ' "$report_file"

    print_stats_for_wave "WAVE_BACKGROUND" "wave_background"
    print_stats_for_wave "WAVE_WUDU" "wave_wudu"
    print_stats_for_wave "WAVE_PROPHETS" "wave_prophets"

    log "[SUMMARY] top_20_savings_begin"
    awk -F'\t' 'NR > 1 {print $7 "\t" $3 "\t" $4}' "$report_file" | sort -nr | head -20 \
      | awk -F'\t' '{printf "[SUMMARY] top_saving bytes_saved=%s source=%s destination=%s\n", $1, $2, $3}'
    log "[SUMMARY] top_20_savings_end"

    log "[SUMMARY] larger_webp_files_begin"
    awk -F'\t' 'NR > 1 && $7 < 0 {printf "[SUMMARY] larger_webp bytes_delta=%s source=%s destination=%s\n", $7, $3, $4}' "$report_file"
    log "[SUMMARY] larger_webp_files_end"
  fi
}

main() {
  validate_precheck
  run_background_wave
  run_wudu_wave
  run_prophets_wave
  validate_outputs
  print_final_summary
}

main "$@"
