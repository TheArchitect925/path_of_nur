#!/usr/bin/env python3
"""Localization quality gate.

Every check here exists because the defect it catches actually shipped. The
German pass on 2026-08-29 found stripped diacritics, sentence punctuation with
no following space, mixed formal/informal address, and locale files inventing or
dropping ICU placeholders — the last of which leaked into the generated Dart API
and forced call sites to pass padding arguments.

Two tiers are scored separately:

  A  surfaces a user meets in normal use (home, salah, settings, onboarding,
     notifications, profile, Qur'an reader, accounts, legal, errors)
  B  deep content (Learn, kids stories, Qur'an teaching, hadith, editorial)

A locale ships on tier A. Tier B is allowed to sit in English.

Usage:
    python3 tools/localization_gate.py                        # report every locale
    python3 tools/localization_gate.py --release ar ur        # fail unless these pass
    python3 tools/localization_gate.py --release-from-source  # derive from Dart
    python3 tools/localization_gate.py --json                 # machine-readable
"""

from __future__ import annotations

import argparse
import collections
import json
import re
import sys
import unicodedata
from pathlib import Path

L10N_DIR = Path(__file__).resolve().parent.parent / "lib" / "l10n"
TEMPLATE = "en"

# Tier A: key prefixes for the surfaces a user actually meets.
TIER_A_PREFIXES = (
    "home", "worship", "salah", "prayer", "settings", "onboarding",
    "notification", "profile", "nav", "dua", "dhikr", "quranTab",
    "quranReader", "quranHub", "quranSummary", "accountsSync", "legal",
    "help", "loading", "fasting", "growth", "journey", "ocean", "garden",
    "error", "common", "action", "app", "peace", "greeting", "occasion",
    "mode", "all",
)

# Ratio of tier-A prose still identical to English that we tolerate in a
# release locale. Proper nouns and format samples legitimately match, so this is
# never zero.
TIER_A_MAX_UNTRANSLATED = 0.05

PLACEHOLDER = re.compile(r"\{([A-Za-z0-9_]+)\}")
ARABIC_SCRIPT = re.compile(r"[؀-ۿݐ-ݿ]")

# A sentence-ending mark glued to the next sentence. Guarded against ordinals
# ("3.Etappe"), decimals and initialisms.
MISSING_SPACE = re.compile(
    r"(?<![A-Z0-9])[.!?](?=[A-ZÄÖÜ][a-zäöüß])"      # Latin: "fällig.Absolvieren"
    r"|(?<![A-Z0-9])[.!?؟](?=[\u0600-\u06FF])"      # Arabic script: "الاتساق.إنه"
)

# Words that are only ever correct with a diacritic AND have no ASCII homograph
# in the language or in stray English strings. Kept deliberately conservative —
# a homograph here (German "wurde"/"Würde", "Garten"/"Gärten") would make the
# gate lie, so borderline words belong in the advisory check instead.
STRIPPED_DIACRITICS = {
    "de": re.compile(
        r"\b(fur|uber|konnen|mochte|wahrend|taglich\w*|nachste[nrs]?|Prufe?\w*"
        r"|zuruck|fruh\w*|spater|uben|Ubung\w*|Losung\w*|Erklarung\w*"
        r"|Verstandnis|Moglichkeit\w*|personlich\w*|regelmassig\w*"
        r"|Bestatigung\w*|Ruckkehr|Grosse|schone[nrs]?)\b"
    ),
    "tr": re.compile(
        r"\b(icin|gunluk|gunu|ogren\w*|calis\w*|tefekkur|gorunum|dogru"
        r"|erisim\w*|hatirlatma\w*|buyuk|kucuk|guzel|degil|namazini"
        r"|ayrintilari|guncelle\w*|baslangic\w*|yardimci|oncelik)\b"
    ),
}

# Formal/informal address. A locale should pick one and hold it. Second-person
# forms addressing Allah in du'a and verse translations are exempt — they are
# correctly informal in every language that marks the distinction.
REGISTER = {
    "de": {
        "formal": re.compile(r"\b(Sie|Ihre[nmrs]?|Ihnen)\b"),
        # (?!'') keeps the ARB-escaped "du''a" from reading as the pronoun "du".
        "informal": re.compile(
            r"\b([Dd]u(?!'')|[Dd]eine[nmrs]?|[Dd]ir|[Dd]ich|[Dd]ein)\b"
        ),
        "expect": "formal",
    },
}
# Keys whose second person addresses Allah, not the reader.
REGISTER_EXEMPT = re.compile(
    r"(Invocation|InvocationMeaning|DuaMeaning|VerseTranslation|GreetingMorningTranslation"
    r"|GreetingEveningTranslation|RecitationSection1Body|LeavingWashroomMeaning"
    r"|EnteringWashroomMeaning|BeforeSleepMeaning|EnteringHomeMeaning|ForParentsMeaning)"
)


