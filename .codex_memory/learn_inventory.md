# Learn System Inventory

Last updated: 2026-03-31

## Current reality

The Learn system is not one thing. It is several overlapping systems that currently coexist:

1. journey-first Learn home at `/learn`
2. legacy Learn hub at `/learn/legacy`
3. section hub routes under `/learn/hub/*`
4. dedicated domain routes for Life, World, Hadith, FAQ, Duas, Trivia, Salah, Qur'an-adjacent surfaces
5. a separate top-level Qur'an tab
6. a guided learning path layer on top of existing content and routes

## Learn home ownership

- `/learn` currently lands on `LearningSectionLandingPage`
- `LearnPage` still exists and is reachable through `/learn/legacy`
- this is intentional transitional state, not clean final IA
- active Learn journey discovery no longer surfaces `legacy-learning`; `/learn/legacy` is now compatibility-only in practice
- the visible `/learn` landing now prioritizes:
  - Continue Your Journey
  - Daily Learning
  - a guided "Start a Journey" section with starter paths
  - six main visible islands for Foundations, Qur'an, Worship, Character, Stories, and Games
  - a separate visible Kids discovery card in non-child mode
  - Explore All as the secondary search/browse/tools entry
- the underlying route graph was not collapsed in that pass; `/learn/legacy`, journey routes, games, quizzes, content-domain routes, and compatibility aliases still remain live

## Guided learning paths

- V1 guided paths now exist under `lib/features/learn/guided_paths/`
- detail route: `/learn/paths/:pathId`
- current starter paths:
  - Foundations Path
  - Salah Path
  - Qur'an Beginner Path
  - Daily Dhikr Path
  - Character Path
  - Stories Path
  - Kids Starter Path
- the path system is orchestration-only:
  - seeded metadata points to existing route owners
  - `/quran/*` remains canonical for Qur'an surfaces
  - kids route families remain canonical for kids-owned destinations
- progress is stored locally under `learn.guided_paths.state.v1`
- `/learn` continue priority now prefers an active guided path before falling back to the older unified continue card

## Learn categories / catalogs

Primary category catalog source:

- `lib/features/learn/presentation/data/learn_category_catalog.dart`

Important catalog facts:

- hidden items exist and should not be treated as active feature commitments:
  - `becoming-muslim`
  - `guidance-new-muslims`
  - `aqeedah-essentials`
  - `five-pillars`
  - `ramadhan-fasting`
  - `zakah-sadaqah`
  - `jummah`
  - `hajj`
  - `umrah`
  - `eid`
  - `funeral`
  - `fiqh-basic`
- supported dynamic section hubs are currently:
  - `prophets`
  - `quizzes`
  - `duas`
  - `faq`

## Real active learn domains

- Qur'an
- Qur'an learning
- Qur'anic Arabic
- Trivia
- Hadith
- Divine Life Lessons / Life
- World & Creation
- Knowledge Constellation
- Prophets
- Baby Names
- 99 Names of Allah
- Duas
- Salah trainer / wudu / guided prayer
- FAQ
- Notes
- Islamic Guides remains in the codebase as a compatibility-only legacy route and is no longer part of visible v1 discoverability

## Data sources / engines already present

- Qur'an repositories and providers
- Hadith curriculum / learning paths / quiz data
- Prophets seeded story/detail/timeline/map/quiz data
- Life and World curriculum data
- Dua seed data with complete vs stub distinction
- unified learn search / theme / path / relationship providers in `learn/shared`
- learning journey registry + localized metadata + lesson content
- guided learning path seeds + local progress overlay

## Progress / resume state already present

- Learning Journey:
  - `learn.journey.progress.v1`
  - started journeys
  - completed stages
  - last opened journey/stage
  - streak/day activity
- Learning paths:
  - `learn.path.state.v1`
- Guided learning paths:
  - `learn.guided_paths.state.v1`
- unified learn continue/daily/saved/notes behavior also exists through the shared learn engine

## Major overlap points

- Qur'an:
  - top-level tab owns primary destination
  - old `/learn/quran/*` aliases still exist
  - guided learning paths may point into Qur'an owners, but do not replace them
- Learn home:
  - `/learn` is journey-first plus guided-path-first for active path resume
  - `/learn/legacy` still hosts broad category/search/path experience
- Trivia:
  - dedicated hub routes plus legacy Learn-category exposure
- Prophets / Duas / FAQ / Quizzes:
  - routed through `/learn/hub/:sectionId`
  - also visible in broader Learn catalog/navigation

