# Platform Inventory

Last updated: 2026-03-25

- 2026-03-25: Phase 27 added shared tvOS launch-readiness contracts plus native empty-state hardening for Learn, Saved, Profiles, Arabic, and Kids so optional shelves fail calmly instead of collapsing into blank rails. Unsigned native `Release` verification now also passes for this phase with `CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_phase27_modulecache_escalated_retry`.
- 2026-03-25: tvOS launch-readiness contracts now include explicit signed-archive and TestFlight-upload evidence records, and the signed-distribution gate is derived from those records instead of only prose notes. Current coded posture remains blocked for public launch because both evidence slots are still unrecorded.
- 2026-03-25: Phase 23 added a shared tvOS update-governance layer for channel, governed route scope, gating phases, and release gates, and aligned the TestFlight checklist with the actual active shell. Unsigned native `Release` verification now also passes for this phase with `CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_phase23_modulecache`.
- 2026-03-25: Phase 26 optimized large-screen tvOS rendering on Home, Learn, and Qur'an with lazy shelves, lazy vertical lists, cached active ayah payloads, and a shared performance profile contract. Unsigned native `Release` verification now also passes for this phase with `CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_phase26_modulecache`.
- 2026-03-25: Phase 25 added a shared tvOS focus-navigation QA matrix and regression harness so enabled routes, ordered focus sections, and focus-required guardrails stay in sync. Unsigned native `Release` verification now also passes for this phase with `CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_phase25_modulecache`.
- 2026-03-25: Phase 24 added local-first tvOS diagnostics, quality guardrails, and Settings visibility for route telemetry, playback failures, and crash buffering. Unsigned native `Release` verification now also passes for this phase with `CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_phase24_modulecache`.
- 2026-03-25: Phase 20 promoted `/settings` into the active tvOS shell as a television-safe preferences route. tvOS now persists startup behavior and Qur'an listening defaults locally while leaving deeper account, backup, and sync controls on companion devices.

## iPhone / iPad

- current first-release target
- release docs treat iOS + iPadOS as the recommended launch scope
- local app code and routing are actively maintained for this path

## macOS

- conditional only
- viable if signed-build validation confirms:
  - iCloud KVS works
  - local notifications permission flow works
  - backup/export/import works under sandboxed signed build
- unsigned local debug is supported, but not sufficient for release-readiness claims

## Apple Watch

- native companion app, extension, and complication target now exist in the integrated iOS project
- Flutter-side watch contract logic and tests exist
- watch simulator build now passes for:
  - `PathOfNurWatch Watch App`
  - `PathOfNurWatchComplications`
- current native watch surface includes:
  - Home, Prayer, Dhikr, Progress, Utility
  - post-prayer adhkar mini flow
  - next prayer + daily progress complications backed by shared watch cache
- not first-release ready
- needs:
  - real-device QA
  - entitlement/app-group signing verification
  - notification / sync / rollover verification

## Wear OS

- Flutter-side contract and QA expectations exist
- release posture is still incomplete
- treat as companion work, not launch-ready product surface

## tvOS

- canonical native target exists in `ios/Runner.xcodeproj` as `PathOfNurTV`
- active source lives in `ios/PathOfNurTV`
- current active tvOS scope is Home, Profiles, Qur'an, Saved, Arabic, Learn, Games, Prayer, Dhikr, and Kids, aligned to the mobile app direction with tvOS focus adaptations
- repo-side archive readiness improved on 2026-03-25:
  - canonical tvOS asset catalog now includes concrete `AppIcon.brandassets` and `TopShelf.imageset`
  - unsigned local `Release` build for `PathOfNurTV` now passes through `xcodebuild`
  - a dedicated repo checklist now exists at `docs/tvos_testflight_release_checklist_2026-03-25.md`
