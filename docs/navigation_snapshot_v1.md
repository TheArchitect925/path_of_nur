# Navigation Snapshot V1

Date: 2026-03-22

Purpose:
- Capture the current routing, entry points, aliases, and major hub link maps before any controlled navigation fix work.
- Serve as a repo-local V1 backup baseline.

Scope:
- Router structure under `lib/app/`
- Major navigation hubs and linked route names
- Top-level tabs, startup guards, deep links, aliases, and major kids/learn/quran/journey flows

## Current router summary

- Router shell: `MaterialApp.router` with one shell scaffold and five effective tabs.
- Startup routes:
  - `/onboarding`
  - `/profiles/launch`
- Top-level tabs:
  - `/worship`
  - `/learn`
  - `/home`
  - `/journey`
  - `/quran`
- Current route counts:
  - total declared routes: `269`
  - page routes: current inventory includes page-backed routes plus redirect routes in the JSON snapshot

## Top-level ownership snapshot

- Home
  - canonical entry: `/home`
- Worship
  - canonical entry: `/worship`
  - section routes: `/worship/prayer`, `/worship/dhikr`, `/worship/fasting`, `/worship/tracking`, `/worship/reminders`, `/worship/duas`
- Learn
  - current front doors:
    - `/learn`
    - `/learn/learning-journey`
    - `/learn/journey-home`
    - `/learn/explore`
    - `/learn/browse`
    - `/learn/legacy`
- Qur'an
  - canonical hub: `/quran`
  - current supporting routes live under `/quran/*`
  - compatibility aliases also exist under `/learn/hub/quran*` and `/learn/quran*`
- Journey
  - canonical hub: `/journey`
  - supporting routes live under `/journey/*`
  - legacy/compatibility aliases exist under `/growth/*` and `/journey/growth/*`
- Settings/Profile
  - canonical routes live under `/settings/*`
  - compatibility aliases still exist under `/profile/*`

## Startup and guard behavior snapshot

- If onboarding is incomplete, all traffic is redirected to `/onboarding`.
- If onboarding is complete and the user revisits `/onboarding`, the app redirects to `/home`.
- If shared-device launch safety is enabled and no session profile is unlocked, the app redirects to `/profiles/launch`.
- Child-profile Learn guard:
  - child traffic under `/learn` is restricted
  - current default child redirect target is `/learn/category/kids-learning`

## Deep-link snapshot

Scheme:
- `pathofnur://`

Current mappings:
- `/home` -> `/home`
- `/worship` -> `/worship`
- `/prayer` -> `/worship`
- `/dhikr` -> `/worship`
- `/growth/today` -> `/journey/today`
- `/growth/reflection` -> `/journey/reflection`
- `/growth/journey` -> `/journey/progress`
- `/growth/habits` -> `/journey/habits`
- `/growth/habit/:id` -> `/journey/habit/:id`
- `/progress` -> `/journey/progress`
- `/journey*` -> passthrough
- `/quran*` -> passthrough
- `/quran/read` -> `/quran/surah/1`
- `/learn*` -> passthrough
- `/ocean` -> `/journey/ocean`
- `/garden` -> `/journey/garden`
- `/tracking` -> `/journey/tracking`

## Alias snapshot

- Settings/Profile aliases:
  - `/profile/summary` -> `/settings/summary`
  - `/profile/whats-new` -> `/settings/whats-new`
  - `/profile/coming-soon` -> `/settings/coming-soon`
- Qur'an compatibility aliases:
  - `/learn/quran/*` -> `/quran/*`
  - `/learn/hub/quran*` remains live
- Journey compatibility aliases:
  - `/growth/today` -> `/journey/today`
  - `/growth/reflection` -> `/journey/reflection`
  - `/growth/journey` -> `/journey/progress`
  - `/journey/growth/*` -> `/journey/*`
- Learn overlap:
  - `/learn/browse` remains a live page route
  - `/learn/legacy` remains live

## Major hub link-map snapshot

- Home
  - settings
  - worship prayer
  - worship dhikr
  - qibla finder
  - salah times
  - quran explorer
  - quran search
  - quran top words
  - quran names of Allah
  - learn history archive
  - learn life landing
  - baby names home
  - learn world landing
  - learn hadith landing
  - learn hadith important
  - learn notes landing
  - assistant
  - circles discovery
  - journal timeline
  - ocean drops
  - wallpaper library
  - journey habits and habit detail path calls

- Worship hub
  - worship prayer page
  - worship dhikr page
  - worship duas page
  - worship fasting page
  - worship tracking page
  - worship reminders page

- Journey home
  - growth tracking dashboard
  - garden page
  - ocean drops
  - spiritual growth page
  - growth today
  - growth paths
  - growth habits
  - growth journey
  - growth reflection

- Learn landing
  - learn journey island hub
  - learn explore all knowledge
  - learn games island
  - learn kids games
  - learn history archive
  - category-route driven cards from taxonomy

- Qur'an hub
  - quran learning hub
  - quran word review
  - quran top words
  - quran topic explorer
  - quran notes
  - quran reflections
  - quran search
  - quran bookmarks
  - quran Arabic
  - quran universe
  - quran ayah insights browse
  - quran knowledge search

- Learning Journey island hub
  - learn journey home

- Learning Journey home
  - learn family management
  - learn explore all knowledge
  - learn legacy
  - dynamic journey routes via registry-backed cards

- Learning Journey island page
  - learn glossary
  - dynamic journey detail routes via registry-backed cards

- Kids bedtime stories
  - kids story library
  - kids bedtime stories family mode
  - kids bedtime stories parent dashboard
  - kids learner progression
  - kids bedtime companion
  - kids seerah journeys

## Current notable state captured in V1

- The current router includes the new Qur'an reflections route:
  - `/quran/reflections`
  - alias: `/learn/quran/reflections`
- Learn still has multiple live front doors.
- Child Learn redirection is currently policy-based at router level.
- Journey still carries compatibility aliases from the older growth namespace.
- Settings owns profile-oriented pages, with compatibility aliases under `/profile/*`.

## Snapshot files

- Summary snapshot:
  - `docs/navigation_snapshot_v1.md`
- Machine-readable route inventory:
  - `docs/navigation_snapshot_v1.json`

## Source files used for this snapshot

- `lib/app/app_router.dart`
- `lib/app/routes/startup_routes.dart`
- `lib/app/routes/core_support_routes.dart`
- `lib/app/routes/discovery_routes.dart`
- `lib/app/routes/journey_routes.dart`
- `lib/app/routes/learn_routes.dart`
- `lib/app/routes/worship_routes.dart`
- `lib/app/routes/router_deep_links.dart`
- `lib/features/home/presentation/home_page.dart`
- `lib/features/worship/presentation/worship_page.dart`
- `lib/features/journey/presentation/growth_home_page.dart`
- `lib/features/learn/presentation/pages/learning_section_landing_page.dart`
- `lib/features/learn/presentation/pages/quran_app_hub_page.dart`
- `lib/features/learn/presentation/pages/learning_journey_island_hub_page.dart`
- `lib/features/learn/journey/presentation/learning_journey_home_page.dart`
- `lib/features/learn/journey/presentation/learning_journey_island_page.dart`
- `lib/features/kids/bedtime_stories/presentation/bedtime_stories_page.dart`
