from __future__ import annotations

import json
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
HADITH_SEED_PATH = ROOT / "lib/features/learn/hadith/data/seeded_hadith_foundation_data.dart"
HADITH_CURRICULUM_PATH = ROOT / "lib/features/learn/hadith/data/hadith_curriculum_data.dart"
HADITH_TRIVIA_PATH = ROOT / "lib/features/learn/trivia/data/packs/hadith_questions.dart"
LEARNING_JOURNEY_PATH = ROOT / "lib/features/learn/journey/data/learning_journey_lesson_content.dart"
LEARNING_JOURNEY_LOCALIZED_PATH = (
    ROOT / "lib/features/learn/journey/data/learning_journey_localized_lesson_content.dart"
)
OUTPUT_PATH = ROOT / "data/hadith/hadith_master_dataset.json"

_STRING_RE = r"(?:'''[\s\S]*?'''|'(?:\\.|[^'\\])*')"
_SCALAR_RE = rf"(?:{_STRING_RE}|[A-Za-z_][A-Za-z0-9_]*|true|false|null)"
_HADITH_BOOK_PATTERN = re.compile(
    r"(Sahih|Bukhari|Muslim|Tirmidhi|Abi Dawud|Abu Dawud|Nasai|Nasa'i|Ibn Majah|Muwatta|Musnad)",
    re.IGNORECASE,
)


@dataclass
class ParsedHadithEntry:
    raw_id: str
    arabic_text: str
    english_text: str
    source_book: str
    reference_number: str
    grade: str | None
    location_in_code: str
    source_url: str | None
    title: str
    excerpt: str
    theme_id: str
    practice_action: str
    meaning: str
    translation_source_verified: bool
    arabic_source_verified: bool
    transliteration_source_verified: bool


def _read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def _parse_const_strings(source: str) -> dict[str, str]:
    return dict(re.findall(r"const\s+(\w+)\s*=\s*'([^']+)';", source))


def _find_hadith_blocks(source: str) -> list[tuple[int, str]]:
    blocks: list[tuple[int, str]] = []
    needle = "HadithEntry("
    index = 0
    while True:
        start = source.find(needle, index)
        if start == -1:
            return blocks
        depth = 0
        cursor = start + len(needle)
        in_string = False
        quote = ""
        triple = False
        escaped = False
        while cursor < len(source):
            char = source[cursor]
            if in_string:
                if triple:
                    if source.startswith(quote * 3, cursor):
                        in_string = False
                        cursor += 3
                        continue
                    cursor += 1
                    continue
                if escaped:
                    escaped = False
                    cursor += 1
                    continue
                if char == "\\":
                    escaped = True
                    cursor += 1
                    continue
                if char == quote:
                    in_string = False
                    cursor += 1
                    continue
                cursor += 1
                continue

            if source.startswith("'''", cursor) or source.startswith('"""', cursor):
                quote = source[cursor]
                triple = True
                in_string = True
                cursor += 3
                continue
            if char in {"'", '"'}:
                quote = char
                triple = False
                in_string = True
                cursor += 1
                continue
            if char == "(":
                depth += 1
            elif char == ")":
                if depth == 0:
                    cursor += 1
                    break
                depth -= 1
            cursor += 1
        line = source.count("\n", 0, start) + 1
        blocks.append((line, source[start:cursor]))
        index = cursor


def _extract_scalar(block: str, field: str, consts: dict[str, str]) -> Any:
    match = re.search(rf"\b{re.escape(field)}:\s*(?P<value>{_SCALAR_RE})", block)
    if not match:
        return None
    value = match.group("value").strip()
    if value.startswith("'''"):
        return value[3:-3]
    if value.startswith("'"):
        inner = value[1:-1]
        return inner.replace("\\'", "'").replace("\\\\", "\\")
    if value == "true":
        return True
    if value == "false":
        return False
    if value == "null":
        return None
    return consts.get(value, value)


def _normalize_text(value: str) -> str:
    return re.sub(r"\s+", " ", value).strip().lower()


