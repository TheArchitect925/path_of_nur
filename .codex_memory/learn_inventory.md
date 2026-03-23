# Learn System Inventory

Last updated: 2026-03-22

## Current reality

The Learn system is not one thing. It is several overlapping systems that currently coexist:

1. journey-first Learn home at `/learn`
2. legacy Learn hub at `/learn/legacy`
3. section hub routes under `/learn/hub/*`
4. dedicated domain routes for Life, World, Hadith, FAQ, Duas, Trivia, Salah, Qur'an-adjacent surfaces
5. a separate top-level Qur'an tab

## Learn home ownership

- `/learn` currently lands on `LearningSectionLandingPage`
- `LearnPage` still exists and is reachable through `/learn/legacy`
- this is intentional transitional state, not clean final IA
- active Learn journey discovery no longer surfaces `legacy-learning`; `/learn/legacy` is now compatibility-only in practice

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

## Progress / resume state already present

- Learning Journey:
  - `learn.journey.progress.v1`
  - started journeys
  - completed stages
  - last opened journey/stage
  - streak/day activity
- Learning paths:
  - `learn.path.state.v1`
- unified learn continue/daily/saved/notes behavior also exists through the shared learn engine

## Major overlap points

- Qur'an:
  - top-level tab owns primary destination
  - old `/learn/quran/*` aliases still exist
- Learn home:
  - `/learn` is journey-first
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

## Major missing pieces

- one clear final Learn IA
- clean ownership boundary between Learn and Qur'an tab
- stronger shared continue/resume persistence across all learn domains
- full localization parity for active learn surfaces and seeded lesson bodies
- explicit archive/removal of unused legacy providers/widgets once route ownership is stable

## Guidance for future Codex work

- treat Learn as the highest duplicate-work-risk area in the repo
- before adding any new learn page, check:
  - `LearnCategoryCatalog`
  - `LearningJourneyRegistry`
  - `LearnPage`
  - existing domain routes in `app_router.dart`
- prefer extending an existing learn domain or journey wrapper over adding a parallel hub
