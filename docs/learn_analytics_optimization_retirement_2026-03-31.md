# Learn Analytics, Optimization & Safe Retirement Planning

## Executive summary

This pass adds a production-ready Learn analytics layer on top of the existing local-first telemetry seam instead of introducing a new external analytics dependency. The result is a consistent event taxonomy for Learn landing usage, guided path progression, discovery/search behavior, recommendation acceptance, related-content handoffs, and legacy/alias route access.

This pass does not remove routes, change canonical ownership, or alter guided path progress contracts. It creates the measurement layer needed to optimize the Learn experience safely and to make future retirement decisions from real usage rather than assumptions.

## Audit findings before changes

- The app already had a safe local analytics seam in `AppTelemetry` plus route-level `screen_view` logging from `TelemetryNavigatorObserver`.
- Learn-specific behavior was not standardized. Search, guided paths, recommendation acceptance, and alias usage were largely unmeasured.
- Compatibility redirects existed, but alias hits were not observable in a single taxonomy.
- Guided path progress already existed and was the safest source of truth for step-open, step-complete, and path-complete measurement.
- The existing local-first telemetry store was already appropriate for lightweight derived metrics and retirement planning.

## Final event taxonomy

### Learn landing and entry surfaces

- `learn_landing_viewed`
- `learn_primary_card_opened`
- `explore_section_opened`
- `legacy_route_opened`
- `compatibility_alias_hit`

### Guided paths

- `guided_path_started`
- `guided_path_resumed`
- `guided_path_step_opened`
- `guided_path_step_completed`
- `guided_path_completed`

### Search and discovery

- `search_opened`
- `search_query_submitted`
- `search_result_opened`
- `filter_applied`
- `related_content_opened`

### Personalization / recommendation acceptance

- `recommended_action_opened`
- `recommended_path_started`

## Metadata rules

Only safe, low-sensitivity metadata is attached:

- `pathId`
- `stepId`
- `domain`
- `sourceSurface`
- `routeKey`
- `aliasPath`
- `canonicalPath`
- `routeFamily`
- `resultType`
- `routeName`
- `queryKind`
- `queryLength`
- `audience`

Raw search text is intentionally not stored. Query analytics are reduced to a lightweight explainable `queryKind` bucket plus query length.

## Key flows instrumented

### Learn landing

- landing viewed
- Continue Your Journey open
- Continue prior content open
- Browse guided paths open
- primary island taps
- featured kids shortcuts
- guided path card opens
- landing search open/query/result open
- Explore All quick-access/support buttons
- legacy library access from landing

### Guided path flows

- path start
- path resume
- step open
- step complete
- path complete
- Foundations next-step handoffs
- Daily Dhikr next-step handoffs and dhikr tool handoff
- Stories next-step handoffs and history archive handoff
- Kids Starter bridge and next-lane handoffs
- Qur'an Beginner soft bridge handoff

### Search and Explore

- Explore viewed
- Explore search open/query/result open
- Explore filter changes for category, type, audience, difficulty, and sort
- related-content opens from related bucket

### Legacy and alias usage

- `/learn/legacy`
- `/learn/journey-home`
- `/learn/learning-journey`
- `/learn/browse`
- compatibility alias redirects under `/learn/hub/*` and `/learn/section/*`
- Salah and trivia alias families

## Derived metrics enabled

The new summary providers make these metrics calculable from the local event log:

- path starts by path id
- path completions by path id
- step completions by path id
- legacy route hits by route
- alias hits by alias path
- search query mix by intent bucket
- search result opens by result type
- recommendation acceptance count
- recommended path starts
- Explore section opens by section id

## Retirement criteria framework

This pass does not retire anything. It introduces a decision framework for later.

### Candidate routes monitored

- `/learn/legacy`
- `/learn/journey-home`
- `/learn/learning-journey`
- `/learn/browse`
- `/learn/hub/salah`
- `/learn/section/salah`
- `/learn/hub/trivia`

### Safe review signal

A route becomes `safeToReviewForRetirement` only when both of these are true in the recent lookback window:

- `directLegacyOpensLast30Days == 0`
- `aliasHitsLast30Days == 0`

### Additional checks required before any real retirement

- confirm no active home, search, personalization, or guided-path links still point there
- confirm compatibility redirects cover deep-link parameters safely
- confirm no new user-facing cards surface the route
- confirm analytics has been running long enough to trust the signal
- confirm no platform-specific parity dependency still references the route

## Privacy and sensitivity notes

- No raw search text is stored.
- No journaling or personal notes content is logged.
- Kids tracking is limited to high-level route, card, path, and lane selection signals.
- The layer tracks route/path/content usage, not detailed religious behavior.
- `/quran/*` remains canonical. Learn analytics measures entry and handoff behavior without duplicating Qur'an ownership.

## `/quran/*` ownership notes

- Qur'an bridge and discovery events only measure handoff into canonical Qur'an surfaces.
- No Learn-owned Qur'an reader or playback telemetry was introduced here.
- The existing Qur'an systems remain intact and outside the scope of this pass.

## Kids safety notes

- Kids instrumentation only captures starter path usage, kids lane taps, and bridge/handoff choices.
- No fine-grained child profiling or invasive behavior logging was introduced.
- Kids route ownership remains unchanged.

## Offline and performance considerations

- All analytics continue to use the existing local shared-preferences telemetry log.
- Event writes are lightweight and do not block navigation.
- No remote dependency was added.
- No rebuild loops were introduced for analytics.
- Derived summaries are provider-based and read from the existing telemetry store.

## Test impact

Added focused coverage in `test/features/learn/analytics/application/learn_analytics_summary_provider_test.dart` for:

- explainable query classification
- derived summary aggregation
- retirement signal generation for recent vs stale route usage

## Localization impact

- No new user-facing strings were added in this pass.
- No localization keys were added.
- No locale files were updated.

## Follow-up optimization ideas

- add a small internal diagnostics surface for Learn summary metrics if product review needs in-app QA visibility
- add derived stall/drop-off helpers for path optimization once enough event history exists
- add stricter alias-family reporting for retirement dashboards
- validate event volume and cap strategy if Learn instrumentation expands further
