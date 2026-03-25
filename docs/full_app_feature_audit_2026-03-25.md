# Full App Feature Audit

Date: 2026-03-25

Scope:
- Audit based on current repository structure, route inventory, continuity memory, and live feature folders.
- Focused on shipped or actively wired product surfaces, with supporting platform/infrastructure layers called out separately.

Status legend:
- `implemented`: route-backed or clearly live in the app
- `partial`: present but still carrying debt, migration, or limited scope
- `supporting`: infrastructure/platform layer rather than a primary end-user surface

## 1. Core app shell and navigation

- `implemented`: onboarding flow with locale, prayer, learning, and reminder preference capture
- `implemented`: guarded app shell with top-level tabs for Worship, Learn, Home, Journey, and Qur'an
- `implemented`: shared-device launch guard and profile-based routing policies
- `implemented`: deep-link handling and route alias compatibility
- `supporting`: telemetry observer, quick actions, swipe-back/navigation support

## 2. Home and daily dashboard

- `implemented`: main Home dashboard
- `implemented`: daily overview and prayer-facing summary
- `implemented`: historical reflection card via On This Day / history archive integration
- `partial`: some active-surface localization debt remains

## 3. Worship and daily practice

- `implemented`: prayer tracking and prayer status logging
- `implemented`: dhikr presets, sessions, and anti-rush handling
- `implemented`: fasting tracking/support
- `implemented`: khushu focus surface
- `implemented`: qibla finder
- `implemented`: worship subsections for prayer, dhikr, fasting, tracking, reminders, and duas

## 4. Qur'an reader, study, and playback

- `implemented`: Qur'an hub as a top-level tab owner
- `implemented`: reader, surah explorer, search, bookmarks, notes, reflections, and verse route
- `implemented`: word study surfaces including top words, word detail, and word review
- `implemented`: thematic/topic exploration and Names of Allah
- `implemented`: ayah insights browse, guided learning paths, and surah insights
- `implemented`: daily Qur'an companion / daily ayah reflection
- `implemented`: saved reflections with private/local notes
- `implemented`: focus recitation mode using the shared playback runtime
- `implemented`: reading-time and listening-time tracking feeding Journey/Growth
- `partial`: route ownership is mostly cleaned up, but some older Learn aliases still exist for compatibility

## 5. Arabic learning and Qur'anic Arabic

- `implemented`: adult Qur'anic Arabic landing and module/lesson flows
- `implemented`: shared Arabic content catalog under `lib/features/arabic/`
- `implemented`: shared search/discovery, lesson packs, progress dashboard, and quick resume
- `implemented`: shared quick mini-assessments
- `implemented`: Qur'an readiness bridge
- `implemented`: short-surah readiness bridge
- `implemented`: guided-passage readiness bridge
- `partial`: offline/audio depth and QA are still active backlog areas

## 6. Learn hub and guided learning system

- `implemented`: journey-first `/learn` landing
- `implemented`: learning journey home, island, journey, stage, and lesson surfaces
- `implemented`: explore-all knowledge and browse surfaces
- `implemented`: learn category taxonomy and section-specific hubs
- `implemented`: learn notes landing and browse flow
- `implemented`: contained-state scaffolds and reusable learn discovery/search UI
- `partial`: Learn remains the biggest migration seam and still carries compatibility/legacy layers

## 7. Salah learning and foundational practice

- `implemented`: salah learning hub
- `implemented`: guided prayer pages by prayer
- `implemented`: surah detail pages tied to salah learning
- `implemented`: wudu guide
- `implemented`: wudu trainer with persisted resume/restart/review flow
- `implemented`: wudu quiz

## 8. Dua and remembrance learning

- `implemented`: dua hub and dua detail pages
- `implemented`: worship-context dua entry
- `implemented`: dua progress provider and repository-backed content flow
- `partial`: verified-vs-stub/source breadth should continue to be audited carefully

## 9. Prophets, Seerah, Hadith, history, and companion knowledge

- `implemented`: prophets landing, stories, detail, timeline, map, family tree, and quiz
- `implemented`: journey of revelation and revelation progress support
- `implemented`: hadith landing, theme/subcategory pages, lessons, learning paths, quizzes, important hadith collection and detail
- `implemented`: history archive, On This Day, event detail, and home card integration
- `implemented`: companion Learn surfaces for Seerah, Character/Adab, and Daily Wisdom
- `implemented`: divine life lessons
- `implemented`: glossary

## 10. Life knowledge and reflective learning

- `implemented`: life landing, themes, subcategories, lessons, and reflection route
- `implemented`: Islamic guides and topic/content detail pages
- `implemented`: Qur'an lessons mapping page
- `implemented`: world/creation-adjacent learning via creation and celestial features

## 11. Quizzes and knowledge games

- `implemented`: trivia session, results, review, stats, and path flow
- `implemented`: crossword home, pack, daily, and puzzle routes
- `implemented`: word search home, pack, daily, and puzzle routes
- `implemented`: matching home, pack, daily, and puzzle routes
- `implemented`: ayah completion home, pack, daily, and puzzle routes
- `implemented`: knowledge game shell/foundation for reusable game adapters
- `implemented`: games island and games browse surfaces

