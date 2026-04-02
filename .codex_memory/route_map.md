# Route Map

Last updated: 2026-03-24

## Canonical top-level tabs

- `/worship`
- `/learn`
  - current primary destination is `LearningSectionLandingPage`
- `/home`
- `/journey`
  - current page is `JourneyPage` -> `GrowthHomePage` section landing
- `/quran`
  - current page is `QuranAppHubPage`

## Router ownership notes

- `lib/app/app_router.dart`
  - shell composition, top-level tab pages, redirect orchestration
- `lib/app/routes/router_policies.dart`
  - child-learning restriction policy and Qur'an-location tab policy helpers
- `lib/app/routes/learn_routes.dart`
  - composition entry point only
- `lib/app/routes/learn/learn_core_routes.dart`
  - canonical Qur'an learning entrypoints, Learn legacy/journey/explore/history/games/category/family
- `lib/app/routes/learn/learn_kids_routes.dart`
  - kids-family route cluster
- `lib/app/routes/learn/learn_hub_and_quiz_routes.dart`
  - hub/alias/quizzes/salah/wudu/faq cluster
- `lib/app/routes/learn/learn_content_domain_routes.dart`
  - Life, World, Hadith, Learn Notes, content detail, Qur'an-adjacent domain routes

## Startup / access control routes

- `/onboarding`
- `/profiles/launch`
  - shared-device profile picker launch gate

## Settings / support canonical routes

- `/settings`
- `/settings/account-sync`
- `/settings/appearance`
- `/settings/prayer-worship`
- `/settings/learning`
- `/settings/notifications-reminders`
- `/settings/widgets-watch`
- `/settings/language-downloads`
- `/settings/privacy-data`
- `/settings/kids-family`
- `/settings/about`
- `/settings/summary`
- `/settings/whats-new`
- `/settings/coming-soon`
- `/salah-times`
- `/legal/privacy`
- `/legal/terms`
- `/legal/support`
- `/legal/attributions`
- `/internal/editorial`
- `/internal/editorial/pin`
- `/internal/editorial/content/:contentType`
- `/internal/editorial/content/:contentType/edit?id=...`

## Canonical accounts / sync routes

- `/accounts-sync`
- `/accounts-sync/profiles`
- `/accounts-sync/accounts`
- `/accounts-sync/shared-device`
- `/accounts-sync/devices`
- `/accounts-sync/backup`
- `/accounts-sync/backup/export`
- `/accounts-sync/backup/import`
- `/accounts-sync/sync-details`

## Canonical Qur'an ownership routes

- `/quran`
- `/quran/learning`
- `/quran/daily`
- `/quran/knowledge-search`
- `/quran/insights`
- `/quran/insights/paths`
- `/quran/arabic`
- `/quran/arabic/module/:moduleId`
- `/quran/arabic/module/:moduleId/lesson/:lessonId`
- `/quran/arabic/words`
- `/quran/arabic/review`
- `/quran/arabic/readiness`
- `/quran/arabic/short-surahs`
- `/quran/arabic/guided-passages`
- `/quran/focus-recitation`
- `/learn/kids/arabic`
- `/learn/kids/arabic/quran-readiness`
- `/learn/kids/arabic/short-surahs`
- `/learn/kids/arabic/guided-passages`
- `/quran/insights/paths/:pathId`
- `/quran/insights/:domainId`
- `/quran/surah-insights`
- `/quran/surah/:surahNumber/insights`
- `/quran/arabic`
- `/quran/explorer`
- `/quran/surah/:surahNumber`
- `/quran/bookmarks`
- `/quran/notes`
- `/quran/reflections`
- `/quran/search`
- `/quran/topics`
- `/quran/topics/:topicId`
- `/quran/names-of-allah`
- `/quran/top-words`
- `/quran/word-review`
- `/quran-verse`

## Learn routes still in active use

### Journey-first learn surfaces

- `/learn/learning-journey`
  - lightweight Learning Journey island page that now owns the Learn-hub journey summary block
- `/learn/journey-home`
  - still active, but not the preferred default for new “explore all” or broad discovery entry points
