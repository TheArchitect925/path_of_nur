#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

python3 - <<'PY'
import re
from collections import Counter, defaultdict
from pathlib import Path

SEARCH_ROOTS = ['lib', 'test', 'pubspec.yaml']
TARGET_DOMAINS = ('kids_stories', 'quran_teacher')
ASSET_RE = re.compile(r"assets/images/(kids_stories|quran_teacher)/[^'\"\s)]+")


def classify_root_cause(asset_path: str) -> str:
    path = Path(asset_path)
    if '$' in asset_path:
        return 'MANUAL_REVIEW'
    if path.exists():
        return 'RESOLVED'
    return 'TRUE_MISSING_ASSET'


def domain_for(asset_path: str) -> str:
    return 'kids_stories' if 'kids_stories' in asset_path else 'quran_teacher'


entries = []
for root in SEARCH_ROOTS:
    path = Path(root)
    files = [path] if path.is_file() else [f for f in path.rglob('*') if f.is_file()]
    for file_path in files:
        try:
            text = file_path.read_text()
        except Exception:
            continue
        for line_number, line in enumerate(text.splitlines(), 1):
            for match in ASSET_RE.finditer(line):
                asset_path = match.group(0)
                entries.append(
                    {
                        'file': str(file_path),
                        'line': line_number,
                        'asset_path': asset_path,
                        'exists': Path(asset_path).exists(),
                        'root_cause': classify_root_cause(asset_path),
                    }
                )

concrete_entries = [
    entry
    for entry in entries
    if '.' in Path(entry['asset_path']).name and '$' not in entry['asset_path']
]
missing_entries = [entry for entry in concrete_entries if not entry['exists']]

grouped_refs = defaultdict(list)
for entry in missing_entries:
    grouped_refs[entry['asset_path']].append(f"{entry['file']}:{entry['line']}")

domain_counts = Counter(domain_for(entry['asset_path']) for entry in missing_entries)

print("[SUMMARY]")
print(f"scanned_references={len(entries)}")
print(f"concrete_missing_references={len(missing_entries)}")
print(f"unique_missing_assets={len(grouped_refs)}")
print(
    "by_domain="
    + ",".join(f"{domain}:{domain_counts.get(domain, 0)}" for domain in TARGET_DOMAINS)
)

print("\n[KIDS_STORIES_MISSING_CONTENT]")
for asset_path in sorted(path for path in grouped_refs if 'kids_stories' in path):
    refs = grouped_refs[asset_path]
    print(f"{asset_path} :: refs={len(refs)} :: first_ref={refs[0]}")

print("\n[QURAN_TEACHER_MISSING_CONTENT]")
for asset_path in sorted(path for path in grouped_refs if 'quran_teacher' in path):
    refs = grouped_refs[asset_path]
    print(f"{asset_path} :: refs={len(refs)} :: first_ref={refs[0]}")

template_entries = [
    entry for entry in entries if '$' in entry['asset_path'] or '.' not in Path(entry['asset_path']).name
]
print("\n[MANUAL_REVIEW]")
for entry in sorted(template_entries, key=lambda item: (item['file'], item['line'], item['asset_path'])):
    print(f"{entry['file']}:{entry['line']} :: {entry['asset_path']}")
PY
