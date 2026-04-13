from __future__ import annotations

import argparse
import json
import re
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parents[1]
SEED_PATH = ROOT / "lib/features/learn/hadith/data/seeded_hadith_foundation_data.dart"
RAW_INPUT_PATH = ROOT / "data/hadith/raw/hadith_source_records.json"
EDITORIAL_INPUT_PATH = ROOT / "data/hadith/editorial/hadith_editorial_enrichment.json"
TRANSLITERATION_INPUT_PATH = ROOT / "data/hadith/raw/hadith_transliteration_records.json"
OUTPUT_JSON_PATH = ROOT / "data/hadith/hadith_master_dataset.json"
TRANSLITERATION_REPORT_PATH = ROOT / "data/hadith/hadith_transliteration_ingestion_report.json"
TRANSLITERATION_REVIEW_QUEUE_PATH = ROOT / "data/hadith/hadith_transliteration_review_queue.json"
TRANSLITERATION_REVIEW_QUEUE_CSV_PATH = ROOT / "data/hadith/hadith_transliteration_review_queue.csv"
OUTPUT_DART_PATH = (
    ROOT / "lib/features/learn/hadith/data/generated_hadith_foundation_data.dart"
)

IMPORT_SOURCE = "hadith_master_dataset"

_STRING_RE = r"(?:'''[\s\S]*?'''|'(?:\\.|[^'\\])*')"
_SCALAR_RE = rf"(?:{_STRING_RE}|[A-Za-z_][A-Za-z0-9_]*|true|false|null|\d+)"

_THEME_TO_TAXONOMY: dict[str, tuple[str, str, str, str]] = {
    "faith_intention": ("faith", "Faith", "intention_sincerity", "Intention & Sincerity"),
    "prayer": ("worship", "Worship", "prayer_presence", "Prayer & Presence"),
    "dua_remembrance": (
        "worship",
        "Worship",
        "dua_remembrance",
        "Du'a & Remembrance",
    ),
    "character_manners": (
        "character",
        "Character",
        "character_manners",
        "Character & Manners",
    ),
    "repentance": (
        "character",
        "Character",
        "repentance_return",
        "Repentance & Return",
    ),
    "patience_gratitude": (
        "character",
        "Character",
        "patience_gratitude",
        "Patience & Gratitude",
    ),
    "family": ("family", "Family", "family_home", "Family & Home"),
    "knowledge": (
        "knowledge",
        "Knowledge",
        "knowledge_learning",
        "Knowledge & Learning",
    ),
    "mercy_compassion": (
        "social_ethics",
        "Social Ethics",
        "mercy_compassion",
        "Mercy & Compassion",
    ),
    "justice_trust": (
        "social_ethics",
        "Social Ethics",
        "justice_trust",
        "Justice & Trust",
    ),
    "death_hereafter": (
        "hereafter",
        "Hereafter",
        "death_hereafter",
        "Death & Hereafter",
    ),
}


@dataclass(frozen=True)
class RawVerification:
    is_verified_source: bool
    is_verified_text: bool
    is_verified_translation: bool
    is_verified_transliteration: bool


@dataclass(frozen=True)
class RawHadithRecord:
    source_record_id: str
    source_collection: str
    source_reference: str
    source_url: str
    hadith_numbers: list[str]
    arabic_text: str
    translation_text: str
    transliteration: str | None
    grading: str
    narrator: str | None
    chapter_number: int | None
    chapter_title: str | None
    verification: RawVerification


@dataclass(frozen=True)
class TransliterationImportRecord:
    source_reference_key: str
    source_collection: str
    source_reference: str
    transliteration_text: str
    transliteration_source: str
    quality_status: str
    review_status: str | None
    reviewed_at: str | None


@dataclass(frozen=True)
class EditorialQuranConnection:
    surah_name: str
    surah_number: int
    verse_range: str
    label: str


@dataclass(frozen=True)
class EditorialHadithRecord:
    source_record_id: str
    preferred_entry_id: str
    theme_id: str
    collection_ids: list[str]
    title: str
    excerpt: str
    tags: list[str]
    quran_connections: list[EditorialQuranConnection]
    meaning: str
    lessons: list[str]
    reflection_prompts: list[str]
    practice_action: str
    related_hadith_ids: list[str]
    is_daily_eligible: bool
    difficulty_level: str
    theme_tag: str | None
    recommended_day: str | None
    is_essential: bool
    category_id: str | None
    category_title: str | None
    subcategory_id: str | None
    subcategory_title: str | None


@dataclass(frozen=True)
class CanonicalHadithRecord:
    payload: dict[str, Any]
    is_verified_source: bool
    is_verified_text: bool
    is_verified_translation: bool


@dataclass(frozen=True)
class ReleaseDecision:
    source_record_id: str
    included: bool
    reasons: list[str]


@dataclass(frozen=True)
class TransliterationIngestionReport:
    matched_entries: int
    matched_reference_groups: int
    derivative_entries_reused: int
    runtime_reference_groups: int
    import_reference_groups: int
    unmatched_runtime_references: list[str]
    unmatched_import_records: list[str]
    duplicate_reference_groups: dict[str, list[str]]
    duplicate_import_records: dict[str, list[str]]
    conflicting_import_records: dict[str, list[dict[str, str]]]
    review_required_records: list[str]
    rejected_records: list[str]
    manual_review_records: list[str]
    review_queue: list[dict[str, Any]]


def _read(path: Path) -> str:
    return path.read_text(encoding="utf-8")


def _parse_const_strings(source: str) -> dict[str, str]:
    return dict(re.findall(r"const\s+(\w+)\s*=\s*'([^']+)';", source))


def _find_constructor_blocks(source: str, constructor_name: str) -> list[str]:
    blocks: list[str] = []
    needle = f"{constructor_name}("
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
        blocks.append(source[start:cursor])
        index = cursor


def _find_hadith_blocks(source: str) -> list[str]:
    return _find_constructor_blocks(source, "HadithEntry")


def _extract_scalar(block: str, field: str, consts: dict[str, str]) -> Any:
    match = re.search(rf"\b{re.escape(field)}:\s*(?P<value>{_SCALAR_RE})", block)
    if not match:
        return None
    value = match.group("value").strip()
    if value.startswith("'''"):
        return value[3:-3]
    if value.startswith("'"):
        return value[1:-1].replace("\\'", "'").replace("\\\\", "\\")
    if value == "true":
        return True
    if value == "false":
        return False
    if value == "null":
        return None
    if value.isdigit():
        return int(value)
    return consts.get(value, value)


