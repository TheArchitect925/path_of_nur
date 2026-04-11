from __future__ import annotations

import importlib.util
import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
MODULE_PATH = ROOT / "tool" / "import_hadith_collection_sources.py"
SPEC = importlib.util.spec_from_file_location("hadith_collection_importer", MODULE_PATH)
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)


class HadithCollectionImporterTest(unittest.TestCase):
    def test_nawawi_theme_map_covers_all_collection_numbers(self) -> None:
        self.assertEqual(sorted(MODULE.NAWAWI_THEME_MAP.keys()), list(range(1, 43)))

    def test_riyad_book_map_covers_all_books(self) -> None:
        self.assertEqual(sorted(MODULE.RIYAD_BOOK_THEME_MAP.keys()), list(range(1, 20)))

    def test_generated_raw_inputs_now_include_nawawi_and_riyad_records(self) -> None:
        raw_payload = MODULE.load_json(MODULE.RAW_INPUT_PATH)
        ids = {entry["sourceRecordId"] for entry in raw_payload["entries"]}

        self.assertIn("nawawi40:1", ids)
        self.assertIn("riyadussalihin:680", ids)

    def test_grade_derivation_handles_common_trusted_citation_patterns(self) -> None:
        client = MODULE.SourcePageClient()
        grade, linked = MODULE.derive_grade_and_source(
            "Al-Bukhari and Muslim",
            [],
            "",
            "",
            client,
        )
        self.assertEqual(grade, "Muttafaqun Alayh")
        self.assertIsNone(linked)

        grade, _ = MODULE.derive_grade_and_source(
            "At-Tirmidhi, who classified it as Hasan Sahih",
            [],
            "",
            "",
            client,
        )
        self.assertEqual(grade, "Hasan Sahih")

    def test_grade_derivation_recovers_explicit_text_evidence_without_source_links(self) -> None:
        client = MODULE.SourcePageClient()

        grade, _ = MODULE.derive_grade_and_source(
            None,
            [],
            "It was related by at-Tirmidhi, who said it was a good and sound hadith.",
            "",
            client,
        )
        self.assertEqual(grade, "Hasan Sahih")

        grade, _ = MODULE.derive_grade_and_source(
            None,
            [],
            "",
            "رواه البخاري ومسلم متفق عليه",
            client,
        )
        self.assertEqual(grade, "Muttafaqun Alayh")

        grade, _ = MODULE.derive_grade_and_source(
            None,
            [],
            "",
            "هذا حديث حسن",
            client,
        )
        self.assertEqual(grade, "Hasan")


if __name__ == "__main__":
    unittest.main()
