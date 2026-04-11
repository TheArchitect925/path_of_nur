from __future__ import annotations

import json
import sys
from collections import Counter
from dataclasses import dataclass
from datetime import datetime, timezone
from pathlib import Path
from typing import Any

TOOL_DIR = Path(__file__).resolve().parent
if str(TOOL_DIR) not in sys.path:
    sys.path.insert(0, str(TOOL_DIR))

from build_hadith_master_dataset import (
    _extract_list_strings,
    _extract_scalar,
    _find_constructor_blocks,
    _parse_const_strings,
    normalize_narrator,
    normalize_spacing,
)


ROOT = Path(__file__).resolve().parents[1]
MASTER_DATASET_PATH = ROOT / "data/hadith/hadith_master_dataset.json"
CURRICULUM_PATH = ROOT / "lib/features/learn/hadith/data/hadith_curriculum_data.dart"
OUTPUT_NORMALIZED_PATH = ROOT / "data/hadith/hadith_existing_corpus_normalized.json"
OUTPUT_INVENTORY_PATH = ROOT / "data/hadith/hadith_existing_corpus_inventory.json"
OUTPUT_REPORT_PATH = ROOT / "data/hadith/hadith_existing_corpus_inventory.md"

MAJOR_COLLECTIONS = [
    "Sahih al-Bukhari",
    "Sahih Muslim",
    "Jami' al-Tirmidhi",
    "Sunan Abi Dawud",
    "Sunan al-Nasa'i",
    "Sunan Ibn Majah",
    "Riyad as-Salihin",
    "Muwatta Malik",
    "Musnad Ahmad",
]


@dataclass(frozen=True)
class LegacyThemeRecord:
    id: str
    title: str


@dataclass(frozen=True)
class LegacySubcategoryRecord:
    id: str
    theme_id: str
    title: str


@dataclass(frozen=True)
class LegacyLessonRecord:
    id: str
    theme_id: str
    subcategory_id: str
    title: str
    subtitle: str
    overview: str
    hadith_perspective: str
    quranic_connection: str
    practical_takeaway: str
    key_concepts: list[str]
    reflection_prompt: str
    related_lesson_ids: list[str]


def load_master_dataset() -> list[dict[str, Any]]:
    payload = json.loads(MASTER_DATASET_PATH.read_text(encoding="utf-8"))
    return list(payload.get("entries", []))


def load_legacy_curriculum() -> tuple[dict[str, LegacyThemeRecord], dict[str, LegacySubcategoryRecord], list[LegacyLessonRecord]]:
    source = CURRICULUM_PATH.read_text(encoding="utf-8")
    consts = _parse_const_strings(source)

    themes = {
        record.id: record
        for record in (
            LegacyThemeRecord(
                id=_extract_scalar(block, "id", consts) or "",
                title=_extract_scalar(block, "title", consts) or "",
            )
            for block in _find_constructor_blocks(source, "HadithTheme")
        )
        if record.id
    }
    subcategories = {
        record.id: record
        for record in (
            LegacySubcategoryRecord(
                id=_extract_scalar(block, "id", consts) or "",
                theme_id=_extract_scalar(block, "themeId", consts) or "",
                title=_extract_scalar(block, "title", consts) or "",
            )
            for block in _find_constructor_blocks(source, "HadithSubcategory")
        )
        if record.id
    }
    lessons = [
        LegacyLessonRecord(
            id=_extract_scalar(block, "id", consts) or "",
            theme_id=_extract_scalar(block, "themeId", consts) or "",
            subcategory_id=_extract_scalar(block, "subcategoryId", consts) or "",
            title=_extract_scalar(block, "title", consts) or "",
            subtitle=_extract_scalar(block, "subtitle", consts) or "",
            overview=_extract_scalar(block, "overview", consts) or "",
            hadith_perspective=_extract_scalar(block, "hadithPerspective", consts) or "",
            quranic_connection=_extract_scalar(block, "quranicConnection", consts) or "",
            practical_takeaway=_extract_scalar(block, "practicalTakeaway", consts) or "",
            key_concepts=_extract_list_strings(block, "keyConcepts", consts),
            reflection_prompt=_extract_scalar(block, "reflectionPrompt", consts) or "",
            related_lesson_ids=_extract_list_strings(block, "relatedLessonIds", consts),
        )
        for block in _find_constructor_blocks(source, "HadithLesson")
        if (_extract_scalar(block, "id", consts) or "").strip()
    ]
    return themes, subcategories, lessons


