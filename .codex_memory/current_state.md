# Current Project State

Last updated: 2026-03-19

## A. Project summary

Path of Nur is a Flutter + Riverpod mobile app centered on worship, Qur'an engagement, learning journeys, reminders, and profile-aware daily practice. The repo is local-first today, with iOS/iPadOS as the practical first release target and Apple sync limited to iCloud key-value storage rather than a production backend.

## B. Architecture summary

- App shell: `MaterialApp.router` + `GoRouter` with onboarding guard, shared-profile launch guard, quick actions, and telemetry observer.
- State management: Riverpod providers and notifiers throughout the app.
- Persistence:
  - `SharedPreferences` via `LocalStore` for profile/settings/lightweight state.
  - `sqlite3` via `AppDatabase` for structured records such as prayers, dhikr, ocean drops, and sync/outbox tables.
- Core systems:
  - prayer schedule/preferences/reminders
  - local notifications + adhan audio
  - app telemetry/crash logs
  - localization through generated `AppLocalizations`
- Navigation shape:
  - top-level tabs now effectively route to Worship, Learn, Home, Journey, and Qur'an
  - settings/profile support pages were moved under settings-oriented routes
  - many legacy aliases still exist for compatibility

## C. Implemented features

- Onboarding flow with prayer reminder choices and first-run routing.
- Worship tracking:
  - prayer completion/status
  - dhikr presets and sessions
  - fasting status/reminders
  - khusu focus and qibla finder
- Prayer/reminder platform logic:
  - local notifications
  - adhan audio selection and preview
  - reminder scheduling with cycle-aware adjustments
  - live activity support paths for fasting/prayer-related moments
- Home dashboard and daily summary surfaces.
- Journey/growth system:
  - today, habits, paths, reflection, progression sync, rewards hooks
  - Ocean drops integration
  - canonical ledger-backed Drops V1 architecture with summary, service hooks, and Garden milestone gallery
  - dedicated Garden V1 page with Drops-backed unlock summary, next-unlock progress, fullscreen viewer, and reusable gallery widgets routed at `/journey/garden`
  - unified tracking/dashboard structure for habits, Ocean, and cross-feature summaries
  - dedicated habit settings and calendar pages built on the existing Growth controller/state
  - custom Growth habit categories with persisted custom habit/category ownership inside the canonical Growth state
  - wallpaper unlock support
- Learn ecosystem with many active domains:
  - Qur'an reader/search/bookmarks/notes/topics/top words/word review/99 names
  - Qur'anic Arabic / teaching modules, review, listen-only, asset manifests
  - Salah learning, guided prayer, surah detail, wudu guide/trainer
  - Prophets domain with stories, detail pages, timeline/map/family tree/quiz
  - Hadith landing, themed lessons, important hadith, learning paths, quiz/review
  - Life and World lesson systems with themed/subcategory/detail routes
  - Dua hub and detail pages with verified-vs-stub awareness
  - Trivia sessions, results, review, stats, knowledge paths
  - New learning journey domain with islands, journey home, stage detail, browse-all, lesson wrappers, localized metadata layer, and route adapters into existing tools
- Accounts/profiles/sync foundations:
  - local profile/account model
  - sync/outbox/cursor schema
  - backup/import/export surfaces
  - shared-device profile launch guard
- Watch companion contract:
  - watch snapshot, settings snapshot, dedup/validation, diagnostics
  - QA matrix and automated tests for core contract logic
  - native iPhone bridge now publishes Flutter snapshot/settings data to Apple Watch via WatchConnectivity
  - integrated watchOS V1 app now exists inside `ios/Runner.xcodeproj`
- Additional feature surfaces:
  - assistant
  - celestial explorer
  - creation explorer + challenges
  - circles/community pages
  - journal timeline/create
  - wallpaper library
- Release/support infrastructure:
  - privacy, terms, support, attributions pages
  - iCloud sync release notes/checklist
  - route map and release-readiness docs

## D. Partial / in-progress features

- Learning Journey is active but still mixed:
  - some journeys route to real lesson-backed or existing pages
  - several stage chains remain explicitly `partial` or `placeholder`
  - metadata localization scaffolding exists, but larger seeded lesson bodies are still not fully localized
- Learn information architecture is in transition:
  - `/learn` now separates standard Learn discovery from a dedicated `Learning Journey` island entry, but broad legacy content systems still coexist
  - duplicate or overlapping entry points remain between Learn, Qur'an, and older content hubs
- Dua dataset is intentionally incomplete:
  - verified entries are live
  - many scaffold-only `stub_*` entries remain tracked but not fully authored
