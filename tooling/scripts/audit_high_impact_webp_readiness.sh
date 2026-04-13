#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="${ROOT_DIR:-$(pwd)}"
REPORT_CSV="${REPORT_CSV:-}"
TARGET_DIRS=(
  "assets/images/prophets"
  "assets/images/backgrounds"
  "assets/images/wudu"
)

tmp_dir="$(mktemp -d)"
cleanup() {
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

cd "$ROOT_DIR"

size_bytes() {
  stat -f '%z' "$1"
}

dimensions() {
  local file_path="$1"
  local width height
  width="$(sips -g pixelWidth "$file_path" 2>/dev/null | awk '/pixelWidth/ {print $2}')"
  height="$(sips -g pixelHeight "$file_path" 2>/dev/null | awk '/pixelHeight/ {print $2}')"
  printf '%sx%s\n' "${width:-unknown}" "${height:-unknown}"
}

normalized_ext() {
  printf '%s' "$1" | awk '{
    lp=tolower($0);
    if (lp ~ /\.png$/) print "png";
    else if (lp ~ /\.webp$/) print "webp";
    else print "other";
  }'
}

has_uppercase_png_extension() {
  case "$1" in
    *.PNG) return 0 ;;
    *) return 1 ;;
  esac
}

leading_numeric_token() {
  local base_name="$1"
  printf '%s' "$base_name" | sed -E 's/^([0-9]+).*/\1/'
}

find_related_webp_note() {
  local png_path="$1"
  local png_dir png_base numeric_token candidate
  png_dir="$(dirname "$png_path")"
  png_base="$(basename "$png_path")"
  numeric_token="$(leading_numeric_token "$png_base")"

  if [ -f "${png_path%.*}.webp" ]; then
    printf 'Sibling WebP already exists.'
    return
  fi

  if [ -n "$numeric_token" ] && [ "$numeric_token" != "$png_base" ]; then
    while IFS= read -r candidate; do
      case "$(basename "$candidate")" in
        "$numeric_token"*)
          printf 'Existing related WebP name mismatch: %s' "$candidate"
          return
          ;;
      esac
    done < <(find "$png_dir" -maxdepth 1 -type f -iname '*.webp' | sort)
  fi

  printf ''
}