def _classify_theme(entry: ParsedHadithEntry) -> str:
    haystack = _normalize_text(
        " ".join(
            [
                entry.title,
                entry.excerpt,
                entry.english_text,
                entry.practice_action,
                entry.meaning,
            ]
        )
    )
    if entry.theme_id == "faith_intention":
        if any(token in haystack for token in ["intention", "intentions", "niyyah"]):
            return "intention"
        if any(token in haystack for token in ["sincerity", "sincere", "nasihah"]):
            return "sincerity"
        if any(token in haystack for token in ["lawful", "unlawful", "heart", "account"]):
            return "accountability"
        if any(token in haystack for token in ["brother", "believer", "community"]):
            return "community"
        if any(token in haystack for token in ["truth", "honest", "promise", "trust"]):
            return "truthfulness"
        return "intention"

    if entry.theme_id == "prayer":
        return "prayer"

    if entry.theme_id == "character_manners":
        if any(token in haystack for token in ["anger", "angry"]):
            return "anger_control"
        if any(token in haystack for token in ["forgive", "forgiveness", "pardon"]):
            return "forgiveness"
        if any(token in haystack for token in ["truth", "honest", "promise", "trust"]):
            return "truthfulness"
        if any(token in haystack for token in ["kind", "gentle", "smile", "softness"]):
            return "kindness"
        return "manners"

    if entry.theme_id == "mercy_compassion":
        if any(token in haystack for token in ["charity", "generosity", "poor", "orphan", "road"]):
            return "charity"
        if any(token in haystack for token in ["neighbor", "brother", "community", "hospitality"]):
            return "community"
        if any(token in haystack for token in ["forgive", "forgiveness", "pardon"]):
            return "forgiveness"
        if any(token in haystack for token in ["kind", "gentle", "smile"]):
            return "kindness"
        return "mercy"

    if entry.theme_id == "knowledge":
        return "knowledge"

    if entry.theme_id == "dua_remembrance":
        if any(token in haystack for token in ["daily", "small deed", "consistent", "habit", "morning", "evening"]):
            return "daily_habits"
        if any(token in haystack for token in ["prayer", "salah", "sujud", "prostration"]):
            return "prayer"
        return "heart_spirituality"

    if entry.theme_id == "family":
        if any(token in haystack for token in ["parent", "mother", "father"]):
            return "parents"
        if any(token in haystack for token in ["brother", "neighbor", "community"]):
            return "community"
        return "family"

    if entry.theme_id == "justice_trust":
        if any(token in haystack for token in ["charity", "generosity", "poor", "orphan", "road"]):
            return "charity"
        if any(token in haystack for token in ["brother", "neighbor", "community"]):
            return "community"
        if any(token in haystack for token in ["lawful", "unlawful", "account", "death", "grave", "hereafter"]):
            return "accountability"
        return "truthfulness"

    if entry.theme_id == "repentance":
        if any(token in haystack for token in ["forgive", "forgiveness", "pardon", "repent"]):
            return "forgiveness"
        if any(token in haystack for token in ["heart", "dua", "remembrance"]):
            return "heart_spirituality"
        return "accountability"

    if entry.theme_id == "patience_gratitude":
        if any(token in haystack for token in ["anger", "angry"]):
            return "anger_control"
        if any(token in haystack for token in ["gratitude", "grateful", "thankful", "shukr"]):
            return "gratitude"
        return "patience"

    if entry.theme_id == "death_hereafter":
        if any(token in haystack for token in ["heart", "dua", "remembrance"]):
            return "heart_spirituality"
        return "accountability"

    if any(token in haystack for token in ["parents", "mother", "father"]):
        return "parents"
    if any(token in haystack for token in ["family", "kinship", "spouse", "home"]):
        return "family"
    if any(token in haystack for token in ["kind", "gentle", "smile", "softness"]):
        return "kindness"
    if any(token in haystack for token in ["mercy", "merciful", "compassion"]):
        return "mercy"
    if any(token in haystack for token in ["truth", "honest", "promise", "trust"]):
        return "truthfulness"
    if any(token in haystack for token in ["patience", "patient", "trial", "hardship", "sabr"]):
        return "patience"
    if any(token in haystack for token in ["gratitude", "grateful", "thankful", "shukr"]):
        return "gratitude"
    if any(token in haystack for token in ["prayer", "salah", "prostration", "sujud", "wudu"]):
        return "prayer"
    if any(token in haystack for token in ["brother", "neighbor", "community", "hospitality"]):
        return "community"
    if any(token in haystack for token in ["speech", "silent", "tongue", "manners", "adab"]):
        return "manners"
    if any(token in haystack for token in ["knowledge", "learn", "scholar"]):
        return "knowledge"
    if any(token in haystack for token in ["charity", "generosity", "poor", "orphan", "road"]):
        return "charity"
    if any(token in haystack for token in ["sincerity", "sincere", "nasihah"]):
        return "sincerity"
    if any(token in haystack for token in ["anger", "angry"]):
        return "anger_control"
    if any(token in haystack for token in ["forgive", "forgiveness", "pardon"]):
        return "forgiveness"
    if any(token in haystack for token in ["daily", "small deed", "consistent", "habit", "dhikr", "morning", "evening"]):
        return "daily_habits"
    if any(token in haystack for token in ["heart", "reliance", "dua", "remembrance"]):
        return "heart_spirituality"
    if any(token in haystack for token in ["lawful", "unlawful", "account", "death", "grave", "hereafter", "time"]):
        return "accountability"
    if any(token in haystack for token in ["intention", "intentions", "niyyah"]):
        return "intention"
    return "general"


