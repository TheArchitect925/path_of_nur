# Hadith Reader and Localization Remaining Phases

Date: 2026-04-12

## Remaining work snapshot

The core Hadith reader Phase 3 backlog is complete, and the follow-up enhancement roadmap is now complete as well.

What remains now falls into two groups:

1. No scheduled phases remain in this roadmap
2. Future follow-up now lives in the enhancement backlog only

## Recommended remaining phases

### Phase 1: Reader Regression Coverage

- Add a focused widget test that taps the reader subcategory chip
- Add a focused widget test that taps the source chapter row
- Add a compact-vs-reader share length budget test so the split formatter stays intentional

### Phase 2: Shared Feedback and Reader Polish

Status: completed 2026-04-12

- Extend the shared transient feedback helper to support warning state in addition to success
- Add a future-safe comparison test for compact share output vs full reader share output
- Keep the current reader layout stable while tightening reuse for other sacred-reading surfaces

### Phase 3: Provenance and Chapter Context Upgrade

Status: completed 2026-04-12

- Add a lightweight “why this source is trusted” explainer entry point behind the provenance row
- Add chapter-position context such as “Hadith 3 of 18 in this chapter” when the data is available
- Preserve the canonical source and chapter route ownership already established

### Phase 4: Search and Metadata Readiness

Status: completed 2026-04-12

- Prepare lightweight reusable indexing metadata for narrator and chapter labels if Hadith discovery expands later
- Keep this reuse inside the shared search/indexing system rather than creating a second search path
- Limit this phase to metadata/index readiness unless product asks for a new visible search surface

### Phase 5: Localization Safety Net

Status: completed 2026-04-12

- Add a lightweight regression test for missing non-English localization keys
- Add a focused audit script that reports same-as-English fallback keys by surface group
- Add a small allowlist for intentional same-as-English product terms
- Add a placeholder-only exception so structurally neutral strings such as `{reference} • {grade}` do not get flagged as real debt

### Phase 6: Translation Pipeline Hardening

Status: completed 2026-04-12

- Add ICU-placeholder protection for machine-assisted translation passes so placeholders like `{count}` and `{surah}` cannot be translated or dropped
- Consider a small recently-touched localization scope tracker for future passes
- Keep this phase tooling-only and avoid reopening already translated product copy

## Total remaining phases

We needed `6` phases in the full roadmap, and Phases 1, 2, 3, 4, 5, and 6 are now all completed.

## Recommended execution order

All planned phases in this roadmap are complete.

## Why this order

- The completed order protected shipped reader behavior first, hardened localization guardrails next, and finished with the search/index metadata pass after the user-facing reader changes had stabilized.
