# Learn Route Ownership Map

Last updated: 2026-03-21

This document clarifies which Learn routes are canonical, which paths remain as compatibility aliases, and what future Learn work should use by default.

## Current route problem

The Learn route layer is transitional:

- `/learn` is a journey-first landing.
- `/learn/legacy` still exists.
- section hubs, dedicated domain routes, and older `/learn/hub/*` paths coexist.
- some aliases still point at destinations now owned by Qur'an or by newer Learn pages.

The goal of this doc is not to force a broad rewrite. It is to reduce route drift and keep future work aligned.

## Canonical Learn routes to use in new work

### Learn entry surfaces

- `/learn`
  - journey-first Learn landing
- `/learn/learning-journey`
  - Learning Journey island hub
- `/learn/journey-home`
  - legacy-but-still-active Learning Journey home surface
- `/learn/explore`
  - canonical Explore All Knowledge surface
- `/learn/games`
  - canonical Games Island surface
- `/learn/games/:sectionId`
  - canonical Games Island section filter
- `/learn/category/:categoryId`
  - canonical category routing for visible Learn categories

### Kids Learn routes

- `/learn/kids/stories`
- `/learn/kids/stories/:storyId`
- `/learn/kids/stories/:storyId/quiz`
- `/learn/kids/stories/:storyId/memory`
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
- `/learn/kids/arabic`
- `/learn/kids/dua`
- `/learn/kids/progression`

### Learn-owned domain routes

Use the direct domain routes instead of older section aliases when they exist:

- `/learn/prophets`
- `/learn/quizzes`
- `/learn/quizzes/*`
- `/learn/duas`
- `/learn/faq`
- `/learn/history`
- `/learn/history/today`
- `/learn/history/event/:slug`
- `/learn/salah/*`
- `/learn/life/*`
- `/learn/world/*`
- `/learn/hadith/*`
- `/learn/notes`
- `/learn/content/:category/:topicId`

## Canonical routes owned outside Learn

These are adjacent to Learn, but new Learn work should target the owning route namespace rather than the older Learn alias:

### Qur'an-owned

- `/quran`
- `/quran/learning`
- `/quran/arabic`
- other `/quran*` routes from the Qur'an route family

Use the canonical Qur'an route names and paths for new work. Keep Learn-owned aliases only for compatibility.

### Journey-owned

- `/journey/*`

Learn may deep-link into Journey-owned surfaces, but should not create new shadow Learn routes for Journey pages.

## Compatibility aliases to preserve for now

These still exist because older call sites, deep links, route-name references, or tests depend on them.

### Keep, but do not expand

- `/learn/legacy`
  - compatibility destination for the older LearnPage
- `/learn/browse`
  - compatibility alias for `/learn/explore`
- `/learn/hub/quran`
  - compatibility alias for `/quran`
- `/learn/hub/quran/learning`
  - compatibility alias for `/quran/learning`
- `/learn/hub/quranic-arabic`
  - compatibility alias for `/quran/arabic`
- `/learn/hub/prophets`
  - compatibility alias for `/learn/prophets`
- `/learn/section/prophets`
  - compatibility alias for `/learn/prophets`
- `/learn/hub/quizzes`
  - compatibility alias for `/learn/quizzes`
- `/learn/section/quizzes`
  - compatibility alias for `/learn/quizzes`
- `/learn/hub/duas`
  - compatibility alias for `/learn/duas`
- `/learn/section/duas`
  - compatibility alias for `/learn/duas`
- `/learn/hub/trivia`
  - compatibility alias for `/learn/quizzes/trivia`

### Still active, but transitional

- `/learn/journey-home`
  - still an active Learning Journey surface; keep using when a flow explicitly wants the older journey-home experience
- `/learn/hub/trivia/paths*`
  - still active under current trivia ownership
- `/learn/hub/salah`
  - still the real Salah Learn hub path today

## Ownership boundaries

### Learn owns

- Learn landing/discovery
- category browsing
- kids learning routes under `/learn/kids/*`
- domain learning surfaces under `/learn/<domain>`
- quizzes/games under `/learn/quizzes/*` and `/learn/games*`

### Qur'an owns

- reader
- Qur'an hub
- bookmarks
- notes
- search
- topics
- names of Allah
- top words
- word review
- Qur'anic Arabic and Qur'an learning entry routes

### Journey owns

- growth, garden, ocean, habits, tracking, and spiritual growth

### Shared / cross-domain rule

If a destination is already owned by another top-level namespace, do not add a new Learn shadow route unless compatibility requires it.

## Practical rules for future work

1. When adding a new Learn destination, prefer the direct domain route under `/learn/<domain>` or `/learn/kids/*`.
2. Only add an alias when there is a real compatibility need:
   - legacy deep links
   - widely used old route names
   - migration bridge for a renamed surface
3. If you add an alias, document:
   - canonical route
   - alias path
   - why the alias exists
   - whether new work should avoid it
4. Prefer canonical route names in new code.
5. Do not create new `/learn/hub/*` aliases for domains that already have stable direct routes.
6. For Qur'an destinations, use the `/quran*` namespace by default.
7. For Journey destinations, use the `/journey*` namespace by default.

## Low-risk cleanup completed in this pass

- documented the canonical Explore All route as `/learn/explore`
- normalized the internal Learning Journey “Browse All Knowledge” links to the canonical route name instead of the older `/learn/browse` alias
- added clarifying comments in `lib/app/routes/learn_routes.dart` around alias groups

## Follow-up cleanup candidates

- decide whether `/learn/journey-home` should remain a long-term public route or eventually collapse into `/learn/learning-journey`
- trim legacy `learnLegacy` route usage where flows now have real route-specific destinations
- eventually replace remaining `learnQuranHub` route-name usage with canonical Qur'an-owned navigation where stack behavior is verified safe
