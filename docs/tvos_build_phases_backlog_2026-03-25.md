# tvOS Build Phases Backlog

Date: 2026-03-25

Purpose:
- Enhancement options and follow-up decisions for the tvOS roadmap.

## Phase 20 follow-up enhancements

1. Add a focused prayer-display preference review only after shared prayer calculation and location posture are stable enough to expose safely on tvOS.
2. Add a reduce-motion and larger-Arabic-reading preference review once Phase 26 performance work and Phase 17 accessibility follow-up converge.
3. Add signed-in sync visibility for tvOS settings only after Phase 24 analytics/quality and Phase 25 regression coverage make the companion-device handoff trustworthy.

## Phase 24 follow-up enhancements

1. Add a lightweight diagnostics export or companion-device handoff only after Phase 25 regression coverage proves the payload is trustworthy.
2. Add route-level focus and playback recovery quality notes once Phase 25 focus-navigation QA begins.
3. Decide whether later release analytics should remain fully local-first on tvOS or selectively mirror only privacy-safe aggregate counters from companion devices.
4. Add a small native crash-context snapshot for active route and profile only if it stays local-first and does not complicate launch stability.

## Phase 25 follow-up enhancements

1. Add native XCTest or UI-test coverage for the highest-risk Qur'an focus paths once the tvOS target gains a dedicated test target.
2. Add a small generated report that turns the shared focus QA matrix into a release checklist artifact for TestFlight QA.
3. Add a parity alert test that fails when native tvOS route sections change without a matching update to the shared focus matrix.
4. Add real-device Apple TV QA evidence capture for sidebar return, listening-mode exit, and profile-switch resume once Phase 27 release readiness begins.

## Phase 26 follow-up enhancements

1. Add native Instruments-guided measurement for Qur'an browse-to-reader transitions and listening-mode open or close once real Apple TV device QA begins.
2. Add image and artwork loading strategy review if later phases introduce richer visual media on Learn or Kids shelves.
3. Add a focused cache and reuse review for tvOS seeded data if the target starts consuming larger shared payload bundles instead of the current curated sets.
4. Add a reduce-motion and focus-animation tuning pass only after real-device QA confirms whether current transitions still feel heavy on older Apple TV hardware.

## Phase 23 follow-up enhancements

1. Add an exportable release-governance summary that can be attached to TestFlight review notes or internal QA tickets.
2. Add environment-aware governance snapshots only if tvOS later needs separate internal and external TestFlight route scopes.
3. Add a build-time check that fails if the TestFlight checklist and shared governed route set drift apart again.
4. Add real-device QA evidence capture and checklist completion logging before Phase 27 public-readiness decisions.

## Highest-value next enhancements

1. Build a shared `tvOS parity manifest` that explicitly maps mirrored mobile surfaces to tvOS ownership and status.
2. Extract shared Home prayer-summary payloads so tvOS stops depending on local-only seeded prayer snapshots.
3. Extract shared Qur'an continue-reading and daily-verse payloads for tvOS consumption.
4. Align tvOS Qur'an playback state with the shared mobile playback contract before adding more features.
5. Add tvOS QA automation notes for focus order, audio behavior, and empty/fallback states.

## Product decisions to settle early

1. Decide whether tvOS should stay Home + Qur'an only for V1 TestFlight, or also include one additional family-facing shelf later.
2. Decide whether tvOS search is entirely deferred or replaced with browse-first curated sections.
3. Decide whether tvOS bookmarks/reflections are a near-term read-only feature or a later-phase phone-handoff feature.
4. Decide whether Top Shelf should stay static in V1 or later reflect continue-reading state.

## Technical quality opportunities

1. Add small shared compatibility checks so changes to mobile Home/Qur'an surfaces trigger a tvOS review.
2. Move tvOS strings toward a clearer shared localization ownership model if the native string layer grows.
3. Add tvOS smoke validation commands to release docs once archive/export flow is standardized.
4. Add Apple TV-specific final layered artwork when design assets are ready, replacing the interim derived assets.

## Phase 3 follow-up enhancements

1. Add a route-header breadcrumb or ambient route summary layer inside the content stage if future phases need more shell context than the current hero sections provide.
2. Add focused QA coverage for left-edge escape behavior from Home and Qur'an browse/playback boundaries.
3. Decide whether a future tvOS route should open in navigation-first mode or content-first mode before more mirrored surfaces are added.
4. Consider lightweight native telemetry for route-entry and focus-section restore events once the analytics phase begins.

## Phase 4 follow-up enhancements

1. Replace the remaining tvOS native seed Home/Qur'an summary values with a bridge that reads the shared parity payload bundle.
2. Expand the shared parity manifest to include explicit freshness/compatibility metadata once the feature-flag phase begins.
3. Decide whether the curated tvOS Qur'an browse list should stay fixed or become a shared recommendations-driven subset later.
4. Add a snapshot/export test once the parity bundle is consumed outside the Flutter provider layer.