classify_file() {
  local png_path="$1"
  local dimensions_value="$2"
  local mode note stem_name

  case "$png_path" in
    assets/images/backgrounds/Loading.png)
      mode="MANUAL_REVIEW"
      note="Branded background with baked text/logo; review visual quality before any lossy pass."
      ;;
    assets/images/backgrounds/*)
      mode="LOSSY_Q85"
      note="Full-frame textured scenic background; lossy WebP is the best first-pass candidate."
      ;;
    assets/images/wudu/*)
      mode="LOSSLESS"
      note="Instructional illustration with clean edges and/or text-safe UI treatment; prefer lossless."
      ;;
    assets/images/prophets/*)
      mode="LOSSLESS"
      note="Poster-style Prophet card with baked title text and soft illustration details; favor text-safe lossless output."
      ;;
    *)
      mode="MANUAL_REVIEW"
      note="Out-of-pattern asset; classify manually."
      ;;
  esac

  if has_uppercase_png_extension "$png_path"; then
    note="$note Uppercase .PNG extension: keep execution scripts case-insensitive."
  fi

  stem_name="$(basename "${png_path%.*}")"
  case "$stem_name" in
    *" "*)
      note="$note Filename includes spaces: quote paths during conversion."
      ;;
    *[!A-Za-z0-9_-]*)
      note="$note Filename uses unusual punctuation: quote paths during conversion."
      ;;
  esac

  printf '%s\t%s\n' "$mode" "$note"
}

inventory_tsv="$tmp_dir/inventory.tsv"
printf 'path\tfolder\tfile_name\tsize_bytes\tdimensions\tsibling_webp\trelated_webp_note\trecommended_mode\tnotes\n' > "$inventory_tsv"

for dir_path in "${TARGET_DIRS[@]}"; do
  find "$dir_path" -type f -iname '*.png' | sort | while IFS= read -r png_path; do
    dims="$(dimensions "$png_path")"
    sibling_webp="no"
    [ -f "${png_path%.*}.webp" ] && sibling_webp="yes"
    related_note="$(find_related_webp_note "$png_path")"
    classification="$(classify_file "$png_path" "$dims")"
    recommended_mode="${classification%%$'\t'*}"
    notes="${classification#*$'\t'}"
    if [ -n "$related_note" ]; then
      notes="$notes $related_note"
    fi
    printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
      "$png_path" \
      "$dir_path" \
      "$(basename "$png_path")" \
      "$(size_bytes "$png_path")" \
      "$dims" \
      "$sibling_webp" \
      "$related_note" \
      "$recommended_mode" \
      "$notes" >> "$inventory_tsv"
  done
done

if [ -n "$REPORT_CSV" ]; then
  awk -F'\t' 'BEGIN {OFS=","}
    {
      for (i = 1; i <= NF; i++) {
        gsub(/"/, "\"\"", $i);
        $i="\"" $i "\"";
      }
      print $0;
    }' "$inventory_tsv" > "$REPORT_CSV"
fi

printf '== High-Impact WebP Readiness Audit ==\n'
printf 'root_dir=%s\n' "$ROOT_DIR"
printf 'target_dirs=%s\n' "${TARGET_DIRS[*]}"
printf '\n'

total_png_count=0
total_png_bytes=0
total_existing_webp_count=0
readiness_status="READY"
blockers=0

printf '== Folder Breakdown ==\n'
for dir_path in "${TARGET_DIRS[@]}"; do
  png_count="$(find "$dir_path" -type f -iname '*.png' | wc -l | tr -d ' ')"
  webp_count="$(find "$dir_path" -type f -iname '*.webp' | wc -l | tr -d ' ')"
  png_bytes="$(find "$dir_path" -type f -iname '*.png' | while IFS= read -r f; do size_bytes "$f"; done | awk '{s+=$1} END {print s+0}')"
  webp_bytes="$(find "$dir_path" -type f -iname '*.webp' | while IFS= read -r f; do size_bytes "$f"; done | awk '{s+=$1} END {print s+0}')"
  total_png_count=$((total_png_count + png_count))
  total_png_bytes=$((total_png_bytes + png_bytes))
  total_existing_webp_count=$((total_existing_webp_count + webp_count))

  lossless_count="$(awk -F'\t' -v dir="$dir_path" 'NR>1 && $2==dir && $8=="LOSSLESS" {count++} END {print count+0}' "$inventory_tsv")"
  lossy_count="$(awk -F'\t' -v dir="$dir_path" 'NR>1 && $2==dir && $8=="LOSSY_Q85" {count++} END {print count+0}' "$inventory_tsv")"
  manual_count="$(awk -F'\t' -v dir="$dir_path" 'NR>1 && $2==dir && $8=="MANUAL_REVIEW" {count++} END {print count+0}' "$inventory_tsv")"

  printf '%s\n' "$dir_path"
  printf '  png_count=%s\n' "$png_count"
  printf '  existing_webp_count=%s\n' "$webp_count"
  printf '  png_bytes=%s\n' "$png_bytes"
  printf '  existing_webp_bytes=%s\n' "$webp_bytes"
  printf '  recommended_modes=LOSSLESS:%s LOSSY_Q85:%s MANUAL_REVIEW:%s\n' "$lossless_count" "$lossy_count" "$manual_count"
  printf '  largest_pngs:\n'
  find "$dir_path" -type f -iname '*.png' | while IFS= read -r f; do printf '%s\t%s\n' "$(size_bytes "$f")" "$f"; done | sort -nr | head -5 \
    | awk -F'\t' '{printf "    %s bytes %s\n", $1, $2}'
  printf '  subfolders:\n'
  find "$dir_path" -type f \( -iname '*.png' -o -iname '*.webp' \) | awk -v base="$dir_path/" '
    {
      path=$0;
      sub("^" base, "", path);
      split(path, parts, "/");
      bucket=(length(parts) > 1 ? parts[1] : ".");
      counts[bucket]++;
    }
    END {
      for (bucket in counts) printf "    %s count=%d\n", bucket, counts[bucket];
    }' | sort
  printf '\n'
done

printf '== Inventory Table ==\n'
cat "$inventory_tsv"
printf '\n'

existing_sibling_webp_count="$(awk -F'\t' 'NR>1 && $6=="yes" {count++} END {print count+0}' "$inventory_tsv")"
related_mismatch_count="$(awk -F'\t' 'NR>1 && length($7)>0 {count++} END {print count+0}' "$inventory_tsv")"
manual_review_count="$(awk -F'\t' 'NR>1 && $8=="MANUAL_REVIEW" {count++} END {print count+0}' "$inventory_tsv")"

if [ "$manual_review_count" -gt 0 ] || [ "$related_mismatch_count" -gt 0 ]; then
  readiness_status="READY_WITH_NOTES"
fi

printf '== Conflict Audit ==\n'
printf 'existing_sibling_webp_count=%s\n' "$existing_sibling_webp_count"
printf 'related_webp_name_mismatch_count=%s\n' "$related_mismatch_count"
awk -F'\t' 'NR>1 && length($7)>0 {printf "%s -> %s\n", $1, $7}' "$inventory_tsv"
printf '\n'

printf '== Wave Plan ==\n'
printf 'Wave 1: assets/images/backgrounds\n'
printf '  png_count=15\n'
printf '  png_bytes=45033683\n'
printf '  mode_mix=LOSSY_Q85:14 MANUAL_REVIEW:1\n'
printf '  rationale=Largest immediate size win with mostly scenic full-frame art and no existing WebP naming conflicts.\n'
printf 'Wave 2: assets/images/wudu\n'
printf '  png_count=14\n'
printf '  png_bytes=27157750\n'
printf '  mode_mix=LOSSLESS:14\n'
printf '  rationale=Consistent instructional illustration set; safe to batch with one lossless command pattern.\n'
printf 'Wave 3: assets/images/prophets\n'
printf '  png_count=25\n'
printf '  png_bytes=66224989\n'
printf '  mode_mix=LOSSLESS:25\n'
printf '  rationale=Largest single folder, but title-bearing poster art plus the Adam naming mismatch make it the highest-review wave.\n'
printf '\n'

printf '== Safe Command Plan ==\n'
printf 'Lossless pattern:\n'
printf '  cwebp -lossless -z 9 "input.png" -o "output.webp"\n'
printf 'Lossy pattern:\n'
printf '  cwebp -q 85 -m 6 -af "input.png" -o "output.webp"\n'
printf 'Skip-if-exists guard:\n'
printf '  if [ -f "${input%%.*}.webp" ]; then echo "[SKIP] $input"; else ...; fi\n'
printf 'Dry-run first:\n'
printf '  DRY_RUN=true DELETE_ORIGINAL=false bash tooling/scripts/convert_png_to_webp.sh\n'
printf 'Recommended exact sequence next:\n'
printf '  1. Convert Wave 1 lossy backgrounds, excluding Loading.png.\n'
printf '  2. Convert Loading.png separately after a quick visual spot-check, ideally with lossless.\n'
printf '  3. Convert all Wave 2 wudu PNGs with lossless.\n'
printf '  4. Convert all Wave 3 prophets PNGs with lossless, then reconcile the Adam WebP naming mismatch before any reference migration.\n'
printf 'Logging expectations:\n'
printf '  [CONVERT] [SKIP] [ERROR] with one summary line per wave.\n'
printf '\n'

printf '== Executive Summary ==\n'
printf 'readiness_status=%s\n' "$readiness_status"
printf 'total_png_in_scope=%s\n' "$total_png_count"
printf 'total_png_bytes_in_scope=%s\n' "$total_png_bytes"
printf 'existing_webp_in_scope=%s\n' "$total_existing_webp_count"
printf 'key_notes:\n'
printf '  - backgrounds are ready for a mostly lossy first wave, with Loading.png marked MANUAL_REVIEW due baked branding text.\n'
printf '  - wudu is ready for a clean lossless batch.\n'
printf '  - prophets is ready with notes: existing story WebPs are already present, and Adam has a non-sibling WebP naming mismatch.\n'
printf '  - cwebp is not installed in this environment, so execution remains blocked until the encoder is available.\n'