def _extract_list_strings(block: str, field: str, consts: dict[str, str]) -> list[str]:
    body = _extract_list_body(block, field)
    if body is None:
        return []
    items = []
    for match in re.finditer(rf"{_STRING_RE}|[A-Za-z_][A-Za-z0-9_]*", body):
        token = match.group(0).strip()
        if token.startswith("'''"):
            items.append(token[3:-3])
        elif token.startswith("'"):
            items.append(token[1:-1].replace("\\'", "'").replace("\\\\", "\\"))
        else:
            items.append(consts.get(token, token))
    return [item for item in items if normalize_spacing(item)]


def _extract_list_body(block: str, field: str) -> str | None:
    match = re.search(rf"\b{re.escape(field)}:\s*\[", block)
    if not match:
        return None
    cursor = match.end()
    start = cursor
    depth = 1
    in_string = False
    quote = ""
    triple = False
    escaped = False
    while cursor < len(block):
        char = block[cursor]
        if in_string:
            if triple:
                if block.startswith(quote * 3, cursor):
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
        if block.startswith("'''", cursor) or block.startswith('"""', cursor):
            quote = block[cursor]
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
        if char == "[":
            depth += 1
        elif char == "]":
            depth -= 1
            if depth == 0:
                return block[start:cursor]
        cursor += 1
    return None


def _extract_quran_connections(block: str, consts: dict[str, str]) -> list[EditorialQuranConnection]:
    body = _extract_list_body(block, "quranConnections")
    if body is None:
        return []
    connections = []
    for connection_block in re.findall(r"QuranConnection\(([\s\S]*?)\)", body):
        wrapped = f"QuranConnection({connection_block})"
        surah_name = _extract_scalar(wrapped, "surahName", consts) or ""
        surah_number = _extract_scalar(wrapped, "surahNumber", consts) or 0
        verse_range = _extract_scalar(wrapped, "verseRange", consts) or ""
        label = _extract_scalar(wrapped, "label", consts) or ""
        connections.append(
            EditorialQuranConnection(
                surah_name=surah_name,
                surah_number=int(surah_number),
                verse_range=verse_range,
                label=label,
            )
        )
    return connections


def normalize_spacing(value: str | None) -> str | None:
    if value is None:
        return None
    trimmed = re.sub(r"\s+", " ", value).strip()
    return trimmed or None


def normalize_narrator(value: str | None) -> str | None:
    normalized = normalize_spacing(value)
    if normalized is None:
        return None
    normalized = normalized.replace("(ra)", "").replace("(r.a)", "")
    normalized = re.sub(r"\s+", " ", normalized).strip()
    return normalized or None


def normalize_transliteration_status(value: str | None, text: str | None) -> str:
    normalized = (normalize_spacing(value) or "").lower()
    if not normalize_spacing(text):
        return "missing"
    if normalized in {"trusted", "verified"}:
        return "trusted"
    if normalized in {"review_required", "review required", "needs_review", "needs review"}:
        return "reviewRequired"
    if normalized in {"unverified", "imported_unverified"}:
        return "unverified"
    return "unverified"


def normalize_transliteration_review_status(value: str | None) -> str:
    normalized = (normalize_spacing(value) or "").lower()
    if normalized in {"rejected", "reject"}:
        return "rejected"
    if normalized in {"approved", "reviewed", "verified"}:
        return "approved"
    if normalized in {"pending", "needs_review", "needs review", "review_required"}:
        return "pending"
    return "notReviewed"


def slugify(value: str) -> str:
    slug = value.lower()
    slug = re.sub(r"[‘’']", "", slug)
    slug = re.sub(r"[^\w]+", "_", slug, flags=re.UNICODE)
    slug = re.sub(r"_+", "_", slug).strip("_")
    return slug


def build_source_reference_key(source_collection: str | None, source_reference: str | None) -> str:
    collection_titles = split_collection_titles(source_collection or "")
    primary_collection_id = normalize_collection_id(collection_titles[0]) if collection_titles else ""
    normalized_reference = slugify(normalize_spacing(source_reference) or "")
    if not primary_collection_id and not normalized_reference:
        return ""
    if not primary_collection_id:
        return normalized_reference
    if not normalized_reference:
        return primary_collection_id
    return f"{primary_collection_id}__{normalized_reference}"


def split_collection_titles(value: str) -> list[str]:
    normalized = normalize_spacing(value)
    if normalized is None:
        return []
    parts = [normalize_spacing(part) for part in normalized.split("/")]
    return [part for part in parts if part]


def normalize_collection_id(title: str) -> str:
    replacements = {
        "sahih al-bukhari": "sahih_al_bukhari",
        "sahih muslim": "sahih_muslim",
        "jami' al-tirmidhi": "jami_al_tirmidhi",
        "jami al-tirmidhi": "jami_al_tirmidhi",
        "sunan abi dawud": "sunan_abi_dawud",
        "sunan abu dawud": "sunan_abi_dawud",
        "sunan al-nasa'i": "sunan_al_nasai",
        "sunan al-nasai": "sunan_al_nasai",
        "sunan ibn majah": "sunan_ibn_majah",
        "riyad as-salihin": "riyad_as_salihin",
        "muwatta malik": "muwatta_malik",
        "musnad ahmad": "musnad_ahmad",
    }
    normalized = normalize_spacing(title)
    if normalized is None:
        return ""
    return replacements.get(normalized.lower(), slugify(normalized))


def normalize_grade(value: str) -> str:
    normalized = normalize_spacing(value)
    if normalized is None:
        return ""
    labels = {
        "muttafaqun alayh": "Muttafaqun Alayh",
        "sahih": "Sahih",
        "hasan sahih": "Hasan Sahih",
        "hasan": "Hasan",
        "balagh": "Balagh",
        "weak": "Weak",
        "daif": "Weak",
        "da'if": "Weak",
    }
    return labels.get(normalized.lower(), normalized)


def extract_hadith_numbers(reference: str) -> list[str]:
    if not reference.strip():
        return []
    explicit_hadith_numbers = re.findall(r"(?i)hadith\s+([0-9]{1,5})", reference)
    if explicit_hadith_numbers:
        return explicit_hadith_numbers
    return re.findall(
        r"(?i)(?:bukhari|muslim|tirmidhi|nasai|nasa'i|malik|dawud|majah)\s*([0-9]{1,5})",
        reference,
    )


def extract_chapter_number(reference: str) -> int | None:
    match = re.search(r"(?i)(?:book|chapter)\s+([0-9]{1,4})", reference)
    if match:
        return int(match.group(1))
    return None


def extract_chapter_title(reference: str, explicit_title: str | None, explicit_number: int | None) -> str | None:
    if normalize_spacing(explicit_title):
        return normalize_spacing(explicit_title)
    number = explicit_number if explicit_number is not None else extract_chapter_number(reference)
    if number is None:
        return None
    return f"Book {number}"


