# Routing strategy

## Canonical routes
- Tabs remain rooted at `/worship`, `/learn`, `/home`, `/journey`, `/quran`.
- `/learn` opens the Learn discovery landing (`LearningSectionLandingPage`).
- Settings ownership is rooted at `/settings`; older `/profile/*` routes are compatibility paths only.
- Real Learn hubs now use explicit product paths:
  - `/learn/prophets`
  - `/learn/duas`
  - `/learn/quizzes`
  - `/learn/faq`

## Deprecated aliases kept intentionally
These still resolve for backward compatibility, but they are no longer the canonical product routes:
- `/learn/hub/prophets`
- `/learn/section/prophets`
- `/learn/hub/duas`
- `/learn/section/duas`
- `/learn/hub/quizzes`
- `/learn/section/quizzes`
- `/learn/section/faq`
- `/growth/today`
- `/growth/reflection`
- `/growth/journey`
- `/growth/habits`
- `/journey/growth/habits`

## Removed routing pattern
- Generic learn-section fallback routing via `learnSectionHub` and `/learn/hub/:sectionId` is no longer used.
- Placeholder learn catalog entries now resolve to the explicit legacy Learn surface instead of a generic section catch-all.

## Deep links
- Custom-scheme deep links are normalized in `lib/app/routes/router_deep_links.dart`.
- Growth deep links should normalize to canonical routes:
  - `/journey/today`
  - `/journey/reflection`
  - `/journey/progress`
  - `/journey/habits`
- Path aliases are handled as explicit route redirects close to the feature routes that own them.
