# Post-Phase Translation Audit

Date: 2026-04-08

## Current state

- Structural missing-key debt is closed.
- `.dart_tool/untranslated-messages-file.json` is empty.
- Translation-quality debt remains very large across both ARB fallback values and hardcoded live UI strings.

## Key findings

- Same-as-English fallback remains high in major domains:
  - `learn`: average `2408.5` same-as-English keys across locales
  - `quran`: average `1340.0`
  - `kids`: average `777.7`
  - `growth`: average `296.6`
  - `editorial`: average `249.0`
  - `onboarding`: average `177.0`
  - `hadith`: average `148.5`
  - `home`: average `133.5`
- Hardcoded live UI strings still remain in active pages and feature flows, especially:
  - Divine Life Lessons
  - World pages
  - Baby Names detail/finder/generator/favorites
  - Growth paths
  - Quran Universe
  - some Salah trainer detail surfaces

## Recommended remaining phases

1. Live hardcoded UI cleanup
2. High-traffic ARB fallback replacement
3. Seeded learning content localization by domain
4. Low-traffic/admin/support surface cleanup
5. Multilingual release QA and overflow/accessibility validation

## Enhancement Options

- Add a route-priority localization dashboard that combines:
  - same-as-English ARB counts
  - hardcoded UI string counts
  - release-surface priority
- Add a localization CI report for top-level routes before release builds.
- Add screenshot QA checklists for long translated locales on Home, Learn, Quran, Worship, and Journey.
