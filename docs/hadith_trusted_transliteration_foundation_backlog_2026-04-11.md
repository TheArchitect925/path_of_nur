# Hadith Trusted Transliteration Foundation Backlog

Date: 2026-04-11

## Enhancement options

1. Import the first trusted transliteration source for `Riyad as-Salihin` through `data/hadith/raw/hadith_transliteration_records.json` using the new canonical source-reference key matching.
2. Add a small pipeline check that fails when transliteration import records duplicate the same canonical source-reference key.
3. Add a runtime-only reader status helper that can later distinguish `trusted`, `reviewRequired`, and `missing` transliteration without changing today’s display behavior.
4. Consolidate duplicate-reference entry ownership so one canonical source-reference record can drive all derived themed entries more explicitly.
5. Add CI coverage for the generated transliteration ingestion report so unmatched or manual-review records are visible before merge.
