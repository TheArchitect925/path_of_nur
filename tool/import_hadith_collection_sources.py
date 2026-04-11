from __future__ import annotations

import json
import re
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Any
from urllib.parse import urljoin

import requests
from bs4 import BeautifulSoup, Tag


ROOT = Path(__file__).resolve().parents[1]
TOOL_DIR = Path(__file__).resolve().parent
if str(TOOL_DIR) not in sys.path:
    sys.path.insert(0, str(TOOL_DIR))

from build_hadith_master_dataset import normalize_spacing, slugify  # noqa: E402


RAW_INPUT_PATH = ROOT / "data/hadith/raw/hadith_source_records.json"
EDITORIAL_INPUT_PATH = ROOT / "data/hadith/editorial/hadith_editorial_enrichment.json"
MASTER_DATASET_PATH = ROOT / "data/hadith/hadith_master_dataset.json"

USER_AGENT = "Mozilla/5.0 (Path of Nur Hadith importer)"


@dataclass(frozen=True)
class ImportedHadith:
    source_record_id: str
    source_collection: str
    source_reference: str
    source_url: str
    hadith_number: str
    arabic_text: str
    translation_text: str
    narrator: str | None
    grading: str
    chapter_number: int | None
    chapter_title: str | None
    book_slug: str | None
    collection_slug: str
    title: str
    excerpt: str
    theme_id: str
    theme_tag: str | None
    category_id: str
    category_title: str
    subcategory_id: str
    subcategory_title: str
    donor_entry: dict[str, Any] | None


NAWAWI_THEME_MAP: dict[int, tuple[str, str | None, str, str, str, str]] = {
    1: ("faith_intention", "Faith", "faith", "Faith", "intention_sincerity", "Intention & Sincerity"),
    2: ("faith_intention", "Faith", "faith", "Faith", "intention_sincerity", "Intention & Sincerity"),
    3: ("prayer", "Worship", "worship", "Worship", "prayer_presence", "Prayer & Presence"),
    4: ("death_hereafter", "Hereafter", "hereafter", "Hereafter", "death_hereafter", "Death & Hereafter"),
    5: ("knowledge", "Knowledge", "knowledge", "Knowledge", "knowledge_learning", "Knowledge & Learning"),
    6: ("faith_intention", "Faith", "faith", "Faith", "intention_sincerity", "Intention & Sincerity"),
    7: ("faith_intention", "Faith", "faith", "Faith", "intention_sincerity", "Intention & Sincerity"),
    8: ("faith_intention", "Faith", "faith", "Faith", "intention_sincerity", "Intention & Sincerity"),
    9: ("prayer", "Worship", "worship", "Worship", "prayer_presence", "Prayer & Presence"),
    10: ("prayer", "Worship", "worship", "Worship", "dua_remembrance", "Du'a & Remembrance"),
    11: ("faith_intention", "Faith", "faith", "Faith", "intention_sincerity", "Intention & Sincerity"),
    12: ("character_manners", "Character", "character", "Character", "character_manners", "Character & Manners"),
    13: ("mercy_compassion", "Mercy", "social_ethics", "Social Ethics", "mercy_compassion", "Mercy & Compassion"),
    14: ("justice_trust", "Justice", "social_ethics", "Social Ethics", "justice_trust", "Justice & Trust"),
    15: ("mercy_compassion", "Mercy", "social_ethics", "Social Ethics", "mercy_compassion", "Mercy & Compassion"),
    16: ("patience_gratitude", "Patience", "character", "Character", "patience_gratitude", "Patience & Gratitude"),
    17: ("mercy_compassion", "Mercy", "social_ethics", "Social Ethics", "mercy_compassion", "Mercy & Compassion"),
    18: ("repentance", "Repentance", "character", "Character", "repentance_return", "Repentance & Return"),
    19: ("faith_intention", "Faith", "faith", "Faith", "intention_sincerity", "Intention & Sincerity"),
    20: ("character_manners", "Character", "character", "Character", "character_manners", "Character & Manners"),
    21: ("faith_intention", "Faith", "faith", "Faith", "intention_sincerity", "Intention & Sincerity"),
    22: ("prayer", "Worship", "worship", "Worship", "prayer_presence", "Prayer & Presence"),
    23: ("prayer", "Worship", "worship", "Worship", "prayer_presence", "Prayer & Presence"),
    24: ("justice_trust", "Justice", "social_ethics", "Social Ethics", "justice_trust", "Justice & Trust"),
    25: ("dua_remembrance", "Remembrance", "worship", "Worship", "dua_remembrance", "Du'a & Remembrance"),
    26: ("mercy_compassion", "Mercy", "social_ethics", "Social Ethics", "mercy_compassion", "Mercy & Compassion"),
    27: ("character_manners", "Character", "character", "Character", "character_manners", "Character & Manners"),
    28: ("knowledge", "Knowledge", "knowledge", "Knowledge", "knowledge_learning", "Knowledge & Learning"),
    29: ("prayer", "Worship", "worship", "Worship", "prayer_presence", "Prayer & Presence"),
    30: ("knowledge", "Knowledge", "knowledge", "Knowledge", "knowledge_learning", "Knowledge & Learning"),
    31: ("death_hereafter", "Hereafter", "hereafter", "Hereafter", "death_hereafter", "Death & Hereafter"),
    32: ("justice_trust", "Justice", "social_ethics", "Social Ethics", "justice_trust", "Justice & Trust"),
    33: ("justice_trust", "Justice", "social_ethics", "Social Ethics", "justice_trust", "Justice & Trust"),
    34: ("justice_trust", "Justice", "social_ethics", "Social Ethics", "justice_trust", "Justice & Trust"),
    35: ("mercy_compassion", "Mercy", "social_ethics", "Social Ethics", "mercy_compassion", "Mercy & Compassion"),
    36: ("mercy_compassion", "Mercy", "social_ethics", "Social Ethics", "mercy_compassion", "Mercy & Compassion"),
    37: ("faith_intention", "Faith", "faith", "Faith", "intention_sincerity", "Intention & Sincerity"),
    38: ("prayer", "Worship", "worship", "Worship", "prayer_presence", "Prayer & Presence"),
    39: ("repentance", "Repentance", "character", "Character", "repentance_return", "Repentance & Return"),
    40: ("death_hereafter", "Hereafter", "hereafter", "Hereafter", "death_hereafter", "Death & Hereafter"),
    41: ("faith_intention", "Faith", "faith", "Faith", "intention_sincerity", "Intention & Sincerity"),
    42: ("repentance", "Repentance", "character", "Character", "repentance_return", "Repentance & Return"),
}

