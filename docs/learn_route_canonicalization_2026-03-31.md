# Learn Route Canonicalization

Date: 2026-03-31

## Executive summary

This pass reduces competing Learn route ownership without deleting working pages or breaking compatibility. The main strategy is:

- keep `/learn` as the primary learning front door
- keep `/quran/*` as the canonical Qur'an owner
- keep the kids route family as the canonical kids audience lane
- keep guided learning paths as orchestration only
- move remaining ambiguous Learn-side owner paths toward clearer canonical URLs while preserving older aliases through redirects

## Canonical ownership matrix

| Area | Canonical owner | Compatibility / alias posture |
|---|---|---|
| Learn front door | `/learn` | none |
| Learn legacy library | `/learn/legacy` | retained legacy compatibility surface |
| Journey islands / journey detail | `/learn/learning-journey`, `/learn/island/:islandId`, `/learn/journey/:journeyId` | `/learn/journey-home` retained legacy-but-live owner |
| Explore All | `/learn/explore` | `/learn/browse` redirects here |
| Games | `/learn/games` | kept as visible owner |
| Quizzes hub | `/learn/quizzes` | `/learn/hub/quizzes`, `/learn/section/quizzes` redirect here |
| Trivia flows | `/learn/quizzes/trivia*` | old `/learn/hub/trivia*` routes now redirect here |
| Salah hub | `/learn/salah` | old `/learn/hub/salah` and new `/learn/section/salah` redirect here |
| Prophets hub | `/learn/prophets` | `/learn/hub/prophets`, `/learn/section/prophets` redirect here |
| Dua hub | `/learn/duas` | `/learn/hub/duas`, `/learn/section/duas` redirect here |
| FAQ | `/learn/faq` | `/learn/section/faq` redirects here |
| Qur'an learning / reader / study | `/quran/*` | old `/learn/hub/quran*` and `/learn/quran/*` aliases redirect to canonical Qur'an routes |
| Kids learning | `/learn/kids/*` | preserved as canonical audience lane |
| Guided paths | `/learn/paths/:pathId` | orchestration layer only, points into canonical owners |

## Route classification

### Canonical visible entry points

- `/learn`
- `/learn/explore`
- `/learn/games`
- `/learn/quizzes`
- `/learn/quizzes/trivia`
- `/learn/salah`
- `/learn/prophets`
- `/learn/duas`
- `/learn/faq`
- `/learn/paths/:pathId`
- `/quran/*`
- `/learn/kids/*`

### Legacy but retained

- `/learn/legacy`
- `/learn/journey-home`

### Redirect-only compatibility aliases

- `/learn/browse` -> `/learn/explore`
- `/learn/hub/quran` -> `/quran`
- `/learn/hub/quran/learning` -> `/quran/learning`
- `/learn/hub/quranic-arabic` -> `/quran/arabic`
- `/learn/hub/prophets` -> `/learn/prophets`
- `/learn/section/prophets` -> `/learn/prophets`
- `/learn/hub/quizzes` -> `/learn/quizzes`
- `/learn/section/quizzes` -> `/learn/quizzes`
- `/learn/hub/duas` -> `/learn/duas`
- `/learn/section/duas` -> `/learn/duas`
- `/learn/hub/salah` -> `/learn/salah`
- `/learn/section/salah` -> `/learn/salah`
- `/learn/hub/trivia` -> `/learn/quizzes/trivia`
- `/learn/hub/trivia/paths*` -> `/learn/quizzes/trivia/paths*`
- `/learn/hub/trivia/session` -> `/learn/quizzes/trivia/session`
- `/learn/hub/trivia/results` -> `/learn/quizzes/trivia/results`
- `/learn/hub/trivia/review` -> `/learn/quizzes/trivia/review`
- `/learn/hub/trivia/stats` -> `/learn/quizzes/trivia/stats`
- `/learn/quran/*` compatibility routes -> matching `/quran/*`

### Future retirement candidates

- `/learn/journey-home`
- some older `/learn/hub/*` aliases after telemetry confirms no meaningful external dependency
- `/learn/legacy` only after hidden catalog and legacy journey metadata no longer depend on it

## Redirects and aliases preserved

The pass intentionally preserved compatibility for:

- old home and journey links
- older Learn-side Qur'an links
- older hub/section links for Prophets, Quizzes, Duas, and FAQ
- older Salah and Trivia hub URLs
- guided-path route targets that rely on named routes rather than literal paths

All redirect changes preserve query parameters, and the new trivia path redirects also preserve path parameters.

## Qur'an ownership notes

- `/quran/*` remains canonical
- no new Learn-owned Qur'an hub was introduced
- Learn continues to feature Qur'an as a curated entry point, but route ownership stays with the Qur'an family
- older Learn-side Qur'an URLs remain compatibility redirects only

## Kids ownership notes

- `/learn/kids/*` remains the canonical kids audience lane
- no kids route families were collapsed into adult Learn routing
- the Kids Starter guided path still points to existing kids destinations only

## Games / quizzes / trivia notes

- Games remains the visible top-level island under `/learn/games`
- Quizzes remains the broader quiz owner at `/learn/quizzes`
- Trivia is now clearly nested under `/learn/quizzes/trivia*`
- the older `/learn/hub/trivia*` family remains supported only as compatibility redirects

## Guided path impact

- guided learning paths continue to use named routes
- no path ids or step ids changed
- no guided path persistence keys changed
- only the underlying canonical path for Salah and trivia-family destinations became clearer

## Search and indexing impact

No search/indexing identifiers were changed in this pass.

- category metadata remains stable
- route names used by existing catalog and journey metadata remain stable
- compatibility redirects protect older route targets from becoming dead links

## Localization impact

No new localization keys were required in this route-safety pass.

## Testing impact

Focused routing coverage was extended to verify:

- `/learn/hub/salah` redirects to `/learn/salah`
- `/learn/hub/trivia/review` redirects to `/learn/quizzes/trivia/review`
- existing alias tests for browse, prophets, and Qur'an learning remain intact

## Risks

- `/learn/journey-home` still coexists with `/learn/learning-journey`, because they are not yet proven to be safe one-to-one replacements
- `/learn/legacy` remains necessary for compatibility and hidden catalog debt
- older path-like and metadata-driven route names still depend on route stability, so future retirement should happen only with telemetry and focused cleanup