def deaccent(word: str) -> str:
    return "".join(
        c for c in unicodedata.normalize("NFD", word)
        if unicodedata.category(c) != "Mn"
    ).lower()


def advisory_stripped_diacritics(data: dict) -> list[str]:
    """Self-calibrating hint, never blocking.

    If a word occurs in this file both bare and accented, the bare form is often
    a machine-translation artefact. It is only a hint: real homograph pairs
    (German "wurde"/"Würde") land here too, so a human decides.
    """
    words: collections.Counter[str] = collections.Counter()
    for key, value in data.items():
        if key.startswith("@") or not isinstance(value, str):
            continue
        for word in re.findall(r"[^\W\d_]{3,}", value, re.UNICODE):
            words[word] += 1

    groups: dict[str, set[str]] = collections.defaultdict(set)
    for word in words:
        groups[deaccent(word)].add(word)

    hints = []
    for variants in groups.values():
        if len(variants) < 2:
            continue
        bare = [w for w in variants if w.isascii() and deaccent(w) == w.lower()]
        accented = [w for w in variants if not w.isascii()]
        if not bare or not accented:
            continue
        for form in bare:
            if words[form] >= 2:
                hints.append(f"{form}×{words[form]} vs {sorted(accented)[0]}")
    return sorted(hints, key=lambda h: -int(h.split("×")[1].split()[0]))


def load(locale: str) -> dict:
    with (L10N_DIR / f"app_{locale}.arb").open(encoding="utf-8") as fh:
        return json.load(fh)


def normalize_for_comparison(text: str) -> str:
    """Fold apostrophe spellings so an untranslated copy cannot hide behind them."""
    return re.sub(r"[\u2019'`]+", "'", text).strip()


def strip_placeholders(text: str) -> str:
    return re.sub(r"\{[^{}]*\}", "", text)


def is_translatable_prose(value: str) -> bool:
    """Skip proper nouns, format samples, Arabic source text and bare symbols.

    A string is only treated as Arabic source when Arabic outweighs Latin —
    English prose carrying an honorific ("Musa عليه السلام") is still prose and
    still needs translating.
    """
    core = strip_placeholders(value).strip()
    if len(ARABIC_SCRIPT.findall(value)) >= len(re.findall(r"[A-Za-z]", value)):
        return False
    if not core or re.fullmatch(r"[\W\d\s_·•–—:/,.\-]+", core):
        return False
    return len(core.split()) >= 2


def tier_of(key: str) -> str:
    return "A" if key.startswith(TIER_A_PREFIXES) else "B"


def check_locale(locale: str, template: dict) -> dict:
    data = load(locale)
    source = {
        k: v for k, v in template.items()
        if not k.startswith("@") and isinstance(v, str)
    }

    findings: dict[str, list[str]] = {
        "missing_key": [],
        "stale_key": [],
        "placeholder_added": [],
        "placeholder_dropped": [],
        "missing_sentence_space": [],
        "stripped_diacritics": [],
        "register_mixed_in_string": [],
        "register_wrong": [],
    }
    counts = {"A": [0, 0], "B": [0, 0]}  # [untranslated, total] of prose keys

    for key in data:
        if not key.startswith("@") and key not in source and key != "@@locale":
            findings["stale_key"].append(key)

    register = REGISTER.get(locale)
    off_register = 0

    for key, english in source.items():
        if key not in data or not isinstance(data[key], str):
            findings["missing_key"].append(key)
            continue
        value = data[key]

        want = set(PLACEHOLDER.findall(english))
        got = set(PLACEHOLDER.findall(value))
        if got - want:
            findings["placeholder_added"].append(f"{key}: +{sorted(got - want)}")
        if want - got:
            findings["placeholder_dropped"].append(f"{key}: -{sorted(want - got)}")

        if is_translatable_prose(english):
            tier = tier_of(key)
            counts[tier][1] += 1
            if normalize_for_comparison(value) == normalize_for_comparison(english):
                counts[tier][0] += 1
                continue  # untranslated copy: later checks would flag the English

        if MISSING_SPACE.search(value):
            findings["missing_sentence_space"].append(key)

        pattern = STRIPPED_DIACRITICS.get(locale)
        if pattern and pattern.search(value):
            findings["stripped_diacritics"].append(key)

        if register and not REGISTER_EXEMPT.search(key):
            formal = bool(register["formal"].search(value))
            informal = bool(register["informal"].search(value))
            if formal and informal:
                findings["register_mixed_in_string"].append(key)
            elif (informal if register["expect"] == "formal" else formal):
                off_register += 1
                if len(findings["register_wrong"]) < 25:
                    findings["register_wrong"].append(key)

    a_untranslated, a_total = counts["A"]
    b_untranslated, b_total = counts["B"]
    return {
        "locale": locale,
        "tier_a_untranslated": a_untranslated,
        "tier_a_total": a_total,
        "tier_a_ratio": a_untranslated / a_total if a_total else 0.0,
        "tier_b_untranslated": b_untranslated,
        "tier_b_total": b_total,
        "register_wrong_count": off_register,
        "findings": {k: v for k, v in findings.items() if v},
        "advisory_diacritics": advisory_stripped_diacritics(data),
    }