- Accounts sync is architected but not production-backend-ready:
  - docs explicitly say release-safe posture is local-only/manual backup/iCloud on Apple devices
- Companion platforms:
  - Apple Watch now has a native V1 companion app with Home, Prayer, Dhikr, Progress, Utility, offline cache, and sync scaffolding
  - watch Phase 3 refinement now adds polished next-prayer complications, post-prayer adhkar mini flow, deeper haptic states, and watch deep-link foundation for future notification routing
  - watch Phase 5 hardening now adds prayer reminder notification actions on the Apple notification path, prayer-row focus routing on watch, tighter complication refresh scheduling, reconnect-triggered snapshot refresh, and fully phone-authored watch settings values for follow-up and snooze preferences
  - watch Phase 6 now adds Auto Dhikr as a native watch-only guided mode with persisted phrase/target/interval preferences, timer-driven recurring haptics, pause/resume/end flows, cache recovery, and sync handoff through the existing dhikr session action pipeline
  - the first complication set now includes Next Prayer for `accessoryRectangular`, `accessoryInline`, and `accessoryCircular`; Prayer Progress for `accessoryCircular` and `accessoryRectangular`; and Auto Dhikr launch complications for `accessoryInline` and `accessoryRectangular`, all reading from the shared watch cache with `pathofnurwatch://` deep links
  - Wear OS contract logic exists
  - release validation is still outstanding
- tvOS now has one canonical native implementation path in `ios/PathOfNurTV` under the `PathOfNurTV` target, with a V1 Home + Qur'an surface that mirrors the mobile app direction as closely as practical while remaining not first-release ready.
- Localization coverage is improving, with locale integration tests added, but many high-traffic pages still contain hardcoded strings. The new watchOS surface is localization-ready through native `Localizable.strings`, but non-English watch locale resources still need to be authored.
- Learning quote usage is now standardized through a shared compact Qur'an 20:114 helper (`Rabbi Zidnee Ilmaa`) across active Learn/Growth quote-banner surfaces instead of repeated handwritten quote objects.
- The app-wide section architecture is moving toward a consistent hub pattern:
  - `/learn` now lands on an island-based `LearningSectionLandingPage`
  - `/worship` is now a landing hub with dedicated Prayer, Dhikr, Duas, Fasting, Tracking, and Reminders pages
  - Growth now uses dedicated destination routes (`/journey/today`, `/journey/paths`, `/journey/progress`, `/journey/reflection`, `/journey/habits`) instead of a mixed filter-first landing
  - Settings now has a landing page with dedicated category destinations under `/settings/*`
- iOS simulator/platform adjustments are in flight in the dirty worktree, with an open investigation around duplicate engine warm-up logs.

## E. Planned but not yet built items

- Consolidate overlapping Learn systems into one clearly owned IA.
- Replace remaining placeholder journey stages:
  - Seerah follow-on depth
  - Daily Wisdom
  - Fiqh Basics
  - Timeline of Islam
  - Tajweed Basics
  - short-surah meaning path
- Deep-link richer journey destinations into exact Prophets/Hadith/Trivia/Qur'anic Arabic states.
- Add stronger learning progress persistence, continue-learning behavior, dwell-time tracking, and stage completion rewards.
- Finish large localization sweep across Home, Worship, Learn, Settings, Accounts Sync, and journey surfaces.
- Add stronger test coverage for learning journey, progress persistence, and app launch smoke paths.
- Ship CI/platform hardening around iOS simulator settings and Apple Silicon assumptions.

## F. Removed / deprecated / orphaned items

- Deleted from the active worktree:
  - `lib/features/journey/presentation/journey_legacy_page.dart`
  - `lib/features/journey/presentation/widgets/journey_widgets.dart`
  - `lib/features/learn/presentation/pages/learn_section_placeholder_page.dart`
  - `lib/features/profile/presentation/profile_page.dart`
  - `lib/features/shared/section_detail_page.dart`
  - `lib/features/worship/presentation/worship_page_legacy.dart`
- Navigation docs indicate the old top-level Profile tab is being retired in favor of Settings-owned routes.
- Legacy Learn routes still exist in places, but backlog direction is to archive/remove unused widgets/providers once routing ownership is clearer.
- README at repo root is outdated boilerplate and does not describe the real app.

## G. Risks / issues / technical debt