- Phase 1 tvOS architecture foundation landed on 2026-03-25:
  - shared tvOS phase definitions now live under `lib/features/tvos/`
  - a canonical tvOS parity registry now records mirrored vs later-phase vs iOS-only surfaces
  - a small shared release-policy layer now exposes current mirrored surfaces and route-level parity review checks
- Phase 3 tvOS shell/navigation foundation landed on 2026-03-25:
  - the native target now uses a shared remote-first shell instead of the default tab-strip layout
  - a native route registry now records `/home` and `/quran` tvOS ownership
  - the shell now remembers preferred content sections for Home and Qur'an and can restore navigation-vs-content focus state
- Phase 4 shared parity payload foundation landed on 2026-03-25:
  - shared Flutter-side payload contracts now exist for mirrored Home and Qur'an tvOS routes
  - Home parity now reuses worship summary, continue-reading, and daily-verse providers
  - Qur'an parity now reuses continue-reading, daily verse, recitation session, audio-enabled state, and shared surah metadata
- Phase 21 tvOS feature-flag/parity policy foundation landed on 2026-03-25:
  - shared tvOS surface and section flags now encode enabled vs staged vs iOS-only availability
  - current canonical tvOS release stage is recorded as `testflight`
  - the enabled sidebar route set now expands phase by phase through the shared release-policy layer instead of native-only shell wiring
- Phase 22 tvOS content-registry foundation landed on 2026-03-25:
  - mirrored Home and Qur'an sections now have stable tvOS content-module IDs and route bundle ordering
  - module onboarding now runs through shared route enablement, section flags, release stage, and dependency checks
  - future tvOS section rollout can extend the shared registry instead of hardcoding route-local module lists
- Phase 5 tvOS Home foundation landed on 2026-03-25:
  - Home now includes a dedicated `Continue your journey` lane near the top of the route
  - Qur'an continuation and listening are now surfaced as large remote-first cards instead of only smaller shelf actions
  - prayer remains visible as a calm Home-first summary instead of being displaced by a denser dashboard layout
  - Home focus restore now treats the continue-journey lane as one remembered section
- Phase 6 tvOS Qur'an browse/reading foundation landed on 2026-03-25:
  - the native Qur'an route now defaults focus toward browse instead of playback
  - curated browse collections now sit above the surah list so TV navigation starts with simpler remote-friendly entry points
  - the reader stage now has stronger selected-surah and selected-ayah context
  - playback remains present, but is now positioned as supporting the reading route ahead of the dedicated listening-mode phase
- Phase 7 tvOS Qur'an listening foundation landed on 2026-03-25:
  - the native Qur'an playback card now opens a dedicated full-screen listening mode
  - listening mode reuses the same tvOS playback state instead of introducing a second player stack
  - the full-screen experience now supports repeat-current-ayah plus translation/transliteration visibility toggles
  - browse and reading remain the base route structure; listening is now a focused mode within that mirrored Qur'an surface
- Phase 10 tvOS Learn hub foundation landed on 2026-03-25:
  - Learn is now a sidebar-enabled mirrored tvOS route in the current `testflight` stage
  - the native route uses a curated master layout instead of porting the denser mobile Learn dashboard directly
  - current Learn shelves focus on guided paths, stories/reflection, and broad knowledge domains for family-room use
  - shared tvOS route and section registries now treat `/learn` as an enabled adaptation surface with stable module ordering
- Phase 11 tvOS stories/reflection foundation landed on 2026-03-25:
  - the Learn route now includes a dedicated story-and-reflection stage for Prophets, Seerah, and Daily Wisdom
  - story content stays inside the existing Learn route instead of creating separate tvOS-only story routes
  - shared tvOS section/module registries now track explicit Phase 11 Learn modules for Prophets stories, Seerah reflection, and Daily Wisdom
- Phase 15 tvOS visual-learning foundation landed on 2026-03-25:
  - the Learn route now includes a dedicated signs/creation visual-learning stage
  - visual learning stays inside the existing Learn route instead of opening a separate tvOS creation route
  - shared tvOS section/module registries now track explicit Phase 15 Learn modules for signs-in-creation and observation-first visual learning
