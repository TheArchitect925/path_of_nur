# Current Project State

Last updated: 2026-03-17

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
  - `/learn` is now journey-first, but broad legacy content systems still coexist
  - duplicate or overlapping entry points remain between Learn, Qur'an, and older content hubs
- Dua dataset is intentionally incomplete:
  - verified entries are live
  - many scaffold-only `stub_*` entries remain tracked but not fully authored
- Accounts sync is architected but not production-backend-ready:
  - docs explicitly say release-safe posture is local-only/manual backup/iCloud on Apple devices
- Companion platforms:
  - Apple Watch and Wear OS contract logic exists
  - release validation is still outstanding
- tvOS and watch native folders exist but are not first-release ready.
- Localization coverage is improving, with locale integration tests added, but many high-traffic pages still contain hardcoded strings.
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

- Large dirty worktree means future engine updates must avoid trampling active user changes.
- Localization debt is high, especially on Settings, Accounts Sync, Journey reflection/habit pages, and several learn surfaces.
- Route sprawl is significant; there are many aliases, legacy redirects, and overlapping hubs.
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
9. Validate iOS simulator/native changes and close the duplicate Flutter engine bootstrap investigation.
10. Decide whether to keep watch/tv companion code as incubating surfaces or explicitly gate them from release paths in-app.

## I. Assumptions / uncertain areas

- This snapshot reflects the repo state as inspected on 2026-03-17, including user-owned uncommitted work already present in the tree.
- Some platform-companion code may be scaffolded more deeply than the Flutter-side docs reveal, but the release guidance in docs is treated as authoritative for readiness.
- The current engine install is repo-local and intentionally does not use the upstream cross-project installer, because the user requested repository-contained setup with minimal manual work.