def _kid_friendly_score(entry: ParsedHadithEntry, theme: str) -> int:
    base_by_theme = {
        "kindness": 5,
        "parents": 5,
        "family": 5,
        "charity": 5,
        "daily_habits": 5,
        "prayer": 4,
        "forgiveness": 4,
        "mercy": 4,
        "truthfulness": 4,
        "community": 4,
        "manners": 4,
        "gratitude": 4,
        "anger_control": 4,
        "patience": 3,
        "knowledge": 3,
        "intention": 3,
        "sincerity": 3,
        "heart_spirituality": 3,
        "accountability": 2,
        "general": 2,
    }
    score = base_by_theme.get(theme, 2)
    haystack = _normalize_text(" ".join([entry.title, entry.excerpt, entry.english_text]))
    if any(token in haystack for token in ["smile", "neighbor", "parents", "kind", "charity", "gentle", "speak good"]):
        score += 1
    if any(token in haystack for token in ["lawful", "unlawful", "hereafter", "death", "world is a prison"]):
        score -= 1
    return max(1, min(5, score))


def _actionability(entry: ParsedHadithEntry, theme: str, kid_score: int) -> str:
    advanced_markers = ["lawful", "unlawful", "hereafter", "grave", "world is a prison"]
    haystack = _normalize_text(" ".join([entry.title, entry.excerpt, entry.english_text]))
    if kid_score <= 1 or any(marker in haystack for marker in advanced_markers):
        return "advanced"
    if theme in {"intention", "sincerity", "patience", "knowledge", "heart_spirituality", "accountability", "general"}:
        return "reflective"
    return "direct_action"


def _entry_quality(entry: ParsedHadithEntry) -> tuple[int, int, int]:
    filled = sum(
        bool(value and str(value).strip())
        for value in [entry.arabic_text, entry.english_text, entry.source_book, entry.reference_number, entry.grade]
    )
    verified = int(entry.translation_source_verified) + int(entry.arabic_source_verified)
    english_length = len(entry.english_text)
    return (filled, verified, english_length)


def _parse_seed_entries() -> list[ParsedHadithEntry]:
    source = _read(HADITH_SEED_PATH)
    consts = _parse_const_strings(source)
    entries: list[ParsedHadithEntry] = []
    for line, block in _find_hadith_blocks(source):
        english_text = _extract_scalar(block, "englishText", consts) or _extract_scalar(block, "hadithText", consts) or ""
        arabic_text = _extract_scalar(block, "arabicText", consts) or ""
        entry = ParsedHadithEntry(
            raw_id=_extract_scalar(block, "id", consts) or "",
            arabic_text=arabic_text,
            english_text=english_text,
            source_book=_extract_scalar(block, "sourceCollection", consts) or _extract_scalar(block, "source", consts) or "",
            reference_number=_extract_scalar(block, "sourceReference", consts) or "",
            grade=_extract_scalar(block, "grading", consts),
            location_in_code=f"{HADITH_SEED_PATH.relative_to(ROOT)}:{line}",
            source_url=_extract_scalar(block, "sourceUrl", consts),
            title=_extract_scalar(block, "title", consts) or "",
            excerpt=_extract_scalar(block, "excerpt", consts) or "",
            theme_id=_extract_scalar(block, "themeId", consts) or "",
            practice_action=_extract_scalar(block, "practiceAction", consts) or "",
            meaning=_extract_scalar(block, "meaning", consts) or "",
            translation_source_verified=bool(_extract_scalar(block, "translationSourceVerified", consts)),
            arabic_source_verified=bool(_extract_scalar(block, "arabicMatnSourceVerified", consts)),
            transliteration_source_verified=bool(_extract_scalar(block, "transliterationSourceVerified", consts)),
        )
        entries.append(entry)
    return entries


