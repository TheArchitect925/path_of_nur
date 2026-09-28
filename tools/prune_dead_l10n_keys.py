#!/usr/bin/env python3
"""Delete English ARB keys that no Dart file references, from every locale.

A key is alive when its name appears anywhere in lib/ (outside lib/l10n) or
test/ — as `l10n.key`, as a bare name inside a string map, or in a test that
reads the generated getter. Everything else is dead copy: nobody sees it, but
translators, the localization gate and the copy lint all pay for it.

Idempotent and safe to run on a tree that carries other sessions' edits: it
removes only the listed keys (and their `@key` metadata) and leaves every
other line untouched. Run `flutter gen-l10n` afterwards.

Usage:
  python3 tools/prune_dead_l10n_keys.py --dry-run     list the keys
  python3 tools/prune_dead_l10n_keys.py               delete them
  python3 tools/prune_dead_l10n_keys.py --keys-file dead.json
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))
from copy_lint import ROOT, dead_keys, load_arb  # noqa: E402

L10N = ROOT / "lib" / "l10n"


def prune_file(path: Path, keys: set[str]) -> int:
    data = json.loads(path.read_text(encoding="utf-8"))
    before = len(data)
    for key in keys:
        data.pop(key, None)
        data.pop(f"@{key}", None)
    removed = before - len(data)
    if removed:
        path.write_text(
            json.dumps(data, ensure_ascii=False, indent=2) + "\n", encoding="utf-8"
        )
    return removed


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--dry-run", action="store_true")
    ap.add_argument("--keys-file", help="JSON list of keys to delete instead of computing them")
    args = ap.parse_args(argv)

    if args.keys_file:
        keys = set(json.loads(Path(args.keys_file).read_text(encoding="utf-8")))
    else:
        keys = set(dead_keys(load_arb()))

    if args.dry_run:
        for k in sorted(keys):
            print(k)
        print(f"\n{len(keys)} dead keys", file=sys.stderr)
        return 0

    total = 0
    for path in sorted(L10N.glob("app_*.arb")):
        n = prune_file(path, keys)
        total += n
        print(f"{path.name}: removed {n}")
    print(f"\n{len(keys)} keys, {total} entries removed across locales. Now run: flutter gen-l10n")
    return 0


if __name__ == "__main__":
    sys.exit(main())