- `/learn/island/:islandId`
- `/learn/journey/:journeyId`
- `/learn/journey/:journeyId/stage/:stageId`
- `/learn/explore`
  - canonical Explore All Knowledge route
- `/learn/browse`
  - compatibility alias for `/learn/explore`; keep for older tool links only
- `/learn/games`
- `/learn/quizzes`
- `/learn/quizzes/trivia`
- `/learn/salah`
- `/learn/paths/:pathId`
- `/learn/games/:sectionId`
- `/learn/category/:categoryId`
- `/learn/family`
- `/learn/seerah`
- `/learn/character`
- `/learn/daily-wisdom`
- `/learn/kids/games`
- `/learn/kids/arabic`
- `/learn/kids/arabic/progress`
- `/learn/kids/arabic/practice`
- `/learn/kids/arabic/words`
- `/learn/kids/arabic/phrases`
- `/learn/kids/arabic/words/reading`
- `/learn/kids/arabic/words/:wordId`
- `/learn/kids/arabic/lesson/:letterId`
- `/learn/kids/arabic/review`
- `/learn/kids/arabic/rewards`
- `/learn/kids/arabic/parent`
- `/learn/kids/arabic/parent/settings`
- `/learn/kids/arabic/coloring`
- `/learn/kids/arabic/coloring/:pageId`
- `/learn/kids/arabic-learning`
- `/learn/kids/quran`
- `/learn/kids/quran/surah/:surahNumber`
- `/learn/kids/hadith`
- `/learn/kids/hadith-stories`
- `/learn/kids/hadith-stories/:storyId`
- `/learn/kids/prophet-stories`
- `/learn/kids/fun-learning`
  - `/learn/kids/quran-insights`
  - `/learn/kids/stories`
  - `/learn/kids/stories/:storyId`
  - `/learn/kids/stories/:storyId/quiz`
  - `/learn/kids/stories/:storyId/memory`
  - `/learn/kids/progression`
  - `/learn/kids/seerah`
  - `/learn/kids/seerah/:journeyId`
  - `/learn/kids/seerah/:journeyId/node/:nodeId`
  - `/learn/kids/bedtime-stories`
  - `/learn/kids/bedtime-stories/companion`
  - `/learn/kids/bedtime-stories/family`
  - `/learn/kids/bedtime-stories/parents`
  - `/learn/kids/bedtime-stories/:storyId`
  - `/learn/kids/bedtime-stories/:storyId/quiz`
  - `/learn/kids/bedtime-stories/:storyId/memory`

### Legacy or secondary learn hubs still wired

- `/learn/legacy`
  - hidden compatibility surface only; retained for older library-style catalog entries and Learning Journey metadata
  - after V6, only unresolved hidden catalog items such as `jummah`, `eid`, and `funeral` plus visible journey/lesson fallback tools still depend on it
- `/learn/notes`
- `/learn/notes/browse`
- `/journal`
- `/journal/create`
- `/journal/entry/:entryId`
  - canonical personal writing routes; Learn Notes and Journal timeline should open specific journal items through `/journal/entry/:entryId`
- `/learn/hub/quran`
  - compatibility redirect for Qur'an-owned `/quran`
- `/learn/hub/quran/learning`
  - compatibility redirect for `/quran/learning`
- `/learn/hub/quranic-arabic`
  - compatibility redirect for `/quran/arabic`
- `/learn/hub/trivia`
  - compatibility redirect for `/learn/quizzes/trivia`
- `/learn/hub/trivia/paths`
- `/learn/hub/trivia/paths/:pathId`
- `/learn/hub/trivia/paths/:pathId/stages/:stageId`
- `/learn/hub/trivia/session`
- `/learn/hub/trivia/results`
- `/learn/hub/trivia/review`
- `/learn/hub/trivia/stats`
  - compatibility redirects for `/learn/quizzes/trivia/*`
- `/learn/hub/salah`
  - compatibility redirect for `/learn/salah`
- `/learn/section/salah`
  - compatibility redirect for `/learn/salah`
