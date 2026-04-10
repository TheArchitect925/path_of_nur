# Production Translation Readiness Audit

Date: 2026-04-08

## Summary

- Supported locale resource files present: 16 total ARB files, including English plus 15 non-English locales.
- Unique untranslated keys still reported by `flutter gen-l10n`: 517.
- Active UI literal-string hotspot matches across `presentation/widgets/pages`: 594 occurrences across 139 files.
- Broader repo literal-string matches including seeded/domain content: 4102 occurrences across 232 files.

## Recommended Phase Plan

1. Localize remaining live user-facing UI on high-traffic routed screens.
2. Remove helper/domain-level English output that can still surface in UI.
3. Close the currently missing untranslated ARB keys across all non-English locales.
4. Replace same-as-English fallback values in release locales on live/high-traffic keys.
5. Finish seeded curriculum/content translation and run multilingual production QA.

## Enhancement Options

- Decide whether the first production translation bar should target all 15 non-English locales equally or prioritize a release locale subset first, then expand.
- Add a repo script that reports per-locale untranslated and same-as-English counts after every localization pass so fallback debt stops silently growing again.
- Add a CI guard for newly introduced hardcoded user-facing strings on routed presentation files.
