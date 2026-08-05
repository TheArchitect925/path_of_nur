#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="${ROOT_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)}"
cd "$ROOT_DIR"

python3 - <<'PY'
import re
from collections import Counter, defaultdict
from pathlib import Path

EXCLUDE_PREFIXES = ('ios/Pods/', 'macos/Pods/', '.dart_tool/', 'build/', 'node_modules/')
MIGRATED_FOLDERS = [
    'assets/images/backgrounds',
    'assets/images/wudu',
    'assets/images/prophets',
    'assets/images/kids_dua_stories',
]
INTENTIONAL_HOLDOUTS = {'assets/images/backgrounds/Loading.png'}
ALLOWLIST_PREFIXES = ['assets/icons/']
RUNTIME_REFERENCE_ROOTS = ['lib', 'test', 'pubspec.yaml']
ASSET_REF_RE = re.compile(r"assets/[^'\"]+\.(png|PNG|webp|WEBP)")
POLICY_NATIVE_PREFIXES = ('ios/', 'android/', 'macos/', 'web/', 'apple_tv_app/')


def should_skip(path: str) -> bool:
    return any(path.startswith(prefix) for prefix in EXCLUDE_PREFIXES)


def scan_repo_counts():
    counts = Counter()
    runtime_by_folder = defaultdict(lambda: Counter())
    for file_path in Path('.').rglob('*'):
        if not file_path.is_file():
            continue
        rel = file_path.as_posix()
        if should_skip(rel):
            continue
        lower = rel.lower()
        if lower.endswith('.png'):
            counts['repo_png'] += 1
            if rel.startswith('assets/'):
                counts['runtime_png'] += 1
                parts = rel.split('/')
                folder = '/'.join(parts[:3]) if len(parts) >= 3 else rel
                runtime_by_folder[folder]['png'] += 1
            elif rel.startswith(POLICY_NATIVE_PREFIXES):
                counts['native_png'] += 1
            else:
                counts['other_png'] += 1
        elif lower.endswith('.webp'):
            counts['repo_webp'] += 1
            if rel.startswith('assets/'):
                counts['runtime_webp'] += 1
                parts = rel.split('/')
                folder = '/'.join(parts[:3]) if len(parts) >= 3 else rel
                runtime_by_folder[folder]['webp'] += 1
            elif rel.startswith(POLICY_NATIVE_PREFIXES):
                counts['native_webp'] += 1
            else:
                counts['other_webp'] += 1
    return counts, runtime_by_folder


def gather_refs():
    refs = []
    for root in RUNTIME_REFERENCE_ROOTS:
        path = Path(root)
        files = [path] if path.is_file() else [f for f in path.rglob('*') if f.is_file()]
        for file_path in files:
            try:
                text = file_path.read_text()
            except Exception:
                continue
            for line_number, line in enumerate(text.splitlines(), 1):
                for match in ASSET_REF_RE.finditer(line):
                    asset = match.group(0)
                    refs.append(
                        {
                            'file': str(file_path),
                            'line': line_number,
                            'asset': asset,
                            'exists': Path(asset).exists(),
                        }
                    )
    return refs


def is_intentional_runtime_png(asset: str) -> bool:
    return asset in INTENTIONAL_HOLDOUTS or any(asset.startswith(prefix) for prefix in ALLOWLIST_PREFIXES)


repo_counts, runtime_by_folder = scan_repo_counts()
refs = gather_refs()

active_ref_counter = Counter()
for ref in refs:
    active_ref_counter[ref['asset']] += 1

migrated_scope_rows = []
verified_count = 0
holdout_count = 0
unexpected_leftover_count = 0

