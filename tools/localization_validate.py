#!/usr/bin/env python3
"""Validate ARB locale parity against a source file."""

from __future__ import annotations

import argparse
import json
import re
import sys
from dataclasses import dataclass
from pathlib import Path


PLACEHOLDER_RE = re.compile(r"\{([A-Za-z0-9_]+)\}")


@dataclass
class ValidationResult:
    locale: str
    exists: bool
    total_keys: int = 0
    missing_keys: int = 0
    extra_keys: int = 0
    placeholder_mismatches: int = 0


def load_arb(path: Path) -> dict[str, object]:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def placeholder_names(value: object) -> list[str]:
    if not isinstance(value, str):
        return []
    return PLACEHOLDER_RE.findall(value)


def validate_locale(source: dict[str, object], locale_path: Path) -> ValidationResult:
    locale = locale_path.stem.replace("app_", "")
    if not locale_path.exists():
        return ValidationResult(locale=locale, exists=False)

    target = load_arb(locale_path)
    missing = set(source) - set(target)
    extra = set(target) - set(source)
    placeholder_mismatches = 0

    for key, source_value in source.items():
        if key.startswith("@"):
            continue
        target_value = target.get(key, "")
        if placeholder_names(source_value) != placeholder_names(target_value):
            placeholder_mismatches += 1

    return ValidationResult(
        locale=locale,
        exists=True,
        total_keys=len(target),
        missing_keys=len(missing),
        extra_keys=len(extra),
        placeholder_mismatches=placeholder_mismatches,
    )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--source",
        default="lib/l10n/app_en.arb",
        help="Source ARB file. Default: %(default)s",
    )
    parser.add_argument(
        "--locales",
        nargs="+",
        required=True,
        help="Locale codes to validate, e.g. ur ar de",
    )
    args = parser.parse_args()

    source_path = Path(args.source)
    source = load_arb(source_path)

    had_failure = False
    for locale in args.locales:
        locale_path = source_path.with_name(f"app_{locale}.arb")
        result = validate_locale(source, locale_path)
        if not result.exists:
            had_failure = True
            print(f"{locale}: missing file")
            continue
        print(
            f"{locale}: keys={result.total_keys} "
            f"missing={result.missing_keys} "
            f"extra={result.extra_keys} "
            f"placeholder_mismatches={result.placeholder_mismatches}"
        )
        if (
            result.missing_keys > 0
            or result.extra_keys > 0
            or result.placeholder_mismatches > 0
        ):
            had_failure = True

    return 1 if had_failure else 0


if __name__ == "__main__":
    sys.exit(main())