def generate_entry_id(raw: RawHadithRecord, editorial: EditorialHadithRecord) -> str:
    preferred = normalize_spacing(editorial.preferred_entry_id)
    if preferred:
        return preferred
    basis = " ".join(
        [
            editorial.title,
            raw.source_collection,
            " ".join(raw.hadith_numbers),
            raw.source_reference,
        ]
    )
    return slugify(basis)


def build_canonical_record(
    raw: RawHadithRecord,
    editorial: EditorialHadithRecord,
    transliteration_record: TransliterationImportRecord | None = None,
) -> CanonicalHadithRecord:
    collection_titles = split_collection_titles(raw.source_collection)
    source_collection_ids = [normalize_collection_id(title) for title in collection_titles]
    primary_collection_title = collection_titles[0] if collection_titles else normalize_spacing(raw.source_collection)
    primary_collection_id = source_collection_ids[0] if source_collection_ids else None
    source_reference = normalize_spacing(raw.source_reference)
    source_grade = normalize_grade(raw.grading)
    chapter_number = raw.chapter_number if raw.chapter_number is not None else extract_chapter_number(raw.source_reference)
    chapter_title = extract_chapter_title(raw.source_reference, raw.chapter_title, raw.chapter_number)
    chapter_id = slugify(chapter_title) if chapter_title else None
    hadith_numbers = [item for item in raw.hadith_numbers if normalize_spacing(item)] or extract_hadith_numbers(raw.source_reference)
    narrator = normalize_narrator(raw.narrator)
    reference_key = build_source_reference_key(raw.source_collection, raw.source_reference)
    transliteration_text = normalize_spacing(
        transliteration_record.transliteration_text if transliteration_record else raw.transliteration
    )
    transliteration_source = normalize_spacing(
        transliteration_record.transliteration_source if transliteration_record else None
    )
    transliteration_status = normalize_transliteration_status(
        transliteration_record.quality_status if transliteration_record else None,
        transliteration_text,
    )
    transliteration_review_status = normalize_transliteration_review_status(
        transliteration_record.review_status if transliteration_record else None
    )
    transliteration_reviewed_at = normalize_spacing(
        transliteration_record.reviewed_at if transliteration_record else None
    )
    transliteration_verified = (
        raw.verification.is_verified_transliteration
        if transliteration_record is None
        else transliteration_status == "trusted"
    )
    category_id = editorial.category_id
    category_title = editorial.category_title
    subcategory_id = editorial.subcategory_id
    subcategory_title = editorial.subcategory_title
    if not category_id or not subcategory_id:
        taxonomy = _THEME_TO_TAXONOMY.get(editorial.theme_id)
        if taxonomy:
            category_id = category_id or taxonomy[0]
            category_title = category_title or taxonomy[1]
            subcategory_id = subcategory_id or taxonomy[2]
            subcategory_title = subcategory_title or taxonomy[3]
    payload = {
        "id": generate_entry_id(raw, editorial),
        "themeId": editorial.theme_id,
        "collectionIds": editorial.collection_ids,
        "title": editorial.title.strip(),
        "excerpt": editorial.excerpt.strip(),
        "hadithText": raw.translation_text.strip(),
        "englishText": raw.translation_text.strip(),
        "arabicText": raw.arabic_text.strip(),
        "transliteration": transliteration_text,
        "sourceReferenceKey": reference_key,
        "transliterationSource": transliteration_source,
        "transliterationStatus": transliteration_status,
        "transliterationReviewStatus": transliteration_review_status,
        "transliterationReviewedAt": transliteration_reviewed_at,
        "sourceUrl": normalize_spacing(raw.source_url),
        "translationSourceVerified": raw.verification.is_verified_translation,
        "arabicMatnSourceVerified": raw.verification.is_verified_text,
        "transliterationSourceVerified": transliteration_verified,
        "source": f"{normalize_spacing(raw.source_collection) or ''} {source_reference or ''}".strip(),
        "sourceCollection": normalize_spacing(raw.source_collection),
        "sourceReference": source_reference,
        "grading": source_grade,
        "narrator": narrator,
        "sourceCollectionIds": source_collection_ids,
        "sourceCollectionId": primary_collection_id,
        "sourceCollectionTitle": primary_collection_title,
        "sourceChapterId": chapter_id,
        "sourceChapterTitle": chapter_title,
        "sourceChapterNumber": chapter_number,
        "sourceHadithNumbers": hadith_numbers,
        "sourceProvenance": "imported",
        "sourceImportSource": IMPORT_SOURCE,
        "categoryId": category_id,
        "categoryTitle": category_title,
        "subcategoryId": subcategory_id,
        "subcategoryTitle": subcategory_title,
        "tags": editorial.tags,
        "quranConnections": [
            {
                "surahName": connection.surah_name,
                "surahNumber": connection.surah_number,
                "verseRange": connection.verse_range,
                "label": connection.label,
            }
            for connection in editorial.quran_connections
        ],
        "meaning": editorial.meaning.strip(),
        "lessons": editorial.lessons,
        "reflectionPrompts": editorial.reflection_prompts,
        "practiceAction": editorial.practice_action.strip(),
        "relatedHadithIds": editorial.related_hadith_ids,
        "isDailyEligible": editorial.is_daily_eligible,
        "difficultyLevel": editorial.difficulty_level,
        "themeTag": editorial.theme_tag,
        "recommendedDay": editorial.recommended_day,
        "isEssential": editorial.is_essential,
    }
    is_verified_source = (
        raw.verification.is_verified_source
        and bool(payload["sourceCollection"])
        and bool(payload["sourceReference"])
        and bool(payload["sourceUrl"])
        and bool(payload["grading"])
    )
    return CanonicalHadithRecord(
        payload=payload,
        is_verified_source=is_verified_source,
        is_verified_text=raw.verification.is_verified_text and bool(payload["arabicText"]),
        is_verified_translation=raw.verification.is_verified_translation and bool(payload["englishText"]),
    )


def release_gate_failures(record: CanonicalHadithRecord) -> list[str]:
    payload = record.payload
    reasons: list[str] = []
    if not payload.get("id"):
        reasons.append("missing_id")
    if not payload.get("title"):
        reasons.append("missing_title")
    if not payload.get("sourceCollection"):
        reasons.append("missing_source_collection")
    if not payload.get("sourceReference"):
        reasons.append("missing_reference")
    if not payload.get("grading"):
        reasons.append("missing_grade")
    if not payload.get("sourceUrl"):
        reasons.append("missing_source_url")
    if not record.is_verified_source:
        reasons.append("unverified_source")
    if not record.is_verified_text:
        reasons.append("unverified_text")
    if not record.is_verified_translation:
        reasons.append("unverified_translation")
    if payload.get("transliteration") and not payload.get("transliterationSourceVerified"):
        reasons.append("unverified_transliteration")
    return reasons


