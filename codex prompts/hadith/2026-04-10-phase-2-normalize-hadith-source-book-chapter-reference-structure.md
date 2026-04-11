===== PHASE 2 — NORMALIZE HADITH SOURCE / BOOK / CHAPTER / REFERENCE STRUCTURE =====

PRIMARY OBJECTIVE === STRENGTHEN THE HADITH FOUNDATION MODEL SO CONTENT HAS CLEAN, CANONICAL SOURCE / BOOK / CHAPTER / REFERENCE STRUCTURE BEFORE BUILDING HADITH SEARCH, READER PARITY, OR CROSS-DOMAIN CONNECTIONS

You are working in the existing Flutter codebase for Path of Nūr.

This is an implementation task based on the completed Hadith audits and Phase 1 foundation pass.
Do not redesign the app yet.
Do not build Hadith search in this phase.
Do not guess. Use the actual repo ownership and public foundation path already established.

CONTEXT
Completed groundwork:
- one canonical public Hadith content owner now exists
- verified-only/default public surfacing rules are enforced
- the newer Hadith foundation repository is the public source of truth

Latest audit confirmed the next blockers:
- no canonical source book / chapter / hadith-number structure yet
- source-facing metadata still mixes display strings and semi-normalized values
- grade handling needs stronger normalization
- future Qur’an ↔ Hadith graph migration and Hadith search depend on better canonical references

GOAL
Normalize Hadith metadata around source / book / chapter / reference structure without breaking current routes, current public Hadith surfacing, or current user flows.

IMPORTANT PRODUCT RULE
This phase is not about adding more content or features.
It is about making the Hadith foundation structurally clean enough for:
- trusted citations
- future source-book browse
- future chapter browse
- future reader parity
- future search/filter/indexing
- future Qur’an ↔ Hadith canonical link migration

IMPLEMENT THE FOLLOWING

A. STRENGTHEN THE CANONICAL HADITH FOUNDATION MODEL
- Extend the canonical Hadith foundation model with structured source metadata where safely possible.
- Add or normalize fields such as:
  - canonical collection/book id
  - display collection/book title
  - normalized source collection/book title
  - chapter id/title/number if available
  - normalized hadith reference / hadith number
  - narrator normalization
  - standardized grading representation
  - provenance/import metadata where safely possible
- Keep this search-ready and citation-ready, but do not overbuild a giant schema.

B. KEEP DISPLAY FIELDS SEPARATE FROM NORMALIZED FIELDS
- Preserve user-facing display strings where needed.
- Keep normalized metadata fields separate from display fields.
- Do not force UI display to use raw normalized values.

C. STANDARDIZE GRADING
- Replace loose grade handling with a more canonical structured representation where safe.
- Preserve current display behavior compatibility.
- Avoid breaking the verified-only/default public surfacing rules from Phase 1.
- If needed, introduce a normalized grading enum/value object while preserving the existing public display string.

D. PREPARE FOR BOOK / CHAPTER / REFERENCE-AWARE UX
- Introduce metadata that can later power:
  - source collection/book browse
  - chapter browse
  - clearer detail-page source citation
  - search filters
  - graph migration from legacy Hadith lesson ids to canonical `HadithEntry.id` + canonical references
- Do not build the full browse/search UI yet unless a tiny safe adjustment is needed.

E. KEEP PUBLIC TRUST RULES COMPATIBLE
- Ensure the new normalized fields work cleanly with the Phase 1 verified/public-default surfacing rules.
- Do not accidentally broaden public surfacing.
- Keep trust logic centralized.

F. PRESERVE CURRENT USER FLOWS
- Keep working:
  - `/learn/hadith`
  - theme/detail flows
  - collection/detail flows
  - daily Hadith flow
  - saved Hadith persistence
  - review/path flows as applicable
  - kids Hadith and Hadith Reflection routes
- Do not break route names or persistence keys.

G. UPDATE THE REPOSITORY / PROVIDERS SAFELY
- Keep the canonical public Hadith foundation repository as the source of truth.
- Avoid split ownership returning.
- Normalize inside the canonical path rather than spreading logic across multiple surfaces.

H. ADD TEST COVERAGE
Add or update focused tests for:
- normalized source/book/reference metadata
- standardized grading handling
- canonical public repository still returning valid public entries
- Phase 1 trust rules remain intact after normalization
- current public routes/pages still resolve correctly
- any new metadata helpers behave deterministically

I. DO NOT BREAK
- GoRouter route names
- saved Hadith persistence
- daily reflection persistence
- editorial Hadith override flow
- kids Hadith routes
- Hadith Reflection routes
- localization
- verified-only public surfacing from Phase 1

J. KEEP THE CHANGESET TIGHT
- Do not build search in this phase.
- Do not redesign Hadith UI broadly.
- Focus on source/book/chapter/reference normalization only.

DELIVERABLES
After implementing, provide:

1. Executive summary
2. Files changed
3. What metadata was normalized or added
4. How grading was standardized
5. How public/trust rules remain compatible
6. Validation notes
7. Analyzer results
8. Test results
9. Any follow-up notes for Phase 3 Hadith reader/detail parity

At the very end, explicitly confirm:
- canonical Hadith metadata is now more structured and search-ready
- verified-only public surfacing still holds
- current Hadith routes and flows remain intact

===== END =====
