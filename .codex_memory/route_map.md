# Route Map

Last updated: 2026-03-21

## Canonical top-level tabs

- `/worship`
- `/learn`
  - current primary destination is `LearningSectionLandingPage`
- `/home`
- `/journey`
  - current page is `JourneyPage` -> `GrowthHomePage` section landing
- `/quran`
  - current page is `QuranAppHubPage`

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
- `/quran/knowledge-search`
- `/quran/insights`
- `/quran/insights/paths`
- `/quran/insights/paths/:pathId`
- `/quran/insights/:domainId`
- `/quran/surah-insights`
- `/quran/surah/:surahNumber/insights`
- `/quran/arabic`
- `/quran/explorer`
- `/quran/surah/:surahNumber`
- `/quran/bookmarks`
- `/quran/notes`
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
- `/learn/games/:sectionId`
- `/learn/category/:categoryId`
- `/learn/family`
- `/learn/kids/games`
- `/learn/kids/arabic-learning`
- `/learn/kids/fun-learning`
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
- `/learn/hub/quran`
  - compatibility alias for Qur'an-owned `/quran`
- `/learn/hub/quran/learning`
  - compatibility alias for `/quran/learning`
- `/learn/hub/quranic-arabic`
  - compatibility alias for `/quran/arabic`
- `/learn/hub/trivia`
- `/learn/hub/trivia/paths`
- `/learn/hub/trivia/paths/:pathId`
- `/learn/hub/trivia/paths/:pathId/stages/:stageId`
- `/learn/hub/trivia/session`
- `/learn/hub/trivia/results`
- `/learn/hub/trivia/review`
- `/learn/hub/trivia/stats`
- `/learn/hub/salah`
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

- Salah:
  - `/learn/salah/prayer/:prayerId`
  - `/learn/salah/guided/:prayerId`
  - `/learn/salah/surah/:surahId`
  - `/learn/salah/wudu`
  - `/learn/salah/wudu/trainer`
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
- `/journey/tracking`
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
- `/learn/quran/*`
  - compatibility aliases for older Learn-owned Qur'an paths
- `/growth/today`
- `/growth/reflection`
- `/growth/journey`
- `/growth/habits`
- `/growth/habit/:habitId`
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