def bootstrap_inputs_from_seed() -> tuple[list[RawHadithRecord], list[EditorialHadithRecord]]:
    source = _read(SEED_PATH)
    consts = _parse_const_strings(source)
    raw_records: list[RawHadithRecord] = []
    editorial_records: list[EditorialHadithRecord] = []
    for block in _find_hadith_blocks(source):
        source_record_id = _extract_scalar(block, "id", consts) or ""
        theme_id = _extract_scalar(block, "themeId", consts) or ""
        taxonomy = _THEME_TO_TAXONOMY.get(theme_id)
        raw_records.append(
            RawHadithRecord(
                source_record_id=source_record_id,
                source_collection=normalize_spacing(_extract_scalar(block, "sourceCollection", consts) or _extract_scalar(block, "source", consts) or "") or "",
                source_reference=normalize_spacing(_extract_scalar(block, "sourceReference", consts) or "") or "",
                source_url=normalize_spacing(_extract_scalar(block, "sourceUrl", consts) or "") or "",
                hadith_numbers=[
                    item
                    for item in _extract_list_strings(block, "sourceHadithNumbers", consts)
                    if normalize_spacing(item)
                ]
                or extract_hadith_numbers(_extract_scalar(block, "sourceReference", consts) or ""),
                arabic_text=_extract_scalar(block, "arabicText", consts) or "",
                translation_text=(_extract_scalar(block, "englishText", consts) or _extract_scalar(block, "hadithText", consts) or ""),
                transliteration=_extract_scalar(block, "transliteration", consts),
                grading=_extract_scalar(block, "grading", consts) or "",
                narrator=_extract_scalar(block, "narrator", consts),
                chapter_number=_extract_scalar(block, "sourceChapterNumber", consts),
                chapter_title=_extract_scalar(block, "sourceChapterTitle", consts),
                verification=RawVerification(
                    is_verified_source=bool(_extract_scalar(block, "sourceUrl", consts))
                    and bool(_extract_scalar(block, "sourceReference", consts))
                    and bool(_extract_scalar(block, "grading", consts))
                    and bool(_extract_scalar(block, "sourceCollection", consts) or _extract_scalar(block, "source", consts)),
                    is_verified_text=bool(_extract_scalar(block, "arabicMatnSourceVerified", consts)),
                    is_verified_translation=bool(_extract_scalar(block, "translationSourceVerified", consts)),
                    is_verified_transliteration=bool(_extract_scalar(block, "transliterationSourceVerified", consts)),
                ),
            )
        )
        editorial_records.append(
            EditorialHadithRecord(
                source_record_id=source_record_id,
                preferred_entry_id=source_record_id,
                theme_id=theme_id,
                collection_ids=_extract_list_strings(block, "collectionIds", consts),
                title=_extract_scalar(block, "title", consts) or "",
                excerpt=_extract_scalar(block, "excerpt", consts) or "",
                tags=_extract_list_strings(block, "tags", consts),
                quran_connections=_extract_quran_connections(block, consts),
                meaning=_extract_scalar(block, "meaning", consts) or "",
                lessons=_extract_list_strings(block, "lessons", consts),
                reflection_prompts=_extract_list_strings(block, "reflectionPrompts", consts),
                practice_action=_extract_scalar(block, "practiceAction", consts) or "",
                related_hadith_ids=_extract_list_strings(block, "relatedHadithIds", consts),
                is_daily_eligible=bool(_extract_scalar(block, "isDailyEligible", consts)),
                difficulty_level=_extract_scalar(block, "difficultyLevel", consts) or "beginner",
                theme_tag=_extract_scalar(block, "themeTag", consts),
                recommended_day=_extract_scalar(block, "recommendedDay", consts),
                is_essential=bool(_extract_scalar(block, "isEssential", consts)),
                category_id=taxonomy[0] if taxonomy else None,
                category_title=taxonomy[1] if taxonomy else None,
                subcategory_id=taxonomy[2] if taxonomy else None,
                subcategory_title=taxonomy[3] if taxonomy else None,
            )
        )
    raw_records.sort(key=lambda item: item.source_record_id)
    editorial_records.sort(key=lambda item: item.source_record_id)
    return raw_records, editorial_records


def write_bootstrap_inputs() -> None:
    raw_records, editorial_records = bootstrap_inputs_from_seed()
    RAW_INPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    EDITORIAL_INPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    TRANSLITERATION_INPUT_PATH.parent.mkdir(parents=True, exist_ok=True)
    RAW_INPUT_PATH.write_text(
        json.dumps(
            {
                "metadata": {
                    "generatedAt": datetime.now(timezone.utc).isoformat(),
                    "source": "bootstrap_from_seeded_hadith_entries",
                    "recordCount": len(raw_records),
                },
                "entries": [
                    {
                        "sourceRecordId": record.source_record_id,
                        "sourceCollection": record.source_collection,
                        "sourceReference": record.source_reference,
                        "sourceUrl": record.source_url,
                        "hadithNumbers": record.hadith_numbers,
                        "arabicText": record.arabic_text,
                        "translationText": record.translation_text,
                        "transliteration": record.transliteration,
                        "grading": record.grading,
                        "narrator": record.narrator,
                        "chapterNumber": record.chapter_number,
                        "chapterTitle": record.chapter_title,
                        "verification": {
                            "isVerifiedSource": record.verification.is_verified_source,
                            "isVerifiedText": record.verification.is_verified_text,
                            "isVerifiedTranslation": record.verification.is_verified_translation,
                            "isVerifiedTransliteration": record.verification.is_verified_transliteration,
                        },
                    }
                    for record in raw_records
                ],
            },
            indent=2,
            ensure_ascii=False,
        )
        + "\n",
        encoding="utf-8",
    )
    EDITORIAL_INPUT_PATH.write_text(
        json.dumps(
            {
                "metadata": {
                    "generatedAt": datetime.now(timezone.utc).isoformat(),
                    "source": "bootstrap_from_seeded_hadith_entries",
                    "recordCount": len(editorial_records),
                },
                "entries": [
                    {
                        "sourceRecordId": record.source_record_id,
                        "preferredEntryId": record.preferred_entry_id,
                        "themeId": record.theme_id,
                        "collectionIds": record.collection_ids,
                        "title": record.title,
                        "excerpt": record.excerpt,
                        "tags": record.tags,
                        "quranConnections": [
                            {
                                "surahName": connection.surah_name,
                                "surahNumber": connection.surah_number,
                                "verseRange": connection.verse_range,
                                "label": connection.label,
                            }
                            for connection in record.quran_connections
                        ],
                        "meaning": record.meaning,
                        "lessons": record.lessons,
                        "reflectionPrompts": record.reflection_prompts,
                        "practiceAction": record.practice_action,
                        "relatedHadithIds": record.related_hadith_ids,
                        "isDailyEligible": record.is_daily_eligible,
                        "difficultyLevel": record.difficulty_level,
                        "themeTag": record.theme_tag,
                        "recommendedDay": record.recommended_day,
                        "isEssential": record.is_essential,
                        "categoryId": record.category_id,
                        "categoryTitle": record.category_title,
                        "subcategoryId": record.subcategory_id,
                        "subcategoryTitle": record.subcategory_title,
                    }
                    for record in editorial_records
                ],
            },
            indent=2,
            ensure_ascii=False,
        )
        + "\n",
        encoding="utf-8",
    )
    if not TRANSLITERATION_INPUT_PATH.exists():
        TRANSLITERATION_INPUT_PATH.write_text(
            json.dumps(
                {
                    "metadata": {
                        "generatedAt": datetime.now(timezone.utc).isoformat(),
                        "source": "trusted_transliteration_import_placeholder",
                        "recordCount": 0,
                        "notes": "Populate only with trusted human-curated transliteration exports matched by canonical source reference.",
                    },
                    "entries": [],
                },
                indent=2,
                ensure_ascii=False,
            )
            + "\n",
            encoding="utf-8",
        )


