# Unlinked Functionality Audit Backlog

Last updated: 2026-03-23

## Highest-value safe discoverability follow-ups

1. Decide whether Journey should expose a dedicated ring-progress explainer card inside `/journey/statistics` or `/journey/progress`, since ring values exist today as summary metrics but not as a first-class product page.
2. Add a clearer parent-hub entry from `/quran` to the broader study surfaces already live under `/quran/learning`, especially Ayah Insights, Knowledge Search, and Surah Insights, if product wants stronger Qur'an discovery from the main tab.
3. Decide whether `Ocean Community` should be reachable directly from the Journey hub or remain a second-step route behind the Ocean dashboard.
4. Review whether `/settings/summary` should stay settings-only or also gain a calmer top-level “My Summary” discoverability entry somewhere in Settings.
5. Audit the hidden `LearnCategoryCatalog` compatibility items still pointing to `learnLegacy`, especially `jummah`, `eid`, and `funeral`, and either re-own or explicitly archive them.
6. Review whether Home search/shortcuts should expose `gardenPage` and `growthStatisticsPage` directly instead of only routing users to the Journey tab.
7. Decide whether Kids parent-facing surfaces such as progression, bedtime family mode, and parent dashboards need one stronger parent-oriented entry path beyond their current in-flow links.
8. Review whether discovery routes under `/circles/*` need a clearer second-level entry map from `CirclesDiscoveryPage` or whether their current in-surface navigation is sufficient.
9. Audit whether the Help Guide should be cross-linked from more settings detail pages or remain a settings-home utility.
10. Review whether older route-backed utility surfaces in Profile/Discovery should stay intentionally secondary or move into stronger Settings / Journey ownership.

## Intentional hidden/internal items to keep hidden unless product changes

1. `/learn/games/internal/content-builder`
   - debug-only internal content authoring tool
2. `/learn/legacy`
   - compatibility surface only
3. older compatibility aliases under `/growth/*`, `/profile/*`, and `/learn/hub/quran*`
   - keep for deep-link compatibility, not active discovery
