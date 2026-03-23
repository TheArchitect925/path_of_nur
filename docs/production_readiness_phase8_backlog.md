# Phase 8 Production Readiness Backlog

## P0 candidates before public beta

- Learn content surfaces still expose placeholder-backed sections and lesson targets in parts of the Learning Hub and learning journey registry.
- Dua coverage is still heavily stub-backed in the seeded repository, which makes some browse flows feel incomplete even when routing is correct.

## P1 next passes

- Localize remaining core-reader hardcoded copy in `quran_reader_page.dart`, especially beta labels, download snack bars, and helper actions.
- Standardize cross-app contextual note creation across Qur'an notes, saved reflections, journal, creation explorer, and celestial notes.
- Audit key core pages for explicit empty/loading/error states where data can be absent or remote fetches can fail.
- Tighten Learn hub page architecture where multiple content families and journey-managed items still overlap.
- Sweep Settings and Home for remaining hardcoded labels and inconsistent wording on high-traffic surfaces.

## P2 polish

- Add stronger accessibility semantics and large-text checks on the core shell tabs and high-use island pages.
- Consolidate repeated pill/badge formatting on Growth detail pages into one shared variant.
- Review secondary browse surfaces for consistent search entry treatment and empty-state language.

## Suggested next implementation order

1. Learn placeholder/stub surfacing audit and containment
2. Cross-app note/add-entry consistency pass
3. Qur'an reader localization hardening
4. Core page empty/loading/error state sweep
5. Settings and Home wording/localization cleanup