def load_raw_records(path: Path) -> list[RawHadithRecord]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    return [
        RawHadithRecord(
            source_record_id=item.get("sourceRecordId", ""),
            source_collection=item.get("sourceCollection", ""),
            source_reference=item.get("sourceReference", ""),
            source_url=item.get("sourceUrl", ""),
            hadith_numbers=[str(value) for value in item.get("hadithNumbers", [])],
            arabic_text=item.get("arabicText", ""),
            translation_text=item.get("translationText", ""),
            transliteration=item.get("transliteration"),
            grading=item.get("grading", ""),
            narrator=item.get("narrator"),
            chapter_number=item.get("chapterNumber"),
            chapter_title=item.get("chapterTitle"),
            verification=RawVerification(
                is_verified_source=bool(item.get("verification", {}).get("isVerifiedSource")),
                is_verified_text=bool(item.get("verification", {}).get("isVerifiedText")),
                is_verified_translation=bool(item.get("verification", {}).get("isVerifiedTranslation")),
                is_verified_transliteration=bool(item.get("verification", {}).get("isVerifiedTransliteration")),
            ),
        )
        for item in payload.get("entries", [])
    ]


def load_editorial_records(path: Path) -> list[EditorialHadithRecord]:
    payload = json.loads(path.read_text(encoding="utf-8"))
    records: list[EditorialHadithRecord] = []
    for item in payload.get("entries", []):
        records.append(
            EditorialHadithRecord(
                source_record_id=item.get("sourceRecordId", ""),
                preferred_entry_id=item.get("preferredEntryId", ""),
                theme_id=item.get("themeId", ""),
                collection_ids=[str(value) for value in item.get("collectionIds", [])],
                title=item.get("title", ""),
                excerpt=item.get("excerpt", ""),
                tags=[str(value) for value in item.get("tags", [])],
                quran_connections=[
                    EditorialQuranConnection(
                        surah_name=connection.get("surahName", ""),
                        surah_number=int(connection.get("surahNumber", 0)),
                        verse_range=connection.get("verseRange", ""),
                        label=connection.get("label", ""),
                    )
                    for connection in item.get("quranConnections", [])
                ],
                meaning=item.get("meaning", ""),
                lessons=[str(value) for value in item.get("lessons", [])],
                reflection_prompts=[str(value) for value in item.get("reflectionPrompts", [])],
                practice_action=item.get("practiceAction", ""),
                related_hadith_ids=[str(value) for value in item.get("relatedHadithIds", [])],
                is_daily_eligible=bool(item.get("isDailyEligible")),
                difficulty_level=item.get("difficultyLevel", "beginner"),
                theme_tag=item.get("themeTag"),
                recommended_day=item.get("recommendedDay"),
                is_essential=bool(item.get("isEssential")),
                category_id=item.get("categoryId"),
                category_title=item.get("categoryTitle"),
                subcategory_id=item.get("subcategoryId"),
                subcategory_title=item.get("subcategoryTitle"),
            )
        )
    return records


def load_transliteration_records(path: Path) -> list[TransliterationImportRecord]:
    if not path.exists():
        return []
    payload = json.loads(path.read_text(encoding="utf-8"))
    records: list[TransliterationImportRecord] = []
    for item in payload.get("entries", []):
        source_collection = item.get("sourceCollection", "")
        source_reference = item.get("sourceReference", "")
        derived_key = build_source_reference_key(source_collection, source_reference)
        source_reference_key = normalize_spacing(item.get("sourceReferenceKey")) or derived_key
        records.append(
            TransliterationImportRecord(
                source_reference_key=source_reference_key,
                source_collection=normalize_spacing(source_collection) or "",
                source_reference=normalize_spacing(source_reference) or "",
                transliteration_text=item.get("transliterationText", ""),
                transliteration_source=item.get("transliterationSource", ""),
                quality_status=item.get("qualityStatus", ""),
                review_status=item.get("reviewStatus"),
                reviewed_at=item.get("reviewedAt"),
            )
        )
    return records


def _index_transliteration_records(
    records: list[TransliterationImportRecord],
) -> tuple[
    dict[str, TransliterationImportRecord],
    dict[str, list[str]],
    dict[str, list[dict[str, str]]],
    list[str],
    list[str],
]:
    indexed: dict[str, TransliterationImportRecord] = {}
    duplicate_imports: dict[str, list[str]] = {}
    conflicting_imports: dict[str, list[dict[str, str]]] = {}
    manual_review_records: list[str] = []
    rejected_records: list[str] = []
    grouped: dict[str, list[TransliterationImportRecord]] = {}
    for record in records:
        grouped.setdefault(record.source_reference_key, []).append(record)
    for key, items in grouped.items():
        if not key:
            duplicate_imports[key or "<missing_key>"] = [
                item.source_reference or item.source_collection
                for item in items
            ]
            manual_review_records.append(key or "<missing_key>")
            continue
        normalized_texts = {
            normalize_spacing(item.transliteration_text) or ""
            for item in items
        }
        if len(items) > 1:
            duplicate_imports[key] = [
                item.source_reference or item.source_collection
                for item in items
            ]
            if len(normalized_texts) > 1:
                conflicting_imports[key] = [
                    {
                        "sourceReference": item.source_reference,
                        "transliterationSource": item.transliteration_source,
                        "qualityStatus": item.quality_status,
                        "reviewStatus": item.review_status or "",
                        "transliterationText": normalize_spacing(
                            item.transliteration_text
                        )
                        or "",
                    }
                    for item in items
                ]
            manual_review_records.append(key)
            continue
        item = items[0]
        if not normalize_spacing(item.transliteration_text):
            manual_review_records.append(key)
            continue
        if normalize_transliteration_review_status(item.review_status) == "rejected":
            rejected_records.append(key)
            manual_review_records.append(key)
            continue
        indexed[key] = item
        if (
            normalize_transliteration_status(item.quality_status, item.transliteration_text)
            == "reviewRequired"
        ):
            manual_review_records.append(key)
    return (
        indexed,
        duplicate_imports,
        conflicting_imports,
        sorted(set(manual_review_records)),
        sorted(set(rejected_records)),
    )


