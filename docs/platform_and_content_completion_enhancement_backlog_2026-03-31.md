# Platform and Content Completion Enhancement Backlog

Date: 2026-03-31

## Highest-value next actions

1. Replace the placeholder references in `lib/features/learn/content/data/learn_content_catalog.dart` and `lib/features/learn/content/data/learn_content_data.dart` with structured Qur'an and hadith references using the shared Qur'an-link conventions.
2. Audit the `12` placeholder-tagged items in `lib/features/learn/presentation/data/learn_category_catalog.dart` and decide one by one whether each should be:
   - reclassified as real content
   - upgraded into a fuller owned surface
   - hidden until complete
3. Complete the final `15` planned Dua placeholders only after product curation defines the exact intended entries and trusted source basis.
4. Decide whether launch requires hadith transliteration coverage; if yes, create a verified transliteration workflow for the `88` seeded hadith entries.
5. Run a cleanup pass on unwired kids story source drafts so reference docs do not drift away from the live seeded story implementation.

## Platform hardening options

1. Run the full Apple Watch paired-device checklist in `docs/watch_launch_qa_checklist.md` and record pass/fail evidence in a dated audit doc.
2. Run the tvOS TestFlight checklist in `docs/tvos_testflight_release_checklist_2026-03-25.md` on real Apple TV hardware and record route-by-route QA evidence.
3. Fix the remaining watch archive/icon packaging issue before attempting any watch distribution claim.
4. Re-run localization validation after a dedicated placeholder-mismatch repair pass, especially for `bn`, `fa`, `fa_AF`, `ha`, `hi`, `id`, `ku`, `ms`, `pa`, `tg`, and `tr`.

## Content governance options

1. Add a lightweight content-integrity script that flags placeholder references in live learning datasets so generic placeholders cannot quietly remain in ship-ready catalogs.
2. Add a Learn-catalog audit test that fails if `sectionType: 'placeholder'` appears on visible high-priority learning categories without an approved exception.
3. Add a hadith dataset QA check for verified transliteration coverage so the gap is measured automatically instead of tracked manually.
