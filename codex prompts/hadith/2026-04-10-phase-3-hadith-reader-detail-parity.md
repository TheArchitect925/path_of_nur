# PHASE 3 — HADITH READER / DETAIL PARITY WITH TRUSTED SOURCE DISPLAY

PRIMARY OBJECTIVE === TURN THE CURRENT HADITH DETAIL EXPERIENCE INTO A TRUE CANONICAL HADITH READER THAT MATCHES THE APP’S SACRED-READING QUALITY, WHILE USING THE NEW STRUCTURED HADITH METADATA

You are working in the existing Flutter codebase for Path of Nūr.

This is an implementation task based on the completed Hadith foundation phases.
Do not build Hadith search yet.
Do not redesign the whole app.
Do not guess. Use the actual canonical Hadith foundation path already established.

CONTEXT
Completed groundwork:
- one canonical public Hadith content owner exists
- verified-only/default public surfacing rules are enforced
- source/book/chapter/reference metadata is now normalized
- source collection/book name is a first-class canonical field
- grading is standardized
- category/subcategory taxonomy exists

The current Hadith detail page is solid, but it still feels more like a Learn content page than a full Hadith reader.

GOAL
Upgrade the Hadith detail experience into a canonical Hadith reader/detail surface that:
1. clearly shows source / reference / grade / narrator
2. feels visually aligned with the Qur’an reader and the rest of Path of Nūr
3. preserves trusted public surfacing
4. prepares for later Hadith search and cross-domain connections

IMPORTANT PRODUCT RULES
- Match the sacred-reading quality of the Qur’an reader, but do NOT copy Qur’an-specific surah/ayah assumptions.
- Hadith is book/chapter/reference-oriented, not surah/ayah-oriented.
- Source trust and citation clarity must be first-class.
- Keep the experience calm, readable, and consistent with the app.

IMPLEMENT THE FOLLOWING

A. UPGRADE THE HADITH DETAIL PAGE INTO A CANONICAL READER
- Use the existing Hadith detail owner as the canonical reader/detail page.
- Improve the page so it feels like a true Hadith reader, not just a lesson card.
- Keep the current route names and flow intact.

B. MAKE SOURCE / REFERENCE / GRADE FIRST-CLASS
- Prominently display:
  - Source collection/book name
  - Reference
  - Grade
- These must be clearly separated and not collapsed into one mixed line.
- Use the normalized canonical fields added in the foundation phase.
- The source should be highly visible and trustworthy at a glance.

C. ADD NARRATOR DISPLAY
- Surface narrator information in a clean and readable way where the metadata exists.
- Keep it distinct from source and grade.

D. IMPROVE READER CONTENT PRESENTATION
- Preserve Arabic + translation presentation.
- Align typography, spacing, metadata hierarchy, and section treatment with the app’s sacred-reading design language.
- Reuse safe visual patterns from the Qur’an reader where appropriate:
  - calm spacing
  - metadata blocks
  - content hierarchy
  - reference sections
  - related content sections
- Do not reuse:
  - surah/ayah transport logic
  - playback/follow-mode assumptions
  - verse-range navigation patterns

E. ADD CORE READER ACTIONS
- Add or complete:
  - save/bookmark from detail page
  - copy
  - share
- Keep behavior consistent with the rest of the app.
- Do not introduce heavy or unrelated action systems.

F. SURFACE RELATED QURAN / RELATED HADITH CLEANLY
- Preserve and improve related Qur’an presentation using the current structured connection fields.
- Preserve and improve related Hadith presentation where canonical ids already exist.
- Keep the sections useful but not noisy.

G. PREPARE FOR FUTURE READER EXTENSIONS
- The upgraded reader should be ready later for:
  - Hadith search result handoff
  - category/subcategory surfacing
  - source-book/chapter navigation
  - cross-domain connection sections
- Do not build all of those now unless a tiny safe improvement is necessary.

H. KEEP TRUST RULES INTACT
- The reader must continue to render only the public verified subset from the canonical public foundation path.
- Do not bypass the trust/public-default gating.

I. PRESERVE CURRENT USER FLOWS
- Keep working:
  - /learn/hadith
  - theme/detail flows
  - collection/detail flows
  - daily Hadith flow
  - saved Hadith persistence
  - review/path flows as applicable
  - kids Hadith and Hadith Reflection routes
- Do not break route names or persistence keys.

J. ADD TEST COVERAGE
Add or update focused tests for:
- reader displays source collection/book clearly
- reader displays reference separately
- reader displays grade separately
- narrator display works when metadata exists
- save/bookmark action works from detail page if applicable
- copy/share actions work safely if added
- related Qur’an / related Hadith sections still work
- verified-only public surfacing still holds
- routes still resolve correctly

K. DO NOT BREAK
- canonical public Hadith foundation owner
- verified-only public surfacing
- existing GoRouter route names
- saved Hadith persistence
- daily reflection persistence
- editorial Hadith override flow
- kids Hadith routes
- Hadith Reflection routes
- localization

L. KEEP THE CHANGESET TIGHT
- Do not build full Hadith search in this phase.
- Do not redesign unrelated Learn pages.
- Focus only on Hadith reader/detail parity and trusted metadata presentation.
