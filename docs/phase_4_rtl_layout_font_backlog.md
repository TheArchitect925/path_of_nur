# Phase 4 RTL / Layout / Font Backlog

Date: 2026-03-23

## Completed in this pass

- Made shared theme typography locale-aware so Arabic and Urdu can use the RTL UI font path without forcing the Arabic UI font onto English and German.
- Passed the active app locale into the production theme builder.
- Switched the shared page scaffold back affordance to `BackButtonIcon` so it mirrors correctly in RTL.
- Reduced bottom navigation label overflow risk with single-line ellipsis behavior.
- Fixed a clear LTR-only indentation bug in the prophetic family tree card using directional padding.
- Added Urdu coverage to the locale integration regression suite and added theme-level font assertions for `en`, `ar`, and `ur`.
- Fixed a provider teardown hazard in `quranSharedAudioPlayerProvider` by capturing the listening-stats notifier before `onDispose`.

## Enhancement options

1. Audit more LTR-only layout assumptions in lower-priority feature widgets such as older settings rows, chips, and legacy learning cards, then migrate them to directional padding/alignment.
2. Add a shared locale-aware typography helper for places that intentionally need Qur'an Arabic, Arabic-learning, Urdu UI, or Latin UI font selection beyond the global theme.
3. Add focused widget tests for shared directional affordances such as `AppPageScaffold` back buttons and bottom-nav label overflow under German and Arabic.
4. Review mixed-content surfaces like Qur'an search results, verse chips, transliteration-heavy cards, and glossary rows for bidi isolation and text-align consistency.
5. Evaluate whether Urdu should continue sharing `Noto Sans Arabic` for UI or get its own optimized Nastaliq-safe font path in a later controlled typography pass.
6. Run a follow-up visual QA sweep on the highest-traffic screens in Arabic, Urdu, German, and English on small and large phones.

## Remaining known debt

- The app still contains additional `EdgeInsets.only(left: ...)` and similar LTR-first layout assumptions outside the highest-value shared surfaces fixed here.
- This pass did not add a new font system for mixed Qur'an text versus Arabic UI versus Urdu UI; it kept the current intentional split and improved the shared UI branch only.
- Some German long-label risks still depend on manual QA because the app has limited overflow-focused tests outside the bottom-nav path.