def build_dataset(
    raw_records: list[RawHadithRecord],
    editorial_records: list[EditorialHadithRecord],
    transliteration_records: list[TransliterationImportRecord],
) -> tuple[list[dict[str, Any]], list[ReleaseDecision], TransliterationIngestionReport]:
    editorial_by_id = {record.source_record_id: record for record in editorial_records}
    (
        transliteration_by_key,
        duplicate_import_records,
        conflicting_import_records,
        manual_review_records,
        rejected_records,
    ) = _index_transliteration_records(transliteration_records)
    for raw in raw_records:
        reference_key = build_source_reference_key(raw.source_collection, raw.source_reference)
    runtime_reference_groups: dict[str, list[str]] = {}
    entries: list[dict[str, Any]] = []
    decisions: list[ReleaseDecision] = []
    matched_entry_count = 0
    matched_reference_keys: set[str] = set()
    review_queue: list[dict[str, Any]] = []
    for raw in raw_records:
        editorial = editorial_by_id.get(raw.source_record_id)
        if editorial is None:
            decisions.append(
                ReleaseDecision(
                    source_record_id=raw.source_record_id,
                    included=False,
                    reasons=["missing_editorial_enrichment"],
                )
            )
            continue
        reference_key = build_source_reference_key(raw.source_collection, raw.source_reference)
        transliteration_record = transliteration_by_key.get(reference_key)
        if transliteration_record is not None:
            matched_entry_count += 1
            matched_reference_keys.add(reference_key)
        canonical = build_canonical_record(raw, editorial, transliteration_record)
        reasons = release_gate_failures(canonical)
        decisions.append(
            ReleaseDecision(
                source_record_id=raw.source_record_id,
                included=not reasons,
                reasons=reasons,
            )
        )
        if not reasons:
            entries.append(canonical.payload)
            if reference_key:
                runtime_reference_groups.setdefault(reference_key, []).append(
                    canonical.payload["id"]
                )
    entries.sort(key=lambda item: item["id"])
    decisions.sort(key=lambda item: item.source_record_id)
    duplicate_reference_groups = {
        key: ids
        for key, ids in runtime_reference_groups.items()
        if len(ids) > 1
    }
    unmatched_import_records = sorted(
        key for key in transliteration_by_key.keys() if key not in matched_reference_keys
    )
    unmatched_runtime_references = sorted(
        key for key in runtime_reference_groups.keys() if key not in transliteration_by_key
    )
    derivative_entries_reused = sum(
        max(0, len(ids) - 1)
        for key, ids in duplicate_reference_groups.items()
        if key in matched_reference_keys
    )
    for key in unmatched_runtime_references:
        review_queue.append(
            {
                "referenceKey": key,
                "status": "unmatched",
                "reason": "runtime_reference_missing_trusted_import",
                "runtimeEntryIds": runtime_reference_groups.get(key, []),
                "importCandidates": [],
            }
        )
    for key in sorted(conflicting_import_records.keys()):
        review_queue.append(
            {
                "referenceKey": key,
                "status": "needs_review",
                "reason": "conflicting_import_payloads",
                "runtimeEntryIds": runtime_reference_groups.get(key, []),
                "importCandidates": conflicting_import_records[key],
            }
        )
    for key in sorted(rejected_records):
        record = transliteration_by_key.get(key)
        review_queue.append(
            {
                "referenceKey": key,
                "status": "rejected",
                "reason": "curator_marked_rejected",
                "runtimeEntryIds": runtime_reference_groups.get(key, []),
                "importCandidates": []
                if record is None
                else [
                    {
                        "sourceReference": record.source_reference,
                        "transliterationSource": record.transliteration_source,
                        "qualityStatus": record.quality_status,
                        "reviewStatus": record.review_status or "",
                        "transliterationText": normalize_spacing(
                            record.transliteration_text
                        )
                        or "",
                    }
                ],
            }
        )
    for key in sorted(manual_review_records):
        if key in conflicting_import_records or key in rejected_records:
            continue
        record = transliteration_by_key.get(key)
        review_queue.append(
            {
                "referenceKey": key,
                "status": "needs_review",
                "reason": "import_record_requires_manual_review",
                "runtimeEntryIds": runtime_reference_groups.get(key, []),
                "importCandidates": []
                if record is None
                else [
                    {
                        "sourceReference": record.source_reference,
                        "transliterationSource": record.transliteration_source,
                        "qualityStatus": record.quality_status,
                        "reviewStatus": record.review_status or "",
                        "transliterationText": normalize_spacing(
                            record.transliteration_text
                        )
                        or "",
                    }
                ],
            }
        )
    for key in unmatched_import_records:
        review_queue.append(
            {
                "referenceKey": key,
                "status": "unmatched",
                "reason": "trusted_import_missing_runtime_reference",
                "runtimeEntryIds": [],
                "importCandidates": [],
            }
        )
    review_queue.sort(key=lambda item: (item["status"], item["referenceKey"]))
    report = TransliterationIngestionReport(
        matched_entries=matched_entry_count,
        matched_reference_groups=len(matched_reference_keys),
        derivative_entries_reused=derivative_entries_reused,
        runtime_reference_groups=len(runtime_reference_groups),
        import_reference_groups=len(transliteration_by_key),
        unmatched_runtime_references=unmatched_runtime_references,
        unmatched_import_records=unmatched_import_records,
        duplicate_reference_groups=duplicate_reference_groups,
        duplicate_import_records=duplicate_import_records,
        conflicting_import_records=conflicting_import_records,
        review_required_records=sorted(
            key for key in manual_review_records if key not in rejected_records
        ),
        rejected_records=rejected_records,
        manual_review_records=manual_review_records,
        review_queue=review_queue,
    )
    return entries, decisions, report