- Phase 8 tvOS Prayer foundation landed on 2026-03-25:
  - Prayer is now a sidebar-enabled tvOS route at `/worship/prayer`
  - the native route uses a calm current/next summary, full-day schedule shelf, and lightweight prayer companion cards
  - shared tvOS section/module registries now track explicit Phase 8 Prayer modules for current-next summary, schedule, and companion guidance
- Phase 9 tvOS Dhikr foundation landed on 2026-03-25:
  - Dhikr is now a sidebar-enabled tvOS route at `/worship/dhikr`
  - the native route uses guided remembrance mode selection, phrase-by-phrase flow, and lightweight companion guidance instead of a touch-counter port
  - shared tvOS section/module registries now track explicit Phase 9 Dhikr modules for mode selection, guided flow, and companion guidance
- Phase 12 tvOS Kids foundation landed on 2026-03-25:
  - Kids is now a sidebar-enabled tvOS route at `/learn/kids/fun-learning`
  - the native route uses family-safe path selection, featured story focus, and lightweight household guidance instead of a tablet-style kids app port
  - shared tvOS section/module registries now track explicit Phase 12 Kids modules for primary paths, featured stories, and family guidance
- Phase 13 tvOS Arabic foundation landed on 2026-03-25:
  - Arabic is now a sidebar-enabled tvOS route at `/quran/arabic`
  - the native route uses beginner path selection, grouped-letter learning, and lightweight learner/family guidance instead of a dense lesson browser or typing-heavy Arabic tool
  - shared tvOS section/module registries now track explicit Phase 13 Arabic modules for primary paths, letter groups, and family guidance
- Phase 14 tvOS Games foundation landed on 2026-03-25:
  - Games is now a sidebar-enabled tvOS route at `/learn/games`
  - the native route uses remote-first game-path selection, single-choice challenge interaction, and lightweight family-room guidance instead of typing-heavy or touch-style game ports
  - shared tvOS section/module registries now track explicit Phase 14 Games modules for primary paths, challenges, and family guidance
  - current sandbox verification passed Flutter tests/analyze, but native unsigned `xcodebuild` remains environment-blocked by Xcode module-session write failure rather than a confirmed source-level compile defect
- Phase 16 tvOS Saved foundation landed on 2026-03-25:
  - Saved is now a sidebar-enabled tvOS route at `/quran/bookmarks`
  - the native route uses read-first saved-lane selection, resume-ready saved items, and watch-later or playlist continuity instead of dense save-management UI
  - shared tvOS section/module registries now track explicit Phase 16 Favorites modules for primary paths, saved items, and watch-later continuity
  - unsigned native `Release` build now passes again when built with an explicit module-cache override: `CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_phase16_modulecache`
- Phase 17 tvOS localization/readability/accessibility hardening landed on 2026-03-25:
  - shared native readability and accessibility helpers now exist in `ios/PathOfNurTV/Support`
  - mirrored Home and Qur'an surfaces, playback/listening controls, navigation shell, saved cards, and prayer cards now expose stronger readable text behavior plus combined accessibility descriptions
  - focus-selected state is now surfaced through accessibility traits in the shared focusable-card modifier
  - unsigned native `Release` build passes after the Phase 17 hardening pass with `CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_phase17_modulecache`
- Phase 18 tvOS offline/caching/sync-aware foundation landed on 2026-03-25:
  - shared Flutter-side resilience models and route-aware snapshot building now exist under `lib/features/tvos/`
  - active tvOS routes are now explicitly modeled as offline-ready with companion-device sync handoff expectations instead of implying live Apple TV sync management
  - the tvOS shell now shows a route-aware offline and sync status card for Qur'an, worship, and learning surfaces
  - unsigned native `Release` build passes after the Phase 18 hardening pass with `CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_phase18_modulecache`
