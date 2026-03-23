# Feature Inventory

Last updated: 2026-03-22

Status legend:

- `implemented`
- `partial`
- `scaffolded`
- `deprecated/removed`
- `risky/inconsistent`

## Onboarding

  - implemented:
  - onboarding flow
  - language/locale preference capture
  - learning age group / experience / salah consistency inputs
  - prayer method and madhab capture
  - reminder defaults and dhikr preference capture
- risky/inconsistent:
  - onboarding choices must continue to flow into localization, prayer prefs, and learn path setup without drift

## Home

- implemented:
  - main dashboard
  - daily overview and prayer-facing summary
  - On This Day historical reflection card driven by the shared history archive dataset
- partial:
  - still carries localization debt in active surfaces
- risky/inconsistent:
  - should stay aligned with Worship and Growth summaries, not become a separate state silo

## Worship

- implemented:
  - prayer tracking/status
  - dhikr presets/sessions
  - fasting support
  - khusu focus
  - qibla finder
- partial:
  - some copy/localization debt remains
- deprecated/removed:
  - `worship_page_legacy.dart`

## Qur'an

- implemented:
  - top-level Qur'an tab
  - reader, explorer, search, bookmarks, notes
  - persisted reading-time totals and per-day reading sessions for Growth/Journey stats
  - persisted listening-time totals and per-day listening sessions from shared playback state
  - topics, names of Allah, top words, word review
  - Qur'an learning and Qur'anic Arabic entrypoints
  - shared ayah-enrichment provider now aggregates starter educational metadata from Qur'an Study seeds, Divine Life Lessons, and World & Creation, and surfaces that through the reader `Learn More` section and `QuranReferenceViewer`
  - ayah enrichment now uses a stricter canonical contract for domains, lesson types, normalized tags, link strength, caution levels, and typed mixed display items so future ayah-detail content can expand without page-local display rules
  - Ayah Insights now also has a Qur'an-owned browse/discovery layer at `/quran/insights` with per-domain listings that deep-link back into the reader at the relevant ayah
  - Ayah Insights now also has a lightweight guided-path layer at `/quran/insights/paths` with curated domain-specific starter journeys that reuse existing enrichment entries instead of creating a second content system
  - Surah-level insight pages now also exist under `/quran/surah-insights` and `/quran/surah/:surahNumber/insights`, using a small curated surah-summary dataset plus existing Ayah Insight clusters rather than a tafsir-style parallel content system
  - Qur'an learning now also has a lightweight global knowledge search route at `/quran/knowledge-search`, with grouped local search across Ayah Insights, guided paths, and surah-insight pages using the existing structured content instead of a separate backend/indexing stack
  - Qur'an learning now also has a lightweight personalization layer that combines recent reading continuity with last-used Ayah Insights path/domain state to surface Continue Learning and Suggested for You cards on the main Qur'an hub, the Qur'an Learning reflect surface, and Ayah Insights browse
  - Qur'an learning now also has a lightweight Daily Ayah Reflection layer driven by the shared Ayah Insights corpus, with deterministic daily selection, Home + Qur'an hub surfacing, persisted completion/streak state, and once-per-day Qur'an XP/drop awards instead of a separate habit engine
  - Qur'an learning now also has a lightweight Saved Reflections layer at `/quran/reflections`, with local ayah/insight saves, optional short private notes, Daily Ayah + Ayah Insights integration, and a dedicated review hub separate from the older manual Qur'an Notes flow
  - Qur'an learning now also has a shared progression bridge that rewards meaningful completions only: Daily Ayah marks the linked entry complete without double XP, Ayah Insights reward once per entry, guided paths award once per fully completed path, and the first non-empty private reflection note awards once lifetime through the existing Journey XP / Drops gateway
  - Qur'an learning now also has a lightweight native sharing/export layer for Daily Ayah, Ayah Insights, related ayahs, saved reflections, and surah insight overviews, using respectful plain-text composition and explicit note-excerpt opt-in instead of a social or public-sharing system
  - kids-safe Ayah Insights now also exists at `/learn/kids/quran-insights`, using a filtered reviewed subset of canonical Ayah Insights entries with simplified localized summaries, safe-theme-only categories, shared Qur'an deep links, and the same respectful studied-completion hook instead of a second kids Qur'an engine
