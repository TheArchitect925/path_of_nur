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

sys.path.insert(0, str(Path(__file__).resolve().parent))
import copy_prose  # noqa: E402

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
LABEL_SUFFIX = re.compile(r"(Title|Action|Label|Badge|Eyebrow|Tab|Chip|Button)$")
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
    "Apple", "Google", "iCloud", "Watch", "TV", "Dynamic", "Island",
    "Hajj", "Umrah", "Zakat", "Tahajjud", "Witr", "Tarawih", "Iftar", "Suhoor",
    "Qibla", "Adhan", "Ayat", "Kursi", "Yasin", "Kahf", "Mulk", "Rahman",
    "Bukhari", "Tirmidhi", "Sahih", "Laylat", "Qadr", "Ashura", "Muharram",
    "Shaban", "Rajab", "Dhul", "Hijjah", "Qadah", "Shawwal", "Safar", "Rabi",
    "Jumada", "Hanafi", "Shafi’i", "Shafi''i", "Maliki", "Hanbali", "Ibrahim",
    "Musa", "Isa", "Yusuf", "Adam", "Nuh", "Ali", "Umar", "Uthman", "Abu",
    "Bakr", "Aishah", "Khadijah", "Fatimah", "Bilal", "Anas", "Jibril", "Hira",
    "Badr", "Uhud", "Hudaybiyyah", "Khandaq", "Tabuk", "Ansar", "Muhajirun",
    "Companions", "Companion", "I", "PDF", "OK", "AR", "GPS", "ID", "FAQ",
    "App", "Store", "Play", "Shahada", "Bismillah", "Allahu", "Akbar",
    "Sahaba", "Hijrah", "Holy",
    # Tabs and sections a button can point at ("Back to Learn", "Edit Home").
    "Home", "Learn", "Worship", "Ibadah", "Growth", "Kids", "Settings",
    "Profile", "Garden", "Ocean", "Creation", "Explore", "Khusū",
}
APP_NAME = re.compile(r"Path of N[uū]r")
SMALL_WORDS = {"of", "in", "and", "with", "the", "for", "to", "a", "an", "vs", "through", "by", "on", "at", "or", "from"}


def is_title_case(value: str) -> bool:
    """Two or more words, every major word capitalized: a Title Case title."""
    ws = [w.strip(".,:;!?()[]“”\"'’") for w in words(value)]
    ws = [w for w in ws if w and not w.startswith("{") and not w[0].isdigit()]
    if len(ws) < 2:
        return False
    major = [w for w in ws if w.lower() not in SMALL_WORDS]
    return len(major) >= 2 and all(w[0].isupper() or not w[0].isalpha() for w in major)
# Names of things, exempt from the sentence-case rule by key.
NAMED_THING_KEYS = re.compile(
    r"^(settingsThemeChoice|settingsThemeMode|quranReaderAtmosphere|settingsLivingSky)"
)


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


# V2a: names and index lists (2026-09-27). A mode called Gentle mode is named, not
# described; a settings category subtitle is an index of what is inside (the
# way a phone's own settings list reads); and two lists are the content itself.
MODE_NAME_KEYS = r"^(profileGentleModeTitle|settingsCareModeGentleTitle)$"
INDEX_LIST_KEYS = re.compile(
    r"^(settingsCategory\w*Subtitle|onboardingOpeningPlatformFooter|settingsOccasionThemesSubtitle)$"
)


def list_of_three(key: str, value: str) -> bool:
    if INDEX_LIST_KEYS.match(key):
        return False
    return bool(_LIST_OF_THREE.search(value))


_LIST_OF_THREE = re.compile(r"\b[\w’'-]+, [\w’'-]+(?: [\w’'-]+)?, (?:and|or) [\w’'-]+")
# Game words in any case ("Streak", "Badges"); "points" only as a score
# ("+10 points"), never the verb ("points to Allah’s wisdom").
_GAMIFIED = re.compile(
    r"\b(streaks?|XP|badges?|level up|leaderboards?)\b|(?:\d|\}) ?points\b", re.I
)


