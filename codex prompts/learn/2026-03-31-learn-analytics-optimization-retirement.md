# PHASE 9 PROMPT — ANALYTICS, OPTIMIZATION & SAFE RETIREMENT PLANNING

PRIMARY OBJECTIVE === BUILD A PRODUCTION-READY ANALYTICS, OPTIMIZATION, AND SAFE RETIREMENT PLANNING LAYER FOR PATH OF NUR SO WE CAN MEASURE WHAT USERS ACTUALLY USE, IMPROVE THE LEARNING EXPERIENCE BASED ON REAL SIGNALS, AND ONLY RETIRE LEGACY SURFACES WHEN IT IS SAFE

You are working in the existing Flutter codebase for “Path of Nūr”.

This pass happens after:
- Learning Hub IA audit
- visible island consolidation
- naming/copy cleanup
- Guided Learning Paths V1
- safe Learn route / alias / canonical ownership consolidation
- deep UX polish & progression clarity
- personalization & path intelligence
- curriculum/content gap audit
- Foundations Path hardening
- Daily Dhikr Path hardening
- Qur’an Beginner soft bridge
- Kids Starter Path hardening
- Stories Path creation
- Search, Discovery & Indexing upgrade

This is a measurement and optimization pass.
It is NOT a destructive cleanup pass.

Core rule:
Do not go haywire and remove/delete records, routes, pages, aliases, path ids, analytics contracts, progress models, metadata, or content for no reason.

PRODUCT GOAL

Now that Learn has:
- cleaner structure
- guided paths
- improved beginner flows
- better discovery

we need to answer with real signals:
- what are users actually starting?
- where are they dropping off?
- which paths are working?
- which discovery flows are helping?
- which legacy routes are still being used?
- what should be optimized next?
- what can eventually be retired safely?

This phase should build the foundation for:
- evidence-based UX improvements
- path optimization
- safe deprecation of old entry points
- future growth decisions

GUIDING PRINCIPLES

- Measure before removing
- Optimize based on real usage
- Preserve privacy
- Keep analytics explainable
- Prefer product decisions backed by clear signals
- Do not collect unnecessary personal data
- Retire only after confidence, not assumption

IMPORTANT NON-GOALS

DO NOT:
- delete legacy routes in this pass
- introduce invasive tracking
- create a giant external analytics dependency if not needed
- break offline-first behavior
- break guided path progress
- break `/quran/*` canonical ownership
- break kids routes
- overcomplicate event taxonomy
- collect sensitive religious behavior in a creepy or over-detailed way

YOUR TASK

1. AUDIT CURRENT ANALYTICS / EVENT SIGNALS
Before editing:
- inspect any current analytics/event logging patterns
- inspect existing progress, reward, search, path, and navigation events
- inspect what Learn already tracks, if anything
- inspect where legacy route usage can be observed
- inspect whether event naming is fragmented or inconsistent

Document:
- what events already exist
- what signals are missing
- what is safe to reuse
- what should be standardized

2. DEFINE A CLEAN LEARN ANALYTICS TAXONOMY
Create a production-ready event model for Learn-related behavior.

Suggested event families:
- learn_landing_viewed
- learn_primary_card_opened
- guided_path_started
- guided_path_resumed
- guided_path_step_opened
- guided_path_step_completed
- guided_path_completed
- guided_path_abandoned_or_stalled (only if derived safely)
- search_opened
- search_query_submitted
- search_result_opened
- filter_applied
- related_content_opened
- explore_section_opened
- legacy_route_opened
- compatibility_alias_hit
- recommended_action_opened
- recommended_path_started

Each event should carry only safe, useful metadata such as:
- stable path id
- stable step id
- domain
- content type
- route family
- source surface
- query type/category (not necessarily raw query if not appropriate)
- beginner/kids/general audience label where useful

Important:
- keep identifiers stable
- avoid over-logging
- avoid collecting unnecessary raw personal text where not needed
- do not log sensitive private content from notes/journals

3. INSTRUMENT KEY LEARN FLOWS
Add or standardize analytics around:
- Learn landing visits
- primary island taps
- Explore usage
- guided path start/resume/complete
- step completion
- path handoff selections
- Qur’an Beginner bridge open and handoff
- Kids Starter usage
- Stories Path usage
- Daily Dhikr Path usage
- search open/query/result open
- related-content clicks
- personalization “Your Next Step” acceptance
- compatibility alias / legacy route entry

Requirements:
- instrument only meaningful decision points
- do not spam events on tiny UI changes
- keep performance smooth