def build_master_dataset_json(
    entries: list[dict[str, Any]],
    decisions: list[ReleaseDecision],
    transliteration_report: TransliterationIngestionReport,
) -> str:
    return json.dumps(
        {
            "metadata": {
                "generatedAt": datetime.now(timezone.utc).isoformat(),
                "sourcePolicy": "Trusted-source structured ingestion with normalization, verification, editorial enrichment, and release gating.",
                "includedCount": len(entries),
                "excludedCount": len([item for item in decisions if not item.included]),
                "releaseGatePolicy": [
                    "source_present",
                    "reference_present",
                    "grade_present",
                    "verified_source",
                    "verified_text",
                    "verified_translation",
                    "verified_transliteration_when_present",
                ],
                "transliterationIngestion": {
                    "matchedEntries": transliteration_report.matched_entries,
                    "matchedReferenceGroups": transliteration_report.matched_reference_groups,
                    "runtimeReferenceGroups": transliteration_report.runtime_reference_groups,
                    "importReferenceGroups": transliteration_report.import_reference_groups,
                    "unmatchedRuntimeReferences": len(
                        transliteration_report.unmatched_runtime_references
                    ),
                    "unmatchedImportRecords": len(
                        transliteration_report.unmatched_import_records
                    ),
                    "derivativeEntriesReused": transliteration_report.derivative_entries_reused,
                    "manualReviewRecords": len(transliteration_report.manual_review_records),
                },
            },
            "excludedEntries": [
                {
                    "sourceRecordId": item.source_record_id,
                    "reasons": item.reasons,
                }
                for item in decisions
                if not item.included
            ],
            "entries": entries,
        },
        indent=2,
        ensure_ascii=False,
    ) + "\n"


def build_transliteration_report_json(report: TransliterationIngestionReport) -> str:
    return json.dumps(
        {
            "metadata": {
                "generatedAt": datetime.now(timezone.utc).isoformat(),
                "source": "trusted_hadith_transliteration_ingestion_foundation",
            },
            "summary": {
                "matchedEntries": report.matched_entries,
                "matchedReferenceGroups": report.matched_reference_groups,
                "derivativeEntriesReused": report.derivative_entries_reused,
                "runtimeReferenceGroups": report.runtime_reference_groups,
                "importReferenceGroups": report.import_reference_groups,
                "unmatchedRuntimeReferences": len(report.unmatched_runtime_references),
                "unmatchedImportRecords": len(report.unmatched_import_records),
                "duplicateReferenceGroups": len(report.duplicate_reference_groups),
                "duplicateImportRecords": len(report.duplicate_import_records),
                "conflictingImportRecords": len(report.conflicting_import_records),
                "reviewRequiredRecords": len(report.review_required_records),
                "rejectedRecords": len(report.rejected_records),
                "manualReviewRecords": len(report.manual_review_records),
            },
            "unmatchedRuntimeReferences": report.unmatched_runtime_references,
            "unmatchedImportRecords": report.unmatched_import_records,
            "duplicateReferenceGroups": report.duplicate_reference_groups,
            "duplicateImportRecords": report.duplicate_import_records,
            "conflictingImportRecords": report.conflicting_import_records,
            "reviewRequiredRecords": report.review_required_records,
            "rejectedRecords": report.rejected_records,
            "manualReviewRecords": report.manual_review_records,
            "reviewQueue": report.review_queue,
        },
        indent=2,
        ensure_ascii=False,
    ) + "\n"


def build_transliteration_review_queue_csv(report: TransliterationIngestionReport) -> str:
    lines = [
        "referenceKey,status,reason,runtimeEntryCount,importCandidateCount,runtimeEntryIds"
    ]
    for item in report.review_queue:
        runtime_entry_ids = "|".join(item.get("runtimeEntryIds", []))
        row = [
            item.get("referenceKey", ""),
            item.get("status", ""),
            item.get("reason", ""),
            str(len(item.get("runtimeEntryIds", []))),
            str(len(item.get("importCandidates", []))),
            runtime_entry_ids,
        ]
        escaped = ['"' + value.replace('"', '""') + '"' for value in row]
        lines.append(",".join(escaped))
    return "\n".join(lines) + "\n"


def build_generated_dart(entries: list[dict[str, Any]]) -> str:
    lines = [
        "import '../domain/hadith_foundation_models.dart';",
        "",
        "// GENERATED CODE - DO NOT EDIT BY HAND.",
        "// Built by tool/build_hadith_master_dataset.py from structured Hadith pipeline inputs.",
        "",
        "const List<HadithEntry> generatedHadithEntries = [",
    ]
    for entry in entries:
        lines.extend(_emit_dart_entry(entry))
    lines.append("];")
    lines.append("")
    return "\n".join(lines)


def _emit_dart_entry(entry: dict[str, Any]) -> list[str]:
    return [
        "  HadithEntry(",
        f"    id: {_dart_string(entry['id'])},",
        f"    themeId: {_dart_string(entry['themeId'])},",
        f"    collectionIds: {_dart_string_list(entry['collectionIds'])},",
        f"    title: {_dart_string(entry['title'])},",
        f"    excerpt: {_dart_string(entry['excerpt'])},",
        f"    hadithText: {_dart_string(entry['hadithText'])},",
        f"    englishText: {_dart_nullable_string(entry.get('englishText'))},",
        f"    arabicText: {_dart_nullable_string(entry.get('arabicText'))},",
        f"    transliteration: {_dart_nullable_string(entry.get('transliteration'))},",
        f"    sourceReferenceKey: {_dart_nullable_string(entry.get('sourceReferenceKey'))},",
        f"    transliterationSource: {_dart_nullable_string(entry.get('transliterationSource'))},",
        f"    transliterationStatus: HadithTransliterationStatus.{entry['transliterationStatus']},",
        "    transliterationReviewStatus: "
        f"HadithTransliterationReviewStatus.{entry['transliterationReviewStatus']},",
        f"    transliterationReviewedAt: {_dart_nullable_string(entry.get('transliterationReviewedAt'))},",
        f"    sourceUrl: {_dart_nullable_string(entry.get('sourceUrl'))},",
        f"    translationSourceVerified: {str(entry['translationSourceVerified']).lower()},",
        f"    arabicMatnSourceVerified: {str(entry['arabicMatnSourceVerified']).lower()},",
        f"    transliterationSourceVerified: {str(entry['transliterationSourceVerified']).lower()},",
        f"    source: {_dart_string(entry['source'])},",
        f"    sourceCollection: {_dart_nullable_string(entry.get('sourceCollection'))},",
        f"    sourceReference: {_dart_nullable_string(entry.get('sourceReference'))},",
        f"    grading: {_dart_string(entry['grading'])},",
        f"    narrator: {_dart_nullable_string(entry.get('narrator'))},",
        f"    sourceCollectionIds: {_dart_string_list(entry['sourceCollectionIds'])},",
        f"    sourceCollectionId: {_dart_nullable_string(entry.get('sourceCollectionId'))},",
        f"    sourceCollectionTitle: {_dart_nullable_string(entry.get('sourceCollectionTitle'))},",
        f"    sourceChapterId: {_dart_nullable_string(entry.get('sourceChapterId'))},",
        f"    sourceChapterTitle: {_dart_nullable_string(entry.get('sourceChapterTitle'))},",
        f"    sourceChapterNumber: {_dart_nullable_int(entry.get('sourceChapterNumber'))},",
        f"    sourceHadithNumbers: {_dart_string_list(entry['sourceHadithNumbers'])},",
        "    sourceProvenance: HadithSourceProvenance.imported,",
        f"    sourceImportSource: {_dart_nullable_string(entry.get('sourceImportSource'))},",
        f"    categoryId: {_dart_nullable_string(entry.get('categoryId'))},",
        f"    categoryTitle: {_dart_nullable_string(entry.get('categoryTitle'))},",
        f"    subcategoryId: {_dart_nullable_string(entry.get('subcategoryId'))},",
        f"    subcategoryTitle: {_dart_nullable_string(entry.get('subcategoryTitle'))},",
        f"    tags: {_dart_string_list(entry['tags'])},",
        f"    quranConnections: {_emit_quran_connections(entry['quranConnections'])},",
        f"    meaning: {_dart_string(entry['meaning'])},",
        f"    lessons: {_dart_string_list(entry['lessons'])},",
        f"    reflectionPrompts: {_dart_string_list(entry['reflectionPrompts'])},",
        f"    practiceAction: {_dart_string(entry['practiceAction'])},",
        f"    relatedHadithIds: {_dart_string_list(entry['relatedHadithIds'])},",
        f"    isDailyEligible: {str(entry['isDailyEligible']).lower()},",
        f"    difficultyLevel: HadithDifficultyLevel.{entry['difficultyLevel']},",
        f"    themeTag: {_dart_nullable_string(entry.get('themeTag'))},",
        f"    recommendedDay: {_dart_nullable_string(entry.get('recommendedDay'))},",
        f"    isEssential: {str(entry['isEssential']).lower()},",
        "  ),",
    ]