- `/learn/quizzes/crossword`
- `/learn/quizzes/crossword/pack/:packId`
- `/learn/quizzes/crossword/daily`
- `/learn/quizzes/crossword/puzzle/:puzzleId`
- `/learn/quizzes/word-search`
- `/learn/quizzes/word-search/pack/:packId`
- `/learn/quizzes/word-search/daily`
- `/learn/quizzes/word-search/puzzle/:puzzleId`
- `/learn/quizzes/matching`
- `/learn/quizzes/matching/pack/:packId`
- `/learn/quizzes/matching/daily`
- `/learn/quizzes/matching/puzzle/:puzzleId`
- `/learn/quizzes/ayah-completion`
- `/learn/quizzes/ayah-completion/pack/:packId`
- `/learn/quizzes/ayah-completion/daily`
- `/learn/quizzes/ayah-completion/puzzle/:puzzleId`
- `/learn/hub/:sectionId`
  - supported hubs currently include:
    - `prophets`
    - `duas`
    - `faq`
    - `quizzes`
  - crossword, word search, matching, and ayah completion now live under the Quizzes section rather than as separate top-level Learn hubs

### Learn domain routes

- Companion surfaces:
  - `/learn/seerah`
    - canonical Seerah companion owner for `seerah-journey`, `seerah-hijrah`, and `seerah-madinah-society`
  - `/learn/character`
    - canonical Character / Adab companion owner for `beautiful-character`
  - `/learn/daily-wisdom`
    - canonical Daily Wisdom / Reflection companion owner for `wisdom-daily-quote`

- Salah:
  - `/learn/salah/prayer/:prayerId`
  - `/learn/salah/guided/:prayerId`
  - `/learn/salah/surah/:surahId`
  - `/learn/salah/wudu`
  - `/learn/salah/wudu/trainer`
  - `/learn/salah/wudu/quiz`
- Qur'an-adjacent:
  - `/learn/quran/universe`
  - `/learn/quran/constellation`
- FAQ:
  - `/learn/faq`
  - `/learn/faq/category/:categoryId`
  - `/learn/faq/item/:faqId`
- History:
  - `/learn/history`
  - `/learn/history/today`
  - `/learn/history/event/:slug`
- Duas:
  - `/learn/duas/:duaId`
- Life:
  - `/learn/life`
  - `/learn/life/theme/:themeId`
  - `/learn/life/subcategory/:subcategoryId`
  - `/learn/life/lesson/:lessonId`
  - `/learn/life/reflection`
  - `/learn/life/family/baby-names/*`
- World:
  - `/learn/world`
  - `/learn/world/theme/:themeId`
  - `/learn/world/subcategory/:subcategoryId`
  - `/learn/world/lesson/:lessonId`
  - `/learn/world/creation/category/:categoryName`
  - `/learn/world/creation/lesson/:lessonId`
  - `/learn/world/explore-creation`
  - `/learn/world/signs-explorer`
  - `/learn/world/cosmic-scale`
  - `/learn/world/deep-ocean`
  - `/learn/world/atmosphere-layers`
  - `/learn/world/reflection-mode`
  - `/learn/world/muslim-scientists`
- Hadith:
  - `/learn/hadith`
  - `/learn/hadith/theme/:themeId`
  - `/learn/hadith/subcategory/:subcategoryId`
  - `/learn/hadith/lesson/:lessonId`
  - `/learn/hadith/important`
  - `/learn/hadith/important/:number`
  - `/learn/hadith/path/:pathId`
  - `/learn/hadith/path/:pathId/chapter/:chapterId/quiz`
  - `/learn/hadith/review/quiz`
- Shared learn tools:
  - `/learn/notes`
  - `/learn/guides`
  - `/learn/guides/quran-lessons-mapping`
  - `/learn/content/:category/:topicId`
