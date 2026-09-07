#!/usr/bin/env python3
"""Copy lint for Path of Nur's English strings.

Counts, per rule, how many strings break the voice guide
(docs/voice_and_copy_guide.md). It is a ratchet, not a wall:
tools/copy_lint_baseline.json holds today's counts, and
test/app/copy_lint_ratchet_test.dart fails when a count rises (new drift) or
falls without the baseline being lowered (so the baseline only ever goes
down and can never rot into a permanent exemption).

Usage:
  python3 tools/copy_lint.py                  table of counts against the baseline
  python3 tools/copy_lint.py --list RULE      the offending keys for one rule
  python3 tools/copy_lint.py --json           machine-readable counts
  python3 tools/copy_lint.py --check          exit 1 when any rule is off baseline
  python3 tools/copy_lint.py --write-baseline lock today's counts

Scopes. "chrome" is every English key that is not lesson prose (see
CONTENT_SUFFIX) and not a sacred text (see SACRED_SUFFIX: du'a and Qur'an
translations are never reworded, only repunctuated). Tone rules run on chrome
only; mechanics run on everything that is not sacred; the apostrophe rule runs
on everything.
"""
from __future__ import annotations

import argparse
import json
import os
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Callable, Iterable

ROOT = Path(__file__).resolve().parent.parent
ARB = ROOT / "lib" / "l10n" / "app_en.arb"
BASELINE = ROOT / "tools" / "copy_lint_baseline.json"
KIDS_STORY_DIRS = (
    ROOT / "lib" / "features" / "kids" / "bedtime_stories" / "data",
    ROOT / "lib" / "features" / "kids" / "seerah" / "data",
    ROOT / "lib" / "features" / "kids_dua_learning" / "data",
)

# Lesson prose: edited for mechanics and studio vocabulary, never for tone.
CONTENT_SUFFIX = re.compile(
    r"(Body|Description|Intro|Introduction|Takeaway\d*|Bullet\d*|Summary|"
    r"Reflection|Quote|Lesson|Explanation|WhyItMatters|StudyFocus|Starter|"
    r"Prompt|Insight|Story|Narration|Answer|Question|Option[A-D0-9]*|"
    r"Choice\d*|Step\d+|Note|Guidance|Tip|Paragraph\d*|Details?|Content|"
    r"Passage|Overview|Context|Practical\w*|Scenario\w*|Outcome\d*)$"
)
# Sacred text: translations of du'a, Qur'an and hadith. Only the apostrophe
# glyph is ever touched.
SACRED_SUFFIX = re.compile(
    r"(Translation|Transliteration|Arabic|Meaning|Invocation\w*|Translit|"
    r"Verse|VerseText|AyahText|Matn)$"
)
LABEL_SUFFIX = re.compile(r"(Title|Action|Label|Badge|Eyebrow|Tab|Chip|Button|Name)$")
CASING_SUFFIX = re.compile(
    r"(Action|Label|Badge|Eyebrow|Tab|Chip|Button|Subtitle|Hint|SectionTitle|Caption)$"
)
KIDS_PREFIX = re.compile(r"^(kids|bedtime)")

