#!/usr/bin/env python3
"""English prose outside the ARB, for the copy lint (voice guide, V3).

Most of the English a person reads in a lesson is not in the ARB: ayah and
surah explanations, trivia, du'a notes, the prophets' pages, history. It
lives in Dart content files and one JSON asset. This module finds those
strings so tools/copy_lint.py can hold them to the guide's mechanics.

A "prose value" is one string (adjacent Dart literals joined) of at least
four English words, assigned to a field that is not sacred text or an id.
Shorter values (names, titles, entity labels) are yielded too, marked, for
the rules that must see them.
Sacred text (translation, transliteration, arabic…, du'a meaning, hadith
and ayah quotations, sources) is never touched.

A line may opt out of a rule with a trailing comment naming it:
    'What happens to ال at the start.', // copy-lint: allow arabic-in-english
"""
from __future__ import annotations

import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Iterator

ROOT = Path(__file__).resolve().parent.parent

JSON_FILES = ("assets/data/historical_calendar_seed.json",)

# Not prose: generated l10n, the Apple TV target (V4 has its own string
# tables), two sourced datasets, and files that carry other languages.
SKIP = re.compile(
    r"^lib/(l10n|features/tvos)/|generated_hadith_foundation_data\.dart$|"
    r"quran_transliteration_local_data\.dart$|_localized_"
)
# The picture books follow docs/kids_picture_books_authoring_rules.md for
# honorifics ("once in full, then the mark").
PICTURE_BOOKS = "lib/features/kids/bedtime_stories/data/books/"

SACRED_FIELD = re.compile(
    r"^(translation\w*|transliteration\w*|translit|\w*[aA]rabic\w*|arabicName|"
    r"meaning|meanings|englishText|hadithText|excerpt|narrator|sourceChapterTitle|"
    r"hadithQuote|quranQuote|matn|ayahText|verseText|source|sources|sourceRef|"
    r"sourceNote|sourceNotes|sourceCollection|reference|collection|"
    r"id|slug|key|route\w*|path|asset\w*|image\w*|icon\w*|illustration\w*|"
    r"visualPrompt|visualHint|tags|categories|"
    r"de|ar|ur|fr|fa|fa_AF|hi|bn|tr|ms|ha|ku|pa|ps|tg)$"
)

_EN = set("the a an and of to in is are you your he she it they we his her their "
          "was were with for on that this be as from by at not".split())
_DE = set("der die das und ist nicht mit ein eine einen einem einer den dem des sich "
          "sie er wir ihr zu zum zur von vom auf für im bei nach aus wie als aber auch "
          "noch dass hat hatte sagte ihm ihn ihre sein seine seinen wurde wird sind "
          "waren kam ging sehr".split())
_WORD = re.compile(r"[A-Za-zÀ-ÿ’']+")
_ALLOW = re.compile(r"//\s*copy-lint:\s*allow\s+([\w\-, ]+)")
_INTERPOLATION = re.compile(r"\$\{[^}]*\}|\$[A-Za-z_]\w*")


def is_english(value: str) -> bool:
    words = [w.lower() for w in _WORD.findall(value)]
    if len(words) < 4 or " " not in value:
        return False
    en = sum(w in _EN for w in words)
    de = sum(w in _DE for w in words)
    return (en > de or (en == de == 0)) and not re.search(r"[äöüß]", value)


@dataclass(frozen=True)
class ProseValue:
    path: str            # repo-relative
    line: int
    field: str
    value: str           # decoded, interpolations shown as {x}
    allow: frozenset[str]
    literals: tuple[tuple[int, int, str], ...]  # (start, end, quote kind) in the file
    is_prose: bool = True  # four English words or more; short values are names and labels

    @property
    def where(self) -> str:
        return f"{self.path}:{self.line}"


# ----------------------------------------------------------------- Dart

_ESC = {"n": "\n", "t": "\t", "r": "\r", "'": "'", '"': '"', "\\": "\\", "$": "$"}


def _decode(body: str, raw: bool) -> str:
    if raw:
        return body
    out, i = [], 0
    while i < len(body):
        c = body[i]
        if c == "\\" and i + 1 < len(body):
            n = body[i + 1]
            if n == "u" and body[i + 2:i + 3] == "{":
                j = body.index("}", i)
                out.append(chr(int(body[i + 3:j], 16)))
                i = j + 1
                continue
            if n == "u":
                out.append(chr(int(body[i + 2:i + 6], 16)))
                i += 6
                continue
            out.append(_ESC.get(n, n))
            i += 2
            continue
        out.append(c)
        i += 1
    return "".join(out)


