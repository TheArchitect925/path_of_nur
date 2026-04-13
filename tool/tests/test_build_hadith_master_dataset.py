from __future__ import annotations

import importlib.util
import sys
import unittest
from pathlib import Path


ROOT = Path(__file__).resolve().parents[2]
MODULE_PATH = ROOT / "tool" / "build_hadith_master_dataset.py"
SPEC = importlib.util.spec_from_file_location("hadith_builder", MODULE_PATH)
assert SPEC and SPEC.loader
MODULE = importlib.util.module_from_spec(SPEC)
sys.modules[SPEC.name] = MODULE
SPEC.loader.exec_module(MODULE)


class HadithBuilderTest(unittest.TestCase):
    def test_generate_entry_id_prefers_editorial_id(self) -> None:
        raw = MODULE.RawHadithRecord(
            source_record_id="seed_1",
            source_collection="Sahih al-Bukhari",
            source_reference="1",
            source_url="https://sunnah.com/bukhari:1",
            hadith_numbers=["1"],
            arabic_text="arabic",
            translation_text="translation",
            transliteration=None,
            grading="Sahih",
            narrator="Umar ibn al-Khattab (ra)",
            chapter_number=None,
            chapter_title=None,
            verification=MODULE.RawVerification(
                is_verified_source=True,
                is_verified_text=True,
                is_verified_translation=True,
                is_verified_transliteration=False,
            ),
        )
        editorial = MODULE.EditorialHadithRecord(
            source_record_id="seed_1",
            preferred_entry_id="intentions_core",
            theme_id="faith_intention",
            collection_ids=["essential_40"],
            title="Actions Are by Intentions",
            excerpt="excerpt",
            tags=["intentions"],
            quran_connections=[],
            meaning="meaning",
            lessons=["lesson"],
            reflection_prompts=["prompt"],
            practice_action="practice",
            related_hadith_ids=[],
            is_daily_eligible=True,
            difficulty_level="beginner",
            theme_tag=None,
            recommended_day=None,
            is_essential=True,
            category_id=None,
            category_title=None,
            subcategory_id=None,
            subcategory_title=None,
        )

        self.assertEqual(MODULE.generate_entry_id(raw, editorial), "intentions_core")

    def test_build_canonical_record_normalizes_source_and_taxonomy(self) -> None:
        raw = MODULE.RawHadithRecord(
            source_record_id="seed_2",
            source_collection="Sahih al-Bukhari / Sahih Muslim",
            source_reference="Book 47, Hadith 8",
            source_url="https://example.test/8",
            hadith_numbers=[],
            arabic_text="arabic",
            translation_text="translation",
            transliteration="translit",
            grading="muttafaqun alayh",
            narrator="Al-Nu'man ibn Bashir (ra)",
            chapter_number=None,
            chapter_title=None,
            verification=MODULE.RawVerification(
                is_verified_source=True,
                is_verified_text=True,
                is_verified_translation=True,
                is_verified_transliteration=True,
            ),
        )
        editorial = MODULE.EditorialHadithRecord(
            source_record_id="seed_2",
            preferred_entry_id="lawful_unlawful_clear",
            theme_id="faith_intention",
            collection_ids=["essential_40"],
            title="The Lawful Is Clear",
            excerpt="excerpt",
            tags=["halal"],
            quran_connections=[],
            meaning="meaning",
            lessons=["lesson"],
            reflection_prompts=["prompt"],
            practice_action="practice",
            related_hadith_ids=[],
            is_daily_eligible=False,
            difficulty_level="beginner",
            theme_tag=None,
            recommended_day=None,
            is_essential=True,
            category_id=None,
            category_title=None,
            subcategory_id=None,
            subcategory_title=None,
        )

        canonical = MODULE.build_canonical_record(raw, editorial)
        payload = canonical.payload

        self.assertEqual(payload["sourceCollectionId"], "sahih_al_bukhari")
        self.assertEqual(payload["sourceCollectionTitle"], "Sahih al-Bukhari")
        self.assertEqual(payload["sourceHadithNumbers"], ["8"])
        self.assertEqual(payload["sourceChapterNumber"], 47)
        self.assertEqual(payload["sourceChapterTitle"], "Book 47")
        self.assertEqual(
            payload["sourceReferenceKey"],
            "sahih_al_bukhari__book_47_hadith_8",
        )
        self.assertEqual(payload["grading"], "Muttafaqun Alayh")
        self.assertEqual(payload["narrator"], "Al-Nu'man ibn Bashir")
        self.assertEqual(payload["categoryId"], "faith")
        self.assertEqual(payload["subcategoryId"], "intention_sincerity")

    def test_build_dataset_applies_trusted_transliteration_by_reference_key(self) -> None:
        raw = MODULE.RawHadithRecord(
            source_record_id="seed_4",
            source_collection="Sahih Muslim",
            source_reference="2699",
            source_url="https://sunnah.com/muslim:2699",
            hadith_numbers=["2699"],
            arabic_text="arabic",
            translation_text="translation",
            transliteration=None,
            grading="Sahih",
            narrator="Abu Hurayrah",
            chapter_number=None,
            chapter_title=None,
            verification=MODULE.RawVerification(
                is_verified_source=True,
                is_verified_text=True,
                is_verified_translation=True,
                is_verified_transliteration=False,
            ),
        )
        editorial = MODULE.EditorialHadithRecord(
            source_record_id="seed_4",
            preferred_entry_id="relieve_believer_hardship",
            theme_id="mercy_compassion",
            collection_ids=["essential_40"],
            title="Whoever Relieves a Believer's Hardship",
            excerpt="excerpt",
            tags=[],
            quran_connections=[],
            meaning="meaning",
            lessons=["lesson"],
            reflection_prompts=["prompt"],
            practice_action="practice",
            related_hadith_ids=[],
            is_daily_eligible=False,
            difficulty_level="beginner",
            theme_tag=None,
            recommended_day=None,
            is_essential=False,
            category_id=None,
            category_title=None,
            subcategory_id=None,
            subcategory_title=None,
        )
        transliteration = MODULE.TransliterationImportRecord(
            source_reference_key="sahih_muslim__2699",
            source_collection="Sahih Muslim",
            source_reference="2699",
            transliteration_text="man naffasa 'an mu'minin kurbatan",
            transliteration_source="trusted_manual_export",
            quality_status="trusted",
            review_status="approved",
            reviewed_at="2026-04-11",
        )

        entries, _, report = MODULE.build_dataset([raw], [editorial], [transliteration])

        self.assertEqual(len(entries), 1)
        self.assertEqual(entries[0]["transliteration"], "man naffasa 'an mu'minin kurbatan")
        self.assertEqual(entries[0]["transliterationSource"], "trusted_manual_export")
        self.assertEqual(entries[0]["transliterationStatus"], "trusted")
        self.assertEqual(entries[0]["transliterationReviewStatus"], "approved")
        self.assertTrue(entries[0]["transliterationSourceVerified"])
        self.assertEqual(report.matched_entries, 1)
        self.assertEqual(report.matched_reference_groups, 1)
        self.assertEqual(report.derivative_entries_reused, 0)

    def test_release_gate_rejects_missing_verification(self) -> None:
        raw = MODULE.RawHadithRecord(
            source_record_id="seed_3",
            source_collection="Sahih Muslim",
            source_reference="55",
            source_url="",
            hadith_numbers=["55"],
            arabic_text="arabic",
            translation_text="translation",
            transliteration=None,
            grading="Sahih",
            narrator=None,
            chapter_number=None,
            chapter_title=None,
            verification=MODULE.RawVerification(
                is_verified_source=False,
                is_verified_text=False,
                is_verified_translation=False,
                is_verified_transliteration=False,
            ),
        )
        editorial = MODULE.EditorialHadithRecord(
            source_record_id="seed_3",
            preferred_entry_id="religion_sincerity",
            theme_id="faith_intention",
            collection_ids=["essential_40"],
            title="Religion Is Sincerity",
            excerpt="excerpt",
            tags=[],
            quran_connections=[],
            meaning="meaning",
            lessons=["lesson"],
            reflection_prompts=["prompt"],
            practice_action="practice",
            related_hadith_ids=[],
            is_daily_eligible=False,
            difficulty_level="beginner",
            theme_tag=None,
            recommended_day=None,
            is_essential=False,
            category_id=None,
            category_title=None,
            subcategory_id=None,
            subcategory_title=None,
        )

        canonical = MODULE.build_canonical_record(raw, editorial)
        failures = MODULE.release_gate_failures(canonical)

        self.assertIn("missing_source_url", failures)
        self.assertIn("unverified_source", failures)
        self.assertIn("unverified_text", failures)
        self.assertIn("unverified_translation", failures)

    def test_generated_dart_uses_dart_null_for_nullable_numbers(self) -> None:
        rendered = MODULE.build_generated_dart(
            [
                {
                    "id": "test_entry",
                    "themeId": "faith_intention",
                    "collectionIds": ["essential_40"],
                    "title": "Title",
                    "excerpt": "Excerpt",
                    "hadithText": "Translation",
                    "englishText": "Translation",
                    "arabicText": "Arabic",
                    "transliteration": None,
                    "sourceReferenceKey": "sahih_al_bukhari__1",
                    "transliterationSource": None,
                    "transliterationStatus": "missing",
                    "transliterationReviewStatus": "notReviewed",
                    "transliterationReviewedAt": None,
                    "sourceUrl": "https://example.test/1",
                    "translationSourceVerified": True,
                    "arabicMatnSourceVerified": True,
                    "transliterationSourceVerified": False,
                    "source": "Sahih al-Bukhari 1",
                    "sourceCollection": "Sahih al-Bukhari",
                    "sourceReference": "1",
                    "grading": "Sahih",
                    "narrator": "Umar ibn al-Khattab",
                    "sourceCollectionIds": ["sahih_al_bukhari"],
                    "sourceCollectionId": "sahih_al_bukhari",
                    "sourceCollectionTitle": "Sahih al-Bukhari",
                    "sourceChapterId": None,
                    "sourceChapterTitle": None,
                    "sourceChapterNumber": None,
                    "sourceHadithNumbers": ["1"],
                    "sourceImportSource": "hadith_master_dataset",
                    "categoryId": "faith",
                    "categoryTitle": "Faith",
                    "subcategoryId": "intention_sincerity",
                    "subcategoryTitle": "Intention & Sincerity",
                    "tags": ["Intention"],
                    "quranConnections": [],
                    "meaning": "Meaning",
                    "lessons": ["Lesson"],
                    "reflectionPrompts": ["Prompt"],
                    "practiceAction": "Practice",
                    "relatedHadithIds": [],
                    "isDailyEligible": False,
                    "difficultyLevel": "beginner",
                    "themeTag": None,
                    "recommendedDay": None,
                    "isEssential": True,
                }
            ]
        )

        self.assertIn("sourceChapterNumber: null,", rendered)
        self.assertNotIn("sourceChapterNumber: None,", rendered)
        self.assertIn("transliterationStatus: HadithTransliterationStatus.missing,", rendered)

    def test_conflicting_transliteration_imports_are_quarantined_for_review(self) -> None:
        raw_a = MODULE.RawHadithRecord(
            source_record_id="seed_a",
            source_collection="Sahih Muslim",
            source_reference="2699",
            source_url="https://sunnah.com/muslim:2699",
            hadith_numbers=["2699"],
            arabic_text="arabic",
            translation_text="translation",
            transliteration=None,
            grading="Sahih",
            narrator=None,
            chapter_number=None,
            chapter_title=None,
            verification=MODULE.RawVerification(
                is_verified_source=True,
                is_verified_text=True,
                is_verified_translation=True,
                is_verified_transliteration=False,
            ),
        )
        raw_b = MODULE.RawHadithRecord(
            source_record_id="seed_b",
            source_collection="Sahih Muslim",
            source_reference="2699",
            source_url="https://sunnah.com/muslim:2699",
            hadith_numbers=["2699"],
            arabic_text="arabic",
            translation_text="translation",
            transliteration=None,
            grading="Sahih",
            narrator=None,
            chapter_number=None,
            chapter_title=None,
            verification=MODULE.RawVerification(
                is_verified_source=True,
                is_verified_text=True,
                is_verified_translation=True,
                is_verified_transliteration=False,
            ),
        )
        editorial_a = MODULE.EditorialHadithRecord(
            source_record_id="seed_a",
            preferred_entry_id="entry_a",
            theme_id="justice_trust",
            collection_ids=["essential_40"],
            title="Entry A",
            excerpt="excerpt",
            tags=[],
            quran_connections=[],
            meaning="meaning",
            lessons=["lesson"],
            reflection_prompts=["prompt"],
            practice_action="practice",
            related_hadith_ids=[],
            is_daily_eligible=False,
            difficulty_level="beginner",
            theme_tag=None,
            recommended_day=None,
            is_essential=False,
            category_id=None,
            category_title=None,
            subcategory_id=None,
            subcategory_title=None,
        )
        editorial_b = MODULE.EditorialHadithRecord(
            source_record_id="seed_b",
            preferred_entry_id="entry_b",
            theme_id="knowledge",
            collection_ids=["beginner_set"],
            title="Entry B",
            excerpt="excerpt",
            tags=[],
            quran_connections=[],
            meaning="meaning",
            lessons=["lesson"],
            reflection_prompts=["prompt"],
            practice_action="practice",
            related_hadith_ids=[],
            is_daily_eligible=False,
            difficulty_level="beginner",
            theme_tag=None,
            recommended_day=None,
            is_essential=False,
            category_id=None,
            category_title=None,
            subcategory_id=None,
            subcategory_title=None,
        )
        import_a = MODULE.TransliterationImportRecord(
            source_reference_key="sahih_muslim__2699",
            source_collection="Sahih Muslim",
            source_reference="2699",
            transliteration_text="text one",
            transliteration_source="trusted_source_a",
            quality_status="trusted",
            review_status="approved",
            reviewed_at=None,
        )
        import_b = MODULE.TransliterationImportRecord(
            source_reference_key="sahih_muslim__2699",
            source_collection="Sahih Muslim",
            source_reference="2699",
            transliteration_text="text two",
            transliteration_source="trusted_source_b",
            quality_status="trusted",
            review_status="approved",
            reviewed_at=None,
        )

        entries, _, report = MODULE.build_dataset(
            [raw_a, raw_b],
            [editorial_a, editorial_b],
            [import_a, import_b],
        )

        self.assertEqual(entries[0]["transliteration"], None)
        self.assertEqual(entries[1]["transliteration"], None)
        self.assertIn("sahih_muslim__2699", report.conflicting_import_records)
        self.assertIn("sahih_muslim__2699", report.review_required_records)
        self.assertEqual(report.matched_entries, 0)
        self.assertEqual(report.derivative_entries_reused, 0)
        self.assertTrue(
            any(
                item["referenceKey"] == "sahih_muslim__2699"
                and item["status"] == "needs_review"
                for item in report.review_queue
            )
        )

    def test_rejected_transliteration_import_is_not_applied(self) -> None:
        raw = MODULE.RawHadithRecord(
            source_record_id="seed_reject",
            source_collection="Sahih Muslim",
            source_reference="482",
            source_url="https://sunnah.com/muslim:482",
            hadith_numbers=["482"],
            arabic_text="arabic",
            translation_text="translation",
            transliteration=None,
            grading="Sahih",
            narrator=None,
            chapter_number=None,
            chapter_title=None,
            verification=MODULE.RawVerification(
                is_verified_source=True,
                is_verified_text=True,
                is_verified_translation=True,
                is_verified_transliteration=False,
            ),
        )
        editorial = MODULE.EditorialHadithRecord(
            source_record_id="seed_reject",
            preferred_entry_id="closest_in_sujud",
            theme_id="prayer",
            collection_ids=["prayer_devotion"],
            title="Closest in Sujud",
            excerpt="excerpt",
            tags=[],
            quran_connections=[],
            meaning="meaning",
            lessons=["lesson"],
            reflection_prompts=["prompt"],
            practice_action="practice",
            related_hadith_ids=[],
            is_daily_eligible=False,
            difficulty_level="beginner",
            theme_tag=None,
            recommended_day=None,
            is_essential=False,
            category_id=None,
            category_title=None,
            subcategory_id=None,
            subcategory_title=None,
        )
        rejected = MODULE.TransliterationImportRecord(
            source_reference_key="sahih_muslim__482",
            source_collection="Sahih Muslim",
            source_reference="482",
            transliteration_text="aqrabu ma yakunu",
            transliteration_source="trusted_source",
            quality_status="trusted",
            review_status="rejected",
            reviewed_at=None,
        )

        entries, _, report = MODULE.build_dataset([raw], [editorial], [rejected])

        self.assertIsNone(entries[0]["transliteration"])
        self.assertIn("sahih_muslim__482", report.rejected_records)
        self.assertIn("sahih_muslim__482", report.manual_review_records)


if __name__ == "__main__":
    unittest.main()
