# Navigation System Stabilization Audit

Date: 2026-03-23

## Canonical top-level tabs

- `/home`
- `/worship`
- `/learn`
- `/journey`
- `/quran`

## Route ownership direction

- `app_router.dart`
  - shell composition
  - top-level tab ownership
  - redirect / guard orchestration
- `core_support_routes.dart`
  - settings, support, profile compatibility, Qur'an reader/support routes
- `journey_routes.dart`
  - canonical Journey routes and Growth compatibility aliases
- `learn_routes.dart`
  - composition entry point only
- `lib/app/routes/learn/*`
  - feature-owned Learn route clusters

## Learn route clusters

- `learn_core_routes.dart`
  - Qur'an-owned learning entrypoints
  - Learn legacy/journey/explore/history/games/category/family
- `learn_kids_routes.dart`
  - Kids Arabic, Kids Dua, bedtime stories, Seerah, kids wrappers
- `learn_hub_and_quiz_routes.dart`
  - Prophets, Quizzes, Dua hub, Trivia, Salah/Wudu, FAQ, Learn Qur'an aliases
- `learn_content_domain_routes.dart`
  - Life, World, Hadith, Learn notes, content detail, Qur'an universe

## Compatibility routes intentionally retained

- `/learn/browse` -> `/learn/explore`
- `/learn/hub/quran*` -> `/quran*`
- `/learn/hub/prophets` and `/learn/section/prophets` -> `/learn/prophets`
- `/learn/hub/quizzes` and `/learn/section/quizzes` -> `/learn/quizzes`
- `/learn/hub/duas` and `/learn/section/duas` -> `/learn/duas`
- `/learn/section/faq` -> `/learn/faq`
- `/growth/*` and `/journey/tracking` remain Journey compatibility paths in `journey_routes.dart`

## Follow-up candidates

- Decide whether `/learn/legacy` should eventually become a redirect, contained state, or archived compatibility surface.
- Continue trimming hidden `learnLegacy` metadata references once product ownership is finalized.
- Add broader query-preservation tests for compatibility redirects if future cleanup touches more alias families.