4. BUILD SAFE DERIVED METRICS / AGGREGATION HOOKS
Create or scaffold a lightweight analytics summary layer so future product decisions are easier.

Examples:
- path start rate
- path completion rate
- step drop-off points
- search-to-open conversion
- recommended-action acceptance rate
- Explore usage by section
- legacy route usage rate
- alias hit frequency
- beginner path adoption
- kids path adoption

If a full reporting UI is out of scope, at least structure the events and docs so these metrics can be calculated reliably later.

5. IDENTIFY SAFE RETIREMENT SIGNALS
Build a framework for deciding when an old route or surface is safe to retire later.

For each legacy or compatibility surface, define:
- what usage signal to monitor
- what threshold suggests it is still needed
- what threshold suggests retirement may be safe
- what dependencies must be checked first

Examples:
- `/learn/legacy`
- `/learn/journey-home`
- `/learn/learning-journey`
- `/learn/hub/*`
- `/learn/section/*`
- `/learn/browse`
- old games/quizzes aliases

Important:
- do not retire in this pass
- only create evidence-based retirement criteria

6. PRESERVE `/quran/*` AND KIDS SAFETY
Analytics must respect canonical ownership and audience sensitivity.

Requirements:
- `/quran/*` remains canonical
- kids usage tracking remains respectful and minimal
- do not create product pressure that misuses kids signals
- track route/source/path usage, not invasive behavioral profiling

7. PRESERVE PERSONALIZATION / SEARCH / PATH INTEGRITY
Ensure new analytics does not:
- break guided path progress
- break personalization logic
- break search
- create duplicate ownership
- introduce heavy coupling across systems

If needed, centralize learn analytics helpers cleanly.

8. OFFLINE-FIRST & PERFORMANCE SAFETY
Analytics must work safely in an offline-first app.

Requirements:
- do not block UX on analytics writes
- queue or store safely if existing app patterns support this
- avoid rebuild storms
- avoid synchronous heavy work on the UI thread
- keep the implementation lightweight and resilient

9. LOCALIZATION / USER-FACING IMPACT
If this phase introduces any user-facing toggles, labels, or settings:
- make them localization-ready
- reuse existing keys where possible
- add minimal new keys if needed

If no user-facing text changes are needed, say so clearly.

10. TESTING
Where practical, add or update tests for:
- key analytics helper behavior
- event emission for major flows
- no regressions in path start/complete flows
- no regressions in route resolution
- no obvious double-firing for critical events

Do not overbuild a giant analytics test suite, but add meaningful coverage where core logic changes.

11. DOCUMENTATION
Create:
docs/learn_analytics_optimization_retirement_2026-03-31.md

Include:
- executive summary
- current analytics audit findings
- final event taxonomy
- key flows instrumented
- derived metrics planned
- safe retirement criteria
- privacy/sensitivity considerations
- `/quran/*` ownership notes
- kids tracking safety notes
- performance/offline notes
- test impact
- follow-up optimization ideas

12. RETIREMENT BACKLOG / DECISION RECORD
Create:
docs/learn_retirement_planning_backlog_2026-03-31.md

Include:
- route/surface retirement candidates
- conditions required before retirement
- metrics to monitor
- compatibility checks
- migration notes
- do-not-break notes
- suggested order of future retirements
- explicit “not ready yet” candidates

VALIDATION

Before finishing, confirm:

1. Learn analytics taxonomy exists and is production-ready.
2. Key Learn flows are instrumented safely.
3. Guided path start/resume/complete events are covered.
4. Search/discovery analytics are covered.
5. Legacy/alias route usage can be measured.
6. No routes/pages were destructively removed.
7. `/quran/*` remains canonical and unaffected.
8. kids tracking remains minimal and respectful.
9. Offline-first behavior remains intact.
10. performance remains smooth.
11. localization remains intact.
12. analyzer passes on changed files, or remaining issues are clearly explained.

DELIVERABLES

1. Implement analytics and optimization instrumentation for Learn.
2. Create the documentation markdown file.
3. Create the retirement planning backlog markdown file.
4. Return a concise but thorough summary including:
   - audit findings before changes
   - files changed
   - analytics taxonomy added
   - flows instrumented
   - derived metrics enabled
   - retirement criteria defined
   - how `/quran/*` was protected
   - how Kids was protected
   - localization impact
   - performance/offline impact
   - test impact
   - analyzer results
5. At the very end, audit your own implementation and provide one full summary so we can work on fixing this next.
