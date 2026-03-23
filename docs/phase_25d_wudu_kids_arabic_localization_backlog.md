# Phase 25D Enhancement Backlog

Last updated: 2026-03-23

## Recommended next enhancements

- Replace the remaining Wudu reward-summary helper bridge in [wudu_localizations.dart](/Users/shahabmansoor/Developer/path_of_nur/lib/features/learn/salah/presentation/wudu_localizations.dart) with generated localization formatting once a small shared plural/conditional pattern is chosen.
- Author real non-English translations for the newly propagated Wudu ARB keys instead of the current English fallback text.
- Author real non-English translations for the newly propagated Kids Arabic ARB keys instead of the current English fallback text.
- Add a narrow localization regression test for Wudu guide body copy and after-wudu dua translation so future content edits cannot fall back to hardcoded English.
- Add a narrow localization regression test for Kids Arabic word-lesson and mastery strings so bridge-free usage stays enforced.
- Audit secondary, non-live Wudu/Kids Arabic helper surfaces and retire any leftover stale localization wrappers that are no longer referenced.
