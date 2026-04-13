#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="${ROOT_DIR:-$(pwd)}"
RUNTIME_ASSET_DIRS="${RUNTIME_ASSET_DIRS:-assets}"
REPORT_CSV="${REPORT_CSV:-}"
POLICY_SCRIPT="${POLICY_SCRIPT:-$ROOT_DIR/tooling/scripts/check_runtime_png_policy.sh}"
ALLOWLIST_FILE="${ALLOWLIST_FILE:-$ROOT_DIR/tooling/config/runtime_png_allowlist.txt}"

tmp_dir="$(mktemp -d)"
cleanup() {
  rm -rf "$tmp_dir"
}
trap cleanup EXIT

cd "$ROOT_DIR"

size_bytes() {
  if [ ! -f "$1" ]; then
    echo 0
    return
  fi
  stat -f '%z' "$1"
}

is_allowlisted() {
  local rel_path="$1"
  if [ ! -f "$ALLOWLIST_FILE" ]; then
    return 1
  fi

  while IFS= read -r line || [ -n "$line" ]; do
    line="${line#"${line%%[![:space:]]*}"}"
    line="${line%"${line##*[![:space:]]}"}"
    [ -z "$line" ] && continue
    case "$line" in
      \#*) continue ;;
      prefix:*)
        local prefix="${line#prefix:}"
        if [[ "$rel_path" == "$prefix"* ]]; then
          return 0
        fi
        ;;
      exact:*)
        local exact="${line#exact:}"
        if [ "$rel_path" = "$exact" ]; then
          return 0
        fi
        ;;
      *)
        if [ "$rel_path" = "$line" ]; then
          return 0
        fi
        ;;
    esac
  done < "$ALLOWLIST_FILE"

  return 1
}

reference_count() {
  local asset_path="$1"
  { rg -F --glob 'pubspec.yaml' --glob 'lib/**' --glob 'test/**' --count-matches "$asset_path" . 2>/dev/null || true; } \
    | awk -F: '{sum += $NF} END {print sum + 0}'
}

runtime_dirs_file="$tmp_dir/runtime_dirs.txt"
printf '%s\n' $RUNTIME_ASSET_DIRS > "$runtime_dirs_file"

runtime_images_file="$tmp_dir/runtime_images.txt"
> "$runtime_images_file"
while IFS= read -r runtime_dir || [ -n "$runtime_dir" ]; do
  [ -z "$runtime_dir" ] && continue
  if [ -d "$runtime_dir" ]; then
    find "$runtime_dir" -type f \( -iname '*.png' -o -iname '*.webp' \) | sort >> "$runtime_images_file"
  fi
done < "$runtime_dirs_file"

sort -u "$runtime_images_file" -o "$runtime_images_file"

runtime_png_file="$tmp_dir/runtime_png.txt"
runtime_webp_file="$tmp_dir/runtime_webp.txt"
awk '
{
  lp = tolower($0);
  if (lp ~ /\.png$/) print $0;
}
' "$runtime_images_file" > "$runtime_png_file"
awk '
{
  lp = tolower($0);
  if (lp ~ /\.webp$/) print $0;
}
' "$runtime_images_file" > "$runtime_webp_file"