def gamified(key: str, value: str) -> bool:
    # Placeholder names ({xp}, {streak}) are code, not copy.
    return bool(_GAMIFIED.search(re.sub(r"\{\w+(?=[,}])", "{", value)))


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
    r"(?:\bProphet Muhammad\b|(?<!Surah )\bMuhammad\b|\bthe Prophet(?:[’']s)?\b(?![’']s)(?! [A-Z])|"
    r"\bthe Messenger of Allah\b|\bthe Messenger(?:[’']s)?\b(?![’']s)(?! of Allah)|\bFinal Messenger\b)"
    r"(?! ﷺ)(?!s\b)"
)


def honorific(key: str, value: str) -> bool:
    if key.startswith("babyNames"):
        return False
    return bool(_HONORIFIC.search(value))


_ABBREVIATION = re.compile(r"\b(Approx|etc|vs|No)\.$")


TERM_CASING = re.compile(
    r"(?<=[a-z,;:] )(?!Salah al-Din)(?:Salah|Duas?|Dhikr|Hadiths?|Wudu|Ayahs?|Surahs|Sunnah|Qada|"
    r"Iftar|Suhoor|Adhan|Tajweed|Khushu|Fiqh|Aqidah|Tawbah|Taqwa|Ihsan|"
    r"Sabr|Shukr|Ikhlas)\b(?! (?:[A-Z\d]|a[dhlnrstz]{1,2}-))|(?<=[a-z,;:] )Surah\b(?! (?:[A-Z\d]|a[dhlnrstz]{1,2}-))"
)


_TERM_CASING_NAMES = re.compile(
    r"^(helpGuideLearningStep1|learningJourneyTodayLightDhikrSubtitleFallback|"
    r"learnEnrichmentMilestoneFoundationsCompletedBody)$"
)


def term_casing(key: str, value: str) -> bool:
    if is_title_case(value) or _TERM_CASING_NAMES.match(key):
        return False
    return bool(TERM_CASING.search(value))


def label_period(key: str, value: str) -> bool:
    if not LABEL_SUFFIX.search(key) or "Semantics" in key:
        return False
    v = value.strip()
    if _ABBREVIATION.search(v):
        return False
    return v.endswith(".") and not v.endswith("...") and len(words(v)) <= 6


