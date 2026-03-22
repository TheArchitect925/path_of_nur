# Current Project State

Last updated: 2026-03-22

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
  - dedicated Garden route at `/journey/garden` now resolves to a learner-scoped visual growth page built on the shared progression ledger, existing garden milestone gallery, and safe Journey fallback for non-child mode
  - unified tracking/dashboard structure for habits, Ocean, and cross-feature summaries
  - unified Journey Stats page at `/journey/tracking` for core progress metrics
  - Growth home Qur'an reading tracker card that opens Journey Stats
  - Journey Stats now also surfaces total post-Salah adhkar completions from stored prayer-log timestamps
  - Journey Stats and Growth now also surface lifetime adhkar totals and total time in dhikr, with new dhikr sessions recording a real active-session start timestamp instead of inferring duration from count
  - Journey Stats now also includes a Time & Reflection section driven by a persisted first-launch timestamp plus trustworthy tracked app time (Qur'an reading, Qur'an listening, dhikr), with the remainder labeled honestly as other/untracked time
  - dedicated habit settings and calendar pages built on the existing Growth controller/state
  - custom Growth habit categories with persisted custom habit/category ownership inside the canonical Growth state
  - Spiritual Growth Layer under Journey with:
    - home at `/journey/spiritual-growth`
    - intention picker at `/journey/spiritual-growth/intentions`
    - reflection page at `/journey/spiritual-growth/reflection`
    - theme summary page at `/journey/spiritual-growth/themes`
    - deterministic daily intention suggestions seeded by audience, adaptive profile, and real app activity
    - recognized growth actions derived from existing salah, dhikr, Qur'an, learning, and Daily Knowledge Challenge completion signals
    - lightweight manual real-life action acknowledgments for kindness, speech, gratitude, anger control, and sincere dua
    - respectful reflection flow with seeded prompt/response content, optional note capture, and theme summaries
    - shared Journey XP / Drops / progression hooks for once-per-day reflection completion without creating a parallel reward system
  - wallpaper unlock support
