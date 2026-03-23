#!/usr/bin/env python3
"""
translate_arb.py

Production-oriented ARB translation pipeline for Flutter localization files.

What it does:
- Reads a source ARB file (e.g. app_en.arb)
- Translates only translatable keys (not @metadata keys)
- Preserves placeholders, structure, and metadata
- Batches work to reduce payload size
- Writes per-language ARB files
- Validates key parity before saving

Environment:
- OPENAI_API_KEY must be set

Usage:
    python translate_arb.py \
      --source lib/l10n/app_en.arb \
      --outdir lib/l10n \
      --languages ur ar de hi tr fr id \
      --model gpt-4.1-mini \
      --batch-size 80
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
import time
from copy import deepcopy
from pathlib import Path
from typing import Dict, List, Tuple

from openai import OpenAI


LANGUAGE_CONFIG = {
    "ur": {
        "name": "Urdu",
        "filename": "app_ur.arb",
        "rules": [
            "Use simple, natural Urdu.",
            "Avoid overly formal or overly Arabic-heavy Urdu.",
            "Keep Islamic terms accurate and familiar.",
            "Keep UI labels short and readable.",
        ],
    },
    "ar": {
        "name": "Arabic",
        "filename": "app_ar.arb",
        "rules": [
            "Use clear Modern Standard Arabic.",
            "Avoid overly classical phrasing.",
            "Keep Islamic terminology precise.",
            "Keep labels concise and app-friendly.",
        ],
    },
    "de": {
        "name": "German",
        "filename": "app_de.arb",
        "rules": [
            "Use natural, modern German.",
            "Avoid literal translation.",
            "Keep UX phrasing short and clear.",
            "Watch for long words and overflow-prone text.",
        ],
    },
    "hi": {
        "name": "Hindi",
        "filename": "app_hi.arb",
        "rules": [
            "Use simple, readable Hindi.",
            "Avoid overly Sanskrit-heavy wording.",
            "Keep tone natural and friendly.",
            "Keep UI text concise.",
        ],
    },
    "tr": {
        "name": "Turkish",
        "filename": "app_tr.arb",
        "rules": [
            "Use modern, natural Turkish.",
            "Keep wording concise and mobile-friendly.",
            "Avoid overly formal or bookish phrasing.",
        ],
    },
    "fr": {
        "name": "French",
        "filename": "app_fr.arb",
        "rules": [
            "Use clear, modern French.",
            "Avoid overly formal constructions.",
            "Keep UX wording concise.",
        ],
    },
    "id": {
        "name": "Indonesian",
        "filename": "app_id.arb",
        "rules": [
            "Use simple, natural Bahasa Indonesia.",
            "Keep phrasing concise and app-friendly.",
            "Avoid stiff or overly formal language.",
        ],
    },
}

ISLAMIC_TERMS_GUIDE = [
    "Preserve Islamic correctness and consistency.",
    "Handle these concepts carefully and consistently: Qur’an, Salah, Dhikr, Hadith, Surah, Ayah.",
    "Do not translate keys or placeholder names.",
]

PLACEHOLDER_PATTERN = re.compile(r"\{[a-zA-Z0-9_]+\}")


def load_json(path: Path) -> Dict[str, object]:
    with path.open("r", encoding="utf-8") as f:
        return json.load(f)


def save_json(path: Path, data: Dict[str, object]) -> None:
    with path.open("w", encoding="utf-8") as f:
        json.dump(data, f, ensure_ascii=False, indent=2)
        f.write("\n")


def split_translatable_entries(arb: Dict[str, object]) -> Tuple[Dict[str, object], Dict[str, str]]:
    """
    Returns:
      metadata/full static entries to preserve unchanged,
      translatable value entries only
    """
    fixed: Dict[str, object] = {}
    translatable: Dict[str, str] = {}

    for key, value in arb.items():
        if key.startswith("@"):
            fixed[key] = value
        elif isinstance(value, str):
            translatable[key] = value
        else:
            fixed[key] = value

    return fixed, translatable


def chunk_items(items: Dict[str, str], batch_size: int) -> List[Dict[str, str]]:
    keys = list(items.keys())
    chunks = []
    for i in range(0, len(keys), batch_size):
        sub = {k: items[k] for k in keys[i:i + batch_size]}
        chunks.append(sub)
    return chunks


def build_system_prompt(language_name: str, language_rules: List[str]) -> str:
    rules = "\n".join(f"- {r}" for r in language_rules)
    islamic = "\n".join(f"- {r}" for r in ISLAMIC_TERMS_GUIDE)
    return f"""
You are translating ARB localization entries for an Islamic mobile app called Path of Nūr.

Target language: {language_name}

Hard rules:
- Return JSON only.
- Do not change any keys.
- Do not add keys.
- Do not remove keys.
- Preserve placeholders exactly, including braces and names.
- Do not translate variable names or metadata.
- Keep translations mobile-friendly and concise.
- Preserve meaning, not literal wording.
- Keep repeated concepts consistent across entries.

Islamic terminology guidance:
{islamic}

Language-specific guidance:
{rules}