- risky/inconsistent:
  - old Learn-owned aliases still exist and can confuse ownership
  - new work should prefer Qur'an-owned routes and avoid duplicating reader/study entrypoints
  - Qur'an educational content is still split across multiple source datasets, so future expansion should extend the shared ayah-enrichment layer instead of adding another page-local ayah lesson list
  - Saved Reflections are intentionally private/local-only in V1 and should not drift into a social or heavy journaling system without explicit product direction

## Learn

  - implemented:
  - journey-first `/learn`
  - canonical Learn Notes landing at `/learn/notes` with a unified category summary and dedicated Browse All Notes route at `/learn/notes/browse`
  - Wudu guide plus real guided trainer under `/learn/salah/wudu` and `/learn/salah/wudu/trainer`, with persisted step progress, explicit resume/restart/review re-entry, normalized fallback for invalid persisted trainer state, asset-backed instruction cards, one-time Learn journey completion rewards surfaced from Ibadah & Practice, and a linked Wudu quiz at `/learn/salah/wudu/quiz` with persisted answer progress, calm feedback, completion summary, and one-time XP/Ocean Drop reinforcement rewards
  - large set of existing learn domains and shared tools
  - kids Seerah journeys now layer on top of the shared kids story engine with a learner-scoped journey progress service, stage/node timeline flow, companion-story reuse, existing Muhammad ﷺ story-part reuse, short reflection nodes, quiz-node reuse, and shared Learn search/discovery exposure
  - kids dua learning now reuses the existing lesson routes with a richer production flow: canonical bundled dua audio resolution, read-along modes, tap-to-repeat segments, gentle-practice actions, learner-scoped progress/My Day storage, bedtime companion linkage, and Qur’anic source deep links on structured references
  - Kids Dua fallback learner identity now aligns with the bedtime-family fallback identity, so no-child-profile households no longer split dua progress, My Day state, creative state, and canonical activity across separate fallback learner IDs
  - Kids Dua creative drawings and parent-view preferences now also persist per learner, with safe migration from the legacy global creative key and the older kids-dua-only fallback learner scope
  - Kids Dua My Day completion now emits a canonical learner-scoped kids activity entry in addition to its shared progression award, so parent summaries can read a stable recent-activity source instead of relying only on progression-derived fallback signals
  - kids stories now extend the bedtime-story engine into a broader mixed library with `/learn/kids/stories`, non-prophet Islamic story seeding, collection-based discovery, optional quiz/memory reuse, and bedtime-eligibility filtering layered over the same canonical story progress/media stack
  - Kids Learning now includes a dedicated Prophet Stories island that routes to the existing kids-safe bedtime prophet stories experience at `/learn/kids/prophet-stories`, instead of sending children through the broader mixed story library first
  - Kids Learning now also surfaces direct first-class islands for the broader kids story library, kids dua learning, and kids Seerah journeys, while keeping the older `Fun Learning` island as the overflow lane for mixed/secondary kids discovery instead of one oversized catch-all being the only route to those live surfaces
  - Kids Learning now also surfaces dedicated kids-only Qur’an, Hadith, and Hadith Stories islands, with `/learn/kids/quran` owning the simplified full-surah browse flow, `/learn/kids/hadith` owning a short curated hadith set, and `/learn/kids/hadith-stories` reusing the existing hadith-backed kids story seeds instead of routing children into adult Qur’an or Hadith pages
  - kids bedtime prophet stories with seeded metadata, transcript-first fallback, local progress persistence, first-completion XP / Ocean Drops hooks, media-aware asset resolution for narration and artwork, a dedicated bedtime player session layer with queue, multipart continuation, full/mini player surfaces, sleep timer support, story-linked quizzes, memory cards, a calm bedtime learning-loop handoff, a bedtime companion routine flow with suggested duas and sleep-ready completion, and a parent-facing bedtime progress dashboard
  - Kids Arabic tracing and review progress now scope to the active learner instead of one global store, with one-time migration from the legacy global Kids Arabic progress/preferences keys
  - Kids Arabic lesson completion and daily mission rewards now flow through the shared learner progression service rather than direct Journey/Ocean reward writes
  - Kids Arabic no longer writes into the older global Learning Journey active-day compatibility layer, so its remaining learner-facing progress, rewards, and activity signals now stay inside the shared learner progression + canonical kids activity architecture
  - Kids Arabic tracing now includes a real vector-based tracing engine for Alif, Ba, Ta, Tha, Jeem, Hha (`ha`), Kha, Dal, Dhal, Ra, Zay, Meem, Noon, Seen, Laam, Kaaf, and Haa (`ha2`), with a shared path source-of-truth for rendering and completion evaluation
  - the full Arabic alphabet now remains reachable through one canonical Kids Arabic lesson order, with the remaining non-vector letters still covered by the safe fallback tracing system
  - Kids Arabic lesson flow now also surfaces an in-lesson ready-to-finish state, retry/reset action, next-letter handoff, previous-letter return, and existing safe XP/drop completion rewards without duplicating the underlying reward engine
  - Kids Arabic tracing now also includes a soft delight layer with idle ghost-stroke previews, subtle completion halo/sparkle animation, delayed completion-action reveal, and optional one-shot pronunciation feedback gated by the existing audio-autoplay preference
  - Kids Arabic now also has a dedicated mastery/progress-map route with a tappable ordered alphabet, gentle `not started / practicing / completed` state mapping, review recommendations from the existing review-needed set, a next recommended letter card, and a home-surface summary entry that routes back into lessons or the existing review flow
  - Kids Arabic now also has a dedicated practice loop route at `/learn/kids/arabic/practice`, with a primary Practice Today focus, continue-letter and continue-word sections, gentle review sections for completed letters/words, and a home-surface entry card built from existing daily mission + mastery + word-progress signals
  - Kids Arabic now also has a beginner-words layer with a canonical words hub, learner-scoped word completion state, short joined-word lessons for `باب`, `نور`, and `قلم`, gentle joining-awareness cards, tap-to-hear word pronunciation, and word tracing that reuses the existing tracing pad with custom guide-backed targets instead of a second tracing engine
  - Kids Arabic now also has a calm reading-mode route at `/learn/kids/arabic/words/reading`, reusing the same beginner-word dataset for large word cards, tap-to-hear pronunciation, and simple previous/next navigation across unlocked words without introducing scoring or a second progress model
  - Kids Arabic now also has a shared audio-learning layer across tracing and reading surfaces, with consistent tap-to-hear pronunciation on letter heroes, word lesson headers, reading-mode cards, and unlocked word cards, plus one shared repeat-after-me card for lessons and reading-mode autoplay reuse through the existing parent `audioAutoplay` preference
  - Kids Arabic now also has a lightweight achievements layer that derives badges and milestones from existing letter, word, and review progress; surfaces them on the home card, mastery map snapshot, and rewards page; and only reveals celebration cards once per learner-scoped unlock without creating a second reward ledger
  - Kids Learning child subcategory wrappers now route distinctly again: `Arabic Learning` opens the real Kids Arabic home, while `Kids Games` and `Fun Learning` render as scoped destination pages with their own headers instead of looking like a generic return to the parent Kids Learning category
  - dedicated Learn-owned Games Island discovery layer for non-kids game discovery, with sectioned access to daily challenges, knowledge games, Qur'an games, Hadith reflection, challenge modes, growth-linked experiences, and existing pack routes
  - history archive entry with seeded On This Day / archive / detail routing
  - crossword puzzle engine under Quizzes with kids mode, adult mode, deterministic daily rotation, bonus objectives, recent-repeat avoidance, local daily history, pack browsing, semi-dynamic template-backed assembly with fallback, documented seed/content pipeline metadata, deterministic validation, persisted cell/direction resume state, progress overviews, and shared XP / Drops / progression hooks
  - word search game under Quizzes with kids mode, adult mode, profile-aware daily puzzle routing, shared Knowledge Games shell/adapter integration, pack browsing, deterministic seeded placement with validation, local progress persistence, hint actions, and shared XP / Drops / progression hooks
  - matching game under Quizzes with kids mode, adult mode, offline daily puzzle routing, themed packs, hint actions, local progress persistence, and shared XP / Drops / progression hooks
  - ayah completion game under Quizzes with kids mode, adult mode, canonical Qur'an reference-driven seed data, profile-aware daily ayah routing, tappable verse references into the reader, optional shared ayah playback, local progress persistence, and shared XP / Drops / progression hooks
  - foundational Knowledge Games layer with shared game/session/result abstractions, generic recommendation helpers, reusable game shell, and crossword / word-search / matching adapters as the first live game-type integrations
  - legacy Learn hub still available at `/learn/legacy`