def dart_tokens(src: str) -> Iterator[tuple]:
    """('code', start, end, text) and ('str', start, end, decoded, quote,
    raw, body_start, body_end), comments skipped."""
    i, n, code_start = 0, len(src), 0
    while i < n:
        c = src[i]
        if c == "/" and src.startswith("//", i):
            j = src.find("\n", i)
            i = n if j < 0 else j
            continue
        if c == "/" and src.startswith("/*", i):
            j = src.find("*/", i)
            i = n if j < 0 else j + 2
            continue
        raw, k = False, i
        if c == "r" and i + 1 < n and src[i + 1] in "'\"" and (
            i == 0 or not (src[i - 1].isalnum() or src[i - 1] in "_$")
        ):
            raw, k = True, i + 1
        if src[k] in "'\"":
            q = src[k] * 3 if src.startswith(src[k] * 3, k) else src[k]
            j = k + len(q)
            while j < n and not src.startswith(q, j):
                if src[j] == "\\" and not raw:
                    j += 2
                    continue
                if len(q) == 1 and src[j] == "\n":
                    break
                j += 1
            if code_start < i:
                yield ("code", code_start, i, src[code_start:i])
            body_start, body_end = k + len(q), j
            yield ("str", i, j + len(q), _decode(src[body_start:body_end], raw),
                   q, raw, body_start, body_end)
            i = j + len(q)
            code_start = i
            continue
        i += 1
    if code_start < n:
        yield ("code", code_start, n, src[code_start:])


_FIELD = re.compile(
    r"(?:([A-Za-z_]\w*)|'([^']+)'|\"([^\"]+)\")\s*:\s*(?:const\s+)?(?:<[^>]*>\s*)?[\[{]?\s*$"
)
_CALL = re.compile(r"([A-Za-z_]\w*)\s*\(\s*(?:const\s+)?$")
_ASSIGN = re.compile(r"([A-Za-z_]\w*)\s*(?:=>|=)\s*$")


def dart_values(path: Path) -> Iterator[ProseValue]:
    rel = path.relative_to(ROOT).as_posix()
    src = path.read_text(encoding="utf-8")
    lines = src.split("\n")
    toks = list(dart_tokens(src))
    field = "?"
    i = 0
    while i < len(toks):
        t = toks[i]
        if t[0] == "code":
            tail = t[3].rstrip()
            m = _FIELD.search(tail[-160:]) if tail else None
            if m:
                field = m.group(1) or m.group(2) or m.group(3)
            elif not tail.endswith(","):
                m2 = _CALL.search(tail[-120:]) or _ASSIGN.search(tail[-120:])
                field = m2.group(1) if m2 else "?"
            i += 1
            continue
        parts, spans = [t[3]], [(t[6], t[7], t[4][0], t[5])]
        j = i + 1
        while (j + 1 < len(toks) and toks[j][0] == "code" and toks[j][3].strip() == ""
               and toks[j + 1][0] == "str"):
            nt = toks[j + 1]
            parts.append(nt[3])
            spans.append((nt[6], nt[7], nt[4][0], nt[5]))
            j += 2
        i = j
        value = _INTERPOLATION.sub("{x}", "".join(parts))
        if SACRED_FIELD.match(field) or not re.search(r"[A-Za-z]", value):
            continue
        first = src.count("\n", 0, t[1])
        last = src.count("\n", 0, spans[-1][1])
        allow: set[str] = set()
        for ln in {first, last}:
            m = _ALLOW.search(lines[ln])
            if m:
                allow.update(r.strip() for r in m.group(1).split(","))
        yield ProseValue(rel, first + 1, field, value, frozenset(allow),
                         tuple((a, b, "raw" if raw else q) for a, b, q, raw in spans),
                         is_english(value))


# ----------------------------------------------------------------- JSON

_JSON_STRING = re.compile(r'"((?:[^"\\]|\\.)*)"(\s*:)?')


def json_values(path: Path) -> Iterator[ProseValue]:
    rel = path.relative_to(ROOT).as_posix()
    src = path.read_text(encoding="utf-8")
    field = "?"
    for m in _JSON_STRING.finditer(src):
        if m.group(2):
            field = json.loads(f'"{m.group(1)}"')
            continue
        value = json.loads(f'"{m.group(1)}"')
        if SACRED_FIELD.match(field) or not re.search(r"[A-Za-z]", value):
            continue
        yield ProseValue(rel, src.count("\n", 0, m.start()) + 1, field, value,
                         frozenset(), ((m.start(1), m.end(1), "json"),), is_english(value))


# ----------------------------------------------------------------- all

def prose_files() -> list[Path]:
    files = [p for p in sorted((ROOT / "lib").rglob("*.dart"))
             if not SKIP.search(p.relative_to(ROOT).as_posix())]
    return files + [ROOT / f for f in JSON_FILES if (ROOT / f).exists()]


def prose_values(files: list[Path] | None = None) -> Iterator[ProseValue]:
    """Every non-sacred value with a Latin letter; [ProseValue.is_prose]
    marks the English prose among them."""
    for path in files if files is not None else prose_files():
        if path.suffix == ".json":
            yield from json_values(path)
        else:
            yield from dart_values(path)