## 12. Kids learning ecosystem

- `implemented`: kids fun learning wrapper and kids-specific routed entry points
- `implemented`: kids Qur'an and kids-safe ayah insights
- `implemented`: kids hadith page and hadith stories
- `implemented`: kids prophet stories and story quiz/memory flows
- `implemented`: kids Seerah journeys, journey detail, and node pages
- `implemented`: kids progression route

## 13. Kids Arabic

- `implemented`: kids Arabic home
- `implemented`: lessons, practice, review, rewards, progress map, and parent dashboard
- `implemented`: words, word lessons, reading mode, and mini phrases
- `implemented`: coloring pages and coloring viewer
- `implemented`: parent settings
- `implemented`: learner-scoped achievements/progress foundations

## 14. Kids dua and bedtime family mode

- `implemented`: kids dua landing, category, lesson, practice, rewards, and parent dashboard
- `implemented`: My Day, read-along, tap-repeat, drawing, drawings, and story-linked flows
- `implemented`: bedtime stories library, detail, player, quiz, memory cards, transcript, and parent dashboard
- `implemented`: bedtime family mode and bedtime companion
- `implemented`: bedtime routines recommendation/session layer
- `partial`: some summaries and family-management patterns still remain specialized to bedtime rather than fully shared across all kids systems

## 15. Journey, growth, and progression

- `implemented`: Journey tab and growth home
- `implemented`: growth Today, Reflection, Progress, Paths, Habits, Browse, and Statistics
- `implemented`: habit dashboard, settings, calendar, and habit detail
- `implemented`: path detail pages
- `implemented`: spiritual growth page, intentions, reflection, and themes
- `implemented`: Journey XP, drops, ocean/garden unlock integration
- `implemented`: learner progression service and learner-scoped progression page
- `implemented`: garden page and milestone growth model
- `partial`: some adult/global surfaces still mirror or bridge from older app-wide ledgers

## 16. Accounts, profiles, sync, and backups

- `implemented`: settings-owned accounts/profiles/sync direction
- `implemented`: shared-device mode and profile picker/launch handling
- `implemented`: account/device/profile management pages
- `implemented`: Apple and Google sign-in integration paths
- `implemented`: honest email sign-in shell
- `implemented`: manual backup export/import with validation and safety snapshots
- `implemented`: remote backup transport abstraction
- `implemented`: iCloud and Google Drive app-data backup transport
- `implemented`: restore preview/comparison engine
- `implemented`: auto-backup engine and scheduling
- `implemented`: granular sync-scope controls
- `partial`: still local-first overall, not a full production cloud account platform

## 17. Settings, help, and legal

- `implemented`: settings page as canonical profile/personalization owner
- `implemented`: summary, what’s new, and coming soon support pages
- `implemented`: help guide hub and detail
- `implemented`: legal, terms, privacy, support, and attributions pages
- `partial`: settings remains one of the larger localization debt areas

## 18. Journal, assistant, and community/discovery extras

- `implemented`: journal timeline, create, and entry detail
- `implemented`: assistant page with provider-backed feature shell
- `implemented`: circles discovery, joined circles, events, moderation, accountability groups, nearby mosques, mosque buddy, and circle detail
- `implemented`: celestial explorer
- `implemented`: creation explorer
- `implemented`: creation challenges
- `partial`: these discovery/community features appear less central than Worship/Learn/Qur'an and may need product-priority validation

## 19. Notifications, reminders, media, and widgets

- `implemented`: local notifications and reminder scheduling
- `implemented`: adhan audio selection/playback
- `implemented`: prayer and Qur'an live-activity support
- `implemented`: just_audio/background audio stack for Qur'an playback
- `implemented`: Arabic and bedtime media manifest/resolver layers
- `implemented`: home-widget bridge support
- `partial`: some device-specific validation and real-device QA remain open

## 20. Platform and companion layers

- `supporting`: Apple Watch companion runtime bridge, sync diagnostics, and Qur'an audio contract
- `supporting`: tvOS parity is a documented requirement, but code presence alone should not be treated as release readiness
- `supporting`: localization system with generated `AppLocalizations` and multi-locale ARB resources
- `supporting`: SQLite + SharedPreferences local-first persistence

## 21. Cross-cutting architecture notes

- State management: Riverpod across major systems
- Navigation: GoRouter with canonical routes plus compatibility aliases
- Persistence: `SharedPreferences` for lightweight state and `sqlite3` for structured app records
- Search/discovery: shared search/indexing patterns exist in Learn/Qur'an/Arabic and should be reused for new discovery-heavy work
- Qur'anic reference interactions: shared verse-link/navigation helpers are already present and should remain the default

## 22. Highest-risk areas from the audit

- Learn remains the easiest area to duplicate accidentally because it contains canonical surfaces, wrappers, and compatibility layers at once.
- Settings/accounts localization and QA are still materially behind the strongest product-owned surfaces.
- Sync/backup is feature-rich, but release confidence still depends on device QA rather than code presence alone.
- Arabic/Qur'an learning has strong breadth now; the main remaining risk is stability, offline media quality, and route/ownership clarity rather than missing feature count.
