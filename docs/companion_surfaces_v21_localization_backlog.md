# Companion Surfaces V21 Localization Backlog

Date: 2026-03-23
Topic: Remaining localization debt for live companion surfaces

## Confirmed debt still remaining

- The companion-surface key family currently contains 192 live keys.
- In the audited locale set `ar`, `de`, `hi`, `id`, `tr`, and `ur`, 189 of those keys still use English fallback values rather than real translations.
- The same fallback pattern also exists across the other generated locale files touched by this pass.

## Safe next steps

- Replace English fallback values for the companion-surface key family with real translations in the production locales first:
  - Arabic
  - German
  - Urdu
  - Turkish
  - Indonesian
  - Hindi
- Run a narrow multilingual visual QA on `/learn/seerah`, `/learn/character`, and `/learn/daily-wisdom` after real translations land.
- Audit whether `learnDailyWisdomThemeIntention` should remain as a separate future key or be deprecated later in favor of the currently used `learnDailyWisdomThemeSincerity`.

## Intentionally deferred in V21

- No key deletion or rename for `learnDailyWisdomThemeIntention`.
- No full translation pass.
- No large regrouping of ARB sections beyond the narrow copy cleanup and fallback sync.