def normalize_foundation_entry(entry: dict[str, Any]) -> dict[str, Any]:
    source_hadith_numbers = [str(item) for item in entry.get("sourceHadithNumbers", [])]
    primary_hadith_number = source_hadith_numbers[0] if source_hadith_numbers else None
    normalized_narrator = normalize_narrator(entry.get("narrator"))
    source_collection_ids = [str(item) for item in entry.get("sourceCollectionIds", [])]
    primary_source_collection_id = entry.get("sourceCollectionId") or (
        source_collection_ids[0] if source_collection_ids else None
    )
    primary_source_collection_title = entry.get("sourceCollectionTitle") or entry.get("sourceCollection")

    return {
        "contentKind": "foundation_entry",
        "id": entry.get("id"),
        "sourceCollectionId": entry.get("sourceCollectionId"),
        "sourceCollectionTitle": entry.get("sourceCollectionTitle"),
        "primarySourceCollectionId": primary_source_collection_id,
        "primarySourceCollectionTitle": primary_source_collection_title,
        "displaySourceCollectionTitle": primary_source_collection_title,
        "bookId": entry.get("sourceChapterId"),
        "bookNumber": entry.get("sourceChapterNumber"),
        "bookTitle": entry.get("sourceChapterTitle"),
        "chapterId": None,
        "chapterNumber": None,
        "chapterTitle": None,
        "hadithNumber": primary_hadith_number,
        "primaryHadithNumber": primary_hadith_number,
        "normalizedSourceReference": entry.get("sourceReference"),
        "displayReference": entry.get("sourceReference"),
        "arabicText": entry.get("arabicText"),
        "translationText": entry.get("englishText") or entry.get("hadithText"),
        "transliteration": entry.get("transliteration"),
        "narrator": entry.get("narrator"),
        "normalizedNarrator": normalized_narrator,
        "gradeText": entry.get("grading"),
        "standardizedGrade": entry.get("grading"),
        "sourceUrl": entry.get("sourceUrl"),
        "categoryId": entry.get("categoryId"),
        "categoryTitle": entry.get("categoryTitle"),
        "subcategoryId": entry.get("subcategoryId"),
        "subcategoryTitle": entry.get("subcategoryTitle"),
        "themeId": entry.get("themeId"),
        "themeTag": entry.get("themeTag"),
        "tags": entry.get("tags", []),
        "lessons": entry.get("lessons", []),
        "quranConnections": entry.get("quranConnections", []),
        "relatedHadithIds": entry.get("relatedHadithIds", []),
        "isVerifiedSource": bool(entry.get("sourceUrl"))
        and bool(entry.get("sourceCollection"))
        and bool(entry.get("sourceReference"))
        and bool(entry.get("grading")),
        "isVerifiedArabicMatn": bool(entry.get("arabicMatnSourceVerified")),
        "isVerifiedTranslation": bool(entry.get("translationSourceVerified")),
        "provenance": {
            "kind": "pipeline_foundation_dataset",
            "path": str(MASTER_DATASET_PATH.relative_to(ROOT)),
            "sourceImportSource": entry.get("sourceImportSource"),
        },
        "launchReady": True,
        "gaps": [],
    }


