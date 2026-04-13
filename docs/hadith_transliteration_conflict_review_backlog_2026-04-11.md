# Hadith Transliteration Conflict Review Backlog

Date: 2026-04-11

## Enhancement options

1. Add a source-evaluation matrix artifact for Riyad as-Salihin candidates so curators can compare trust level, licensing posture, coverage, and reference-shape fit before import.
2. Add a focused `--transliteration-report-only` builder mode for faster curator iterations when runtime Dart regeneration is not needed.
3. Split the review queue into per-source files once a real Riyad import lands, so curators do not have to scan the full global queue for one source family.
4. Add a tiny summary markdown export beside the JSON/CSV outputs for non-technical review sessions.
5. Add CI assertions for conflict/rejected/import-review counts once the first trusted transliteration source is committed.
