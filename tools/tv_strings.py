#!/usr/bin/env python3
"""Keep the Apple TV .strings tables in step with the Swift that uses them.

The Apple TV target looks strings up by their English text
(`tvLocalized("Continue reading")`), so a rewritten line is a new key and the
old one is left behind in five tables. This tool reads the keys out of the
Swift sources and reconciles the tables against them.

    python3 tools/tv_strings.py                  # report; exit 1 if out of step
    python3 tools/tv_strings.py --write          # add new keys, drop dead ones
    python3 tools/tv_strings.py --write --translations FILE.json
    python3 tools/tv_strings.py --lint           # the voice guide, as JSON

FILE.json is {"<locale>": {"<english key>": "<translation>"}}. A key with no
translation on offer is left out of that locale's table, and the app falls
back to the English.

The lint holds the released sections to docs/voice_and_copy_guide.md and to
full translation. The sections that are not in the rail yet are counted, not
failed: test/app/tv_strings_ratchet_test.dart keeps their count from rising.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
TARGET = ROOT / "ios" / "PathOfNurTV"
LOCALES = ("de", "ar", "ur", "fr")

STRING = r'"((?:[^"\\]|\\.)*)"'
CALL = re.compile(r"tvLocalized\(\s*" + STRING)
KEY_PROPERTY = re.compile(r"var \w+Key: String \{")
RETURN = re.compile(r"return\s+" + STRING)
ENTRY = re.compile(r"^" + STRING + r"\s*=\s*" + STRING + r";\s*$")
FORMAT_SPEC = re.compile(r"%(?:\d+\$)?[@dfs]")


# What a viewer can reach. Whole files, and the named parts of the files that
# also carry the sections still held back.
RELEASED_FILES = (
    "Components/TVContinueJourneyCard.swift",
    "Components/TVDhikrModeCard.swift",
    "Components/TVEmptyStateCard.swift",
    "Components/TVHeroCard.swift",
    "Components/TVNavigationSidebar.swift",
    "Components/TVPrayerTimeCard.swift",
    "Components/TVQuranAyahCard.swift",
    "Components/TVQuranBrowseCollectionCard.swift",
    "Components/TVQuranPlaybackCard.swift",
    "Components/TVQuranSurahRow.swift",
    "Components/TVSectionHeader.swift",
    "Data/TVDhikrRoutineData.swift",
    "Data/TVPrayerCities.swift",
    "Screens/TVDhikrRoutinePlayerScreen.swift",
    "Screens/TVDhikrScreen.swift",
    "Screens/TVHomeScreen.swift",
    "Screens/TVPrayerCityPickerScreen.swift",
    "Screens/TVPrayerScreen.swift",
    "Screens/TVQuranListeningModeScreen.swift",
    "Screens/TVQuranScreen.swift",
    "Screens/TVSettingsScreen.swift",
    "Support/TVPrayerService.swift",
    "Theme/TVTheme.swift",
)
RELEASED_PARTS = {
    "ViewModels/TVAppViewModel.swift": (
        "final class TVSettingsViewModel",
        "final class TVPrayerViewModel",
        "final class TVDhikrViewModel",
        "final class TVHomeViewModel",
        "final class TVQuranViewModel",
    ),
    "Data/TVSeedRepository.swift": (
        "static func homeHero",
        "static func prayerHero",
        "static func dhikrHero",
        "static func settingsHero",
        "static func dhikrModes",
        "static func dhikrSteps",
        "static func homeContinueJourneyItems",
        "static func quranBrowseCollections",
    ),
    "Models/TVModels.swift": ("enum TVQuranReciter",),
}
# Keys reached through a released case of an enum that also has held-back cases.
RELEASED_KEYS = (
    "Home", "Prayer", "Qur’an", "Dhikr", "Settings",
    "Today’s prayers and verse", "Today’s prayer times", "Read and listen",
    "Remembrance, phrase by phrase", "Appearance and listening",
    "Where you left off", "Opens the last section you used.",
    "Opens on today’s prayers and verse.", "Opens on the reader.",
    "Opens on today’s prayer times.",
)

# docs/voice_and_copy_guide.md, rules 2, 4, 6 and 12.
RULES = {
    "studio-vocabulary": re.compile(
        r"\b(tvOS|surface|island|hub|module|flow|layer|legacy|migration|parity|"
        r"canonical|scaffold|entry point|enrichment|dataset|route|shell|"
        r"remote-first|mobile app|this build|the current build)\b", re.I),
    "self-described-tone": re.compile(
        r"\b(calm|gentle|quiet|steady|soft|peaceful|meaningful|intentional|mindful)\w*\b",
        re.I),
    "roadmap": re.compile(
        r"\b(coming soon|placeholder|for now|not yet|future passes|phase ships|"
        r"return later|will appear)\b", re.I),
    "straight-apostrophe": re.compile(r"'"),
    "dash": re.compile(r"—| - "),
}


def unescape(text: str) -> str:
    return text.replace('\\"', '"').replace("\\n", "\n").replace("\\\\", "\\")


def escape(text: str) -> str:
    return text.replace("\\", "\\\\").replace('"', '\\"').replace("\n", "\\n")


def keys_in_sources() -> set[str]:
    keys: set[str] = set()
    for path in sorted(TARGET.rglob("*.swift")):
        keys |= keys_in(path.read_text(encoding="utf-8"))
    return keys


def keys_in(source: str) -> set[str]:
    keys = {unescape(match) for match in CALL.findall(source)}
    for block in KEY_PROPERTY.finditer(source):
        keys.update(unescape(m) for m in RETURN.findall(braced(source, block.end() - 1)))
    # An interpolated literal is not a key: it is looked up after it is built.
    return {key for key in keys if "\\(" not in key and key}


def braced(source: str, open_brace: int) -> str:
    """The text of the block whose opening brace is at `open_brace`."""
    depth, index = 0, open_brace
    while index < len(source):
        depth += {"{": 1, "}": -1}.get(source[index], 0)
        index += 1
        if depth == 0:
            break
    return source[open_brace:index]


def released_keys() -> set[str]:
    keys = set(RELEASED_KEYS)
    for name in RELEASED_FILES:
        keys |= keys_in((TARGET / name).read_text(encoding="utf-8"))
    for name, parts in RELEASED_PARTS.items():
        source = (TARGET / name).read_text(encoding="utf-8")
        for part in parts:
            at = source.find(part)
            if at < 0:
                raise SystemExit(f"tv_strings: “{part}” is no longer in {name}")
            keys |= keys_in(braced(source, source.index("{", at)))
    return keys


def lint() -> int:
    used = keys_in_sources()
    released = released_keys() & used
    report = {
        "released": {rule: [] for rule in RULES},
        "untranslated": {},
        "held_back": {},
    }
    for rule, pattern in RULES.items():
        report["released"][rule] = sorted(k for k in released if pattern.search(k))
        report["held_back"][rule] = sum(
            1 for k in used - released if pattern.search(k))
    for locale in LOCALES:
        table = read_table(TARGET / f"{locale}.lproj" / "Localizable.strings")
        report["untranslated"][locale] = sorted(released - set(table))
    print(json.dumps(report, ensure_ascii=False, indent=2))
    return 0


def read_table(path: Path) -> dict[str, str]:
    table: dict[str, str] = {}
    if not path.exists():
        return table
    for line in path.read_text(encoding="utf-8").splitlines():
        match = ENTRY.match(line.strip())
        if match:
            table[unescape(match.group(1))] = unescape(match.group(2))
    return table


def write_table(path: Path, table: dict[str, str], order: list[str]) -> None:
    lines = [f'"{escape(key)}" = "{escape(table[key])}";' for key in order if key in table]
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def plain(key: str) -> str:
    """The key as it was before the apostrophe was curled."""
    return key.replace("’", "'")


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--write", action="store_true")
    parser.add_argument("--translations", type=Path)
    parser.add_argument("--lint", action="store_true")
    args = parser.parse_args()
    if args.lint:
        return lint()

    used = keys_in_sources()
    english_path = TARGET / "en.lproj" / "Localizable.strings"
    english = read_table(english_path)

    missing = sorted(used - set(english))
    dead = sorted(set(english) - used)

    offered: dict[str, dict[str, str]] = {}
    if args.translations:
        offered = json.loads(args.translations.read_text(encoding="utf-8"))

    # Existing order first, so a diff shows what changed and nothing else.
    order = [key for key in english if key in used] + missing
    problems: list[str] = []

    for locale in LOCALES:
        path = TARGET / f"{locale}.lproj" / "Localizable.strings"
        table = read_table(path)
        kept = {key: value for key, value in table.items() if key in used}
        for key in used - set(kept):
            if key in offered.get(locale, {}):
                kept[key] = offered[locale][key]
            elif plain(key) in table:
                kept[key] = table[plain(key)]
        for key, value in kept.items():
            if FORMAT_SPEC.findall(key) != FORMAT_SPEC.findall(value):
                problems.append(f"{locale}: format specifiers differ in “{key}”")
        untranslated = sorted(used - set(kept))
        print(f"{locale}: {len(kept)} of {len(used)} translated, "
              f"{len(table) - len([k for k in table if k in used])} dead")
        if args.write:
            write_table(path, kept, order)
        elif set(table) - used:
            problems.append(f"{locale}: {len(set(table) - used)} dead keys")
        if untranslated and args.translations:
            for key in untranslated[:400]:
                print(f"  {locale} has no translation for: {key}")

    print(f"en: {len(used)} keys in use, {len(missing)} missing from the table, {len(dead)} dead")
    if args.write:
        write_table(english_path, {key: key for key in used}, order)
    else:
        problems.extend(f"en: missing “{key}”" for key in missing)
        if dead:
            problems.append(f"en: {len(dead)} dead keys")

    for problem in problems[:40]:
        print(problem, file=sys.stderr)
    return 1 if problems else 0


if __name__ == "__main__":
    sys.exit(main())