- Journey now has a canonical ledger-backed XP V1 architecture under `lib/features/journey/xp/`, but many older surfaces still read formula-based XP from `journey_progression_provider.dart`; those consumers need migration to remove parallel XP truth.
- Drops now also have a canonical ledger-backed V1 architecture under `lib/features/journey/drops/`, but many older features still award Ocean drops directly; those call sites need gradual migration so Ocean becomes a downstream projection rather than parallel drop ownership.
- App-side Qur’an quote/banner ownership is now reference-driven:
  - `QuranVerseRef`, `QuranQuoteRef`, `QuranAudioRef` live under `lib/features/learn/quran/domain/quran_content_refs.dart`
  - `QuranContentRepository` hydrates Arabic, transliteration, translation, and audio from the canonical Qur’an repositories
  - `QuranQuoteBlock` and the shared quote pools no longer store hardcoded Qur’an Arabic in presentation widgets
  - `/quran-verse` and shared Qur’an quote navigation now move verse metadata only, not raw Arabic/transliteration/translation strings
- Qur’an playback now has a centralized Bismillah-first policy layer:
  - `QuranPlaybackRequest`, `BismillahPlaybackMode`, and `QuranPlaybackOrchestrator` live under `lib/features/learn/quran/`
  - `QuranAudioRepository` now exposes canonical Bismillah metadata/source resolution
  - shell/watch resume paths now use `QuranPlayerController.resumeCurrentPlaybackWithBismillah()` instead of raw `player.play()`
  - persisted recitation-session resume now falls back through `QuranPlayerController` when no in-memory session exists
  - reader start/resume/jump paths prepare playback through the orchestrator before loading audio
  - watch adjacent-surah boundary transitions now route through `QuranPlayerController.playAdjacentSurahWithBismillah(...)`
  - in-reader ayah-entry jumps no longer raw-seek around the Bismillah policy path
- A repo-wide Qur’an Text and Audio Integrity audit report now exists at `docs/quran_text_audio_integrity_audit.md`, with a follow-up backlog in `docs/quran_text_audio_integrity_backlog.md`.
- Large dirty worktree means future engine updates must avoid trampling active user changes.
- Localization debt is high, especially on Settings, Accounts Sync, Journey reflection/habit pages, and several learn surfaces.
- Route sprawl is significant; there are many aliases, legacy redirects, and overlapping hubs.
- Growth/Tracking routing is cleaner than before, with dedicated routes for unified tracking, habit dashboard, habit settings, habit calendar, and the new Ocean dashboard, but the older Growth tab/deep-link split still needs long-term consolidation.
- Seeded educational content quality varies:
  - some surfaces are carefully structured
  - some still use placeholders or scaffold text
  - scholar/content verification metadata is incomplete in several areas
- The app has many major surface areas but limited automated coverage relative to scope.
- Upstream `codex_context_engine` README references runtime scripts (`boot.py`, `packet.py`, `query.py`, `global_metrics.py`) that are not present in the fetched upstream snapshot.
- Root README and some docs lag behind the codebase’s actual state.

## H. Recommended next steps in priority order

1. Finish the Learn IA cleanup so `/learn`, Qur'an, and legacy content routes stop overlapping.
2. Complete localization of high-traffic user-facing pages and remove remaining hardcoded strings from active flows.
3. Replace the most visible Learning Journey placeholders with real lesson-backed routes or explicit planned-state cards.
4. Add tests for Learning Journey home, continue journey, and stage completion/resume behavior.
5. Stabilize settings/profile/accounts sync copy and navigation under the new settings-first ownership.
6. Audit seeded Islamic content for source completeness, verification metadata, and placeholder references.
7. Decide which legacy Learn widgets/providers are safe to delete after current route migrations settle.
8. Refresh the root README so local contributors see the real product and setup posture.
9. Run paired Apple Watch QA for snapshot refresh, queued prayer actions, dhikr completion sync, complication refresh, and day rollover behavior.
10. Validate iOS simulator/native changes and close the duplicate Flutter engine bootstrap investigation.
11. Migrate remaining Home/Profile/Wallpaper/watch level consumers to the new ledger-backed XP summary and retire legacy formula XP ownership.
12. Migrate remaining direct Ocean award call sites to the canonical Drops ledger where trustworthy completion boundaries already exist.
13. Finish the remaining Qur’an integrity migration items called out in `docs/quran_text_audio_integrity_audit.md`, especially tvOS seed content and feature-level verse catalogs that still embed raw Arabic.

## I. Assumptions / uncertain areas

- This snapshot reflects the repo state as inspected on 2026-03-17, including user-owned uncommitted work already present in the tree.
- Some platform-companion code may be scaffolded more deeply than the Flutter-side docs reveal, but the release guidance in docs is treated as authoritative for readiness.
- The current engine install is repo-local and intentionally does not use the upstream cross-project installer, because the user requested repository-contained setup with minimal manual work.