def _dedupe_entries(entries: list[ParsedHadithEntry]) -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    grouped: dict[str, list[ParsedHadithEntry]] = {}
    for entry in entries:
        key = _normalize_text(entry.english_text or entry.arabic_text)
        grouped.setdefault(key, []).append(entry)

    cleaned: list[dict[str, Any]] = []
    duplicate_groups: list[dict[str, Any]] = []
    for group in grouped.values():
        canonical = sorted(group, key=_entry_quality, reverse=True)[0]
        merged_ids = [item.raw_id for item in group]
        issues = []
        if not canonical.arabic_text.strip():
            issues.append("missing_arabic")
        if not canonical.english_text.strip():
            issues.append("missing_translation")
        if not canonical.source_book.strip():
            issues.append("missing_source")
        if not canonical.reference_number.strip():
            issues.append("missing_reference")
        theme = _classify_theme(canonical)
        kid_score = _kid_friendly_score(canonical, theme)
        actionability = _actionability(canonical, theme, kid_score)
        cleaned.append(
            {
                "id": canonical.raw_id,
                "hadith_reference": f"{canonical.source_book} {canonical.reference_number}".strip(),
                "arabic_text": canonical.arabic_text,
                "english_text": canonical.english_text,
                "source_book": canonical.source_book,
                "reference_number": canonical.reference_number,
                "grade": canonical.grade,
                "location_in_code": canonical.location_in_code,
                "theme": theme,
                "kid_friendly_score": kid_score,
                "actionability": actionability,
                "story_candidate": kid_score >= 3,
                "structure_status": "verified_structure" if not issues else "incomplete_structure",
                "structure_issues": issues,
                "source_url": canonical.source_url,
                "translation_source_verified": canonical.translation_source_verified,
                "arabic_matn_source_verified": canonical.arabic_source_verified,
                "transliteration_source_verified": canonical.transliteration_source_verified,
                "duplicate_ids_merged": merged_ids[1:],
                "raw_entry_ids": merged_ids,
                "title": canonical.title,
                "excerpt": canonical.excerpt,
                "legacy_theme_id": canonical.theme_id,
            }
        )
        if len(group) > 1:
            duplicate_groups.append(
                {
                    "canonical_id": canonical.raw_id,
                    "merged_ids": [item.raw_id for item in group if item.raw_id != canonical.raw_id],
                    "shared_reference": f"{canonical.source_book} {canonical.reference_number}".strip(),
                    "locations": [item.location_in_code for item in group],
                }
            )
    cleaned.sort(key=lambda item: item["id"])
    duplicate_groups.sort(key=lambda item: item["canonical_id"])
    return cleaned, duplicate_groups


def _theme_distribution(entries: list[dict[str, Any]]) -> dict[str, int]:
    counts: dict[str, int] = {
        "intention": 0,
        "kindness": 0,
        "mercy": 0,
        "truthfulness": 0,
        "patience": 0,
        "gratitude": 0,
        "prayer": 0,
        "parents": 0,
        "family": 0,
        "community": 0,
        "manners": 0,
        "knowledge": 0,
        "charity": 0,
        "sincerity": 0,
        "anger_control": 0,
        "forgiveness": 0,
        "daily_habits": 0,
        "heart_spirituality": 0,
        "accountability": 0,
        "general": 0,
    }
    for entry in entries:
        counts[entry["theme"]] = counts.get(entry["theme"], 0) + 1
    return dict(sorted(counts.items(), key=lambda item: item[0]))


def _gap_analysis(theme_distribution: dict[str, int]) -> dict[str, Any]:
    weak_themes = sorted([theme for theme, count in theme_distribution.items() if count < 5])
    critical = {
        "kindness": theme_distribution.get("kindness", 0),
        "daily_habits": theme_distribution.get("daily_habits", 0),
        "emotional_control": theme_distribution.get("anger_control", 0),
        "small_good_deeds": theme_distribution.get("daily_habits", 0),
    }
    missing_or_weak = weak_themes[:]
    for label, count in critical.items():
        if count < 5 and label not in missing_or_weak:
            missing_or_weak.append(label)
    recommendations = []
    if critical["kindness"] < 5:
        recommendations.append("Add more concise kindness hadith with simple social-action hooks.")
    if critical["daily_habits"] < 5:
        recommendations.append("Expand daily-habits hadith covering small repeated deeds and daily routines.")
    if critical["emotional_control"] < 5:
        recommendations.append("Add more hadith focused on anger control, restraint, and emotional steadiness.")
    if critical["small_good_deeds"] < 5:
        recommendations.append("Prioritize short hadith about small good deeds for the future story-action pipeline.")
    return {
        "theme_distribution": theme_distribution,
        "missing_or_weak_themes": sorted(dict.fromkeys(missing_or_weak)),
        "recommendations": recommendations,
    }