- partial:
  - kids Seerah journeys currently ship as one polished journey pack with three companion stories; broader Seerah stage coverage and additional companion content remain expansion work
  - multiple systems overlap:
    - learning journey
    - legacy Learn hub
    - hub-by-section routes
    - dedicated domain routes
  - Quizzes and Games discovery now coexist intentionally: Quizzes remains the legacy/secondary hub, while the Games Island is the new non-kids discovery entry layered on top of the existing routes
- risky/inconsistent:
  - strongest architectural seam in the repo
  - easiest place for duplicate work
  - crossword, word search, matching, and ayah completion are intentionally Quizzes-owned; future knowledge-games work should extend that ownership instead of creating another parallel game hub
  - kids-only games should continue to route through Kids Learning wrappers rather than being surfaced directly in the main Games Island
  - Kids Arabic achievements are intentionally derived from existing progress plus a tiny UI-state store for seen celebrations; future work should extend that model instead of introducing a second durable achievements backend unless product requirements materially change
  - FAQ landing now explicitly disables the default Learn quote so the page no longer inherits a duplicate generic Qur’anic quote block from the shared Learn-hub scaffold

## Journey / growth

- implemented:
  - growth home/today/reflection/journey/habits
  - unified Journey Stats page and Growth-level Qur'an reading tracker
  - path detail and habit detail
  - Ocean drops and wallpaper unlock integration
  - Spiritual Growth Layer with seeded daily intentions, recognized action summaries, manual real-life acknowledgments, respectful reflection prompts, theme summaries, and shared Journey reward/progression integration