Output format:
{{
  "translated": {{
    "key1": "translated text",
    "key2": "translated text"
  }}
}}
""".strip()


def build_user_prompt(batch: Dict[str, str]) -> str:
    return (
        "Translate this ARB value batch. "
        "Return only the translated values for the same keys.\n\n"
        + json.dumps(batch, ensure_ascii=False, indent=2)
    )


def call_translation_model(
    client: OpenAI,
    model: str,
    system_prompt: str,
    user_prompt: str,
    max_retries: int = 4,
) -> Dict[str, str]:
    schema = {
        "name": "arb_translation_batch",
        "schema": {
            "type": "object",
            "properties": {
                "translated": {
                    "type": "object",
                    "additionalProperties": {"type": "string"}
                }
            },
            "required": ["translated"],
            "additionalProperties": False,
        },
    }

    for attempt in range(1, max_retries + 1):
        try:
            response = client.chat.completions.create(
                model=model,
                temperature=0,
                response_format={
                    "type": "json_schema",
                    "json_schema": schema,
                },
                messages=[
                    {"role": "system", "content": system_prompt},
                    {"role": "user", "content": user_prompt},
                ],
            )

            content = response.choices[0].message.content
            payload = json.loads(content)
            translated = payload["translated"]

            if not isinstance(translated, dict):
                raise ValueError("Model returned invalid translated payload")

            return translated

        except Exception as exc:
            if attempt == max_retries:
                raise
            sleep_s = attempt * 2
            print(f"[retry {attempt}/{max_retries}] {exc} — sleeping {sleep_s}s", file=sys.stderr)
            time.sleep(sleep_s)

    raise RuntimeError("Unreachable retry state")


def validate_batch(source_batch: Dict[str, str], translated_batch: Dict[str, str]) -> None:
    source_keys = set(source_batch.keys())
    translated_keys = set(translated_batch.keys())

    missing = source_keys - translated_keys
    extra = translated_keys - source_keys

    if missing or extra:
        raise ValueError(
            f"Key mismatch. Missing={sorted(missing)} Extra={sorted(extra)}"
        )

    for key, source_text in source_batch.items():
        src_placeholders = set(PLACEHOLDER_PATTERN.findall(source_text))
        dst_placeholders = set(PLACEHOLDER_PATTERN.findall(translated_batch[key]))
        if src_placeholders != dst_placeholders:
            raise ValueError(
                f"Placeholder mismatch for key '{key}'. "
                f"Expected {sorted(src_placeholders)}, got {sorted(dst_placeholders)}"
            )


def translate_language(
    client: OpenAI,
    model: str,
    source_arb: Dict[str, object],
    lang_code: str,
    batch_size: int,
    outdir: Path,
) -> Path:
    if lang_code not in LANGUAGE_CONFIG:
        raise ValueError(f"Unsupported language code: {lang_code}")

    config = LANGUAGE_CONFIG[lang_code]
    language_name = config["name"]
    filename = config["filename"]
    language_rules = config["rules"]

    fixed, translatable = split_translatable_entries(source_arb)
    chunks = chunk_items(translatable, batch_size)

    translated_all: Dict[str, str] = {}

    print(f"\n=== Translating {language_name} ({lang_code}) ===")
    print(f"Total keys: {len(translatable)} in {len(chunks)} batch(es)")

    system_prompt = build_system_prompt(language_name, language_rules)

    for idx, batch in enumerate(chunks, start=1):
        print(f"  - batch {idx}/{len(chunks)} ({len(batch)} keys)")
        user_prompt = build_user_prompt(batch)
        translated_batch = call_translation_model(client, model, system_prompt, user_prompt)
        validate_batch(batch, translated_batch)
        translated_all.update(translated_batch)

    output = deepcopy(fixed)
    for key in source_arb.keys():
        if key in translated_all:
            output[key] = translated_all[key]
        elif key in fixed:
            output[key] = fixed[key]
        else:
            raise ValueError(f"Missing key during rebuild: {key}")

    outpath = outdir / filename
    save_json(outpath, output)
    print(f"Saved: {outpath}")
    return outpath


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--source", required=True, help="Path to source ARB, e.g. lib/l10n/app_en.arb")
    parser.add_argument("--outdir", required=True, help="Output directory for translated ARBs")
    parser.add_argument(
        "--languages",
        nargs="+",
        default=["ur", "ar", "de", "hi", "tr", "fr", "id"],
        help="Language codes to generate",
    )
    parser.add_argument("--model", default="gpt-4.1-mini", help="Model name")
    parser.add_argument("--batch-size", type=int, default=80, help="Keys per batch")
    args = parser.parse_args()

    api_key = os.environ.get("OPENAI_API_KEY")
    if not api_key:
        print("Missing OPENAI_API_KEY", file=sys.stderr)
        return 1

    source_path = Path(args.source)
    outdir = Path(args.outdir)
    outdir.mkdir(parents=True, exist_ok=True)

    source_arb = load_json(source_path)
    client = OpenAI(api_key=api_key)

    generated: List[Path] = []
    for lang in args.languages:
        generated.append(
            translate_language(
                client=client,
                model=args.model,
                source_arb=source_arb,
                lang_code=lang,
                batch_size=args.batch_size,
                outdir=outdir,
            )
        )

    print("\nDone.")
    for path in generated:
        print(f" - {path}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