- Quizzes / knowledge games:
  - `/learn/quizzes`
  - `/learn/quizzes/trivia`
  - `/learn/quizzes/daily-challenge`
  - `/learn/games/internal/content-builder`
    - hidden debug-only internal tooling route for normalized content authoring; do not surface in public discovery
  - `/learn/quizzes/crossword`
  - `/learn/quizzes/crossword/pack/:packId`
  - `/learn/quizzes/crossword/daily`
  - `/learn/quizzes/crossword/puzzle/:puzzleId`
  - `/learn/quizzes/word-search`
  - `/learn/quizzes/word-search/pack/:packId`
  - `/learn/quizzes/word-search/daily`
  - `/learn/quizzes/word-search/puzzle/:puzzleId`
  - `/learn/quizzes/matching`
  - `/learn/quizzes/matching/pack/:packId`
  - `/learn/quizzes/matching/daily`
  - `/learn/quizzes/matching/puzzle/:puzzleId`
  - `/learn/quizzes/ayah-completion`
  - `/learn/quizzes/ayah-completion/pack/:packId`
  - `/learn/quizzes/ayah-completion/daily`
  - `/learn/quizzes/ayah-completion/puzzle/:puzzleId`
  - `/learn/quizzes/hadith-reflection`
  - `/learn/quizzes/hadith-reflection/pack/:packId`
  - `/learn/quizzes/hadith-reflection/daily`
  - `/learn/quizzes/hadith-reflection/puzzle/:puzzleId`

## Journey / growth routes

- `/journey`
- `/journey/garden`
  - canonical garden route; now owned by `lib/features/garden/` while reusing Journey garden milestone assets/catalog
- `/journey/ocean`
- `/journey/wallpapers`
- `/journey/today`
- `/journey/reflection`
- `/journey/progress`
- `/journey/paths`
- `/journey/habits`
- `/journey/statistics`
  - canonical Journey stats/tracking destination; prefer this over `/journey/tracking` and `/growth/*` in all visible discovery
- `/journey/browse`
- `/journey/tracking`
  - compatibility alias redirect to `/journey/statistics`
- `/journey/tracking/habits`
- `/journey/tracking/habits/settings`
- `/journey/tracking/habits/calendar`
- `/journey/spiritual-growth`
- `/journey/spiritual-growth/intentions`
- `/journey/spiritual-growth/reflection`
- `/journey/spiritual-growth/themes`
- `/journey/path/:pathId`
- `/journey/habit/:habitId`

## Alias / compatibility routes to preserve but not expand

- `/profile/summary`
- `/profile/whats-new`
- `/profile/coming-soon`
  - keep as compatibility aliases only; new work should target `/settings/*`
- `/learn/browse`
  - use `/learn/explore` in new work
- `/learn/hub/quran`
- `/learn/hub/quran/learning`
- `/learn/hub/quranic-arabic`
  - use `/quran*` ownership in new work
- `/learn/hub/prophets`
- `/learn/section/prophets`
  - use `/learn/prophets` in new work
- `/learn/hub/quizzes`
- `/learn/section/quizzes`
  - use `/learn/quizzes` in new work
- `/learn/hub/duas`
- `/learn/section/duas`
  - use `/learn/duas` in new work
- `/learn/hub/salah`
- `/learn/section/salah`
  - use `/learn/salah` in new work
- `/learn/hub/trivia`
- `/learn/hub/trivia/paths`
- `/learn/hub/trivia/paths/:pathId`
- `/learn/hub/trivia/paths/:pathId/stages/:stageId`
- `/learn/hub/trivia/session`
- `/learn/hub/trivia/results`
- `/learn/hub/trivia/review`
- `/learn/hub/trivia/stats`
  - use `/learn/quizzes/trivia*` ownership in new work
- `/learn/quran/*`
  - compatibility aliases for older Learn-owned Qur'an paths
- `/growth/today`
- `/growth/reflection`
- `/growth/journey`
- `/growth/habits`
- `/growth/habit/:habitId`
  - compatibility alias redirect to `/journey/habit/:habitId`
- `/journey/growth/today`
- `/journey/growth/reflection`
- `/journey/growth/journey`
- `/journey/growth/habits`
  - deep-link aliases for growth

## Routes that should not be reintroduced as new ownership patterns

- any new top-level `/profile` destination hierarchy beyond compatibility aliases
- generic placeholder section routes like the removed learn section placeholder page
- restoring `/learn` as a generic legacy hub by default
- restoring dedicated legacy journey or worship legacy pages
