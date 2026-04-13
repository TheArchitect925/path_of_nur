# Qur'an Translation API Enhancement Backlog

Date: 2026-04-12

## Suggested next enhancements

1. Audit the exact translator/edition names currently surfaced by the local `quran` package so the Phase 1 resource model can preserve user-facing continuity.
2. Build a release-language allowlist document mapping each supported app language to one approved Qur'an translation edition.
3. Add a small internal import prototype for one non-English language first, then compare imported text against the current package output for drift.
4. Decide whether approved translation bundles should ship inside the app binary or be downloaded as managed content packs later.
5. Add source-attribution UI for Qur'an translations similar to the trust-aware posture already emerging in hadith and tafsir-related surfaces.