- partial:
  - some richer node-detail ideas were removed and not yet replaced with real surfaces
  - spiritual growth currently adds lightweight notes and manual acknowledgments, but does not yet include a deeper weekly review or richer recommendation handoff
- deprecated/removed:
  - `journey_legacy_page.dart`
  - `journey_widgets.dart`

## Settings

- implemented:
  - settings-first ownership for profile/personalization, appearance, notifications, privacy, language, about
  - links into accounts/sync and family learning management
- partial:
  - high localization debt
  - route migration still keeps `/profile/*` compatibility aliases
- deprecated/removed:
  - top-level `profile_page.dart`

## Profiles / accounts

- implemented:
  - profile/account/domain models
  - shared-device mode
  - profile picker
  - profile/account/device management pages
- partial:
  - auth/account providers are modelled, but production backend auth is not present
- risky/inconsistent:
  - avoid implying full cloud account infrastructure exists

## Sync / backup / import / export

- implemented:
  - outbox/cursor storage
  - manual backup/export/import flows
  - iCloud transport bridge on Apple platforms
- partial:
  - production cloud sync is not implemented in this repo
- risky/inconsistent:
  - docs explicitly constrain release posture to local-first + manual backup + iCloud

## Notifications / reminders / adhan

- implemented:
  - local notification service
  - reminder scheduler
  - adhan audio selection and playback
  - fasting/prayer live activity support
