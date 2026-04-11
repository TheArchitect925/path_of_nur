# Dua Phase 2 Release Trust Enhancements

Date: 2026-04-10

Recommended follow-ups after the release trust pass:

1. Add a tiny internal trust-audit test that asserts only trusted tiers are used and that excluded/review entries never remain marked core.
2. Build a selector helper for future widgets/daily cards that defaults to `verified_strong` and optionally expands to `verified_general` in richer in-app discovery flows.
3. Revisit the two `needs_review` entries with a scholar-verified grading note if the product wants them surfaced more prominently later.
4. Review whether additional educational guidance entries should move out of the main dua feed into a separate “guidance notes” surface.
5. Add a small “source strength” explainer in a future pass if users will be shown trust tiers directly.
6. Run a focused transliteration consistency pass later across the entire dua corpus once trust/content baselines are settled.
