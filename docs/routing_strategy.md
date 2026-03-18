# Routing strategy

## Canonical routes
- Tabs remain rooted at `/worship`, `/learn`, `/home`, `/journey`, `/quran`.
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

## Removed routing pattern
- Generic learn-section fallback routing via `learnSectionHub` and `/learn/hub/:sectionId` is no longer used.
- Placeholder learn catalog entries now resolve to the explicit legacy Learn surface instead of a generic section catch-all.

## Deep links
- Custom-scheme deep links are normalized in `lib/app/routes/router_deep_links.dart`.
- Path aliases are handled as explicit route redirects close to the feature routes that own them.