# Words that are proper names on this app's screens. A Title Case rule that
# flagged "Surah Al-Fatihah" would only teach people to ignore it.
PROPER = {
    "Allah", "Qur’an", "Qur''an", "Quran", "Qur’anic", "Qur''anic", "Ramadan",
    "Eid", "Fajr", "Dhuhr", "Asr", "Maghrib", "Isha", "Jumu’ah", "Jumu''ah",
    "Hijri", "Gregorian", "Surah", "Makkah", "Madinah", "Seerah", "Sunnah",
    "Arabic", "English", "German", "Urdu", "Persian", "Farsi", "Dari", "Tajik",
    "Turkish", "French", "Hindi", "Bengali", "Indonesian", "Malay", "Punjabi",
    "Pashto", "Kurdish", "Hausa", "Islam", "Islamic", "Muslim", "Muslims",
    "Prophet", "Prophets", "Muhammad", "Al-Fatihah", "Fatihah", "Nur", "Nūr",
    "Path", "Apple", "Google", "iCloud", "Watch", "TV", "Dynamic", "Island",
    "Hajj", "Umrah", "Zakat", "Tahajjud", "Witr", "Tarawih", "Iftar", "Suhoor",
    "Qibla", "Adhan", "Ayat", "Kursi", "Yasin", "Kahf", "Mulk", "Rahman",
    "Bukhari", "Tirmidhi", "Sahih", "Laylat", "Qadr", "Ashura", "Muharram",
    "Shaban", "Rajab", "Dhul", "Hijjah", "Qadah", "Shawwal", "Safar", "Rabi",
    "Jumada", "Hanafi", "Shafi’i", "Shafi''i", "Maliki", "Hanbali", "Ibrahim",
    "Musa", "Isa", "Yusuf", "Adam", "Nuh", "Ali", "Umar", "Uthman", "Abu",
    "Bakr", "Aishah", "Khadijah", "Fatimah", "Bilal", "Anas", "Jibril", "Hira",
    "Badr", "Uhud", "Hudaybiyyah", "Khandaq", "Tabuk", "Ansar", "Muhajirun",
    "Companions", "Companion", "I", "PDF", "OK", "AR", "GPS", "ID", "FAQ",
    "App", "Store", "Play", "Misbaha", "Khatm", "Juz", "Hizb", "Tajweed",
    "Ayah", "Hadith", "Dhikr", "Salah", "Dua", "Wudu", "Khushu", "Ibadah",
    "Fiqh", "Aqidah", "Shahada", "Bismillah", "Salawat", "Tasbih", "Hifz",
    "Alhamdulillah", "Subhanallah", "Allahu", "Akbar", "Sabr", "Shukr",
    "Ikhlas", "Tawbah", "Taqwa", "Barakah", "Sadaqah", "Khayr", "Deen",
    "Iman", "Ihsan", "Ummah", "Sahaba", "Ansar", "Hijrah", "Masjid",
}


def load_arb(path: Path = ARB) -> dict[str, str]:
    data = json.loads(path.read_text(encoding="utf-8"))
    return {k: v for k, v in data.items() if not k.startswith("@") and isinstance(v, str)}


def is_sacred(key: str) -> bool:
    return bool(SACRED_SUFFIX.search(key))


def is_content(key: str) -> bool:
    return bool(CONTENT_SUFFIX.search(key))


def is_chrome(key: str) -> bool:
    return not is_sacred(key) and not is_content(key)


def words(value: str) -> list[str]:
    return [w for w in re.split(r"\s+", value.strip()) if w]


# --------------------------------------------------------------------- rules

@dataclass(frozen=True)
class Rule:
    id: str
    scope: str  # "chrome" | "prose" (everything not sacred) | "all"
    description: str
    fix: str
    match: Callable[[str, str], bool]

    def applies(self, key: str) -> bool:
        if self.scope == "all":
            return True
        if self.scope == "prose":
            return not is_sacred(key)
        return is_chrome(key)


def rx(pattern: str, flags: int = 0) -> Callable[[str, str], bool]:
    compiled = re.compile(pattern, flags)
    return lambda key, value: bool(compiled.search(value))


def rx_key_exempt(pattern: str, exempt_keys: str, flags: int = 0) -> Callable[[str, str], bool]:
    compiled = re.compile(pattern, flags)
    exempt = re.compile(exempt_keys)
    return lambda key, value: not exempt.search(key) and bool(compiled.search(value))


_TAIL_END = re.compile(r"\b(right now|today|tonight)\W*$", re.I)
_TAIL_ANY = re.compile(
    r"\bin one (?:calm |focused |quiet )?(?:place|flow|view|space|screen|dashboard)\b|"
    r"\bat your own pace\b|\bwhen you (?:want|need)\b|"
    r"\bwith (?:intention|care|ease|clarity|presence)\b",
    re.I,
)


def tail(key: str, value: str) -> bool:
    if _TAIL_ANY.search(value):
        return True
    return len(words(value)) >= 5 and bool(_TAIL_END.search(value))


_CHEER_WORDS = re.compile(
    r"\b(Great job|Great work|Awesome|Amazing|Well done|Congratulations|Congrats|Hooray|Yay|Superstar)\b"
)


def cheer(key: str, value: str) -> bool:
    if _CHEER_WORDS.search(value):
        return True
    return "!" in value and not KIDS_PREFIX.match(key)


_HONORIFIC = re.compile(
    r"(?:\bProphet Muhammad\b|\bMuhammad\b|\bthe Prophet\b(?:[’']s)?(?! [A-Z])|"
    r"\bthe Messenger of Allah\b|\bthe Messenger\b|\bFinal Messenger\b)"
    r"(?! ﷺ)(?!s\b)"
)


def honorific(key: str, value: str) -> bool:
    if key.startswith("babyNames"):
        return False
    return bool(_HONORIFIC.search(value))