def title_case_outside_titles(key: str, value: str) -> bool:
    if not CASING_SUFFIX.search(key) or NAMED_THING_KEYS.match(key):
        return False
    value = APP_NAME.sub("", value)
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
            r"Channel|QuietHours|Silent|SoundQuiet|" + MODE_NAME_KEYS,
            re.I,
        ),
    ),
    Rule(
        "tone-list-of-three", "chrome",
        "A list of three or more things in chrome copy (\"X, Y, and Z\").",
        "Name the purpose, not the inventory. Settings category subtitles are indexes and may list.",
        list_of_three,
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
        gamified,
    ),
    Rule(
        "studio-vocabulary", "chrome",
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
        rx(r"(?<!Clear )(?<!package:)\bQuran(?:ic)?\b(?!\.com)"),
    ),
    Rule(
        "term-spelling", "prose",
        "A spelling the glossary does not use (Qaza, Taraweeh, Noor, Mecca, InshaAllah…).",
        "See the glossary in docs/voice_and_copy_guide.md.",
        rx(
            r"\b(Qaza|qaza|Taraweeh|Hadeeth|Zikr|Namaz|Wudhu|Ramadhan|Mecca|Medina|"
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
        "Lowercase salah, du’a, dhikr, hadith, wudu, ayah, surah unless it starts the sentence, names something (Surah Yusuf) or sits in a Title Case title.",
        term_casing,
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
        lambda key, value: value.strip() != "—" and bool(re.search(r"—|\s-\s", value)),
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


# The Name in Arabic script as a word of an English sentence ("Glory be to
# الله"). A find-and-replace in March 2026 put it in some eighty strings; the
# Latin faces have no Arabic, so the phone draws it in a fallback face, small
# and off the line. An Arabic phrase that holds the Name (رضي الله عنه,
# بسم الله) is not flagged: a word beside it is Arabic.
_ARABIC_LETTER = re.compile(r"[ء-ؿف-يٱ-ۓ]")
_ARABIC_MARKS = re.compile(r"[ـً-ٰٟۖ-ۭ]")
_LATIN_LETTER = re.compile(r"[A-Za-z]")
_NAME_IN_LINE = re.compile(r"[اٱ]ل\W*ل\W*ه")
_DART_STRING = re.compile(r"""'(?:[^'\\\n]|\\.)*'|"(?:[^"\\\n]|\\.)*\"""")
# Fields that hold Latin script even when the whole value is the Name.
_LATIN_FIELD = re.compile(r"\b(transliteration|translit|gloss|translation|meaning)\s*:\s*$", re.I)
_ARABIC_FIELD = re.compile(r"\b\w*(arabic|Arabic|phrase|Ar)\s*:\s*$")
_LATIN_KEY = re.compile(r"(Transliteration|Translit|Translation|Meaning|Gloss)$")


def is_the_name(word: str) -> bool:
    letters = "".join(_ARABIC_LETTER.findall(_ARABIC_MARKS.sub("", word)))
    return letters.replace("ٱ", "ا") == "الله"


def arabic_name_spans(text: str, latin_field: bool = False) -> list[tuple[int, int]]:
    """Where the Name stands in Arabic script among Latin words: the (start,
    end) of each such word in [text]. [latin_field] also counts the Name
    alone, for a value that is meant to be Latin script (a transliteration)."""
    ws = list(re.finditer(r"\S+", text))
    spans: list[tuple[int, int]] = []
    for i, w in enumerate(ws):
        if not is_the_name(w.group()):
            continue
        before = ws[i - 1].group() if i else ""
        after = ws[i + 1].group() if i + 1 < len(ws) else ""
        if _ARABIC_LETTER.search(before) or _ARABIC_LETTER.search(after):
            continue
        if latin_field or _LATIN_LETTER.search(before + w.group() + after):
            spans.append(w.span())
    return spans


def arabic_name_in_arb(strings: dict[str, str]) -> list[str]:
    return [
        k for k, v in strings.items()
        if not k.endswith("Arabic") and arabic_name_spans(v, bool(_LATIN_KEY.search(k)))
    ]


def dart_literals_with_arabic_name(path: Path) -> list[tuple[int, re.Match[str], bool]]:
    """(line, literal, latin_field) for each Dart string literal in [path]
    that writes the Name in Arabic script among Latin words."""
    found: list[tuple[int, re.Match[str], bool]] = []
    for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
        if not _NAME_IN_LINE.search(line) or line.lstrip().startswith("//"):
            continue
        for literal in _DART_STRING.finditer(line):
            lead = line[: literal.start()].rstrip("r")
            if _ARABIC_FIELD.search(lead):
                continue
            latin_field = bool(_LATIN_FIELD.search(lead))
            if arabic_name_spans(literal.group()[1:-1], latin_field):
                found.append((number, literal, latin_field))
    return found


def arabic_name_in_dart() -> list[str]:
    hits: list[str] = []
    l10n = ROOT / "lib" / "l10n"
    for path in sorted((ROOT / "lib").rglob("*.dart")):
        if l10n in path.parents:
            continue
        for number, _literal, _field in dart_literals_with_arabic_name(path):
            hits.append(f"{path.relative_to(ROOT)}:{number}")
    return hits


# ------------------------------------------ prose outside the ARB (V3)
#
# tools/copy_prose.py finds the English prose in Dart content files and the
# history JSON. The mechanics rules below hold it to the same glossary as
# the ARB; the last four are V3's rewrites (studio vocabulary, roadmap,
# tails, and lists in the card and summary fields people scan), counted so
# the baseline can only go down.

_APOSTROPHE_BETWEEN = re.compile(r"[A-Za-z]'[A-Za-z]")
# Studio vocabulary in lesson prose. The chrome list would flag the World
# lessons' root systems and atmospheric layers, the Hijrah's migration and a
# scholar's legacy, so prose counts the studio *senses*: words that only ever
# mean the product, and the ambiguous ones where they name a page or feature.
PROSE_STUDIO = re.compile(
    r"\b(?:hubs?|modules?|parity|scaffold(?:ing)?|entry[ -]points?|enrichment|datasets?|"
    r"routing|toggles?|fallback|deprecated|payload|runtime|canonical|(?<!Dynamic )islands?|utilities)\b|"
    r"\butility (?:surfaces?|tools?|pages?)\b|"
    r"\b(?:legacy|older|migrated) (?:learning|library|hub|island|sections?|surfaces?|pages?|content)\b|"
    r"\bduring migration\b|\bsurfaces\b|"
    r"\b(?:learning|reflection|practice|companion|words|note-keeping|timeline|wisdom|hadith|dhikr|"
    r"Prophets|top-words) surface\b|"
    r"\b(?:Prophets|quiz|learning|journey|trivia path|timeline|worship|hadith|core|design) systems?\b|"
    r"\b(?:guided|practice|quiz|capture|meaning|story|checklist practice|wisdom|guided salah|guided prayer) flows?\b|"
    r"\bin one flow\b|"
    r"\b(?:first|middle|next|daily|study|observation|translation) layers?\b|"
    r"\b(?:reading|real|in-app|faster) routes?\b|\broute (?:indirection|through)\b|\bNo route is attached\b",
    re.I,
)
# Roadmap talk in lesson prose: what the product will do later, not the
# future the lesson speaks of (future generations, your future self).
PROSE_ROADMAP = re.compile(
    r"will appear here as|\bas (?:the |more )?(?:content|library|app|section|collection|lessons?|journeys?|features?) "
    r"(?:grows?|expands?|matures?|(?:is|are) prepared)\b|"
    r"\b(?:a|in a) future\b(?! mercy)|\bfuture (?:phases?|updates?|passes|releases?|versions?|kids journeys)\b|"
    r"coming soon|placeholder|not fully available|intentionally contained|later passes|parity with|"
    r"\bphased\b|\broadmap\b|\bFor now\b|\bcontained for now\b"
)
# Filler tails in lesson prose. A closing "today" or "right now" is the point
# of a reflection prompt or a practice ("When did your heart feel most awake
# today?"), and "with care" / "with ease" / "when you need help" are usually
# meant (treat doubtful matters with care; with hardship comes ease), so
# prose counts only the habits that add nothing: "in one place", "at your own
# pace", "with clarity", "with intention" and "with presence" as bare
# adverbs, and "when you want/need" in an instruction to use a page.
PROSE_TAIL = re.compile(
    r"\bin one (?:calm |focused |quiet )?(?:place|flow|view|space|screen|dashboard)\b|"
    r"\bat your own pace\b|\bwith (?:clarity|intention|presence)\b|"
    r"\b(?:Use|Open|Reopen|Adjust|Choose|Visit)\b[^.]{0,140}\bwhen you (?:want|need)\b"
)
_ARABIC_SCRIPT = re.compile(r"[ء-يٱ-ۓ]")
# ARB keys whose Arabic line is the point: the Fajr adhan's "prayer is
# better than sleep".
_ARABIC_IN_ENGLISH_KEYS = re.compile(r"^notificationsPrayerAtTimeFajrBody$")
_CARD_FIELD = re.compile(
    r"^(title|subtitle|label|summary|shortSummary|simpleSummary|shortTeachingSummary|"
    r"themeSummary|storySummary|overview|description|shortDescription|tagline|"
    r"caption|blurb|keyThemes|theme)$"
)
_CARD_KEY = re.compile(r"(Summary|Overview|Description)$")


def _picture_book(v: "copy_prose.ProseValue") -> bool:
    return v.path.startswith(copy_prose.PICTURE_BOOKS)


def _arabic_in_english(text: str) -> bool:
    return bool(_ARABIC_SCRIPT.search(text.replace("ﷺ", "")))


# An Arabic honorific after a Latin name, even in a short value: a title,
# a name, a history entity ("Abu Bakr رضي الله عنه").
ARABIC_HONORIFIC = re.compile(
    r"(عليه|عليها|عليهم|عليهما) السلام|رضي الله (عنه|عنها|عنهما|عنهم)|(رحمه|رحمها|رحمهم) الله"
)


def _arabic_honorific_after_latin(text: str) -> bool:
    m = ARABIC_HONORIFIC.search(text)
    return bool(m) and bool(re.search(r"[A-Za-z]", text[: m.start()]))


@dataclass(frozen=True)
class ProseRule:
    id: str
    description: str
    fix: str
    match: Callable[["copy_prose.ProseValue"], bool]
    # ARB keys counted with the same rule (lesson prose the ARB carries).
    arb: Callable[[str, str], bool] | None = None


PROSE_RULES: list[ProseRule] = [
    ProseRule(
        "prose-apostrophe", "A straight apostrophe in prose outside the ARB.",
        "Use the curly ’ (Qur’an, Allah’s).",
        lambda v: bool(_APOSTROPHE_BETWEEN.search(v.value)),
    ),
    ProseRule(
        "prose-quran-spelling", "Quran without the apostrophe, outside the ARB.", "Qur’an, Qur’anic.",
        lambda v: RULE_BY_ID["quran-spelling"].match(v.field, v.value),
    ),
    ProseRule(
        "prose-term-spelling", "A spelling the glossary does not use, outside the ARB.",
        "See the glossary in docs/voice_and_copy_guide.md.",
        lambda v: RULE_BY_ID["term-spelling"].match(v.field, v.value),
    ),
    ProseRule(
        "prose-uk-spelling", "British spelling outside the ARB.", "US spelling throughout.",
        lambda v: RULE_BY_ID["uk-spelling"].match(v.field, v.value),
    ),
    ProseRule(
        "prose-term-casing", "An Islamic common noun capitalized mid-sentence, outside the ARB.",
        "salah, du’a, dhikr, hadith, sunnah, wudu… in lowercase mid-sentence.",
        lambda v: term_casing(v.field, v.value),
    ),
    ProseRule(
        "prose-honorific", "The Prophet or Muhammad without ﷺ, outside the ARB.",
        "ﷺ after every mention, possessives too. The picture books keep their own rule.",
        lambda v: not _picture_book(v) and bool(_HONORIFIC.search(v.value)),
    ),
    ProseRule(
        "prose-typo", "todays / a doubled word, outside the ARB.", "Fix the typo.",
        lambda v: RULE_BY_ID["typo"].match(v.field, v.value),
    ),
    ProseRule(
        "arabic-in-english", "Arabic script inside English (عليه السلام, رضي الله عنه, فساد).",
        "Prophets: (peace be upon him) at the first mention in a passage, then the name. "
        "Companions: (may Allah be pleased with him/her). Terms: transliterate and gloss, "
        "fasad (corruption). Titles and names: the name alone.",
        lambda v: not _picture_book(v) and (
            (v.is_prose and _arabic_in_english(v.value)) or _arabic_honorific_after_latin(v.value)),
        lambda k, v: (not k.endswith("Arabic") and not _ARABIC_IN_ENGLISH_KEYS.search(k)
                      and ((copy_prose.is_english(v) and _arabic_in_english(v))
                           or _arabic_honorific_after_latin(v))),
    ),
    ProseRule(
        "prose-studio-vocabulary", "Studio vocabulary in lesson prose: the ARB's prose keys and the Dart content (hub, module, the Prophets system, a practice surface).",
        "Say what the person sees: a lesson, a page, the reader. Science and history senses (root systems, legacy, migration) are not counted.",
        lambda v: bool(PROSE_STUDIO.search(v.value)),
        lambda k, v: is_content(k) and not is_sacred(k) and bool(PROSE_STUDIO.search(v)),
    ),
    ProseRule(
        "prose-roadmap", "Roadmap talk in lesson prose (will appear here, coming soon, for now).",
        "Say what is here.",
        lambda v: bool(PROSE_ROADMAP.search(v.value)),
        lambda k, v: is_content(k) and not is_sacred(k) and bool(PROSE_ROADMAP.search(v)),
    ),
    ProseRule(
        "prose-tail", "A filler tail in lesson prose (in one place, at your own pace, with clarity, with intention).",
        "Drop the tail. Where intention means niyyah or presence means khushu, say so.",
        lambda v: bool(PROSE_TAIL.search(v.value)),
        lambda k, v: is_content(k) and not is_sacred(k) and bool(PROSE_TAIL.search(v)),
    ),
    ProseRule(
        "prose-list-of-three", "A list of three in a card or summary (title, summary, overview, description).",
        "Name the purpose. Lesson bodies keep their lists (decision, 2026-09-27).",
        lambda v: bool(_CARD_FIELD.match(v.field)) and RULE_BY_ID["tone-list-of-three"].match(v.field, v.value),
        lambda k, v: (is_content(k) and not is_sacred(k) and bool(_CARD_KEY.search(k))
                      and RULE_BY_ID["tone-list-of-three"].match(k, v)),
    ),
]
PROSE_RULE_BY_ID = {r.id: r for r in PROSE_RULES}
# where → text, for --list
PROSE_TEXT: dict[str, str] = {}


def prose_findings(strings: dict[str, str]) -> dict[str, list[str]]:
    out: dict[str, list[str]] = {r.id: [] for r in PROSE_RULES}
    for r in PROSE_RULES:
        if r.arb:
            out[r.id].extend(k for k, v in strings.items() if r.arb(k, v))
    for v in copy_prose.prose_values():
        for r in PROSE_RULES:
            # Short values are names and labels, often matched in code; only
            # the Arabic check reads them, and the apostrophe check in the
            # picture books, where every line is text on a page.
            if not v.is_prose and r.id != "arabic-in-english" and not (
                r.id == "prose-apostrophe" and _picture_book(v)):
                continue
            if r.id not in v.allow and r.match(v):
                out[r.id].append(v.where)
                PROSE_TEXT[v.where] = v.value
    return out


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
    out["allah-in-arabic-script"] = arabic_name_in_arb(strings) + arabic_name_in_dart()
    out.update(prose_findings(strings))
    return out


def describe(rule_id: str) -> tuple[str, str]:
    if rule_id == "dead-keys":
        return ("An English key no Dart file references.",
                "Delete it from every ARB: python3 tools/prune_dead_l10n_keys.py")
    if rule_id == "kids-dialogue-unquoted":
        return ("A kids story line of speech without quotation marks.",
                "Mama said, “Bismillah.”")
    if rule_id == "allah-in-arabic-script":
        return ("The Name in Arabic script inside English (Glory be to الله), in the ARB or a Dart file.",
                "Write Allah. Arabic phrases (بسم الله, رضي الله عنه) and arabic: fields are not flagged.")
    if rule_id in PROSE_RULE_BY_ID:
        p = PROSE_RULE_BY_ID[rule_id]
        return (p.description, p.fix)
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
            text = strings.get(k, PROSE_TEXT.get(k))
            print(f"  {k}: {text[:160]}" if text is not None else f"  {k}")
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