def _dart_string(value: str) -> str:
    rendered = json.dumps(value, ensure_ascii=False)
    return (
        rendered.replace("\u202a", "\\u202A")
        .replace("\u202b", "\\u202B")
        .replace("\u202c", "\\u202C")
        .replace("\u202d", "\\u202D")
        .replace("\u202e", "\\u202E")
        .replace("\u2066", "\\u2066")
        .replace("\u2067", "\\u2067")
        .replace("\u2068", "\\u2068")
        .replace("\u2069", "\\u2069")
    )


def _dart_nullable_string(value: str | None) -> str:
    return "null" if value is None else _dart_string(value)


def _dart_string_list(values: list[str]) -> str:
    if not values:
        return "[]"
    return "[" + ", ".join(_dart_string(value) for value in values) + "]"


def _dart_nullable_int(value: int | None) -> str:
    return "null" if value is None else str(value)


def _emit_quran_connections(values: list[dict[str, Any]]) -> str:
    if not values:
        return "[]"
    rendered = []
    for item in values:
        rendered.append(
            "QuranConnection("
            f"surahName: {_dart_string(item['surahName'])}, "
            f"surahNumber: {item['surahNumber']}, "
            f"verseRange: {_dart_string(item['verseRange'])}, "
            f"label: {_dart_string(item['label'])})"
        )
    return "[" + ", ".join(rendered) + "]"


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--bootstrap-inputs", action="store_true")
    parser.add_argument("--check", action="store_true")
    args = parser.parse_args()

    if args.bootstrap_inputs:
        write_bootstrap_inputs()

    if not RAW_INPUT_PATH.exists() or not EDITORIAL_INPUT_PATH.exists():
        print("Missing Hadith pipeline inputs. Run with --bootstrap-inputs first.")
        return 1

    raw_records = load_raw_records(RAW_INPUT_PATH)
    editorial_records = load_editorial_records(EDITORIAL_INPUT_PATH)
    transliteration_records = load_transliteration_records(TRANSLITERATION_INPUT_PATH)
    entries, decisions, transliteration_report = build_dataset(
        raw_records,
        editorial_records,
        transliteration_records,
    )

    duplicates = sorted(
        entry_id
        for entry_id in {item["id"] for item in entries}
        if sum(1 for entry in entries if entry["id"] == entry_id) > 1
    )
    if duplicates:
        print(f"Duplicate Hadith ids detected: {', '.join(duplicates)}")
        return 1

    if args.check:
        excluded = [item for item in decisions if not item.included]
        if excluded:
            print(f"Release gate excluded {len(excluded)} records.")
            for item in excluded[:20]:
                print(f" - {item.source_record_id}: {', '.join(item.reasons)}")
        print(
            "Transliteration ingestion:"
            f" matched {transliteration_report.matched_entries} entries across"
            f" {transliteration_report.matched_reference_groups} reference groups;"
            f" unmatched runtime {len(transliteration_report.unmatched_runtime_references)};"
            f" unmatched imports {len(transliteration_report.unmatched_import_records)};"
            f" review required {len(transliteration_report.review_required_records)};"
            f" rejected {len(transliteration_report.rejected_records)}."
        )
        print(f"Hadith pipeline validation passed for {len(entries)} entries.")
        return 0

    OUTPUT_JSON_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT_JSON_PATH.write_text(
        build_master_dataset_json(entries, decisions, transliteration_report),
        encoding="utf-8",
    )
    TRANSLITERATION_REPORT_PATH.parent.mkdir(parents=True, exist_ok=True)
    TRANSLITERATION_REPORT_PATH.write_text(
        build_transliteration_report_json(transliteration_report),
        encoding="utf-8",
    )
    TRANSLITERATION_REVIEW_QUEUE_PATH.write_text(
        json.dumps(transliteration_report.review_queue, indent=2, ensure_ascii=False)
        + "\n",
        encoding="utf-8",
    )
    TRANSLITERATION_REVIEW_QUEUE_CSV_PATH.write_text(
        build_transliteration_review_queue_csv(transliteration_report),
        encoding="utf-8",
    )
    OUTPUT_DART_PATH.parent.mkdir(parents=True, exist_ok=True)
    OUTPUT_DART_PATH.write_text(build_generated_dart(entries), encoding="utf-8")
    excluded = [item for item in decisions if not item.included]
    if excluded:
        print(f"Release gate excluded {len(excluded)} records from the public runtime dataset.")
        for item in excluded[:20]:
            print(f" - {item.source_record_id}: {', '.join(item.reasons)}")
    print(
        "Transliteration ingestion report:"
        f" matched {transliteration_report.matched_entries} entries across"
        f" {transliteration_report.matched_reference_groups} reference groups;"
        f" unmatched runtime {len(transliteration_report.unmatched_runtime_references)};"
        f" unmatched imports {len(transliteration_report.unmatched_import_records)};"
        f" review required {len(transliteration_report.review_required_records)};"
        f" rejected {len(transliteration_report.rejected_records)}."
    )
    print(f"Built Hadith dataset with {len(entries)} verified entries.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