- Learn ecosystem with many active domains:
  - Qur'an reader/search/bookmarks/notes/topics/top words/word review/99 names
  - Qur'an reader `Learn More` and `QuranReferenceViewer` now also consume a shared ayah-enrichment layer that aggregates starter entries from Qur'an Study seeds, Divine Life Lessons, and World & Creation without mixing lesson metadata into the canonical Qur'an text repository
  - the ayah-enrichment layer now also has a canonical display contract with fixed domains, lesson types, normalized tags, explicit link strength, typed display items, caution levels, and mixed-item priority rules so one ayah can surface multiple intentional linked knowledge items safely
  - Ayah Insights now also has a Qur'an-owned browse/discovery flow:
    - browse route at `/quran/insights`
    - lightweight global search route at `/quran/knowledge-search`
    - domain route at `/quran/insights/:domainId`
    - Learning Hub entry points from the Qur'an app hub and Qur'an Learning hub
    - calm domain cards for Signs in Creation, Worship & Remembrance, Character & Adab, Tawhid & Belief, Akhirah & Accountability, Prophets & Lessons, and Guidance & Reflection when available
    - per-domain lists that deep-link into the Qur'an reader at the exact ayah instead of introducing a dead-end detail page
    - a local grouped knowledge search that reuses existing Ayah Insights, guided paths, and surah-insight data rather than adding a second search/indexing engine
  - Ayah Insights now also has a lightweight learning-path layer:
    - path browse route at `/quran/insights/paths`
    - path detail route at `/quran/insights/paths/:pathId`
    - six curated starter paths for Signs in Creation, Worship & Remembrance, Character & Adab, Tawhid & Belief, Akhirah & Accountability, and Prophets & Lessons
    - path detail pages that present ordered ayah-insight sequences and tap straight back into the reader at the relevant ayah
  - Qur'an learning now also has a V1 surah-insight layer:
    - browse route at `/quran/surah-insights`
    - detail route at `/quran/surah/:surahNumber/insights`
    - curated starter surah pages for Al-Baqarah, Ali 'Imran, Ta-Ha, Al-Furqan, and Luqman
    - concise surah overview, key themes, key lessons, Ayah Insight clusters, and suggested guided paths
    - reader-level entry card when the current surah has curated insight coverage
  - Qur'anic Arabic / teaching modules, review, listen-only, asset manifests
  - Salah learning, guided prayer, surah detail, wudu guide/trainer
  - Prophets domain with stories, detail pages, timeline/map/family tree/quiz
  - Hadith landing, themed lessons, important hadith, learning paths, quiz/review
  - Life and World lesson systems with themed/subcategory/detail routes
  - Dua hub and detail pages with verified-vs-stub awareness
  - Trivia sessions, results, review, stats, knowledge paths
  - Crossword puzzle engine with:
    - Quizzes-owned home at `/learn/quizzes/crossword`
    - pack route at `/learn/quizzes/crossword/pack/:packId`
    - daily route at `/learn/quizzes/crossword/daily`
    - puzzle route at `/learn/quizzes/crossword/puzzle/:puzzleId`
    - kids and adult puzzle catalogs
    - themed puzzle packs and pack-level progress summaries
    - reusable layout-template catalog and semi-dynamic assembled puzzles with safe fallback to seeded boards
    - deterministic validation layer for entries, templates, puzzles, and pack references
    - deterministic weekday-theme daily resolver with recent-repeat avoidance and target-difficulty balancing
    - full daily challenge layer with optional bonus objectives, bonus reward guard, stored completion time, recent daily history, and daily contribution messaging
    - local solved/completed progress persistence plus cell-level resume state and persisted clue-focus direction
    - reveal-letter, reveal-word, and extra-hint support with per-puzzle limits
    - local daily completion tracking and crossword daily streak summary
    - shared Journey XP / Drops / progression reward hooks with reward dedupe
    - content bundle/version metadata plus a documented crossword content pipeline for future offline content-pack and live-override work
    - Phase 4/5 polish with resume-first home surfacing, mode progress overviews, pack list prioritization, daily history, better cell/clue accessibility semantics, and stronger daily completion feedback
    - Knowledge Games foundation layer with shared game/session/result models, generic recommendation helpers, reusable game shell, and a crossword adapter so future game types can plug into the same engine without replacing crossword models yet
  - Word Search game with:
    - Quizzes-owned home at `/learn/quizzes/word-search`
    - pack route at `/learn/quizzes/word-search/pack/:packId`
    - daily route at `/learn/quizzes/word-search/daily`
    - puzzle route at `/learn/quizzes/word-search/puzzle/:puzzleId`
    - kids and adult puzzle catalogs with themed packs
    - deterministic seeded word placement with validation and safe offline daily resolution
    - shared Knowledge Games adapter/shell integration without changing crossword behavior
    - local progress persistence for found words, selection state, hints, completion, and daily history
    - shared Journey XP / Drops / progression reward hooks with reward dedupe
  - Matching Game with:
    - Quizzes-owned home at `/learn/quizzes/matching`
    - pack route at `/learn/quizzes/matching/pack/:packId`
    - daily route at `/learn/quizzes/matching/daily`
    - puzzle route at `/learn/quizzes/matching/puzzle/:puzzleId`
    - kids and adult seeded matching catalogs with themed packs
    - shared Knowledge Games adapter/shell integration and shared Quizzes discoverability
    - offline daily resolver with weekday-theme routing and profile-aware kids/adult selection
    - local progress persistence for matched pairs, hint usage, selection state, completion, and daily history
    - shared Journey XP / Drops / progression reward hooks with reward dedupe
  - Ayah Completion game with:
    - Quizzes-owned home at `/learn/quizzes/ayah-completion`
    - pack route at `/learn/quizzes/ayah-completion/pack/:packId`
    - daily route at `/learn/quizzes/ayah-completion/daily`
    - puzzle route at `/learn/quizzes/ayah-completion/puzzle/:puzzleId`
    - seeded kids and adult ayah-completion catalogs built only from canonical Qur'an references and runtime-hydrated verse text
    - shared Knowledge Games adapter/shell integration and Quizzes discoverability
    - profile-aware daily routing, local progress persistence for blank fills / hints / completion / daily history, and shared Journey XP / Drops / progression reward hooks with reward dedupe
    - verse-reference deep links into the shared Qur'an reader plus optional shared ayah playback
  - new History / Historical Calendar system with:
    - seeded offline archive dataset
    - On This Day home card
    - today-matches page
    - event detail page
    - Learn archive entry at `/learn/history`
  - Learn-owned Games Island discovery layer with:
    - main route at `/learn/games`
    - section route at `/learn/games/:sectionId`
    - reuse of existing Daily Knowledge, Crossword, Word Search, Matching, Ayah Completion, Hadith Reflection, Spiritual Growth, and pack routes instead of new game engines
    - Kids Learning wrapper routes at `/learn/kids/games`, `/learn/kids/arabic-learning`, and `/learn/kids/fun-learning` so kids-only game discovery remains separate from the non-kids Games Island
  - Kids bedtime prophet stories with:
    - list route at `/learn/kids/bedtime-stories`
    - detail route at `/learn/kids/bedtime-stories/:storyId`
    - seeded Adam, Nuh, Ibrahim, Ismail, Yusuf, Musa, Yunus, Dawud, Isa, Sulaiman, and Prophet Muhammad ﷺ Parts 1-4 story catalog
    - transcript-first reading flow with graceful fallback when narration is not bundled
    - just_audio-backed local asset playback when narration assets exist
    - local progress / completion persistence and first-completion Journey XP / Ocean Drops hooks
    - media-aware canonical asset manifest/resolver for future multilingual narration and illustration expansion
    - bedtime queue/session controller with single-story, tonight, and multipart-series playback flow plus in-session sleep timer handling
    - floating mini player on bedtime surfaces and a full-player sheet with next/previous, seek, autoplay toggle, and calm completion state
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
- Crossword UI chrome is localized, while the seeded clue content remains English-first for V1 and should be treated as translation-ready dataset content.
- Ayah Completion UI chrome is localized, while seeded puzzle metadata remains reference-driven and translation-ready through canonical Qur'an sources rather than handwritten verse text.
- Bedtime Stories now also include a lightweight bedtime learning loop:
  - story-linked quiz routes at `/learn/kids/bedtime-stories/:storyId/quiz`
  - story-linked memory routes at `/learn/kids/bedtime-stories/:storyId/memory`
  - seeded quiz and memory datasets for every bedtime prophet story
  - local-first progress persistence for quiz and memory activity state
  - bedtime detail/landing entry cards for Continue Learning and Tonight's Question
  - XP-only first-completion rewards for learning activities, separate from the existing story completion drop hook