def normalize_legacy_lesson(
    lesson: LegacyLessonRecord,
    theme: LegacyThemeRecord | None,
    subcategory: LegacySubcategoryRecord | None,
) -> dict[str, Any]:
    gaps = [
        "missing_source_collection",
        "missing_reference",
        "missing_grade",
        "missing_arabic_text",
        "missing_translation_text",
        "missing_verified_source",
        "missing_verified_arabic_matn",
        "missing_verified_translation",
    ]
    lesson_points = [
        normalize_spacing(lesson.practical_takeaway),
        *[normalize_spacing(item) for item in lesson.key_concepts],
    ]
    lessons = [item for item in lesson_points if item]

    return {
        "contentKind": "legacy_curriculum_lesson",
        "id": lesson.id,
        "sourceCollectionId": None,
        "sourceCollectionTitle": None,
        "primarySourceCollectionId": None,
        "primarySourceCollectionTitle": None,
        "displaySourceCollectionTitle": None,
        "bookId": None,
        "bookNumber": None,
        "bookTitle": None,
        "chapterId": subcategory.id if subcategory else None,
        "chapterNumber": None,
        "chapterTitle": subcategory.title if subcategory else None,
        "hadithNumber": None,
        "primaryHadithNumber": None,
        "normalizedSourceReference": None,
        "displayReference": None,
        "arabicText": None,
        "translationText": None,
        "transliteration": None,
        "narrator": None,
        "normalizedNarrator": None,
        "gradeText": None,
        "standardizedGrade": "unknown",
        "sourceUrl": None,
        "categoryId": None,
        "categoryTitle": None,
        "subcategoryId": subcategory.id if subcategory else None,
        "subcategoryTitle": subcategory.title if subcategory else None,
        "themeId": lesson.theme_id,
        "themeTag": theme.title if theme else None,
        "tags": lesson.key_concepts,
        "lessons": lessons,
        "quranConnections": [],
        "relatedHadithIds": lesson.related_lesson_ids,
        "isVerifiedSource": False,
        "isVerifiedArabicMatn": False,
        "isVerifiedTranslation": False,
        "provenance": {
            "kind": "legacy_curriculum_lesson",
            "path": str(CURRICULUM_PATH.relative_to(ROOT)),
            "legacyThemeTitle": theme.title if theme else None,
            "legacySubcategoryTitle": subcategory.title if subcategory else None,
            "legacySubtitle": lesson.subtitle,
            "legacyOverview": lesson.overview,
            "legacyHadithPerspective": lesson.hadith_perspective,
            "legacyQuranicConnection": lesson.quranic_connection,
            "legacyReflectionPrompt": lesson.reflection_prompt,
        },
        "launchReady": False,
        "gaps": gaps,
    }


def duplicate_candidates(entries: list[dict[str, Any]]) -> dict[str, list[Any]]:
    by_id = Counter(entry["id"] for entry in entries if entry.get("id"))
    foundation = [entry for entry in entries if entry["contentKind"] == "foundation_entry"]
    by_source_ref = Counter(
        (
            entry.get("primarySourceCollectionTitle"),
            entry.get("displayReference"),
        )
        for entry in foundation
        if entry.get("primarySourceCollectionTitle") and entry.get("displayReference")
    )
    by_title = Counter(
        normalize_spacing(entry.get("translationText") or entry.get("id") or "")
        for entry in foundation
        if normalize_spacing(entry.get("translationText") or entry.get("id") or "")
    )
    return {
        "duplicateIds": [key for key, count in by_id.items() if count > 1],
        "duplicateSourceReferences": [
            {"sourceCollectionTitle": key[0], "displayReference": key[1], "count": count}
            for key, count in by_source_ref.items()
            if count > 1
        ],
        "duplicateTranslations": [
            {"normalizedTranslation": key, "count": count}
            for key, count in by_title.items()
            if count > 1
        ][:25],
    }


def metadata_presence_counts(entries: list[dict[str, Any]]) -> dict[str, dict[str, int]]:
    foundation = [entry for entry in entries if entry["contentKind"] == "foundation_entry"]

    def _presence(key: str) -> dict[str, int]:
        present = sum(1 for entry in foundation if entry.get(key))
        return {"present": present, "missing": len(foundation) - present}

    return {
        "arabicText": _presence("arabicText"),
        "translationText": _presence("translationText"),
        "narrator": _presence("narrator"),
        "sourceUrl": _presence("sourceUrl"),
        "sourceReference": _presence("displayReference"),
        "category": _presence("categoryId"),
        "subcategory": _presence("subcategoryId"),
        "quranConnections": {
            "present": sum(1 for entry in foundation if entry.get("quranConnections")),
            "missing": sum(1 for entry in foundation if not entry.get("quranConnections")),
        },
    }


def grouped_counts(entries: list[dict[str, Any]], key: str) -> dict[str, int]:
    foundation = [entry for entry in entries if entry["contentKind"] == "foundation_entry"]
    counter = Counter()
    for entry in foundation:
        value = normalize_spacing(entry.get(key))
        counter[value or "unknown"] += 1
    return dict(sorted(counter.items(), key=lambda item: (-item[1], item[0])))


def readiness_counts(entries: list[dict[str, Any]]) -> dict[str, int]:
    return {
        "launchReadyFoundationEntries": sum(
            1 for entry in entries if entry["contentKind"] == "foundation_entry" and entry["launchReady"]
        ),
        "nonLaunchReadyFoundationEntries": sum(
            1 for entry in entries if entry["contentKind"] == "foundation_entry" and not entry["launchReady"]
        ),
        "legacyCurriculumLessons": sum(
            1 for entry in entries if entry["contentKind"] == "legacy_curriculum_lesson"
        ),
    }