- partial:
  - some platform-specific validation still needed

## Media / audio

- implemented:
  - just_audio + background audio for Qur'an
  - adhan audio assets and preview
  - Qur'anic Arabic teaching audio assets
  - bedtime story audio/image manifest + resolver layer with canonical bundled path conventions, legacy compatibility fallbacks, and graceful transcript-first degradation when media is missing
  - bedtime story queue/player/session state is now learner-scoped through the bedtime family-mode layer, so bedtime playback state no longer assumes one global child
- risky/inconsistent:
  - avoid new media flows that bypass existing audio providers/repositories

## Kids / bedtime family mode

- implemented:
  - bedtime stories now reuse the shared Family Learning child-profile system instead of introducing a second identity stack
  - canonical kids activity logging now lives under `lib/features/kids/activity/` as a learner-scoped local ledger for meaningful cross-feature recent activity events
  - bedtime family mode route and UI exist under `/learn/kids/bedtime-stories/family`
  - bedtime companion route and UI exist under `/learn/kids/bedtime-stories/companion`
  - learner progression route now exists under `/learn/kids/progression`
  - bedtime story progress, bedtime learning progress, bedtime recommendations, bedtime queue state, and the bedtime parent dashboard are learner-scoped
  - bedtime companion sessions and bedtime routine recommendations are learner-scoped
  - kids Seerah journey progress is also learner-scoped through the same bedtime-family child context so journey stages/nodes do not leak across child profiles
  - legacy single-learner bedtime progress migrates once into the currently active bedtime learner scope
- partial:
  - bedtime fallback learner still supports legacy single-learner households that have not created a child profile yet
  - not every kids feature event is logged yet; the canonical ledger currently focuses on meaningful open/completion actions for bedtime stories, story learning, dua learning, Arabic, Seerah, and bedtime routines
  - guardian-mode bedtime rewards are derived safely per learner, but global Journey XP/Drops are only mirrored when the active app profile is the same child profile
  - archiving exists for bedtime-family selection, but shared non-bedtime family management has not adopted the same archive semantics yet
  - bedtime companion currently reuses learner-scoped session state and existing dua content, but it does not yet write to a dedicated bedtime activity log for parent summaries
  - bedtime parent dashboard now uses learner progression totals when available, but falls back to inferred bedtime totals for older data that predates the progression ledger
- risky/inconsistent:
  - avoid writing bedtime rewards directly into app-wide ledgers from guardian context until a canonical multi-learner reward architecture exists

## Progression / levels / badges

- implemented:
  - canonical Journey XP level definitions still live under `lib/features/journey/xp/` and remain the source for titles and thresholds
  - learner-scoped progression models, catalog, service, route, and tests now live under `lib/features/progression/`
  - learner-scoped garden models, stage catalog, service, route-backed page, and tests now live under `lib/features/garden/`
  - `/journey/garden` now derives visual growth from learner progression totals, dimension mapping, existing garden milestone thresholds, and safe Journey fallback data for non-child mode
  - kids bedtime stories, bedtime learning, bedtime routines, Seerah rewards, kids dua lessons, kids dua practice, and kids dua My Day now award through the shared learner progression service
  - Kids Arabic lesson and daily mission rewards now also award through the shared learner progression service, with progression metrics for Kids Arabic completions available to downstream summaries such as Garden
  - learner progression supports child-scoped XP totals, Ocean Drops totals, badges, milestones, and calm long-term summaries
  - Journey learning XP now accepts custom XP amounts so mirrored global Journey totals stay aligned with actual balanced award values