def _inventory_secondary_sources() -> list[dict[str, Any]]:
    curriculum = _read(HADITH_CURRICULUM_PATH)
    trivia = _read(HADITH_TRIVIA_PATH)
    journey = _read(LEARNING_JOURNEY_PATH)
    journey_localized = _read(LEARNING_JOURNEY_LOCALIZED_PATH)

    def count_hadith_refs(source: str) -> int:
        count = 0
        for match in re.finditer(r"sourceReference[s]?:\s*(?P<value>[^,\n]+)", source):
            if _HADITH_BOOK_PATTERN.search(match.group("value")):
                count += 1
        return count

    return [
        {
            "type": "canonical_full_dataset",
            "path": str(HADITH_SEED_PATH.relative_to(ROOT)),
            "contains_full_hadith_text": True,
            "raw_entries": len(_find_hadith_blocks(_read(HADITH_SEED_PATH))),
        },
        {
            "type": "thematic_curriculum_metadata",
            "path": str(HADITH_CURRICULUM_PATH.relative_to(ROOT)),
            "contains_full_hadith_text": False,
            "theme_count": curriculum.count("HadithTheme("),
            "subcategory_count": curriculum.count("HadithSubcategory("),
            "lesson_count": curriculum.count("HadithLesson("),
        },
        {
            "type": "learning_journey_hadith_references",
            "path": str(LEARNING_JOURNEY_PATH.relative_to(ROOT)),
            "contains_full_hadith_text": False,
            "hadith_reference_mentions": count_hadith_refs(journey),
        },
        {
            "type": "learning_journey_localized_hadith_references",
            "path": str(LEARNING_JOURNEY_LOCALIZED_PATH.relative_to(ROOT)),
            "contains_full_hadith_text": False,
            "hadith_reference_mentions": count_hadith_refs(journey_localized),
        },
        {
            "type": "trivia_reference_pack",
            "path": str(HADITH_TRIVIA_PATH.relative_to(ROOT)),
            "contains_full_hadith_text": False,
            "question_count": trivia.count("Question("),
            "source_reference_count": trivia.count("sourceReference:"),
        },
    ]


def build_dataset() -> dict[str, Any]:
    parsed = _parse_seed_entries()
    cleaned_entries, duplicate_groups = _dedupe_entries(parsed)
    theme_distribution = _theme_distribution(cleaned_entries)
    gap_analysis = _gap_analysis(theme_distribution)
    incomplete_entries = sum(1 for entry in cleaned_entries if entry["structure_status"] == "incomplete_structure")
    story_candidates = sum(1 for entry in cleaned_entries if entry["story_candidate"])
    return {
        "metadata": {
            "generated_at": "2026-03-19",
            "source_policy": "Structure-only audit. No external validation performed in this pass.",
            "raw_hadith_count": len(parsed),
            "deduped_hadith_count": len(cleaned_entries),
            "duplicates_removed": len(parsed) - len(cleaned_entries),
            "incomplete_entries_count": incomplete_entries,
            "story_candidate_count": story_candidates,
            "secondary_source_inventory": _inventory_secondary_sources(),
        },
        "duplicate_groups": duplicate_groups,
        "entries": cleaned_entries,
        "gap_analysis": gap_analysis,
    }


def main() -> None:
    dataset = build_dataset()
    OUTPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT_PATH.write_text(json.dumps(dataset, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
    print(
        json.dumps(
            {
                "output": str(OUTPUT_PATH.relative_to(ROOT)),
                "raw_hadith_count": dataset["metadata"]["raw_hadith_count"],
                "deduped_hadith_count": dataset["metadata"]["deduped_hadith_count"],
                "duplicates_removed": dataset["metadata"]["duplicates_removed"],
                "incomplete_entries_count": dataset["metadata"]["incomplete_entries_count"],
                "story_candidate_count": dataset["metadata"]["story_candidate_count"],
                "theme_distribution": dataset["gap_analysis"]["theme_distribution"],
                "missing_or_weak_themes": dataset["gap_analysis"]["missing_or_weak_themes"],
            },
            ensure_ascii=False,
            indent=2,
        )
    )


if __name__ == "__main__":
    main()