inventory_summary="$tmp_dir/inventory_summary.txt"
find . \
  \( -path './.git' -o -path './build' -o -path './.dart_tool' -o -path './ios/Pods' -o -path './macos/Pods' -o -path './node_modules' \) -prune -o \
  -type f -print \
  | awk '
{
  lp = tolower($0);
  if (lp ~ /\.png$/) {
    total_png++;
    if ($0 ~ /^\.\/assets\//) runtime_png++;
    else if ($0 ~ /^\.\/(ios|android|macos|web|apple_tv_app)\//) native_png++;
    else other_png++;
  }
  if (lp ~ /\.webp$/) {
    total_webp++;
    if ($0 ~ /^\.\/assets\//) runtime_webp++;
    else if ($0 ~ /^\.\/(ios|android|macos|web|apple_tv_app)\//) native_webp++;
    else other_webp++;
  }
}
END {
  printf("total_png=%d\n", total_png);
  printf("total_webp=%d\n", total_webp);
  printf("runtime_png=%d\n", runtime_png);
  printf("runtime_webp=%d\n", runtime_webp);
  printf("native_png=%d\n", native_png);
  printf("native_webp=%d\n", native_webp);
  printf("other_png=%d\n", other_png);
  printf("other_webp=%d\n", other_webp);
}
' > "$inventory_summary"

runtime_folder_breakdown="$tmp_dir/runtime_folder_breakdown.tsv"
awk '
{
  lp = tolower($0);
  split($0, parts, "/");
  folder = parts[1] "/" parts[2];
  if (lp ~ /\.png$/) png[folder]++;
  if (lp ~ /\.webp$/) webp[folder]++;
}
END {
  for (folder in png) printf("%s\tpng\t%d\n", folder, png[folder]);
  for (folder in webp) printf("%s\twebp\t%d\n", folder, webp[folder]);
}
' "$runtime_images_file" | sort > "$runtime_folder_breakdown"

pair_report="$tmp_dir/pair_report.tsv"
printf 'png_path\twebp_path\tpng_exists\twebp_exists\tpng_ref_count\twebp_ref_count\tallowlisted\tclassification\tpng_bytes\twebp_bytes\tbytes_saved\n' > "$pair_report"

total_candidates=0
migrated_count=0
not_migrated_count=0
kept_intentionally_count=0
manual_review_count=0
paired_count=0
paired_png_total=0
paired_webp_total=0

while IFS= read -r png_path || [ -n "$png_path" ]; do
  [ -z "$png_path" ] && continue
  total_candidates=$((total_candidates + 1))
  webp_path="${png_path%.*}.webp"
  png_ref_count="$(reference_count "$png_path")"
  webp_ref_count="$(reference_count "$webp_path")"
  png_bytes="$(size_bytes "$png_path")"
  webp_exists=0
  webp_bytes=0
  bytes_saved=0
  if [ -f "$webp_path" ]; then
    webp_exists=1
    webp_bytes="$(size_bytes "$webp_path")"
    bytes_saved=$((png_bytes - webp_bytes))
    paired_count=$((paired_count + 1))
    paired_png_total=$((paired_png_total + png_bytes))
    paired_webp_total=$((paired_webp_total + webp_bytes))
  fi

  allowlisted=0
  if is_allowlisted "$png_path"; then
    allowlisted=1
  fi

  classification="NOT_MIGRATED"
  if [ "$webp_exists" -eq 1 ] && [ "$png_ref_count" -eq 0 ] && [ "$webp_ref_count" -gt 0 ]; then
    classification="MIGRATED"
  elif [ "$webp_exists" -eq 1 ] && [ "$png_ref_count" -gt 0 ]; then
    classification="NEEDS_MANUAL_REVIEW"
  elif [ "$webp_exists" -eq 1 ] && [ "$webp_ref_count" -eq 0 ]; then
    classification="NEEDS_MANUAL_REVIEW"
  elif [ "$allowlisted" -eq 1 ] && [ "$png_ref_count" -eq 0 ]; then
    classification="KEPT_INTENTIONALLY"
  fi

  case "$classification" in
    MIGRATED) migrated_count=$((migrated_count + 1)) ;;
    NOT_MIGRATED) not_migrated_count=$((not_migrated_count + 1)) ;;
    KEPT_INTENTIONALLY) kept_intentionally_count=$((kept_intentionally_count + 1)) ;;
    NEEDS_MANUAL_REVIEW) manual_review_count=$((manual_review_count + 1)) ;;
  esac

  printf '%s\t%s\t1\t%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$png_path" \
    "$webp_path" \
    "$webp_exists" \
    "$png_ref_count" \
    "$webp_ref_count" \
    "$allowlisted" \
    "$classification" \
    "$png_bytes" \
    "$webp_bytes" \
    "$bytes_saved" >> "$pair_report"