for folder in MIGRATED_FOLDERS:
    folder_path = Path(folder)
    pngs = sorted(p.as_posix() for p in folder_path.rglob('*.png')) if folder_path.exists() else []
    webps = sorted(p.as_posix() for p in folder_path.rglob('*.webp')) if folder_path.exists() else []

    if folder == 'assets/images/backgrounds':
        expected_bases = [p[:-5] for p in webps] + ['assets/images/backgrounds/Loading']
    elif folder == 'assets/images/wudu':
        expected_bases = [p[:-5] for p in webps]
    elif folder == 'assets/images/prophets':
        expected_bases = []
        resolver_file = Path('lib/features/learn/prophets/application/prophet_image_resolver.dart')
        if resolver_file.exists():
            for match in ASSET_REF_RE.finditer(resolver_file.read_text()):
                asset = match.group(0)
                if asset.startswith('assets/images/prophets/') and asset.lower().endswith('.webp'):
                    expected_bases.append(asset[:-5])
    elif folder == 'assets/images/kids_dua_stories':
        expected_bases = [p[:-5] for p in webps]
    else:
        expected_bases = [p[:-5] for p in webps]

    for base in sorted(set(expected_bases)):
        png_path = f'{base}.png'
        webp_path = f'{base}.webp'
        png_exists = Path(png_path).exists()
        webp_exists = Path(webp_path).exists()
        png_refs = active_ref_counter.get(png_path, 0)
        webp_refs = active_ref_counter.get(webp_path, 0)

        classification = 'MANUAL_REVIEW'
        if base == 'assets/images/backgrounds/Loading' and png_exists and not webp_exists:
            classification = 'INTENTIONAL_HOLDOUT'
            holdout_count += 1
        elif webp_exists and not png_exists and folder in {
            'assets/images/backgrounds',
            'assets/images/wudu',
            'assets/images/prophets',
            'assets/images/kids_dua_stories',
        } and png_refs == 0:
            classification = 'FULLY_VERIFIED'
            verified_count += 1
        elif png_exists:
            classification = 'UNEXPECTED_LEFTOVER'
            unexpected_leftover_count += 1

        migrated_scope_rows.append(
            {
                'base': base,
                'png_exists': png_exists,
                'webp_exists': webp_exists,
                'png_refs': png_refs,
                'webp_refs': webp_refs,
                'classification': classification,
            }
        )

png_ref_counts = Counter()
webp_ref_counts = Counter()
broken_missing_ref_count = 0
stale_runtime_png_ref_count = 0
intentional_runtime_png_count = 0

for ref in refs:
    asset = ref['asset']
    if '$' in asset:
        continue
    if asset.lower().endswith('.webp'):
        if ref['exists']:
            webp_ref_counts['ACTIVE_WEBP_OK'] += 1
        else:
            webp_ref_counts['BROKEN_WEBP_REF'] += 1
    else:
        if is_intentional_runtime_png(asset) and ref['exists']:
            png_ref_counts['INTENTIONAL_RUNTIME_PNG'] += 1
            intentional_runtime_png_count += 1
        elif ref['exists']:
            png_ref_counts['STALE_RUNTIME_PNG_REF'] += 1
            stale_runtime_png_ref_count += 1
        else:
            png_ref_counts['BROKEN_MISSING_REF'] += 1
            broken_missing_ref_count += 1

print('[EXECUTIVE_SUMMARY]')
print(f"repo_png={repo_counts['repo_png']}")
print(f"repo_webp={repo_counts['repo_webp']}")
print(f"runtime_png={repo_counts['runtime_png']}")
print(f"runtime_webp={repo_counts['runtime_webp']}")
print(f"native_png={repo_counts['native_png']}")
print(f"other_png={repo_counts['other_png']}")
print(f"migrated_scope_verified={verified_count}")
print(f"intentional_runtime_png_holdouts={holdout_count}")
print(f"unexpected_leftover_pngs_in_migrated_scope={unexpected_leftover_count}")
print(f"stale_runtime_png_refs={stale_runtime_png_ref_count}")
print(f"broken_runtime_asset_refs={broken_missing_ref_count + webp_ref_counts['BROKEN_WEBP_REF']}")

print('\n[RUNTIME_FOLDER_BREAKDOWN]')
for folder in sorted(runtime_by_folder):
    print(
        f"{folder} :: png={runtime_by_folder[folder]['png']} :: webp={runtime_by_folder[folder]['webp']}"
    )

print('\n[MIGRATED_SCOPE]')
for row in migrated_scope_rows:
    active_target = 'none'
    if row['webp_refs'] > 0:
        active_target = 'webp'
    elif row['png_refs'] > 0:
        active_target = 'png'
    print(
        f"{row['base']} :: png_exists={int(row['png_exists'])} :: webp_exists={int(row['webp_exists'])} :: "
        f"active_ref_target={active_target} :: classification={row['classification']}"
    )

print('\n[ACTIVE_REFERENCE_COUNTS]')
print(f"ACTIVE_WEBP_OK={webp_ref_counts['ACTIVE_WEBP_OK']}")
print(f"INTENTIONAL_RUNTIME_PNG={png_ref_counts['INTENTIONAL_RUNTIME_PNG']}")
print(f"STALE_RUNTIME_PNG_REF={png_ref_counts['STALE_RUNTIME_PNG_REF']}")
print(f"BROKEN_MISSING_REF={png_ref_counts['BROKEN_MISSING_REF']}")
print(f"BROKEN_WEBP_REF={webp_ref_counts['BROKEN_WEBP_REF']}")

print('\n[INTENTIONAL_RUNTIME_PNGS]')
for asset in sorted({ref['asset'] for ref in refs if ref['asset'].lower().endswith('.png') and is_intentional_runtime_png(ref['asset'])}):
    print(asset)
PY