## Placeholder / incomplete areas

- hidden placeholder-like categories remain in the catalog for future concepts
- some larger content areas still depend on scaffold or seeded data
- dua library intentionally tracks many `stub_*` entries not ready as full content
- v1 discovery now hides stub/planned dua counts and only surfaces verified dua categories/items to users
- legacy `IslamicGuidesPage` and `QuranLessonsMappingPage` now render calm contained states because they depend on placeholder-backed content
- `tajweed-basics` now resolves to a real lesson-backed beginner Tajweed journey again and is safe to surface from Learn discovery
- generic learn content pages no longer show placeholder reference sections until structured source-backed references exist
- older English fallback content still exists in parts of the journey lesson system
- guided path completion is still explicit/manual for many steps and does not yet infer completion from every owner surface

## Current UX posture

- `/learn` now surfaces progression more clearly after the 2026-03-31 polish pass:
  - active guided paths show current step, numeric progress, and a lightweight progress bar in `Continue Your Journey`
  - guided path cards now show visible progress and next-step context
  - guided path detail now highlights the current step, dims completed steps, and gives lightweight snackbar feedback for step/path completion
  - Explore All is grouped more intentionally into quick-access, support/saved spaces, and search results
  - Kids remains explicitly discoverable through a featured Learn card rather than only indirect routing
- Learn discovery now has an additive path-aware search layer after the 2026-03-31 search/discovery upgrade:
  - `learnDiscoveryIndexProvider` merges the shared Learn knowledge index with guided paths instead of replacing existing metadata
  - guided paths are now first-class search results alongside direct lessons/pages
  - Explore supports light type/audience/difficulty filtering plus grouped result buckets instead of only flat filtered cards
  - direct Qur'an search results now canonicalize broad Qur'an hubs to `/quran/*` owners while guided Qur'an paths remain orchestration-only
  - kids queries now boost kids-safe entries and the Kids Starter Path without changing kids route ownership
- Learn analytics is now an explicit subsystem after the 2026-03-31 analytics pass:
  - guided paths, landing cards, Explore search, related-content handoffs, recommendation acceptance, and legacy/alias route hits now emit stable Learn events through `LearnAnalyticsService`
  - the summary provider can now derive path starts/completions, step completions, search query mix, result-type opens, Explore section usage, recommendation acceptance, and legacy/alias route usage from the local telemetry log
  - retirement review for older Learn surfaces can now be based on measured alias/direct-route activity instead of guesswork
- Learn enrichment is now an explicit subsystem after the 2026-03-31 delight pass:
  - milestone unlocks and recent learning memories are now stored independently from guided-path progress, so enrichment can evolve without taking over the progress owner
  - the Learn landing can now show a single pending milestone moment plus recent memory highlights without turning the page into a reward dashboard
  - completed guided paths now have a calmer enriched completion state with next-path suggestions, while existing path reward hooks remain the only XP/Ocean award boundaries
- Final Learn launch-readiness audit status after the 2026-03-31 final pass:
  - overall status is `Ready with minor polish`
  - strongest shipped lanes are Foundations, Qur'an Beginner, Daily Dhikr, Kids Starter, Stories, guided-path UX, and path-aware discovery
  - `Character Path` was the clearest targeted follow-up hardening need and has now been tightened with a calmer companion-led intro, focused trait step, practical lesson-backed application, explicit reflection, and stronger completion sequencing toward Stories
  - `Salah Path` now starts with the existing `salah-foundations` intro lesson instead of dropping directly into the full Salah hub, reducing the last obvious hub-first beginner edge
  - Explore/discovery no longer repeats the same item across multiple result buckets or curated sections

## Major missing pieces

- one clear final Learn IA
- clean ownership boundary between Learn and Qur'an tab
- stronger shared continue/resume persistence across all learn domains
- full localization parity for active learn surfaces and seeded lesson bodies
- explicit archive/removal of unused legacy providers/widgets once route ownership is stable
- richer adaptive guided path recommendations and automatic completion

## Guidance for future Codex work

- treat Learn as the highest duplicate-work-risk area in the repo
- before adding any new learn page, check:
  - `LearnCategoryCatalog`
  - `LearningJourneyRegistry`
  - existing guided learning path seeds
  - `LearnPage`
  - existing domain routes in `app_router.dart`
- prefer extending an existing learn domain, guided path, or journey wrapper over adding a parallel hub