- Bedtime Stories now also include a parent-facing progress surface at `/learn/kids/bedtime-stories/parents` with derived overview stats, prophet-by-prophet progress, recent bedtime activity, simple recommendation rules, and bedtime-habit summaries sourced from the canonical bedtime story and bedtime learning progress stores.
- Kids Learning now also includes a canonical learner-scoped kids activity ledger under `lib/features/kids/activity/`, with lightweight persistent entries for meaningful cross-feature events across bedtime stories, story learning, Seerah, dua learning, Arabic learning, and bedtime routines.
- The broader parent dashboard now prefers the canonical kids activity ledger for cross-feature recent activity, while safely falling back to older progression-derived signals when the canonical log has no entries yet.
- Kids Arabic tracing/review progress and parent preferences are now learner-scoped through the shared child-profile context, with one-time migration from legacy global Kids Arabic storage into the active learner scope.
- Kids Arabic lesson and daily-mission rewards now route through the shared learner progression ledger instead of writing directly into Journey XP / Ocean Drops services, reducing cross-profile leakage risk while preserving the existing tracing UX.
- Kids Arabic no longer emits the older global Learning Journey active-day compatibility writes, so its remaining meaningful progress and reward events now stay inside learner-scoped progression plus canonical kids activity logging.
- Kids Dua fallback learner identity now matches the bedtime-family fallback learner identity, preventing no-child-profile households from splitting dua progress, My Day state, creative state, and canonical kids activity across separate fallback learner IDs.
- Kids Dua creative drawings and parent-view preferences are now learner-scoped with one-time migration from the old global creative key and the older kids-dua-only fallback scope.
- Kids Dua My Day completion now writes a canonical kids activity entry, so parent summaries no longer need to rely only on progression-derived fallback signals for that flow.
- A top-level consolidation and execution-planning reference now exists at `docs/master_execution_roadmap_2026-03-22.md`, summarizing current readiness, remaining gaps, legacy items, and the recommended next phase order.
- Kids Learning now also includes a Seerah journeys layer:
  - hub at `/learn/kids/seerah`
  - journey route at `/learn/kids/seerah/:journeyId`
  - node route at `/learn/kids/seerah/:journeyId/node/:nodeId`
  - one learner-scoped Seerah journey pack reusing the shared kids story engine, Muhammad ﷺ bedtime story parts, shared quiz routes, companion-story seeds, and manual reflection/milestone nodes
  - companion stories for Khadijah رضي الله عنها, Abu Bakr رضي الله عنه, and Bilal رضي الله عنه are now part of the broader kids stories library and share canonical story progress, rewards, media resolution, and search exposure
