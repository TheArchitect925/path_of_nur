# Feature Inventory

Last updated: 2026-03-24

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
  - Qur'an learning now also has a dedicated Daily Qur'an Companion owner at `/quran/daily`, reusing the existing daily reflection assignment plus reference/memorization/path systems for a calmer daily flow with meaning, practical takeaway, and next-step handoffs
  - Qur'an learning now also has a lightweight Saved Reflections layer at `/quran/reflections`, with local ayah/insight saves, optional short private notes, Daily Ayah + Ayah Insights integration, and a dedicated review hub separate from the older manual Qur'an Notes flow
  - Qur'an learning now also has a shared progression bridge that rewards meaningful completions only: Daily Ayah marks the linked entry complete without double XP, Ayah Insights reward once per entry, guided paths award once per fully completed path, and the first non-empty private reflection note awards once lifetime through the existing Journey XP / Drops gateway
  - Qur'an learning now also has a lightweight native sharing/export layer for Daily Ayah, Ayah Insights, related ayahs, saved reflections, and surah insight overviews, using respectful plain-text composition and explicit note-excerpt opt-in instead of a social or public-sharing system
  - kids-safe Ayah Insights now also exists at `/learn/kids/quran-insights`, using a filtered reviewed subset of canonical Ayah Insights entries with simplified localized summaries, safe-theme-only categories, shared Qur'an deep links, and the same respectful studied-completion hook instead of a second kids Qur'an engine
  - Qur'an learning now also has a staged Qur’an Readiness bridge shared across Kids and adult Arabic learning, with eight exact app-sourced beginner snippets across Al-Fatihah and Al-Ikhlas, three lightweight recognition levels, shared phrase/audio overlap from Arabic learning where available, lightweight snippet-in-ayah highlighting, small pronunciation-hint cards, and dedicated owner routes at `/learn/kids/arabic/quran-readiness` and `/quran/arabic/readiness` instead of a second full-reader surface
  - the Qur'an Readiness bridge now also includes a light Tajweed-integration layer: optional clear/stretch/bounce hint metadata per snippet, subtle in-snippet pronunciation highlighting, and calm lesson handoffs into existing adult Tajweed lessons or the Kids `tajweed-basics` journey where a safe beginner match exists
  - Qur'an learning now also has a bridge-owned short-surah readiness layer with four curated beginner surahs, lightweight ayah-level playback highlighting, route-owned Kids/adult surfaces at `/learn/kids/arabic/short-surahs` and `/quran/arabic/short-surahs`, and an optional `Open in Qur'an reader` handoff without merging this bridge into the full reader UI
  - Focus Recitation Mode V1 now exists as a dedicated full-screen `/quran/focus-recitation` listening surface driven by the canonical playback state, with Arabic-first ayah display, persisted translation/transliteration visibility toggles, minimal transport controls, and entry from the expanded player rather than a second playback stack
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
  - Kids Arabic now also includes a calm mini-phrase mode under `/learn/kids/arabic/phrases`, with a small curated set of very short everyday Arabic phrases, learner-scoped heard/resume state, TTS-backed tap-to-hear playback, and next/previous navigation that reuses the existing Kids Arabic audio and reading patterns without adding quiz pressure
  - Arabic learning now also has a shared lesson-pack layer under `lib/features/arabic/` with reusable grouped entries for Kids and adult letters, words, phrases, review, Qur'an bridge, and beginner Tajweed support, surfaced through the existing Kids Arabic home, adult Qur'anic Arabic section page, and shared Arabic search instead of new standalone route islands
  - the existing Kids Arabic parent dashboard now reuses the shared Arabic progress/continuity/review layer plus Kids achievements to show a calmer parent-friendly overview with latest milestone, recent activity, practiced-today state, weekly consistency, and primary/secondary next-step actions
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
  - Arabic learning now also has a shared discovery layer under `lib/features/arabic/` that indexes letters, beginner words, phrases where a live owner exists, gentle review/continue targets, and Qur’an Readiness snippets; Kids Arabic home and adult Qur'anic Arabic now surface that layer through one calm search/filter section each instead of separate page-local discovery logic
  - Kids Arabic now also has a lightweight achievements layer that derives badges and milestones from existing letter, word, and review progress; surfaces them on the home card, mastery map snapshot, and rewards page; and only reveals celebration cards once per learner-scoped unlock without creating a second reward ledger
  - Arabic learning now also has a shared gentle mini-assessment layer with short recognition-only `see -> choose` and `hear -> choose` sessions, shared route-target follow-up, and optional quick-practice entry cards on Kids Arabic home and adult Qur'anic Arabic without adding scores, timers, or a separate quiz product
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
  - mini phrases intentionally do not award separate XP or add correctness pressure; they are a confidence/repetition surface, not a test mode
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
  - settings-owned Accounts, Profiles & Sync status card plus account/backups/import-export subflows
  - real Apple and Google sign-in integration paths through a shared auth repository
  - honest email sign-in shell with not-yet-connected messaging instead of fake success
- partial:
  - backend-backed account infrastructure is still not present; Apple/Google auth currently establishes device identity and backup readiness only
- risky/inconsistent:
  - avoid implying full cloud account infrastructure exists

## Sync / backup / import / export

- implemented:
  - outbox/cursor storage
  - manual backup/export/import flows
  - metadata-rich backup payloads with schema/app-version fields
  - file-based import validation/preview plus merge-or-replace confirmation
  - safety snapshot creation before risky restore/import apply
  - iCloud transport bridge on Apple platforms
  - remote backup transport abstraction with provider-specific Apple iCloud document transport, Google Drive `appDataFolder` transport, and honest email-backend placeholder transport
  - remote backup metadata/status persistence, remote restore preview, and confirmed remote restore routed through the existing validated import pipeline
  - remote restore comparison engine with domain-aware conflict summaries, warning states, and a dedicated restore-preview page in Accounts, Profile & Sync
  - safe merge support for profile basics, prayer tracking, and dhikr state/history only, with replace-only handling left explicit for settings snapshots, Qur'an snapshots, learning snapshots, reminders, theme/accessibility, and XP/drops/ocean data
  - auto-backup engine with persisted preferences, payload-fingerprint dirty tracking, provider-aware eligibility checks, manual retry, lifecycle-triggered evaluation, and settings-surface status visibility
  - granular sync-scope controls with persisted optional-domain exclusions, scope-aware remote payload generation, scope summaries in backup metadata, partial-backup restore preview messaging, and excluded-domain preservation during partial restore/import apply
- partial:
  - true background execution reliability, richer per-domain dirty tracking, deeper per-domain payload separation for currently grouped snapshot domains, multi-backup history, and backend-backed email/cloud sync are still not implemented in this repo
- risky/inconsistent:
  - docs explicitly constrain release posture to local-first + optional remote backup, and real-world Apple/Google transport still needs credential/device QA

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

## Arabic learning progress dashboard

- implemented:
  - `lib/features/arabic/` now owns a shared Arabic progress-summary model/provider that derives calm letter/word/phrase coverage, recent activity, and next-step/review actions for Kids and adult Arabic from existing progress, continuity, review, and Qur’an bridge signals
  - Kids Arabic home now includes a shared progress dashboard card with simple counts, a light progress bar, latest-achievement highlight, and shared continue/review actions
  - adult Qur'anic Arabic now includes a shared progress dashboard card with clean coverage counts, completed-lesson summary, recent activity, and shared continue/review actions
- partial:
  - adult word and phrase progress remain intentionally lightweight because the current adult beginner-word flow only persists last-opened state and bridge-snippet activity rather than full completion history
  - the new dashboard currently lives on the Kids and adult landing owners only; there is no dedicated Arabic progress detail page
- risky/inconsistent:
  - future copy must stay honest about what adult progress truly measures today so the dashboard does not imply stronger completion tracking than the data actually supports

## Arabic offline-first bundle

- implemented:
  - the shared Arabic data stack for letters, positional forms, beginner words, phrases, continuity, review, progress, and search is now explicitly hardened as local-first, with no network dependency in the core discovery/progress decision paths
  - `lib/features/arabic/application/arabic_learning_asset_bundle.dart` now provides one cached asset-manifest reader plus a lightweight warmup helper that can prewarm a tiny starter audio set and the current continue target for Kids and adult Arabic landing surfaces
  - the shared Arabic audio controller now verifies bundled asset availability before attempting playback and falls back calmly to Arabic TTS when asset packs are missing or the asset manifest itself is unavailable
  - Kids Arabic home and adult Qur'anic Arabic now trigger small post-build audio warmup to improve first-play reliability without changing the visible UX
- partial:
  - the checked-in repo snapshot still does not contain most of the `assets/audio/quran_teacher/*` paths referenced by the Arabic-teaching manifests, so offline audio quality still depends heavily on graceful fallback rather than a complete bundled audio pack
  - adult lesson-step prewarm currently only covers step audio cues and shared letter candidates; it does not attempt broad module-wide eager loading
- risky/inconsistent:
  - future manifest additions should stay aligned with real bundled assets, otherwise the system will remain reliable but asset-backed playback coverage will continue to be narrower than the manifests suggest

## Arabic content authoring framework

- implemented:
  - `lib/features/arabic/` now owns a shared authoring layer with `ArabicContentUnit` and `ArabicContentPackComposition`, covering reusable authored Arabic items across letters, shared beginner words, shared phrases, review anchors, adult module anchors, Qur'an bridge snippets, and short-surah bridge items
  - the shared lesson-pack provider now consumes explicit pack-composition metadata instead of repeating grouped content ids and preview metadata in provider-local pack construction
  - the shared Arabic search provider now indexes letters, words, phrases, and Qur'an bridge items from the same authored content-unit source used by the pack-composition layer
  - lightweight contributor rules for future Arabic content now live in `docs/arabic_content_authoring_rules.md`
- partial:
  - short-surah bridge items are normalized in the shared authoring layer, but they still surface through their existing route-owned bridge cards instead of a dedicated pack or search filter
  - adult lesson-step and quiz-step detail content remain owned by the richer Qur'anic Arabic teaching catalog rather than being fully normalized into the shared Arabic authoring layer
- risky/inconsistent:
  - future Arabic content work should extend the shared content-unit and pack-composition layers first, otherwise pack/search/bridge metadata could drift back into page-local or feature-local definitions

## Adult Arabic overview

- implemented:
  - the canonical adult Qur'anic Arabic landing at `/quran/arabic` now has a dedicated calm overview card at the top of the page instead of relying only on the generic shared progress dashboard presentation
  - `quran_teaching_adult_overview_provider.dart` derives first-time, in-progress, and completed states from the shared Arabic progress summary plus existing adult module/word targets for browse actions
  - the overview card exposes one primary continue/start action, optional review action, recent activity, simple counts, and low-noise browse letters/words links without changing adult route ownership
- partial:
  - the overview remains landing-page-first; there is no dedicated adult Arabic detail page yet
- risky/inconsistent:
  - adult word completion is still intentionally lightweight, so the overview must continue framing word progress as opened/covered rather than implying richer mastery data than the current model stores

## Arabic quick resume

- implemented:
  - `lib/features/arabic/` now owns a shared quick-resume provider and app-side widget bridge that turn continuity/review state into stable Kids/adult one-tap resume metadata
  - app quick actions now include localized adult continue, adult review, and Kids continue shortcuts driven by shared Arabic quick-resume state instead of hardcoded feature routes
  - adult Arabic module, lesson, beginner-word, and review owners now have canonical deep-linkable routes under `/quran/arabic/...`, which lets quick actions and future widgets open adult learning surfaces without requiring an already-open page stack
  - Kids Arabic home and adult Arabic landing both surface a shared quick-resume section for in-app one-tap continue/review actions
- partial:
  - the `home_widget` payload/update layer is live, but there is not yet a dedicated native Arabic widget owner rendering the synced payload on iOS/Android home screens
- risky/inconsistent:
  - future shortcut or widget work should keep using the shared Arabic quick-resume provider and route-location helper rather than reintroducing feature-local route strings

## Qur'an guided passages

- implemented:
  - `lib/features/learn/quran/` now owns a dedicated guided-passage readiness model/provider/page that extends the existing bridge with staged Al-Fatihah ayah ranges after the short-surah step
  - canonical guided-passage routes now exist at `/quran/arabic/guided-passages` and `/learn/kids/arabic/guided-passages`, with existing readiness and short-surah pages surfacing that next-stage entry instead of relying on hidden navigation
  - the guided-passage page reuses the shared Qur'an repository, player controller, playback-speed settings, and canonical reader handoff while keeping bridge-owned whole-ayah highlighting and calm presentation
  - Kids Arabic home and the adult Qur'anic Arabic landing now each surface a guided-passage card so the stronger bridge progression is reachable from the existing canonical discovery owners
- partial:
  - the advanced passage set is intentionally narrow and currently centered on Al-Fatihah only; no second longer-passage family has been added yet
- risky/inconsistent:
  - future guided-passage additions should stay within exact app-sourced Qur'an ranges and single-surah reader handoff unless the canonical reader/navigation model is expanded deliberately

## Arabic vocabulary themes

- implemented:
  - the shared Arabic lesson-pack layer now includes six themed vocabulary packs: Kids/adult daily words, prayer words, and Qur'an-linked words
  - all themed packs are composed from existing shared content-unit ids in `arabic_content_authoring_catalog.dart`, so words, phrases, and bridge snippets stay canonical and are not redefined per page
  - Kids Arabic home and the adult Arabic landing already surface the themed packs through the existing shared lesson-pack section, and the Qur'an readiness bridge now also shows the audience-appropriate Qur'an-linked theme pack as an additional bridge-owned discovery card
  - the shared Arabic search index picks the new themed packs up automatically through the existing lesson-pack search path
- partial:
  - the current theme catalog is intentionally small and limited by the shared beginner-content set, so broader theme breadth will require future shared-content expansion rather than more pack shells
  - some phrases in the broader shared mini-phrase set still rely more on existing page-level playback/TTS behavior than explicit shared manifest coverage, so the strongest themed packs currently favor the items with clearer shared audio/readiness overlap
- risky/inconsistent:
  - future vocabulary-theme work should keep extending shared content units and pack compositions instead of introducing page-local “daily words” or “prayer words” cards with duplicated metadata

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