# Structural defects. These block for every locale, shipping or not, because
# gen-l10n unions placeholders across all ARB files — one locale inventing a
# placeholder adds a phantom parameter to the method English and German call.
STRUCTURAL = (
    "missing_key",
    "stale_key",
    "placeholder_added",
    "placeholder_dropped",
)

# Copy quality. Only blocks for a locale that actually ships; the others are
# works in progress and would hold CI red for no benefit.
COPY_QUALITY = (
    "missing_sentence_space",
    "stripped_diacritics",
    "register_mixed_in_string",
)


def blocking_failures(result: dict, release: bool) -> list[str]:
    fails = [c for c in STRUCTURAL if c in result["findings"]]
    if not release:
        return fails
    fails += [c for c in COPY_QUALITY if c in result["findings"]]
    if result["tier_a_ratio"] > TIER_A_MAX_UNTRANSLATED:
        fails.append(
            f"tier_a_untranslated {result['tier_a_ratio']:.1%} "
            f"> {TIER_A_MAX_UNTRANSLATED:.0%}"
        )
    if result["register_wrong_count"]:
        fails.append(f"register_wrong ({result['register_wrong_count']} strings)")
    return fails


def advisory_notes(result: dict, release: bool) -> list[str]:
    """Non-blocking: real defects on a locale that is not shipping yet."""
    if release:
        return []
    return [c for c in COPY_QUALITY if c in result["findings"]]


LOCALE_PROVIDER = (
    Path(__file__).resolve().parent.parent
    / "lib" / "core" / "localization" / "locale_provider.dart"
)


def release_locales_from_source() -> set[str]:
    """Read releaseSupportedLocales out of the Dart source.

    Deriving it rather than repeating it means adding a locale to the app
    automatically subjects it to the full gate — the list cannot drift.
    """
    source = LOCALE_PROVIDER.read_text(encoding="utf-8")
    match = re.search(
        r"releaseSupportedLocales\s*=\s*<Locale>\[(.*?)\]", source, re.S
    )
    if not match:
        raise SystemExit(f"could not find releaseSupportedLocales in {LOCALE_PROVIDER}")
    found = set()
    for lang, country in re.findall(
        r"Locale\(\s*'([^']+)'(?:\s*,\s*'([^']+)')?", match.group(1)
    ):
        found.add(f"{lang}_{country}" if country else lang)
    return found


def main() -> int:
    ap = argparse.ArgumentParser(
        description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter
    )
    ap.add_argument("--release", nargs="*", default=None,
                    help="locales that must pass the full release gate")
    ap.add_argument("--release-from-source", action="store_true",
                    help="derive the release list from releaseSupportedLocales")
    ap.add_argument("--json", action="store_true", help="emit JSON")
    args = ap.parse_args()
    if args.release_from_source:
        derived = release_locales_from_source() - {TEMPLATE}
        args.release = sorted(derived | set(args.release or []))

    template = load(TEMPLATE)
    locales = sorted(
        p.stem.replace("app_", "") for p in L10N_DIR.glob("app_*.arb")
        if p.stem.replace("app_", "") != TEMPLATE
    )
    release = set(args.release or [])

    results = [check_locale(loc, template) for loc in locales]
    if args.json:
        print(json.dumps(results, indent=2, ensure_ascii=False))

    failed = False
    if not args.json:
        print(f"{'locale':8}{'tier A left':>12}{'':3}{'tier B left':>12}{'':3}{'issues'}")
        print("-" * 72)
    for r in results:
        fails = blocking_failures(r, r["locale"] in release)
        if fails:
            failed = True
        if args.json:
            continue
        gate = "RELEASE" if r["locale"] in release else ""
        notes = advisory_notes(r, r["locale"] in release)
        if fails:
            issues = "FAIL: " + ", ".join(fails)
        elif notes:
            issues = "ok (warn: " + ", ".join(notes) + ")"
        else:
            issues = "clean"
        print(
            f"{r['locale']:8}"
            f"{r['tier_a_untranslated']:>7}/{r['tier_a_total']:<4}"
            f"{'':3}{r['tier_b_untranslated']:>7}/{r['tier_b_total']:<4}"
            f"{'':3}{issues}{('  [' + gate + ']') if gate else ''}"
        )
    if not args.json:
        for r in results:
            fails = blocking_failures(r, r["locale"] in release)
            if not fails:
                continue
            print(f"\n{r['locale']}:")
            for check, items in r["findings"].items():
                print(f"  {check}: {len(items)}")
                for item in items[:5]:
                    print(f"      {item}")
                if len(items) > 5:
                    print(f"      … {len(items) - 5} more")
    return 1 if failed else 0


if __name__ == "__main__":
    sys.exit(main())