## Phase 21 follow-up enhancements

1. Export surface and section flags together with the shared parity payload bundle when a native bridge layer is introduced.
2. Add a lightweight assertion test that fails if a mirrored surface is marked enabled without also requiring shared parity payloads.
3. Decide whether future limited-release phases need environment-specific stage overrides or whether the repo should stay on one canonical tvOS stage constant.
4. Add a single release-governance report helper that lists enabled, staged, and iOS-only tvOS surfaces for audits.

## Phase 22 follow-up enhancements

1. Add a registry validation test that prevents duplicate section keys, duplicate module order within a route, and missing dependency keys.
2. Decide whether future later-phase surfaces should each own one route bundle or whether some should be nested modules under an existing route.
3. Export onboarded route bundles alongside flags and parity payloads once native bridge consumption begins.
4. Add module-level freshness/version metadata if native caching later depends on registry snapshots.

## Phase 5 follow-up enhancements

1. Replace the current native continue-journey seeded entries with bridge-fed shared parity payloads so Home reflects true mobile-aligned resume state.
2. Add a route-aware resume distinction between reading-state and listening-state so Home can return users to the strongest actual Qur'an continuation path.
3. Add Apple TV QA coverage for horizontal shelf focus restore after Home -> Qur'an -> Home transitions.
4. Decide whether the prayer-focused continue-journey card should later deep-link into a dedicated tvOS prayer route or remain a Home-only summary action until the prayer phase ships.

## Phase 6 follow-up enhancements

1. Replace the current native Qur'an browse collections with shared parity-fed recommendation bundles once the native bridge/export layer is ready.
2. Add exact ayah-opening behavior from the daily-verse summary card instead of only selecting the parent surah.
3. Add a real recent-reading or family-recitation collection driven by shared continuation data rather than static curated seeds.
4. Keep Phase 7 focused on full-screen listening mode and expanded playback controls without reworking the browse/reader structure added here.

## Phase 7 follow-up enhancements

1. Add QA coverage for exiting listening mode back into the Phase 6 browse/reader route while playback continues.
2. Consider a tvOS-safe sleep timer only if it can remain remote-friendly and does not complicate the listening surface.
3. Bridge listening-mode display preferences to shared Qur'an reader settings once a shared native/export preference contract exists.
4. Add subtle ayah-transition polish later, but keep motion restrained and performance-safe for Apple TV hardware.

## Phase 10 follow-up enhancements

1. Replace the current native Learn shelves with shared Learn manifest-fed bundles once a native/shared bridge exists, so tvOS content stays closer to live mobile ownership.
2. Add a true `Continue learning` entry when shared Learn journey state can expose the strongest next lesson or module for tvOS.
3. Add Apple TV QA coverage for Learn focus order, detail-rail updates, and navigation escape behavior across all shelf clusters.
4. Decide whether a future stories/detail phase should stay inside the Learn master route or open a lightweight secondary stage without fragmenting the shell too early.

## Phase 11 follow-up enhancements

1. Replace the Phase 11 seeded Prophets, Seerah, and Daily Wisdom collections with shared Learn-owned manifest bundles once native/shared content bridging is available.
2. Add a calm story-detail expansion pattern only if it can stay route-contained under `/learn` and preserve the family-room simplicity of the current stage.
3. Add Apple TV QA coverage for story-card focus restore, detail-rail updates, and left-edge navigation escape from the Phase 11 stage.
4. Decide whether last-selected story state should later be household-aware once the profiles and continuity phases are active.

## Phase 15 follow-up enhancements

1. Replace the seeded Phase 15 signs/creation collections with shared World and Creation manifest-fed bundles once native/shared Learn bridging exists.
2. Add restrained ambient polish only if it stays performance-safe and does not distract from observation-first learning.
3. Add Apple TV QA coverage for visual-card focus restore, detail-rail updates, and transitions between story and visual learning stages.
4. Decide whether household continuity should later remember the last-selected visual collection once profile/session continuity work lands.

## Phase 8 follow-up enhancements

1. Replace the current native prayer snapshot route data with a stronger shared prayer parity bridge once mobile/shared prayer contracts are stable enough for tvOS consumption.
2. Add Apple TV QA coverage for prayer-boundary refresh, route-entry focus restore, and day-rollover behavior across the Prayer route.
3. Decide whether Home should always deep-link into the dedicated Prayer route or keep some prayer summary flows on Home depending on context.
4. Add a low-friction post-prayer dhikr handoff later only if it stays remote-friendly and does not turn Prayer into a dense worship hub.

## Phase 9 follow-up enhancements

1. Replace the current native Dhikr mode and phrase seeds with shared worship-owned manifest data once a stronger mobile-to-tvOS bridge exists.
2. Add Apple TV QA coverage for Dhikr mode switching, focus restore, and left-edge navigation escape after guided-flow interaction.
3. Decide whether later phases should add lightweight audio accompaniment or spoken guidance for Dhikr without turning the route into a second playback engine.
4. Add a calm post-prayer handoff from the Prayer route into the Dhikr route only if shared prayer continuity can identify the right context cleanly.

