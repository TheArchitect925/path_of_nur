# Learning Hub Copy Cleanup

Date: 2026-03-31
Scope: visible `/learn` naming, subtitles, supporting card copy, and route-facing ownership language
Mode: production-safe copy cleanup, non-destructive

## Top-Level Naming Model

Primary visible structure on `/learn`:

- Continue Your Journey
- Daily Learning
- Foundations
- Qur'an
- Worship
- Character
- Stories
- Games
- Explore All

## Before / After Decisions

### Landing subtitle

- Before: category-ownership and journey-heavy wording
- After: calmer guided-entry wording focused on continuing, daily learning, and one clear next path

### Continue section

- Before: `Continue Learning`
- After: `Continue Your Journey`

Reason:
- matches the intended top-level model
- keeps the guidance tone without renaming routes or progress systems

### Empty continue fallback

- Before: `Browse Journeys`
- After: `Open Guided Paths`

Reason:
- reduces route-system language in the primary UI
- keeps the journey home route alive as a compatibility owner

### Main islands section header

- Before: `Explore by Category`
- After: `Choose a focus`

Reason:
- category language felt library-like
- the visible landing is now guided, not taxonomy-first

### Qur'an island subtitle

- Before: implied Learn-owned Qur'anic study tools
- After: positions the island as an entry into the Qur'an space for reading, reflection, and guided study

Reason:
- protects canonical ownership under `/quran/*`
- avoids implying a second Qur'an hub inside Learn

### Games language

- Before: mixed visible wording across games, quizzes, and challenge language
- After: main island stays `Games`, subtitle frames quizzes, challenges, and review games as one family

Reason:
- keeps Games as the visible top-level owner
- treats quizzes and challenges as content types/destinations, not competing peer islands

### Stories language

- Before: prophet-heavy, implementation-history wording
- After: `Learn through prophets, seerah, and Islamic history.`

Reason:
- better matches the intended Stories umbrella
- stays broad enough to preserve prophet, seerah, and history entry points

### Kids discovery card

- Before: category copy that sounded taxonomy-based
- After: warmer audience-facing wording for younger learners

Reason:
- keeps Kids discoverable without re-fragmenting the main adult island model

### Explore All

- Before: `Explore All Knowledge`
- After: `Explore All`

Reason:
- cleaner and calmer
- better reflects its role as the secondary catch-all surface for tools, notes, FAQ, and browse-heavy entry points

### Legacy/library quick action

- Before: generic `Explore`
- After: `Library`

Reason:
- keeps the older library accessible without making it a main Learn owner

## Qur'an Ownership Guidance

- `/quran/*` remains the canonical Qur'an owner
- the Learn Qur'an island should sound like a guided entry point
- avoid visible wording such as:
  - separate Qur'an hub
  - Learn-owned Qur'anic tools
  - duplicate study home

Preferred direction:

- enter the Qur'an space
- open Qur'an reading, reflection, and guided study
- route into the canonical Qur'an experience

## Games Wording Guidance

- top-level visible owner: `Games`
- visible subtypes:
  - quizzes
  - challenges
  - review games
- avoid using `Quizzes`, `Trivia`, and `Challenges` as competing top-level labels on `/learn`

## Kids Wording Guidance

- keep Kids visible on `/learn`
- use audience wording instead of taxonomy wording when possible
- preserve the distinct kids route family
- do not bury Kids inside Explore All only

## Preserved Internal Identifiers

The following were intentionally preserved:

- route names and path families
- `learnHubCategory` identifiers
- search/index metadata
- taxonomy and analytics-facing IDs
- existing compatibility aliases

## Localization Impact

New landing-specific keys were added instead of overwriting broader taxonomy strings. This keeps the copy cleanup scoped to `/learn` while preserving the existing translation structure for category pages and related routes.

## Risks / Follow-Ups

- non-English locales currently use English fallback values for the new landing-specific keys
- deeper route/page copy outside the primary `/learn` landing still includes older words like journey, legacy, browse, hub, and section
- Explore All and games-specific pages should be the next cleanup targets so the supporting pages match the calmer landing language