def source_collection_counts(entries: list[dict[str, Any]]) -> dict[str, int]:
    foundation = [entry for entry in entries if entry["contentKind"] == "foundation_entry"]
    counter = Counter()
    for entry in foundation:
        value = normalize_spacing(entry.get("primarySourceCollectionTitle")) or "unknown"
        counter[value] += 1
    return dict(sorted(counter.items(), key=lambda item: (-item[1], item[0])))


def subcategory_counts(entries: list[dict[str, Any]]) -> dict[str, int]:
    foundation = [entry for entry in entries if entry["contentKind"] == "foundation_entry"]
    counter = Counter()
    for entry in foundation:
        value = normalize_spacing(entry.get("subcategoryTitle")) or "unknown"
        counter[value] += 1
    return dict(sorted(counter.items(), key=lambda item: (-item[1], item[0])))


def build_source_inventory(themes: dict[str, LegacyThemeRecord], subcategories: dict[str, LegacySubcategoryRecord], lessons: list[LegacyLessonRecord]) -> list[dict[str, Any]]:
    return [
        {
            "owner": "canonical_runtime_generated_dataset",
            "path": "lib/features/learn/hadith/data/generated_hadith_foundation_data.dart",
            "contentKind": "foundation_entry",
            "recordCount": len(load_master_dataset()),
            "notes": "Canonical runtime Hadith base used through editorialHadithEntriesProvider.",
        },
        {
            "owner": "hadith_pipeline_raw_input",
            "path": "data/hadith/raw/hadith_source_records.json",
            "contentKind": "raw_source_records",
            "recordCount": len(load_master_dataset()),
            "notes": "Structured source-backed raw ingest input for the Hadith pipeline.",
        },
        {
            "owner": "hadith_pipeline_editorial_enrichment",
            "path": "data/hadith/editorial/hadith_editorial_enrichment.json",
            "contentKind": "editorial_enrichment_records",
            "recordCount": len(load_master_dataset()),
            "notes": "Structured editorial metadata layered before release gating.",
        },
        {
            "owner": "hadith_master_dataset_artifact",
            "path": "data/hadith/hadith_master_dataset.json",
            "contentKind": "verified_foundation_entries",
            "recordCount": len(load_master_dataset()),
            "notes": "Trusted pipeline output artifact containing only verified entries.",
        },
        {
            "owner": "legacy_hadith_curriculum",
            "path": "lib/features/learn/hadith/data/hadith_curriculum_data.dart",
            "contentKind": "legacy_curriculum_lessons",
            "recordCount": len(lessons),
            "themeCount": len(themes),
            "subcategoryCount": len(subcategories),
            "notes": "Legacy educational lesson system; not source-verified Hadith runtime content.",
        },
        {
            "owner": "editorial_override_path",
            "path": "lib/features/editorial_dashboard/application/editorial_content_versions_provider.dart",
            "contentKind": "editorial_override_runtime_layer",
            "recordCount": 0,
            "notes": "Supports local editorial overrides, but no repo-stored Hadith override snapshots were found.",
        },
    ]


def build_inventory(entries: list[dict[str, Any]], themes: dict[str, LegacyThemeRecord], subcategories: dict[str, LegacySubcategoryRecord], lessons: list[LegacyLessonRecord]) -> dict[str, Any]:
    represented = list(source_collection_counts(entries).keys())
    present_major = [title for title in MAJOR_COLLECTIONS if title in represented]
    absent_major = [title for title in MAJOR_COLLECTIONS if title not in represented]

    non_launch_ready = [
        {"id": entry["id"], "contentKind": entry["contentKind"], "gaps": entry["gaps"]}
        for entry in entries
        if not entry["launchReady"]
    ]

    return {
        "metadata": {
            "generatedAt": datetime.now(timezone.utc).isoformat(),
            "foundationEntryCount": sum(1 for entry in entries if entry["contentKind"] == "foundation_entry"),
            "legacyLessonCount": sum(1 for entry in entries if entry["contentKind"] == "legacy_curriculum_lesson"),
            "totalNormalizedRecordCount": len(entries),
        },
        "sourceInventory": build_source_inventory(themes, subcategories, lessons),
        "counts": {
            "bySourceCollection": source_collection_counts(entries),
            "byCategory": grouped_counts(entries, "categoryTitle"),
            "bySubcategory": subcategory_counts(entries),
            "byGrade": grouped_counts(entries, "gradeText"),
            "verificationReadiness": readiness_counts(entries),
            "metadataPresence": metadata_presence_counts(entries),
        },
        "duplicates": duplicate_candidates(entries),
        "launchReadyContent": {
            "publicFoundationIds": [
                entry["id"]
                for entry in entries
                if entry["contentKind"] == "foundation_entry" and entry["launchReady"]
            ],
        },
        "nonLaunchReadyContent": non_launch_ready,
        "coverage": {
            "representedMajorCollections": present_major,
            "missingMajorCollections": absent_major,
            "corpusShape": "curated_subset",
            "notes": [
                "Current verified corpus is a curated subset rather than full-book coverage.",
                "Legacy curriculum lessons remain educational/supporting content, not source-verified hadith entries.",
            ],
        },
    }