- Learning quote usage is now standardized through a shared compact Qur'an 20:114 helper (`Rabbi Zidnee Ilmaa`) across active Learn/Growth quote-banner surfaces instead of repeated handwritten quote objects.
- Spiritual Growth content is seeded through structured intention / action / prompt datasets and localized through ARB keys instead of being hardcoded in widgets.
- The app-wide section architecture is moving toward a consistent hub pattern:
  - `/learn` now lands on an island-based `LearningSectionLandingPage`
  - `/learn` now also exposes a dedicated Games Island card that opens the new non-kids game discovery layer without replacing the existing Quizzes hub
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
- Qur'an progress now tracks real reading-time totals and per-day reading sessions in addition to location progress, and Growth/Journey Stats reuse that shared metric source.
- Qur'an playback now also tracks real listening-time totals and per-day listening sessions off the shared audio player state, separate from reading time.
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
- Crossword has focused repository coverage, but puzzle-screen widget and reward-flow interaction coverage are still missing.
- Hadith Reflection + Scenario Decisions now exists as a Quizzes-owned Knowledge Game under `lib/features/learn/hadith_reflection/`, reusing canonical `HadithEntry` sources, local daily rotation, shared XP/Drops/progression hooks, and shared Learn/Quizzes discoverability.
- Hadith Reflection uses curated scenario seeds that reference existing Hadith IDs instead of duplicating Hadith text, so source integrity stays anchored in the main Hadith foundation layer.
- Learn Quizzes and shared Learn indexing now include Hadith Reflection entry points, and child profiles are allowed through the new `/learn/quizzes/hadith-reflection*` route family.
- A unified Daily Knowledge Challenge Hub now exists under `lib/features/learn/knowledge_games/daily/`, bundling daily Crossword, Word Search, Matching, Ayah Completion, and Hadith Reflection into one deterministic offline-first route with bundle-level completion, streak, and bonus reward guards.
- A shared adaptive learning layer now exists under `lib/features/learn/knowledge_games/adaptive/`, deriving a local `UserLearningProfile` from existing game progress, persisting a compact snapshot, nudging per-game daily target difficulty and puzzle selection bias, and surfacing light transparency on the Daily Knowledge Challenge Hub without forking any individual game flow.
- A shared game variations layer now exists under `lib/features/learn/knowledge_games/`, adding `KnowledgeGameConfig`, unified variation types, deterministic daily variation assignment, shared timer/badge shell support, and small per-game variation hooks without replacing any existing game engine.
- Daily bundle game refs now carry variation config, so the Daily Knowledge Challenge Hub can surface mode badges while each game still owns its own puzzle, reward, and progress logic.
- Crossword daily selection now respects child profiles by resolving kids-mode daily puzzles instead of always using the adult pool, which keeps the new bundle viable for child-visible flows.
- A shared internal content-expansion layer now exists under `lib/features/learn/knowledge_games/content_expansion/`, normalizing current crossword, word search, matching, ayah completion, hadith reflection, spiritual growth, pack, and variation metadata into one authoring snapshot without changing runtime game loading.
- A hidden debug-only route now exists at `/learn/games/internal/content-builder`, exposing a form-based internal builder for draft validation, preview, and JSON export against the normalized schema.
- The canonical future import/export landing zone is now documented in `content/README.md`; runtime content still loads from existing seeded Dart data, but future content work should target the shared `content/` layout instead of inventing new per-feature formats.
- Upstream `codex_context_engine` README references runtime scripts (`boot.py`, `packet.py`, `query.py`, `global_metrics.py`) that are not present in the fetched upstream snapshot.
- Root README and some docs lag behind the codebase’s actual state.
- Bedtime Stories now has a family-mode layer on top of the shared Family Learning child-profile system:
  - bedtime story progress, bedtime learning progress, and bedtime queue state are learner-scoped under per-learner storage keys
  - legacy single-learner bedtime progress keys migrate once into the current active bedtime learner scope
  - bedtime parent dashboard, continue-learning logic, and recommendations now read the active bedtime learner scope instead of one global bedtime state
  - bedtime queue/audio/sleep-timer state clears safely on learner switches to avoid cross-profile carryover
  - new bedtime family management route exists at `/learn/kids/bedtime-stories/family`
  - guardian-mode bedtime rewards are intentionally not mirrored into the global Journey XP/Drops ledgers unless the active app profile is the same child profile, to avoid cross-profile corruption until a canonical app-wide child reward architecture exists