## Phase 12 follow-up enhancements

1. Replace the current native Kids story and learning seeds with shared kids-learning manifest bundles once mobile-to-tvOS content bridging is available.
2. Add Apple TV QA coverage for mixed-age family use, focus restore, and left-edge navigation escape across the Kids route.
3. Decide whether the bedtime lane should later hand off directly into Dhikr or short-surah listening without overcomplicating the route.
4. Add lightweight household continuity for last-selected kids path only when Phase 19 profile/session work is ready.

## Phase 13 follow-up enhancements

1. Replace the current native Arabic letter-group and beginner-path seeds with shared Arabic-learning manifest bundles once mobile-to-tvOS content bridging is available.
2. Add Apple TV QA coverage for route focus restore, letter-group readability at distance, and left-edge navigation escape across the Arabic route.
3. Decide whether the route should later add very lightweight audio replay controls for grouped letters without becoming a full lesson player.
4. Add a stronger shared handoff from tvOS Arabic into the existing Qur'an readiness and short-surah bridge only when continuity and recommendation signals are ready.

## Phase 14 follow-up enhancements

1. Replace the current native game-path and challenge seeds with shared Learn-owned games manifests once mobile-to-tvOS content bridging is available.
2. Add Apple TV QA coverage for answer-state visibility, focus restore, and left-edge navigation escape across the Games route.
3. Decide whether later phases should surface crossword and word-search only as simplified browse-first challenge cards or through a stronger phone-handoff pattern.
4. Add shared continuity for `review mistakes` and `continue challenge` only when profile/session continuity can identify the right household or learner safely.

## Phase 16 follow-up enhancements

1. Replace the current native saved-item seeds with shared bookmark, reflection, and listening-queue payloads once the tvOS bridge can consume real mobile-owned saved state.
2. Add Apple TV QA coverage for Saved route focus restore, sidebar return, and lane-to-item continuity after Home and Qur'an transitions.
3. Decide whether later phases should expose any remote-light save actions on tvOS or keep the route strictly resume-first and hand off authoring to iPhone/iPad.
4. Add household-aware last-saved and continue-listening continuity only when Phase 19 profile/session work can identify the active room safely.

## Phase 17 follow-up enhancements

1. Run a dedicated Apple TV VoiceOver QA pass across Home, Qur'an, Prayer, Dhikr, Learn, Kids, Arabic, Games, and Saved to validate spoken order, hints, and selected-state clarity on real hardware.
2. Add route-level accessibility summaries or a lightweight help overlay only if user testing shows the sidebar and long-form shelves still need orientation support.
3. Add large-text, RTL, and mixed-language QA coverage for Arabic-heavy and bilingual surfaces so the new readability helpers are validated beyond the default English layout.
4. Normalize future tvOS text surfaces onto the shared readability helper layer as new phases ship, instead of reintroducing one-off accessibility labeling or sizing rules.

## Phase 18 follow-up enhancements

1. Bridge the shared `tvosResilienceSnapshotProvider` into native tvOS once a real Flutter-to-native export layer exists, replacing the current route-group seeding in the shell status card.
2. Add real Apple TV QA coverage for cold launch without network, resume after connectivity loss, and post-backup or sign-in state refresh.
3. Decide whether Saved and Qur'an should later expose lightweight stale-data timestamps without cluttering the large-screen layout.
4. Keep backup, import, and restore authoring on iPhone or iPad unless the later settings phase can prove a calm tvOS-safe version.

## Phase 19 follow-up enhancements

1. Bridge the native tvOS household profile state to the shared Flutter active-profile and shared-device truth once a native-to-shared export path exists, so Apple TV switching stops relying on seeded profile personas.
2. Add real Apple TV QA coverage for repeated profile switching, sleep-wake resume, and mixed-age household use across Home, Qur'an, Kids, and Arabic routes.
3. Decide whether later phases should expose a lightweight protected-profile re-entry check on tvOS or keep that entirely on companion devices.
4. Keep account editing, backup authoring, and deeper permissions management on iPhone or iPad unless the tvOS settings phase can prove a calm television-safe version.

## Phase 27 follow-up enhancements

1. Extend the new empty-state coverage to Home, Qur'an, Prayer, Dhikr, Games, and Settings so every active tvOS route fails calmly if a later shared manifest or parity bridge returns sparse data.
2. Replace native-seeded empty-state decisions with shared Flutter parity and content-registry signals once a stronger Flutter-to-native export path exists.
3. Add signed archive, TestFlight upload, and real-device QA evidence into the shared launch-readiness contract so the remaining public-launch blockers stop living partly outside code.
4. Add a small launch-help overlay or first-run route orientation only if real Apple TV QA shows new users still need sidebar or focus guidance on the active shell.