def label_period(key: str, value: str) -> bool:
    if not LABEL_SUFFIX.search(key):
        return False
    v = value.strip()
    return v.endswith(".") and not v.endswith("...") and len(words(v)) <= 6


def title_case_outside_titles(key: str, value: str) -> bool:
    if not CASING_SUFFIX.search(key):
        return False
    ws = [w.strip(".,:;!?()") for w in words(value)]
    ws = [w for w in ws if w and not w.startswith("{")]
    if len(ws) < 2:
        return False
    for w in ws:
        if w[0].islower() and len(w) >= 4:
            return False  # sentence case already
    offenders = [
        w for w in ws[1:]
        if w[0].isupper() and w not in PROPER and not w.isupper() and "ﷺ" not in w
    ]
    return bool(offenders)


def subtitle_long(key: str, value: str) -> bool:
    if not key.endswith("Subtitle"):
        return False
    return len(value) > 92 or len(words(value)) > 14


RULES: list[Rule] = [
    Rule(
        "tone-self-described", "chrome",
        "The copy names its own tone (calm, gentle, quiet, steady, soft, meaningful).",
        "Delete the adjective. Calm copy is short; it does not say it is calm.",
        rx_key_exempt(
            r"\b(calm(?:ly|er|est)?|gentl(?:e|y|er)|quiet(?:ly|er)?|stead(?:y|ily|ier)|"
            r"soft(?:ly|er)?|peaceful(?:ly)?|meaningful(?:ly)?|intentional(?:ly)?|"
            r"mindful(?:ly)?|serene(?:ly)?)\b",
            r"Channel|QuietHours|Silent|SoundQuiet",
            re.I,
        ),
    ),
    Rule(
        "tone-list-of-three", "chrome",
        "A list of three or more things in chrome copy (\"X, Y, and Z\").",
        "Name the purpose, not the inventory.",
        rx(r"\b[\w’'-]+, [\w’'-]+(?: [\w’'-]+)?, (?:and|or) [\w’'-]+"),
    ),
    Rule(
        "tone-tail", "chrome",
        "A filler tail: right now / today / in one place / at your own pace / when you want / with intention.",
        "Drop the tail unless the sentence is untrue without it.",
        tail,
    ),
    Rule(
        "tone-cheer", "chrome",
        "Cheerleading: Great job, Awesome, or an exclamation mark outside kids copy.",
        "State the fact quietly, or let the deen carry the warmth (alhamdulillah).",
        cheer,
    ),
    Rule(
        "tone-gamified", "chrome",
        "Game vocabulary: streak, XP, points, badge, level up.",
        "Say days in a row, light, and what was actually done (decision 1, 2026-09-07).",
        rx(r"\b(streaks?|XP|points|badges?|level up|leaderboards?)\b"),
    ),
    Rule(
        "studio-vocabulary", "prose",
        "Product or engineering words on screen: surface, island, hub, module, flow, layer, legacy, migration, parity, canonical, system.",
        "Say what the person sees: a page, a lesson, the reader.",
        rx_key_exempt(
            r"(?<!Dynamic )(?<!solar )(?<!Solar )\b(surfaces?|islands?|hubs?|modules?|flows?|"
            r"layers?|legacy|migrations?|migrated|parity|canonical|scaffold(?:ing)?|"
            r"owner|entry points?|enrichment|datasets?|routes?|routing|toggles?|fallback|"
            r"deprecated|payload|runtime|utilit(?:y|ies))\b|"
            r"\b(?<!Solar )(?<!solar )systems?\b(?! default)",
            r"^(editorial|contentBuilder|worldAtmosphere|settingsThemeMode|profileWhatsNew)",
            re.I,
        ),
    ),
    Rule(
        "roadmap-speak", "chrome",
        "The screen talks about the roadmap: will appear here as content grows, future, placeholder, coming soon, for now.",
        "An empty state says what is here. It never promises.",
        rx_key_exempt(
            r"will appear here|as .{0,50}\b(?:grows?|expands?|are prepared|is prepared|matures?)\b|"
            r"\bfuture\b|coming soon|placeholder|not fully available|intentionally contained|"
            r"later passes|parity with|phased|roadmap|\bfor now\b",
            r"^(editorial|contentBuilder|profileWhatsNew)",
            re.I,
        ),
    ),
    Rule(
        "apostrophe-straight", "all",
        "A straight apostrophe (ARB '' renders as ').",
        "Use the curly ’ so Qur’an looks the same on every screen.",
        rx(r"''"),
    ),
    Rule(
        "quran-spelling", "prose",
        "Quran without the apostrophe.",
        "Qur’an, Qur’anic.",
        rx(r"\bQuran(?:ic)?\b"),
    ),
    Rule(
        "term-spelling", "prose",
        "A spelling the glossary does not use (Qaza, Taraweeh, Noor, Mecca, InshaAllah…).",
        "See the glossary in docs/voice_and_copy_guide.md.",
        rx(
            r"\b(Qaza|qaza|Taraweeh|Noor|Hadeeth|Zikr|Namaz|Wudhu|Ramadhan|Mecca|Medina|"
            r"Sirah|Seera|Sahabah?)\b|"
            r"\b[Ii]nsha ?[Aa]llah\b|\b[Ii]nshallah\b|\b[Mm]asha ?[Aa]llah\b|\b[Mm]ashallah\b|"
            r"\bAlhamdulilah\b|\bJazak ?[Aa]llah\b"
        ),
    ),
    Rule(
        "uk-spelling", "prose",
        "British spelling in a US-spelled app (colour, favourite, practise, memorise, centre).",
        "US spelling throughout.",
        rx(
            r"\b(?:colour\w*|honour\w*|favourite\w*|practis(?:e|es|ed|ing)|memoris\w*|"
            r"organis\w*|recognis\w*|centre\w*|behaviour\w*|neighbour\w*|programme\w*|"
            r"catalogue\w*|travell\w+|cancell\w+|learnt|whilst)\b",
            re.I,
        ),
    ),
    Rule(
        "term-casing", "prose",
        "An Islamic common noun capitalized mid-sentence (the Hadith library, daily Dhikr).",
        "Lowercase salah, du’a, dhikr, hadith, wudu, ayah, surah unless it starts the sentence or names something (Surah Yusuf).",
        rx(
            r"(?<=[a-z,;:] )(?:Salah|Duas?|Dhikr|Hadiths?|Wudu|Ayahs?|Surahs|Sunnah|Qada|"
            r"Iftar|Suhoor|Adhan|Tajweed|Khushu|Ibadah|Fiqh|Aqidah|Tawbah|Taqwa|Ihsan|"
            r"Sabr|Shukr|Ikhlas)\b(?! [A-Z\d])|(?<=[a-z,;:] )Surah\b(?! [A-Z\d])"
        ),
    ),
    Rule(
        "honorific-missing", "prose",
        "The Prophet or Muhammad without ﷺ.",
        "ﷺ after every mention, including possessives (the Prophet’s ﷺ).",
        honorific,
    ),
    Rule(
        "typo", "prose",
        "todays / tonights / a doubled word.",
        "Fix the typo.",
        rx(r"\btodays\b|\btonights\b|\bchilds\b|\b(\w{2,}) \1\b(?![’'])", re.I),
    ),
    Rule(
        "dash", "chrome",
        "An em-dash or a spaced hyphen used as a dash in chrome copy.",
        "A period, a comma, or a middle dot (·) between values.",
        rx(r"—|\s-\s"),
    ),
    Rule(
        "label-period", "chrome",
        "A title, button or label that ends with a period.",
        "Labels carry no terminal period; only sentences do.",
        label_period,
    ),
    Rule(
        "title-case-outside-titles", "chrome",
        "Title Case on a button, label, section title, subtitle or hint (decision 2: sentence case).",
        "Continue reading, Start here. Page titles keep Title Case.",
        title_case_outside_titles,
    ),
    Rule(
        "subtitle-long", "chrome",
        "A subtitle over 92 characters or 14 words.",
        "One breath. Aim for eight words.",
        subtitle_long,
    ),
]