done < "$runtime_png_file"

webp_report="$tmp_dir/webp_report.tsv"
printf 'webp_path\tmatching_png_path\tpng_exists\twebp_ref_count\tpng_ref_count\tclassification\twebp_bytes\n' > "$webp_report"

webp_only_count=0
while IFS= read -r webp_path || [ -n "$webp_path" ]; do
  [ -z "$webp_path" ] && continue
  png_path="${webp_path%.*}.png"
  png_exists=0
  if [ -f "$png_path" ]; then
    png_exists=1
  fi
  webp_ref_count="$(reference_count "$webp_path")"
  png_ref_count="$(reference_count "$png_path")"
  classification="WEBP_ONLY"
  if [ "$png_exists" -eq 1 ]; then
    classification="PNG_AND_WEBP"
  fi
  if [ "$png_exists" -eq 0 ]; then
    webp_only_count=$((webp_only_count + 1))
  fi
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
    "$webp_path" \
    "$png_path" \
    "$png_exists" \
    "$webp_ref_count" \
    "$png_ref_count" \
    "$classification" \
    "$(size_bytes "$webp_path")" >> "$webp_report"
done < "$runtime_webp_file"

runtime_png_reference_audit="$tmp_dir/runtime_png_references.tsv"
printf 'ref_file\tline\tasset_path\texists\tmatching_webp_exists\tclassification\n' > "$runtime_png_reference_audit"

rg -n -o --glob 'pubspec.yaml' --glob 'lib/**' --glob 'test/**' "assets/[^'\"[:space:]]+\\.(png|PNG)" . 2>/dev/null \
  | while IFS=: read -r ref_file ref_line asset_path; do
      exists=0
      [ -f "$asset_path" ] && exists=1
      matching_webp=0
      webp_path="${asset_path%.*}.webp"
      [ -f "$webp_path" ] && matching_webp=1
      classification="ACTIVE_RUNTIME_PNG_REFERENCE"
      if [ "$exists" -eq 0 ]; then
        classification="STALE_OR_MISSING_RUNTIME_REFERENCE"
      elif [ "$matching_webp" -eq 1 ]; then
        classification="STALE_RUNTIME_REFERENCE_SHOULD_USE_WEBP"
      fi
      printf '%s\t%s\t%s\t%s\t%s\t%s\n' \
        "$ref_file" "$ref_line" "$asset_path" "$exists" "$matching_webp" "$classification" \
        >> "$runtime_png_reference_audit"
    done

active_runtime_png_refs="$(awk -F'\t' 'NR>1 && $6=="ACTIVE_RUNTIME_PNG_REFERENCE" {count++} END {print count+0}' "$runtime_png_reference_audit")"
stale_runtime_png_refs="$(awk -F'\t' 'NR>1 && $6=="STALE_RUNTIME_REFERENCE_SHOULD_USE_WEBP" {count++} END {print count+0}' "$runtime_png_reference_audit")"
missing_runtime_png_refs="$(awk -F'\t' 'NR>1 && $6=="STALE_OR_MISSING_RUNTIME_REFERENCE" {count++} END {print count+0}' "$runtime_png_reference_audit")"

if [ -n "$REPORT_CSV" ]; then
  awk -F'\t' 'BEGIN {OFS=","} NR==1 {print $0; next} {for (i=1;i<=NF;i++) {gsub(/"/, "\"\"", $i); $i="\"" $i "\""} print $0}' "$pair_report" > "$REPORT_CSV"
fi

policy_output_file="$tmp_dir/policy_output.txt"
policy_status="not_run"
if [ -x "$POLICY_SCRIPT" ] || [ -f "$POLICY_SCRIPT" ]; then
  if bash "$POLICY_SCRIPT" > "$policy_output_file" 2>&1; then
    policy_status="pass"
  else
    policy_status="fail"
  fi
