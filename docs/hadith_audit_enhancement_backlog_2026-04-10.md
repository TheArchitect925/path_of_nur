# Hadith Audit Enhancement Backlog

1. Build a single canonical Hadith domain layer so the newer verified foundation dataset and the older curriculum/progress layer stop drifting apart.
2. Add a production Hadith search stack with indexed fields for title, Arabic matn, translation, source collection, source reference, narrator, grading, tags, and theme.
3. Introduce explicit public-default gating so only source-backed, reference-complete, graded entries appear in broad browse, daily, recommendation, and widget surfaces.
4. Add a dedicated Hadith reader polish pass with share, copy, citation-forward metadata, and source-clarity improvements once trust gating is locked.
5. Replace route naming like `hadithLessonDetail` with entry/reader terminology only if migrated carefully with compatibility aliases.
6. Decide whether the old curriculum models should be retired, migrated onto the foundation dataset, or kept as an editorial layer without owning user progress.
7. Add a verified import/build pipeline around `data/hadith/hadith_master_dataset.json` so source-backed content stops depending on manual seed maintenance alone.
8. Expand kids Hadith curation and kids Hadith stories only through the same verified-entry source policy, not a separate trust standard.
9. Add focused regression tests for search indexing, trust gating, route handoff, and saved/daily/detail behavior before a larger Hadith rebuild.
10. Reuse the shared search and deep-linking patterns from Qur'an where they fit, but keep Hadith collection/chapter/reference structure distinct from surah/ayah assumptions.