RULE_BY_ID = {r.id: r for r in RULES}


# ------------------------------------------------------- repository scans

_IDENT = re.compile(r"[A-Za-z_][A-Za-z0-9_]*")


def referenced_identifiers(roots: Iterable[Path] = ()) -> set[str]:
    """Every identifier-shaped token in lib/ (minus lib/l10n) and test/.

    A key counts as used when it appears anywhere in Dart, including as a
    bare name inside a string map: a few services look keys up by name.
    """
    roots = tuple(roots) or (ROOT / "lib", ROOT / "test")
    found: set[str] = set()
    for root in roots:
        for dirpath, _dirs, files in os.walk(root):
            if dirpath.startswith(str(ROOT / "lib" / "l10n")):
                continue
            for name in files:
                if not name.endswith(".dart"):
                    continue
                try:
                    text = Path(dirpath, name).read_text(encoding="utf-8", errors="ignore")
                except OSError:
                    continue
                found.update(_IDENT.findall(text))
    return found


def dead_keys(strings: dict[str, str] | None = None) -> list[str]:
    strings = strings if strings is not None else load_arb()
    used = referenced_identifiers()
    return sorted(k for k in strings if k not in used)


_UNQUOTED_SPEECH = re.compile(
    r"\b(?:said|asked|whispered|replied|answered|called|laughed|shouted|sang|prayed)"
    r"(?: [a-z]+)?, [A-Z]"
)