- Phase 19 tvOS profiles/household continuity foundation landed on 2026-03-25:
  - Profiles is now a sidebar-enabled tvOS route at `/accounts-sync/profiles`
  - the native route focuses on household switching, per-profile last-route continuity, and shared-device guidance instead of porting the full mobile accounts manager
  - shared tvOS route and section registries now treat Profiles as an enabled Phase 19 adaptation surface with stable module ordering
  - unsigned native `Release` build passes after the Phase 19 pass with `CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_phase19_modulecache`
- Phase 24 tvOS analytics/crash-safety foundation landed on 2026-03-25:
  - shared Flutter-side quality guardrail models and policy helpers now exist under `lib/features/tvos/`
  - the native tvOS target now logs local-first diagnostics for route opens, profile switching, listening behavior, settings changes, and playback failures
  - Settings now exposes a diagnostics summary card so quality posture is visible without adding backend analytics dependencies
  - unsigned native `Release` build passes after the Phase 24 pass with `CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_phase24_modulecache`
- Phase 25 tvOS regression-harness foundation landed on 2026-03-25:
  - shared Flutter-side focus QA and regression models now exist under `lib/features/tvos/`
  - the active tvOS sidebar route set now has a canonical QA matrix for default sections, ordered focus groups, left-edge sidebar escape, and modal-return expectations
  - shared tests now fail if enabled sidebar routes, focus-required quality guardrails, and route-level focus ordering drift apart
  - unsigned native `Release` build passes after the Phase 25 pass with `CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_phase25_modulecache`
- Phase 26 tvOS performance-hardening foundation landed on 2026-03-25:
  - shared Flutter-side performance profiles now identify Home, Qur'an, and Learn as the current large-surface optimization priorities
  - the native tvOS Home, Learn, and Qur'an routes now use lazy shelf or lazy vertical rendering in their heaviest sections
  - Qur'an now caches the active selected-ayah payload inside the view model instead of repeatedly deriving it from the repository during selection-heavy interactions
  - unsigned native `Release` build passes after the Phase 26 pass with `CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_phase26_modulecache`
- Phase 23 tvOS update-governance foundation landed on 2026-03-25:
  - shared Flutter-side governance models now define the active update channel, governed route scope, required gating phases, and release gates
  - the TestFlight checklist now matches the actual active tvOS shell instead of the earlier Home-plus-Qur'an-only assumption
  - current governance explicitly allows TestFlight posture only and keeps public promotion blocked on real-device Apple TV QA
  - unsigned native `Release` build passes after the Phase 23 pass with `CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_phase23_modulecache`
- Phase 27 tvOS launch-polish/readiness hardening landed on 2026-03-25:
  - shared Flutter-side launch-readiness models now define testflight readiness vs public-launch blockers for the current tvOS shell
  - native tvOS Learn, Saved, Profiles, Arabic, and Kids routes now show explicit empty-state cards instead of mostly blank shelves or detail rails when optional content is absent
  - current repo-side posture is now encoded as testflight-ready but still blocked for public launch by signed-distribution proof and real-device Apple TV QA
  - unsigned native `Release` build passes after the Phase 27 pass with `CLANG_MODULE_CACHE_PATH=/tmp/path_of_nur_phase27_modulecache_escalated_retry`
- not first-release ready
- should not be advertised as shipping until release-grade validation is complete

## Simulator / device-specific conditions

- active iOS backlog items include:
  - Apple Silicon simulator config hardening
  - Xcode 26+ local setup documentation
  - plugin compatibility review
  - Creation Explorer camera latency tuning
- open non-fatal investigation:
  - `This FlutterEngine was already invoked.`

## Release-readiness summary

- ready enough for primary focus:
  - iOS
  - iPadOS
- conditional:
  - macOS
- not ready:
  - Apple Watch as a launch-ready surface, despite native V1 scaffolding now compiling
  - tvOS
  - any claimed Path of Nūr production cloud sync
