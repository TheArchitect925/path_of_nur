#!/usr/bin/env python3
"""Stage a generated ARB locale file without overwriting the canonical file."""

from __future__ import annotations

import argparse
import json
import re
import sys
import time
from pathlib import Path

from deep_translator import GoogleTranslator


PLACEHOLDER_RE = re.compile(r"\{([A-Za-z0-9_]+)\}")
ICU_RE = re.compile(r"\{[^{}]+,\s*(plural|select|selectordinal),")


def load_arb(path: Path) -> dict[str, object]:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def placeholder_names(value: object) -> list[str]:
    if not isinstance(value, str):
        return []
    return PLACEHOLDER_RE.findall(value)


def should_copy_as_is(text: str) -> bool:
    stripped = PLACEHOLDER_RE.sub("", text).strip()
    if not stripped:
        return True
    if re.fullmatch(r"[\d\s\W_]+", stripped):
        return True
    return False


def mask_placeholders(text: str) -> tuple[str, dict[str, str]]:
    replacements: dict[str, str] = {}
    index = 0

    def repl(match: re.Match[str]) -> str:
        nonlocal index
        token = f"__PH_{index}__"
        replacements[token] = match.group(0)
        index += 1
        return token

    return PLACEHOLDER_RE.sub(repl, text), replacements


def restore_placeholders(text: str, replacements: dict[str, str]) -> str:
    restored = text
    for token, original in replacements.items():
        restored = restored.replace(token, original)
    return restored


def is_structurally_valid(source_text: str, existing_value: object) -> bool:
    return (
        isinstance(existing_value, str)
        and existing_value != ""
        and placeholder_names(source_text) == placeholder_names(existing_value)
    )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--source", default="lib/l10n/app_en.arb")
    parser.add_argument("--target", required=True, help="Target locale code, e.g. fr")
    parser.add_argument(
        "--output",
        default=None,
        help="Optional explicit output path. Default writes next to target as *.generated.arb",
    )
    parser.add_argument(
        "--batch-size",
        type=int,
        default=40,
        help="Batch size for simple string translation. Default: %(default)s",
    )
    parser.add_argument(
        "--delay-ms",
        type=int,
        default=150,
        help="Delay between batches. Default: %(default)s",
    )
    args = parser.parse_args()

    source_path = Path(args.source)
    target_path = source_path.with_name(f"app_{args.target}.arb")
    output_path = (
        Path(args.output)
        if args.output
        else source_path.with_name(f"app_{args.target}.generated.arb")
    )

    source = load_arb(source_path)
    existing = load_arb(target_path) if target_path.exists() else {}
    translator = GoogleTranslator(source="en", target=args.target)

    result: dict[str, object] = {}
    translation_cache: dict[str, str] = {}
    needs_translation: list[tuple[str, str]] = []

    for key, source_value in source.items():
        if key.startswith("@") or not isinstance(source_value, str):
            result[key] = source_value
            continue
        existing_value = existing.get(key)
        if is_structurally_valid(source_value, existing_value):
            result[key] = existing_value
        else:
            needs_translation.append((key, source_value))

    unique_simple_strings: list[str] = []
    seen: set[str] = set()
    for _, text in needs_translation:
        if text in seen or should_copy_as_is(text) or ICU_RE.search(text):
            continue
        seen.add(text)
        unique_simple_strings.append(text)

    for start in range(0, len(unique_simple_strings), args.batch_size):
        batch = unique_simple_strings[start : start + args.batch_size]
        masked_batch: list[str] = []
        token_maps: list[dict[str, str]] = []
        for text in batch:
            masked, token_map = mask_placeholders(text)
            masked_batch.append(masked)
            token_maps.append(token_map)
        try:
            translated_batch = translator.translate_batch(masked_batch)
        except Exception:
            translated_batch = [None] * len(batch)
        if not isinstance(translated_batch, list) or len(translated_batch) != len(batch):
            translated_batch = [None] * len(batch)

        for original, translated, token_map in zip(batch, translated_batch, token_maps):
            if translated is None:
                translation_cache[original] = original
            else:
                translation_cache[original] = restore_placeholders(translated, token_map)

        batch_index = start // args.batch_size + 1
        batch_total = (len(unique_simple_strings) + args.batch_size - 1) // args.batch_size
        print(f"batch {batch_index}/{batch_total}", flush=True)
        time.sleep(args.delay_ms / 1000.0)

    reused = 0
    copied_source = 0
    generated = 0
    for key, source_text in needs_translation:
        if is_structurally_valid(source_text, existing.get(key)):
            reused += 1
            result[key] = existing[key]
        elif should_copy_as_is(source_text) or ICU_RE.search(source_text):
            copied_source += 1
            result[key] = source_text
        else:
            generated += 1
            result[key] = translation_cache.get(source_text, source_text)

    with output_path.open("w", encoding="utf-8") as handle:
        json.dump(result, handle, ensure_ascii=False, indent=2)
        handle.write("\n")

    print(f"wrote {output_path}")
    print(f"source_keys={len(source)}")
    print(f"needs_translation={len(needs_translation)}")
    print(f"generated={generated}")
    print(f"copied_source={copied_source}")
    print(f"reused_existing={len(source) - len(needs_translation)}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
