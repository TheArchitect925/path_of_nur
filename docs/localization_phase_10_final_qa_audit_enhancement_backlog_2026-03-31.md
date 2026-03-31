# Localization Phase 10 Enhancement Backlog

Date: 2026-03-31

## High-value next improvements

- Add the remaining missing ARB metadata entries, especially `@quranTeachingPracticeRecommendationPhrasesSubtitle`, `@quranTeachingPracticeRecommendationWordsSubtitle`, and the additional metadata entries still missing in `app_de.arb` and `app_ur.arb`.
- Repair placeholder-shape drift in `app_bn.arb`, `app_fa.arb`, `app_fa_AF.arb`, `app_ha.arb`, `app_hi.arb`, `app_id.arb`, `app_ku.arb`, `app_ms.arb`, `app_pa.arb`, and `app_tr.arb` so the validator passes cleanly.
- Replace same-as-English fallback in the broader non-English locales with reviewed real translations, prioritizing active release-visible surfaces before deeper seeded-content sets.
- Add a small repo script or CI check that reports:
  - missing user-facing keys
  - missing metadata keys
  - placeholder mismatches
  - same-as-English counts
- After the validator debt is reduced, run one final manual RTL and large-text spot-check across FAQ, Learn browse, Qur'an helper pages, Salah helper pages, and the kids/family wrapper surfaces.
