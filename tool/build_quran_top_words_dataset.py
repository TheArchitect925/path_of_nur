#!/usr/bin/env python3
"""Build a trusted local Quran top-words dataset from Quran.com word data."""

from __future__ import annotations

import argparse
import collections
import json
import re
import time
import urllib.parse
import urllib.request
from pathlib import Path

API_ROOT = "https://api.quran.com/api/v4/verses/by_chapter/{chapter}?{query}"
DEFAULT_LIMIT = 181
REQUEST_HEADERS = {
    "User-Agent": "PathOfNur/1.0 (+https://pathofnur.app)",
    "Accept": "application/json",
}
_DIACRITICS_RE = re.compile(r"[\u0610-\u061A\u064B-\u065F\u0670\u06D6-\u06ED\u0640]")


def _normalize_arabic(text: str) -> str:
    normalized = text.strip()
    normalized = _DIACRITICS_RE.sub("", normalized)
    normalized = (
        normalized.replace("ٱ", "ا")
        .replace("أ", "ا")
        .replace("إ", "ا")
        .replace("آ", "ا")
        .replace("ى", "ي")
        .replace("ؤ", "و")
        .replace("ئ", "ي")
    )
    return normalized


def _clean_label(text: str) -> str:
    return " ".join(text.strip().split())


def _fetch_page(chapter: int, page: int) -> dict:
    query = urllib.parse.urlencode(
        {
            "words": "true",
            "word_fields": "text_uthmani,text_imlaei",
            "per_page": "50",
            "page": str(page),
        }
    )
    request = urllib.request.Request(
        API_ROOT.format(chapter=chapter, query=query),
        headers=REQUEST_HEADERS,
    )
    with urllib.request.urlopen(request, timeout=30) as response:
        return json.load(response)


def _pick_most_common(counter: collections.Counter[str]) -> str:
    if not counter:
        return ""
    best_count = max(counter.values())
    candidates = [item for item, count in counter.items() if count == best_count]
    candidates.sort(key=lambda item: (-len(item), item))
    return candidates[0]


def build_dataset(limit: int) -> list[dict]:
    counts: collections.Counter[str] = collections.Counter()
    display_arabic: dict[str, collections.Counter[str]] = collections.defaultdict(
        collections.Counter
    )
    transliterations: dict[str, collections.Counter[str]] = collections.defaultdict(
        collections.Counter
    )
    meanings: dict[str, collections.Counter[str]] = collections.defaultdict(
        collections.Counter
    )
    root_letters: dict[str, collections.Counter[str]] = collections.defaultdict(
        collections.Counter
    )
    meaning_expansions: dict[str, collections.Counter[str]] = collections.defaultdict(
        collections.Counter
    )

    for chapter in range(1, 115):
        page = 1
        while True:
            payload = _fetch_page(chapter, page)
            for verse in payload.get("verses", []):
                for word in verse.get("words", []):
                    if word.get("char_type_name") != "word":
                        continue

                    arabic = _clean_label(
                        word.get("text_uthmani")
                        or word.get("text_imlaei")
                        or word.get("text")
                        or ""
                    )
                    transliteration = _clean_label(
                        ((word.get("transliteration") or {}).get("text")) or ""
                    )
                    meaning = _clean_label(
                        ((word.get("translation") or {}).get("text")) or ""
                    )
                    root = _clean_label(
                        ((word.get("root") or {}).get("text"))
                        or word.get("root")
                        or ""
                    )
                    meaning_expansion = _clean_label(
                        ((word.get("meaning") or {}).get("text"))
                        or word.get("meaning")
                        or ""
                    )
                    if not arabic or not transliteration or not meaning:
                        continue

                    normalized = _normalize_arabic(arabic)
                    if not normalized:
                        continue

                    counts[normalized] += 1
                    display_arabic[normalized][arabic] += 1
                    transliterations[normalized][transliteration] += 1
                    meanings[normalized][meaning] += 1
                    if root:
                        root_letters[normalized][root] += 1
                    if meaning_expansion:
                        meaning_expansions[normalized][meaning_expansion] += 1

            pagination = payload.get("pagination") or {}
            next_page = pagination.get("next_page")
            if not next_page:
                break
            page = int(next_page)
            time.sleep(0.08)

    rows = []
    for normalized, occurrences in counts.most_common(limit):
        row = {
            "rank": len(rows) + 1,
            "arabic": _pick_most_common(display_arabic[normalized]),
            "transliteration": _pick_most_common(transliterations[normalized]),
            "meaning": _pick_most_common(meanings[normalized]),
            "occurrences": occurrences,
        }
        root = _pick_most_common(root_letters[normalized])
        meaning_expansion = _pick_most_common(meaning_expansions[normalized])
        if root:
            row["rootLetters"] = root
        if meaning_expansion:
            row["meaningExpansion"] = meaning_expansion
        rows.append(row)
    return rows


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--output",
        default="assets/data/quran_top_words_curated.json",
        help="Output JSON path",
    )
    parser.add_argument(
        "--limit",
        type=int,
        default=DEFAULT_LIMIT,
        help="Number of top words to write",
    )
    args = parser.parse_args()

    dataset = build_dataset(limit=args.limit)
    output_path = Path(args.output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(
        json.dumps(dataset, ensure_ascii=False, indent=2) + "\n",
        encoding="utf-8",
    )
    print(f"Wrote {len(dataset)} rows to {output_path}")


if __name__ == "__main__":
    main()