fi

printf '== WebP Migration Audit ==\n'
printf 'root_dir=%s\n' "$ROOT_DIR"
printf 'runtime_asset_dirs=%s\n' "$RUNTIME_ASSET_DIRS"
printf '\n'
printf '== Inventory ==\n'
cat "$inventory_summary"
printf '\n'
printf '== Runtime Folder Breakdown ==\n'
awk -F'\t' '{printf "%s %s=%s\n", $1, $2, $3}' "$runtime_folder_breakdown"
printf '\n'
printf '== Runtime Migration Summary ==\n'
printf 'runtime_png_candidates=%s\n' "$total_candidates"
printf 'runtime_webp_files=%s\n' "$(wc -l < "$runtime_webp_file" | tr -d ' ')"
printf 'migrated=%s\n' "$migrated_count"
printf 'not_migrated=%s\n' "$not_migrated_count"
printf 'kept_intentionally=%s\n' "$kept_intentionally_count"
printf 'needs_manual_review=%s\n' "$manual_review_count"
printf 'webp_only_files=%s\n' "$webp_only_count"
printf '\n'
printf '== Runtime Reference Audit ==\n'
printf 'active_runtime_png_references=%s\n' "$active_runtime_png_refs"
printf 'stale_runtime_png_references=%s\n' "$stale_runtime_png_refs"
printf 'missing_runtime_png_references=%s\n' "$missing_runtime_png_refs"
printf '\n'
printf '== Pairwise Savings ==\n'
printf 'paired_png_webp_files=%s\n' "$paired_count"
printf 'original_png_total_bytes=%s\n' "$paired_png_total"
printf 'new_webp_total_bytes=%s\n' "$paired_webp_total"
printf 'bytes_saved=%s\n' "$((paired_png_total - paired_webp_total))"
if [ "$paired_png_total" -gt 0 ]; then
  awk -v png_total="$paired_png_total" -v webp_total="$paired_webp_total" 'BEGIN {
    saved = png_total - webp_total;
    mb = saved / (1024 * 1024);
    pct = (saved / png_total) * 100;
    printf("mb_saved=%.2f\npercent_saved=%.2f\n", mb, pct);
  }'
else
  printf 'mb_saved=0.00\npercent_saved=0.00\n'
fi
printf '\n'
printf '== Top Savings ==\n'
if [ "$paired_count" -gt 0 ]; then
  awk -F'\t' 'NR>1 {print $11 "\t" $1 "\t" $2}' "$pair_report" | sort -nr | head -20 \
    | awk -F'\t' '{printf "bytes_saved=%s png=%s webp=%s\n", $1, $2, $3}'
else
  printf 'No sibling PNG/WebP pairs found in runtime assets.\n'
fi
printf '\n'
printf '== Regressions ==\n'
if [ "$paired_count" -gt 0 ]; then
  awk -F'\t' 'NR>1 && $11 < 0 {print $11 "\t" $1 "\t" $2}' "$pair_report" | sort -n \
    | awk -F'\t' 'BEGIN {found=0} {found=1; printf "bytes_delta=%s png=%s webp=%s\n", $1, $2, $3} END {if (!found) print "None."}'
else
  printf 'None.\n'
fi
printf '\n'
printf '== WebP-Only Runtime Files ==\n'
awk -F'\t' 'NR>1 && $6=="WEBP_ONLY" {printf "%s refs=%s\n", $1, $4}' "$webp_report"
printf '\n'
printf '== Source Runtime PNG References ==\n'
awk -F'\t' 'NR>1 {printf "%s:%s %s %s\n", $1, $2, $3, $6}' "$runtime_png_reference_audit"
printf '\n'
printf '== CI Policy Check ==\n'
printf 'policy_status=%s\n' "$policy_status"
if [ -f "$policy_output_file" ]; then
  cat "$policy_output_file"
fi