- partial:
  - adult/global Journey pages still primarily surface the app-wide profile ledger, while the learner-specific progression UI currently lives on the kids route and bedtime parent summary
  - child prayer-specific garden contributions still use a consistency/routine proxy until learner-scoped prayer tracking becomes canonical
  - badge coverage is intentionally limited to first completions and milestone-style badges in V1

## Growth statistics / dashboard

- implemented:
  - the Growth Statistics page now includes Summary, Trends, Insights, and Reports/Share sections on top of the existing Qur’an, overview, metrics, and Ocean sections
  - centralized aggregation for daily/weekly/monthly rollups now lives under `lib/features/journey/application/growth_statistics_provider.dart`
  - weekly trend charts use the last 7 daily buckets; monthly trends use four weekly buckets across the last 28 days
  - “Your best day” is derived from the existing Journey daily score model with safe XP/drop tie-breakers
  - share/export currently uses text snapshots via `share_plus`, built from the same dashboard aggregation model
- partial:
  - chart rendering is intentionally lightweight and local; no general chart library or report-detail route exists yet
  - locale ARB keys were added for the new copy, but runtime access still uses a local extension shim until the repo-wide generated-l10n drift is reconciled
- risky/inconsistent:
  - focused widget/provider tests for the new dashboard are present, but `flutter test` remains blocked by broader repo-wide generated-localization drift outside Growth

## Knowledge games / quizzes

- implemented:
  - crossword, word search, matching, ayah completion, and hadith reflection all live under Quizzes using the shared Knowledge Games layer
  - shared game abstractions, adapter pattern, game shell, daily challenge posture, pack metadata, reward integration, and local persistence patterns
  - shared game variations now extend the existing game types through `KnowledgeGameConfig`, deterministic daily assignment, shell-level timer/badge UI, and low-risk game-specific hooks instead of separate mode engines
  - shared internal content-expansion models, validator, and repository now normalize the current game + spiritual-growth seed content into one authoring snapshot
  - hidden debug-only internal builder route now supports draft create/preview/validate/export flows for normalized content items
  - Hadith Reflection specifically reuses `HadithEntry` content and `HadithContentBlock` rather than duplicating source text
  - Daily Knowledge Challenge Hub now orchestrates the five game types into one daily bundle using their existing daily resolvers rather than replacing them
  - adaptive learning now derives a local user-learning profile from existing game progress and uses it to personalize daily target difficulty and puzzle/category ordering across the shared game stack
- partial:
  - most games have focused repository/progress/adapter tests, but widget-level interaction coverage is still thin
  - daily archive/history surfaces are still inconsistent across game types
  - adaptive personalization currently derives from persisted progress snapshots rather than live per-session adapter callbacks
  - variations are currently introduced through daily configs and shell/game hooks; non-daily pack browsing does not yet expose a broader variation catalog
  - crossword pack metadata is still assembled in the runtime repository, so the content-expansion snapshot does not yet normalize crossword packs through the same pack source path
- risky/inconsistent:
  - avoid creating new game types outside the shared Knowledge Games path unless there is a strong reason

## Watch / TV / platform-specific surfaces

- implemented:
  - watch contract logic and QA/testing docs
  - native Apple Watch V1 companion app integrated into `ios/Runner.xcodeproj`
  - watch Home, Prayer check-in, Dhikr counter, Progress, and Utility surfaces
  - watch/iPhone WatchConnectivity bridge with cached snapshot + queued action recovery
  - complication/widget foundation for next prayer and daily progress
- partial:
  - watch real-data behavior still depends on the Flutter snapshot/reconciler bridge being active on the phone
  - release validation is incomplete
- partial:
  - canonical tvOS native surface in `ios/PathOfNurTV`
  - mirrored Home prayer and Qur'an V1 shell with seeded data and native playback wiring
- risky/inconsistent:
  - code presence does not equal release readiness
  - mirrored Home prayer and Qur'an surfaces should stay in parity review with mobile changes unless platform constraints justify divergence
  - watch reward projection is intentionally optimistic and must defer final truth to phone-side app logic