- A learner-scoped bedtime companion flow now exists under `/learn/kids/bedtime-stories/companion`:
  - bedtime routine plans are derived from bedtime learner preferences, including dua-first/story-first ordering and a simplified younger-learner mode
  - bedtime companion sessions persist per learner and track step-by-step routine completion without creating a second reward architecture
  - bedtime companion reuses existing kids-dua bedtime content for the primary sleeping dua and quiet dhikr suggestions
  - bedtime story handoff reuses the existing bedtime queue/detail/player stack and marks the story routine step complete once real listening progress begins
  - bedtime companion intentionally avoids reading global kids-dua completion state so bedtime routine progress does not leak across child learners before the dua feature itself is family-scoped
- Kids Dua Learning now includes a production dua-learning flow on the existing lesson page:
  - whole-dua audio reuses `just_audio` with a canonical bundled asset path under `assets/audio/kids_dua/en/path_of_nur/`
  - read-along, tap-to-repeat, and gentle-practice modes share one lesson surface instead of separate mini-flows
  - learner-scoped dua lesson progress and My Day routine state now migrate once from the old global keys into per-learner storage keys
  - bedtime-relevant duas can deep-link back into the bedtime companion flow, while Qur'anic source references use the shared tappable Qur'an-link widgets
  - segment-level repeat is future-ready through structured segment models and currently falls back safely to full-dua playback when dedicated segment audio is not bundled
- Kids Stories now also has a broader mixed library route under `/learn/kids/stories`:
  - the existing bedtime-story engine now supports prophet and non-prophet story types through one shared model/repository stack
  - prophet bedtime stories remain intact as one collection inside the broader library
  - an initial non-prophet seed wave now covers adab, daily-life, family-kindness, Ramadan, and Eid stories with learner-scoped progress and optional quiz/memory reuse
  - bedtime routes still filter bedtime-eligible stories, while the new library route can browse the full mixed catalog
  - structured Qur'an references remain tappable and hadith/source-note fields are available for source-aware child-story content without forcing every story into the same prophet-only shape
- Kids Arabic tracing now uses learner-scoped progress and parent-preference storage:
  - lesson completion, review-needed state, daily mission progress, sticker unlocks, and local streak state now persist under per-learner keys instead of one global `kids.arabic.progress.v1` blob
  - parent focus/review/support preferences now also persist per learner instead of one shared global parent-preferences blob
  - legacy global Kids Arabic progress/preferences keys migrate once into the first active learner scope and are then removed
  - Kids Arabic lesson and daily-mission rewards now award through the shared learner progression controller, with Journey mirroring only when the active app profile is the same child profile
  - direct Ocean-drop writes and the old Learning Journey active-day compatibility writes were removed from Kids Arabic, so the feature now follows the shared learner progression + canonical kids activity path
- Kids Dua learner scoping is now aligned end-to-end:
  - fallback learner IDs now reuse the bedtime-family fallback identity for no-child-profile households
  - dua lesson progress, My Day state, and creative drawings all persist under learner-scoped keys
  - legacy global and older kids-dua-only fallback-scoped dua data migrates once into the current canonical learner scope where safe
  - Kids Dua My Day completion now logs a canonical kids activity entry in addition to the shared progression award
- A learner-scoped progression layer now exists under `lib/features/progression/`:
  - child learning XP, Ocean Drops, levels, badges, and milestones are stored locally per learner instead of being inferred separately by multiple kids features
  - the canonical 100-level Journey XP curve under `lib/features/journey/xp/` is reused for learner progression summaries rather than duplicated
  - bedtime stories, bedtime quiz/memory, bedtime routine completion, Seerah node/stage/journey rewards, kids dua lesson completion, kids dua practice, and kids dua My Day completion now award through the shared learner progression service first
  - Journey/global XP mirroring now accepts explicit per-event learning XP amounts, fixing the older mismatch where some kids surfaces displayed 5/6/8 XP locally while the global Journey ledger always awarded the default learning XP amount
  - Journey/global XP and Drops are only mirrored from learner progression when the active app profile matches the linked child profile, so guardian-mode browsing does not leak rewards across profiles
  - a new kids progression route exists at `/learn/kids/progression`
  - the bedtime parent dashboard now reads bedtime XP/drop totals from the learner progression ledger, with a safe fallback to legacy inferred totals when historical progression entries do not exist yet

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
14. Add a cross-feature integration test that completes a kids action and verifies the same learner’s progression, canonical activity, and parent-summary surfaces together.

## I. Assumptions / uncertain areas

- This snapshot reflects the repo state as inspected on 2026-03-17, including user-owned uncommitted work already present in the tree.
- Some platform-companion code may be scaffolded more deeply than the Flutter-side docs reveal, but the release guidance in docs is treated as authoritative for readiness.
- The current engine install is repo-local and intentionally does not use the upstream cross-project installer, because the user requested repository-contained setup with minimal manual work.