RIYAD_BOOK_THEME_MAP: dict[int, tuple[str, str | None, str, str, str, str]] = {
    1: ("character_manners", "Good Manners", "character", "Character", "character_manners", "Character & Manners"),
    2: ("character_manners", "Eating Etiquette", "character", "Character", "character_manners", "Character & Manners"),
    3: ("character_manners", "Dress", "character", "Character", "character_manners", "Character & Manners"),
    4: ("character_manners", "Sleeping", "character", "Character", "character_manners", "Character & Manners"),
    5: ("mercy_compassion", "Greetings", "social_ethics", "Social Ethics", "mercy_compassion", "Mercy & Compassion"),
    6: ("mercy_compassion", "Care", "social_ethics", "Social Ethics", "mercy_compassion", "Mercy & Compassion"),
    7: ("character_manners", "Travel Etiquette", "character", "Character", "character_manners", "Character & Manners"),
    8: ("faith_intention", "Virtues", "faith", "Faith", "intention_sincerity", "Intention & Sincerity"),
    9: ("prayer", "I'tikaf", "worship", "Worship", "prayer_presence", "Prayer & Presence"),
    10: ("prayer", "Hajj", "worship", "Worship", "prayer_presence", "Prayer & Presence"),
    11: ("justice_trust", "Jihad", "social_ethics", "Social Ethics", "justice_trust", "Justice & Trust"),
    12: ("knowledge", "Knowledge", "knowledge", "Knowledge", "knowledge_learning", "Knowledge & Learning"),
    13: ("patience_gratitude", "Gratitude", "character", "Character", "patience_gratitude", "Patience & Gratitude"),
    14: ("dua_remembrance", "Salawat", "worship", "Worship", "dua_remembrance", "Du'a & Remembrance"),
    15: ("dua_remembrance", "Remembrance", "worship", "Worship", "dua_remembrance", "Du'a & Remembrance"),
    16: ("dua_remembrance", "Supplication", "worship", "Worship", "dua_remembrance", "Du'a & Remembrance"),
    17: ("justice_trust", "Prohibitions", "social_ethics", "Social Ethics", "justice_trust", "Justice & Trust"),
    18: ("faith_intention", "Core Values", "faith", "Faith", "intention_sincerity", "Intention & Sincerity"),
    19: ("repentance", "Forgiveness", "character", "Character", "repentance_return", "Repentance & Return"),
}

