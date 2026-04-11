from __future__ import annotations

import importlib.util
import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
MODULE_PATH = ROOT / "tool" / "build_hadith_corpus_inventory.py"
SPEC = importlib.util.spec_from_file_location("hadith_inventory_builder", MODULE_PATH)
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)


class HadithCorpusInventoryBuilderTest(unittest.TestCase):
    def test_load_legacy_curriculum_counts(self) -> None:
        themes, subcategories, lessons = MODULE.load_legacy_curriculum()

        self.assertEqual(len(themes), 9)
        self.assertEqual(len(subcategories), 18)
        self.assertEqual(len(lessons), 36)

    def test_normalize_foundation_entry_is_launch_ready(self) -> None:
        entry = MODULE.load_master_dataset()[0]
        normalized = MODULE.normalize_foundation_entry(entry)

        self.assertEqual(normalized["contentKind"], "foundation_entry")
        self.assertTrue(normalized["launchReady"])
        self.assertTrue(normalized["isVerifiedSource"])
        self.assertTrue(normalized["isVerifiedArabicMatn"])
        self.assertTrue(normalized["isVerifiedTranslation"])
        self.assertIsNotNone(normalized["primarySourceCollectionTitle"])

    def test_normalize_legacy_lesson_marks_gaps_explicitly(self) -> None:
        themes, subcategories, lessons = MODULE.load_legacy_curriculum()
        normalized = MODULE.normalize_legacy_lesson(
            lessons[0],
            themes.get(lessons[0].theme_id),
            subcategories.get(lessons[0].subcategory_id),
        )

        self.assertEqual(normalized["contentKind"], "legacy_curriculum_lesson")
        self.assertFalse(normalized["launchReady"])
        self.assertIn("missing_source_collection", normalized["gaps"])
        self.assertIn("missing_verified_translation", normalized["gaps"])

    def test_build_inventory_matches_current_repo_corpus_shape(self) -> None:
        foundation_entries = [
            MODULE.normalize_foundation_entry(entry)
            for entry in MODULE.load_master_dataset()
        ]
        themes, subcategories, lessons = MODULE.load_legacy_curriculum()
        legacy_entries = [
            MODULE.normalize_legacy_lesson(
                lesson,
                themes.get(lesson.theme_id),
                subcategories.get(lesson.subcategory_id),
            )
            for lesson in lessons
        ]

        inventory = MODULE.build_inventory(
            [*foundation_entries, *legacy_entries],
            themes,
            subcategories,
            lessons,
        )

        self.assertEqual(inventory["metadata"]["foundationEntryCount"], 1192)
        self.assertEqual(inventory["metadata"]["legacyLessonCount"], 36)
        self.assertEqual(
            inventory["counts"]["verificationReadiness"]["launchReadyFoundationEntries"],
            1192,
        )
        self.assertIn("Sahih al-Bukhari", inventory["coverage"]["representedMajorCollections"])
        self.assertIn("Riyad as-Salihin", inventory["coverage"]["representedMajorCollections"])
        self.assertIn("Musnad Ahmad", inventory["coverage"]["missingMajorCollections"])


if __name__ == "__main__":
    unittest.main()