def render_markdown_report(inventory: dict[str, Any]) -> str:
    counts = inventory["counts"]
    coverage = inventory["coverage"]
    lines = [
        "# Hadith Existing Corpus Inventory",
        "",
        f"- Generated: {inventory['metadata']['generatedAt']}",
        f"- Total normalized records: {inventory['metadata']['totalNormalizedRecordCount']}",
        f"- Verified foundation entries: {inventory['metadata']['foundationEntryCount']}",
        f"- Legacy curriculum lessons: {inventory['metadata']['legacyLessonCount']}",
        "",
        "## Source collections",
    ]
    for key, value in counts["bySourceCollection"].items():
        lines.append(f"- {key}: {value}")
    lines.extend(["", "## Categories"])
    for key, value in counts["byCategory"].items():
        lines.append(f"- {key}: {value}")
    lines.extend(["", "## Subcategories"])
    for key, value in counts["bySubcategory"].items():
        lines.append(f"- {key}: {value}")
    lines.extend(["", "## Grades"])
    for key, value in counts["byGrade"].items():
        lines.append(f"- {key}: {value}")
    lines.extend(["", "## Verification readiness"])
    for key, value in counts["verificationReadiness"].items():
        lines.append(f"- {key}: {value}")
    lines.extend(["", "## Metadata completeness"])
    for key, value in counts["metadataPresence"].items():
        lines.append(f"- {key}: present {value['present']}, missing {value['missing']}")
    lines.extend(["", "## Major collections represented"])
    for item in coverage["representedMajorCollections"]:
        lines.append(f"- {item}")
    lines.extend(["", "## Major collections missing"])
    for item in coverage["missingMajorCollections"]:
        lines.append(f"- {item}")
    lines.extend(["", "## Duplicate / suspicious candidates"])
    duplicates = inventory["duplicates"]
    if not duplicates["duplicateIds"] and not duplicates["duplicateSourceReferences"]:
        lines.append("- None detected in active duplicate-id/source-reference checks.")
    else:
        for item in duplicates["duplicateIds"]:
            lines.append(f"- Duplicate id: {item}")
        for item in duplicates["duplicateSourceReferences"]:
            lines.append(
                f"- Duplicate source reference: {item['sourceCollectionTitle']} {item['displayReference']} ({item['count']})"
            )
    lines.extend(["", "## Launch/public readiness"])
    lines.append(
        f"- Launch/public-ready verified entries: {len(inventory['launchReadyContent']['publicFoundationIds'])}"
    )
    lines.append(f"- Non-launch-ready normalized records: {len(inventory['nonLaunchReadyContent'])}")
    return "\n".join(lines) + "\n"


def main() -> int:
    foundation_entries = [normalize_foundation_entry(entry) for entry in load_master_dataset()]
    themes, subcategories, lessons = load_legacy_curriculum()
    legacy_entries = [
        normalize_legacy_lesson(
            lesson,
            themes.get(lesson.theme_id),
            subcategories.get(lesson.subcategory_id),
        )
        for lesson in lessons
    ]
    entries = sorted(
        [*foundation_entries, *legacy_entries],
        key=lambda item: (item["contentKind"], item["id"] or ""),
    )
    inventory = build_inventory(entries, themes, subcategories, lessons)

    OUTPUT_NORMALIZED_PATH.write_text(
        json.dumps(
            {
                "metadata": inventory["metadata"],
                "entries": entries,
            },
            indent=2,
            ensure_ascii=False,
        )
        + "\n",
        encoding="utf-8",
    )
    OUTPUT_INVENTORY_PATH.write_text(
        json.dumps(inventory, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )
    OUTPUT_REPORT_PATH.write_text(render_markdown_report(inventory), encoding="utf-8")
    print(
        f"Built Hadith corpus inventory with {inventory['metadata']['foundationEntryCount']} verified foundation entries and {inventory['metadata']['legacyLessonCount']} legacy lessons."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