SOURCE_TITLE_NORMALIZATION = {
    "al-bukhari": "Sahih al-Bukhari",
    "bukhari": "Sahih al-Bukhari",
    "muslim": "Sahih Muslim",
    "al- bukhari": "Sahih al-Bukhari",
    "al-bukhari and muslim": "Sahih al-Bukhari / Sahih Muslim",
    "al- bukhari and muslim": "Sahih al-Bukhari / Sahih Muslim",
    "abu dawud": "Sunan Abi Dawud",
    "abu dawood": "Sunan Abi Dawud",
    "at-tirmidhi": "Jami' al-Tirmidhi",
    "at- tirmidhi": "Jami' al-Tirmidhi",
    "an- nasa'i": "Sunan al-Nasa'i",
    "an-nasa'i": "Sunan al-Nasa'i",
    "malik": "Muwatta Malik",
}


def normalize_collection_title(label: str) -> str:
    normalized = normalize_spacing(label) or label
    return SOURCE_TITLE_NORMALIZATION.get(normalized.lower(), normalized)


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def save_json(path: Path, payload: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(
        json.dumps(payload, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
    )


class SourcePageClient:
    def __init__(self) -> None:
        self.session = requests.Session()
        self.session.headers.update({"User-Agent": USER_AGENT})
        self._cache: dict[str, BeautifulSoup] = {}

    def fetch_soup(self, url: str) -> BeautifulSoup:
        if url not in self._cache:
            response = self.session.get(url, timeout=30)
            response.raise_for_status()
            self._cache[url] = BeautifulSoup(response.text, "html.parser")
        return self._cache[url]


def load_existing_corpus() -> list[dict[str, Any]]:
    return load_json(MASTER_DATASET_PATH)["entries"]


def build_donor_lookup(entries: list[dict[str, Any]]) -> dict[tuple[str, str], dict[str, Any]]:
    lookup: dict[tuple[str, str], dict[str, Any]] = {}
    for entry in entries:
        collection = normalize_spacing(entry.get("sourceCollection")) or ""
        reference = normalize_spacing(entry.get("sourceReference")) or ""
        if collection and reference:
            lookup[(collection.lower(), reference.lower())] = entry
    return lookup


def parse_reference_number(sticky: str) -> str:
    match = re.search(r"(\d+[a-z]?)", sticky, re.IGNORECASE)
    return match.group(1) if match else sticky


def clean_translation_text(container: Tag) -> tuple[str, str | None]:
    narrated = normalize_spacing(
        container.select_one(".hadith_narrated").get_text(" ", strip=True)
        if container.select_one(".hadith_narrated")
        else ""
    )
    details = container.select_one(".text_details")
    if not details:
        return narrated or "", narrated
    details = BeautifulSoup(str(details), "html.parser")
    for node in details.select("a,b,br"):
        node.extract()
    detail_text = normalize_spacing(details.get_text(" ", strip=True)) or ""
    if narrated and detail_text.startswith(narrated):
        detail_text = normalize_spacing(detail_text[len(narrated) :]) or ""
    if narrated and detail_text:
        return f"{narrated} {detail_text}".strip(), narrated
    return detail_text or narrated or "", narrated


def extract_source_citation_label(container: Tag) -> str | None:
    details = container.select_one(".text_details")
    if not details:
        return None
    text = details.get_text(" ", strip=True)
    matches = re.findall(r"\[(.*?)\]", text)
    return normalize_spacing(matches[-1]) if matches else None


def _derive_grade_from_text_evidence(*text_blocks: str | None) -> tuple[str, str | None]:
    evidence = " ".join(normalize_spacing(block) or "" for block in text_blocks if block).strip()
    if not evidence:
        return "", None

    lowered = evidence.lower()
    if (
        "al-bukhari and muslim" in lowered
        or "al- bukhari and muslim" in lowered
        or "bukhari and muslim" in lowered
        or "متفق عليه" in evidence
    ):
        return "Muttafaqun Alayh", "explicit_source_text"
    if (
        "good and sound hadeeth" in lowered
        or "good and sound hadith" in lowered
        or "hasan sahih" in lowered
        or "hasan saheeh" in lowered
        or "حسن صحيح" in evidence
    ):
        return "Hasan Sahih", "explicit_grade_text"
    if (
        re.search(r"\ba hasan \(good\) hadeeth\b", lowered)
        or re.search(r"\ba hasan \(good\) hadith\b", lowered)
        or re.search(r"\ba good hadeeth\b", lowered)
        or re.search(r"\ba good hadith\b", lowered)
        or re.search(r"\bthis hadith is hasan\b", lowered)
        or "حديث حسن" in evidence
    ):
        return "Hasan", "explicit_grade_text"
    if (
        re.search(r"\[\s*muslim\s*\]", lowered)
        or re.search(r"\(\s*muslim\s*\)", lowered)
        or "رواه مسلم" in evidence
        or "في رواية لمسلم" in evidence
        or re.search(r"\[\s*al-\s*bukhari\s*\]", lowered)
        or re.search(r"\[\s*al-bukhari\s*\]", lowered)
        or re.search(r"\[\s*bukhari\s*\]", lowered)
        or "رواه البخاري" in evidence
    ):
        return "Sahih", "explicit_source_text"
    return "", None


def derive_grade_and_source(
    citation_label: str | None,
    source_links: list[str],
    translation_text: str | None,
    arabic_text: str | None,
    client: SourcePageClient,
) -> tuple[str, str | None]:
    citation = (citation_label or "").lower()
    cleaned_links = [urljoin("https://sunnah.com", link) for link in source_links]
    if "al-bukhari and muslim" in citation or "bukhari & muslim" in citation:
        return "Muttafaqun Alayh", None
    if citation in {"muslim", "al-bukhari", "al- bukhari", "bukhari"}:
        return "Sahih", None
    if "hasan sahih" in citation:
        return "Hasan Sahih", None
    if re.search(r"\bhasan\b", citation):
        return "Hasan", None
    if "sound chain" in citation or "authentic isnad" in citation:
        return "Sahih", None
    if cleaned_links:
        source_soup = client.fetch_soup(cleaned_links[0])
        grade_node = source_soup.select_one(".gradetable")
        if grade_node:
            grade_text = normalize_spacing(grade_node.get_text(" ", strip=True)) or ""
            if "hasan sahih" in grade_text.lower():
                return "Hasan Sahih", cleaned_links[0]
            if re.search(r"\bhasan\b", grade_text.lower()):
                return "Hasan", cleaned_links[0]
            if "sahih" in grade_text.lower():
                return "Sahih", cleaned_links[0]
            if "da'if" in grade_text.lower() or "daif" in grade_text.lower():
                return "Weak", cleaned_links[0]
            return grade_text.replace("Grade :", "").strip(), cleaned_links[0]
        if "/bukhari" in cleaned_links[0] or "/muslim" in cleaned_links[0]:
            return "Sahih", cleaned_links[0]
    inferred_grade, _ = _derive_grade_from_text_evidence(citation_label, translation_text, arabic_text)
    if inferred_grade:
        return inferred_grade, cleaned_links[0] if cleaned_links else None
    return "", cleaned_links[0] if cleaned_links else None


def parse_source_links(container: Tag) -> list[str]:
    details = container.select_one(".text_details")
    if not details:
        return []
    links = []
    for anchor in details.select("a[href]"):
        href = anchor.get("href", "")
        if not href or href.startswith("javascript:") or href.startswith("#"):
            continue
        links.append(href)
    return links


def parse_permalink(container: Tag) -> str:
    link = container.select_one(".hadith_reference a[href]")
    if link and link.get("href"):
        return urljoin("https://sunnah.com", link["href"])
    return ""


def build_title(text: str, fallback: str) -> str:
    snippet = normalize_spacing(text) or fallback
    if not snippet:
        return fallback
    sentence = re.split(r"[.!?]", snippet, 1)[0].strip()
    words = sentence.split()
    if len(words) > 10:
        sentence = " ".join(words[:10]).strip()
    return sentence[:90].rstrip(" ,;:") or fallback


def build_excerpt(text: str) -> str:
    cleaned = normalize_spacing(text) or ""
    if len(cleaned) <= 160:
        return cleaned
    return cleaned[:157].rstrip() + "..."


def derive_donor_from_sources(
    source_links: list[str],
    donor_lookup: dict[tuple[str, str], dict[str, Any]],
    client: SourcePageClient,
) -> dict[str, Any] | None:
    for link in source_links:
        url = urljoin("https://sunnah.com", link)
        soup = client.fetch_soup(url)
        reference_text = normalize_spacing(
            soup.select_one(".hadith_reference").get_text(" ", strip=True)
            if soup.select_one(".hadith_reference")
            else ""
        ) or ""
        match = re.search(r"Reference\s*:\s*(.*?)\s+In-book reference", reference_text)
        if not match:
            continue
        reference = normalize_spacing(match.group(1)) or ""
        collection = normalize_collection_title(reference.rsplit(" ", 1)[0])
        number_match = re.search(r"(\d+[a-z]?)$", reference)
        normalized_reference = (
            f"{collection} {number_match.group(1)}" if number_match else reference
        )
        donor = donor_lookup.get((collection.lower(), (number_match.group(1) if number_match else reference).lower()))
        if donor:
            return donor
        donor = donor_lookup.get((collection.lower(), normalized_reference.replace(f"{collection} ", "").lower()))
        if donor:
            return donor
        donor = donor_lookup.get((collection.lower(), normalized_reference.lower()))
        if donor:
            return donor
    return None


def book_taxonomy(
    collection_slug: str,
    hadith_number: int,
    book_number: int | None,
) -> tuple[str, str | None, str, str, str, str]:
    if collection_slug == "nawawi40":
        return NAWAWI_THEME_MAP.get(
            hadith_number,
            ("faith_intention", "Faith", "faith", "Faith", "intention_sincerity", "Intention & Sincerity"),
        )
    if book_number is not None:
        return RIYAD_BOOK_THEME_MAP.get(
            book_number,
            ("faith_intention", "Faith", "faith", "Faith", "intention_sincerity", "Intention & Sincerity"),
        )
    return ("faith_intention", "Faith", "faith", "Faith", "intention_sincerity", "Intention & Sincerity")


def import_collection_page(
    url: str,
    source_collection: str,
    collection_slug: str,
    client: SourcePageClient,
    donor_lookup: dict[tuple[str, str], dict[str, Any]],
) -> list[ImportedHadith]:
    soup = client.fetch_soup(url)
    page_book_number = None
    page_book_title = None
    book_number_node = soup.select_one(".book_page_number")
    book_title_node = soup.select_one(".book_page_english_name")
    if book_number_node:
        try:
            page_book_number = int(book_number_node.get_text(" ", strip=True))
        except ValueError:
            page_book_number = None
    if book_title_node:
        page_book_title = normalize_spacing(book_title_node.get_text(" ", strip=True))

    imported: list[ImportedHadith] = []
    for container in soup.select(".actualHadithContainer"):
        sticky = normalize_spacing(
            container.select_one(".hadith_reference_sticky").get_text(" ", strip=True)
            if container.select_one(".hadith_reference_sticky")
            else ""
        ) or ""
        hadith_number = parse_reference_number(sticky)
        permalink = parse_permalink(container)
        translation_text, narrated_line = clean_translation_text(container)
        arabic_text = normalize_spacing(
            container.select_one(".arabic_hadith_full").get_text(" ", strip=True)
            if container.select_one(".arabic_hadith_full")
            else ""
        ) or ""
        source_links = parse_source_links(container)
        citation_label = extract_source_citation_label(container)
        grading, linked_source_url = derive_grade_and_source(
            citation_label,
            source_links,
            translation_text,
            arabic_text,
            client,
        )
        donor = derive_donor_from_sources(source_links, donor_lookup, client)
        try:
            numeric_hadith_number = int(re.match(r"(\d+)", hadith_number).group(1))  # type: ignore[union-attr]
        except AttributeError:
            numeric_hadith_number = 0
        (
            theme_id,
            theme_tag,
            category_id,
            category_title,
            subcategory_id,
            subcategory_title,
        ) = book_taxonomy(collection_slug, numeric_hadith_number, page_book_number)
        title = build_title(
            donor.get("title") if donor else translation_text,
            f"{source_collection} {hadith_number}",
        )
        excerpt = build_excerpt(translation_text)
        source_url = permalink or linked_source_url or url
        imported.append(
            ImportedHadith(
                source_record_id=f"{collection_slug}:{hadith_number}",
                source_collection=source_collection,
                source_reference=hadith_number,
                source_url=source_url,
                hadith_number=hadith_number,
                arabic_text=arabic_text,
                translation_text=translation_text,
                narrator=narrated_line[:-1] if narrated_line and narrated_line.endswith(":") else narrated_line,
                grading=grading,
                chapter_number=page_book_number,
                chapter_title=page_book_title,
                book_slug=slugify(page_book_title) if page_book_title else None,
                collection_slug=collection_slug,
                title=title,
                excerpt=excerpt,
                theme_id=donor.get("themeId") if donor else theme_id,
                theme_tag=donor.get("themeTag") if donor else theme_tag,
                category_id=donor.get("categoryId") if donor else category_id,
                category_title=donor.get("categoryTitle") if donor else category_title,
                subcategory_id=donor.get("subcategoryId") if donor else subcategory_id,
                subcategory_title=donor.get("subcategoryTitle") if donor else subcategory_title,
                donor_entry=donor,
            )
        )
    return imported


def merge_imports(records: list[ImportedHadith]) -> None:
    raw_payload = load_json(RAW_INPUT_PATH)
    editorial_payload = load_json(EDITORIAL_INPUT_PATH)
    raw_by_id = {item["sourceRecordId"]: item for item in raw_payload["entries"]}
    editorial_by_id = {item["sourceRecordId"]: item for item in editorial_payload["entries"]}

    for record in records:
        raw_by_id[record.source_record_id] = {
            "sourceRecordId": record.source_record_id,
            "sourceCollection": record.source_collection,
            "sourceReference": record.source_reference,
            "sourceUrl": record.source_url,
            "hadithNumbers": [record.hadith_number],
            "arabicText": record.arabic_text,
            "translationText": record.translation_text,
            "transliteration": None,
            "grading": record.grading,
            "narrator": record.narrator,
            "chapterNumber": record.chapter_number,
            "chapterTitle": record.chapter_title,
            "verification": {
                "isVerifiedSource": bool(record.source_collection and record.source_reference and record.source_url and record.grading),
                "isVerifiedText": bool(record.arabic_text),
                "isVerifiedTranslation": bool(record.translation_text),
                "isVerifiedTransliteration": False,
            },
        }
        donor = record.donor_entry or {}
        editorial_by_id[record.source_record_id] = {
            "sourceRecordId": record.source_record_id,
            "preferredEntryId": f"{record.collection_slug}_{slugify(record.hadith_number)}",
            "themeId": record.theme_id,
            "collectionIds": donor.get("collectionIds", []),
            "title": donor.get("title", record.title),
            "excerpt": donor.get("excerpt", record.excerpt),
            "tags": donor.get("tags", []),
            "quranConnections": donor.get("quranConnections", []),
            "meaning": donor.get("meaning", ""),
            "lessons": donor.get("lessons", []),
            "reflectionPrompts": donor.get("reflectionPrompts", []),
            "practiceAction": donor.get("practiceAction", ""),
            "relatedHadithIds": donor.get("relatedHadithIds", []),
            "isDailyEligible": False,
            "difficultyLevel": donor.get("difficultyLevel", "beginner"),
            "themeTag": donor.get("themeTag", record.theme_tag),
            "recommendedDay": donor.get("recommendedDay"),
            "isEssential": record.collection_slug == "nawawi40" or bool(donor.get("isEssential")),
            "categoryId": donor.get("categoryId", record.category_id),
            "categoryTitle": donor.get("categoryTitle", record.category_title),
            "subcategoryId": donor.get("subcategoryId", record.subcategory_id),
            "subcategoryTitle": donor.get("subcategoryTitle", record.subcategory_title),
        }

    raw_payload["entries"] = sorted(raw_by_id.values(), key=lambda item: item["sourceRecordId"])
    raw_payload["metadata"]["recordCount"] = len(raw_payload["entries"])
    raw_payload["metadata"]["source"] = "bootstrap_from_seeded_hadith_entries_plus_verified_collection_imports"
    editorial_payload["entries"] = sorted(
        editorial_by_id.values(),
        key=lambda item: item["sourceRecordId"],
    )
    editorial_payload["metadata"]["recordCount"] = len(editorial_payload["entries"])
    editorial_payload["metadata"]["source"] = "bootstrap_from_seeded_hadith_entries_plus_verified_collection_imports"

    save_json(RAW_INPUT_PATH, raw_payload)
    save_json(EDITORIAL_INPUT_PATH, editorial_payload)


def main() -> int:
    client = SourcePageClient()
    donor_lookup = build_donor_lookup(load_existing_corpus())
    imports = []
    imports.extend(
        import_collection_page(
            "https://sunnah.com/nawawi40",
            "40 Hadith an-Nawawi",
            "nawawi40",
            client,
            donor_lookup,
        )
    )
    for index in range(1, 20):
        imports.extend(
            import_collection_page(
                f"https://sunnah.com/riyadussalihin/{index}",
                "Riyad as-Salihin",
                "riyadussalihin",
                client,
                donor_lookup,
            )
        )

    merge_imports(imports)
    print(f"Imported {len(imports)} collection entries into structured Hadith raw/editorial inputs.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