def unquoted_kids_dialogue() -> list[str]:
    hits: list[str] = []
    for root in KIDS_STORY_DIRS:
        if not root.exists():
            continue
        for path in sorted(root.rglob("*.dart")):
            for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
                if _UNQUOTED_SPEECH.search(line):
                    hits.append(f"{path.relative_to(ROOT)}:{number}")
    return hits


# ------------------------------------------------------------------ report

def offenders(rule: Rule, strings: dict[str, str]) -> list[tuple[str, str]]:
    return [(k, v) for k, v in strings.items() if rule.applies(k) and rule.match(k, v)]


def run(strings: dict[str, str] | None = None) -> dict[str, list[str]]:
    strings = strings if strings is not None else load_arb()
    out: dict[str, list[str]] = {}
    for rule in RULES:
        out[rule.id] = [k for k, _ in offenders(rule, strings)]
    out["dead-keys"] = dead_keys(strings)
    out["kids-dialogue-unquoted"] = unquoted_kids_dialogue()
    return out


def describe(rule_id: str) -> tuple[str, str]:
    if rule_id == "dead-keys":
        return ("An English key no Dart file references.",
                "Delete it from every ARB: python3 tools/prune_dead_l10n_keys.py")
    if rule_id == "kids-dialogue-unquoted":
        return ("A kids story line of speech without quotation marks.",
                "Mama said, “Bismillah.”")
    r = RULE_BY_ID[rule_id]
    return (r.description, r.fix)


def load_baseline() -> dict[str, int]:
    if not BASELINE.exists():
        return {}
    return dict(json.loads(BASELINE.read_text(encoding="utf-8")).get("counts", {}))


def main(argv: list[str] | None = None) -> int:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--json", action="store_true", help="emit counts as JSON")
    ap.add_argument("--list", metavar="RULE", help="print the offending keys for one rule")
    ap.add_argument("--limit", type=int, default=0, help="with --list, stop after N rows")
    ap.add_argument("--check", action="store_true", help="exit 1 when any rule is off baseline")
    ap.add_argument("--write-baseline", action="store_true", help="write tools/copy_lint_baseline.json")
    args = ap.parse_args(argv)

    strings = load_arb()
    results = run(strings)
    counts = {rule: len(keys) for rule, keys in results.items()}

    if args.list:
        if args.list not in results:
            print(f"unknown rule {args.list!r}; rules: {', '.join(results)}", file=sys.stderr)
            return 2
        desc, fix = describe(args.list)
        print(f"{args.list}: {desc}\n  fix: {fix}\n")
        rows = results[args.list]
        if args.limit:
            rows = rows[: args.limit]
        for k in rows:
            print(f"  {k}: {strings[k][:160]}" if k in strings else f"  {k}")
        print(f"\n{len(results[args.list])} total")
        return 0

    if args.write_baseline:
        BASELINE.write_text(
            json.dumps(
                {
                    "note": "Copy-lint ratchet. Counts may only go down; lower them with "
                            "`python3 tools/copy_lint.py --write-baseline` after a real fix.",
                    "counts": counts,
                },
                indent=2,
                ensure_ascii=False,
            )
            + "\n",
            encoding="utf-8",
        )
        print(f"wrote {BASELINE.relative_to(ROOT)}")

    if args.json:
        print(json.dumps({"counts": counts}, indent=2))
        return 0

    baseline = load_baseline()
    width = max(len(r) for r in counts)
    print(f"{'rule':<{width}}  {'now':>6}  {'base':>6}  delta")
    off = False
    for rule, n in counts.items():
        b = baseline.get(rule)
        delta = "" if b is None else f"{n - b:+d}"
        if b is not None and n != b:
            off = True
        print(f"{rule:<{width}}  {n:>6}  {'' if b is None else b:>6}  {delta}")
    chrome_n = sum(1 for k in strings if is_chrome(k))
    print(f"\n{len(strings)} English strings, {chrome_n} chrome, "
          f"{sum(1 for k in strings if is_content(k))} prose, "
          f"{sum(1 for k in strings if is_sacred(k))} sacred")
    if args.check and off:
        print("\ncopy lint is off its baseline (see the delta column)", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
