# Route Map

Last updated: 2026-03-17

## Canonical top-level tabs

- `/worship`
- `/learn`
  - current primary destination is `LearningJourneyHomePage`
- `/home`
- `/journey`
  - current page is `JourneyPage` -> `GrowthHomePage`
- `/quran`
  - current page is `QuranAppHubPage`

## Startup / access control routes

- `/onboarding`
- `/profiles/launch`
  - shared-device profile picker launch gate

## Settings / support canonical routes

- `/settings`
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

- `/learn/journey-home`
- `/learn/island/:islandId`
- `/learn/journey/:journeyId`
- `/learn/journey/:journeyId/stage/:stageId`
- `/learn/browse`
- `/learn/family`

### Legacy or secondary learn hubs still wired

- `/learn/legacy`
- `/learn/hub/quran`
- `/learn/hub/quran/learning`
- `/learn/hub/quranic-arabic`
- `/learn/hub/trivia`
- `/learn/hub/trivia/paths`
- `/learn/hub/trivia/paths/:pathId`
- `/learn/hub/trivia/paths/:pathId/stages/:stageId`
- `/learn/hub/trivia/session`
- `/learn/hub/trivia/results`
- `/learn/hub/trivia/review`
- `/learn/hub/trivia/stats`
- `/learn/hub/salah`
- `/learn/hub/:sectionId`
  - supported hubs currently include:
    - `prophets`
    - `duas`
    - `faq`
    - `quizzes`

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

## Journey / growth routes

- `/journey`
- `/journey/ocean`
- `/journey/wallpapers`
- `/journey/growth/today`
- `/journey/growth/reflection`
- `/journey/growth/journey`
- `/journey/growth/habits`
- `/journey/path/:pathId`
- `/journey/habit/:habitId`

## Alias / compatibility routes to preserve but not expand

- `/profile/summary`
- `/profile/whats-new`
- `/profile/coming-soon`
  - keep as compatibility aliases only; new work should target `/settings/*`
- `/learn/quran/*`
  - compatibility aliases for older Learn-owned Qur'an paths
- `/growth/today`
- `/growth/reflection`
- `/growth/journey`
- `/growth/habit/:habitId`
  - deep-link aliases for growth

## Routes that should not be reintroduced as new ownership patterns

- any new top-level `/profile` destination hierarchy beyond compatibility aliases
- generic placeholder section routes like the removed learn section placeholder page
- restoring `/learn` as a generic legacy hub by default
- restoring dedicated legacy journey or worship legacy pages
