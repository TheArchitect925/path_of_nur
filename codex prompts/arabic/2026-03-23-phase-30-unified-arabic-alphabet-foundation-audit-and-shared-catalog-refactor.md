# ===== PHASE 30 PROMPT — UNIFIED ARABIC ALPHABET FOUNDATION AUDIT AND SHARED CATALOG REFACTOR =====

PRIMARY OBJECTIVE === BUILDING A SINGLE SHARED ARABIC ALPHABET FOUNDATION USED BY BOTH KIDS AND ADULT LEARNING EXPERIENCES, WHILE PRESERVING AGE-APPROPRIATE UI DIFFERENCES

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready architecture and content-unification phase. DO NOT rebuild the Kids Arabic or Adult Arabic experiences from scratch. DO NOT remove working progress, routing, tracing, audio, or learning flows. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve both Kids Arabic and Adult Arabic learning experiences
- Do not merge the UI into one generic page
- Unify the shared content/model/source-of-truth beneath them
- Preserve progress, lesson state, routing, tracing support, audio mappings, and current learning flows
- Ensure both Kids and Adult Arabic support the full alphabet
- Do not introduce destructive migrations
- Keep Kids easier and friendlier, while Adults remain clean and easy
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Audit the existing Kids Arabic alphabet system and the existing Adult Arabic alphabet system

2. Identify mismatches in:
   - letter ids
   - alphabet coverage
   - ordering
   - naming
   - transliteration/pronunciation metadata
   - tracing support flags
   - audio mappings
   - lesson sequencing
   - content duplication

3. Create one canonical shared Arabic alphabet foundation/catalog

4. Refactor both Kids and Adult Arabic experiences to use that shared catalog

5. Ensure both experiences support the full alphabet

6. Preserve age-appropriate presentation differences:
   - Kids = simpler, more guided, more playful
   - Adults = calm, easy, cleaner, more direct

--------------------------------------------------
A. AUDIT BOTH SYSTEMS FIRST
--------------------------------------------------

Audit the full Arabic alphabet learning implementation across both Kids and Adults.

Inspect:
- Kids Arabic data/models/catalogs
- Adult Arabic data/models/catalogs
- tracing-related letter definitions
- any adult lesson/reader/alphabet pages
- ordering logic
- transliteration/pronunciation metadata
- audio mappings
- lesson sequencing
- any fallback/legacy alphabet data
- routing and page entry points for both kids and adults

Audit these questions:
- What is the canonical alphabet list currently used in Kids?
- What is the canonical alphabet list currently used in Adults?
- Are the internal ids consistent?
- Are there naming mismatches such as ha/ha2, kaf/kaaf, lam/laam, etc.?
- Does either side have missing letters?
- Are transliteration or pronunciation strings duplicated or inconsistent?
- Are audio mappings duplicated or inconsistent?
- Are tracing support flags only present in Kids?
- What content/model duplication should be eliminated?
- What should remain presentation-only and not be moved into shared data?

--------------------------------------------------
B. DEFINE ONE CANONICAL ARABIC LETTER MODEL
--------------------------------------------------

Create one shared Arabic letter model/catalog used by both systems.

This shared model should be the single source of truth for the alphabet and may include only what is genuinely useful and safe, such as:
- canonical id
- Arabic glyph
- display name
- order/index
- transliteration/basic pronunciation metadata
- audio key/path if already supported
- tracing support flag
- any simple grouping metadata if already useful

Requirements:
- use one consistent id system
- keep it maintainable
- avoid bloated speculative fields
- support both Kids and Adults cleanly

--------------------------------------------------
C. ENSURE FULL ALPHABET COVERAGE
--------------------------------------------------

Make sure both Kids and Adult Arabic experiences support the full alphabet.

Requirements:
- no missing letters in either experience
- no dead-end letters
- no partial catalog mismatch
- if one mode still relies on fallback behavior for some letters, it must still present complete alphabet coverage cleanly
- preserve stable routing and lesson ordering

The user experience should never feel like one mode has “more real letters” than the other unless that is purely a presentation/interaction difference and not content coverage.

--------------------------------------------------
D. REFACTOR BOTH EXPERIENCES TO USE THE SHARED CATALOG
--------------------------------------------------

Refactor Kids Arabic and Adult Arabic so they both read from the same shared alphabet foundation.

Requirements:
- remove duplicate alphabet definitions where safe
- centralize ordering and identity logic
- centralize transliteration/pronunciation metadata where appropriate
- preserve the existing tracing engine and any adult-specific learning UI
- do not break current progress/state by changing ids recklessly

If compatibility shims are needed, use them safely.

--------------------------------------------------
E. KEEP KIDS AND ADULT PRESENTATION DISTINCT
--------------------------------------------------

Do NOT make Kids and Adults visually identical.

Kids should remain:
- easier
- more guided
- more visual
- more playful
- tracing/support focused

Adults should remain:
- easy and calm
- cleaner
- more direct
- less cartoon-like
- more explanation-friendly if already part of the product

This phase is about unifying the data/source-of-truth, not flattening the UX.

--------------------------------------------------
F. UNIFY AUDIO / PRONUNCIATION MAPPINGS WHERE POSSIBLE
--------------------------------------------------

If Kids and Adults currently use separate pronunciation metadata or audio mapping for letters, unify this where safe.

Requirements:
- shared mapping where the source is the same
- preserve different playback behavior only if the presentation layer needs it
- do not duplicate static mappings unnecessarily
- keep safe fallbacks if audio is not available for every letter yet

--------------------------------------------------
G. UNIFY LETTER ORDER / SEQUENCING
--------------------------------------------------

Ensure both experiences use a consistent canonical alphabet order.

Requirements:
- one source for ordering
- no page-local hardcoded sequences scattered around
- if Kids and Adults surface letters in different learning flows, they should still derive from the same underlying order/catalog
- preserve current sequence continuity where possible

--------------------------------------------------
H. HANDLE ID COMPATIBILITY SAFELY
--------------------------------------------------

If ids differ today between Kids and Adults, normalize them carefully.

Requirements:
- do not break progress records, tracing support, or lesson routing
- use aliases/compatibility mapping if needed
- preserve old ids where necessary through a compatibility layer
- explain clearly in the final summary how compatibility was handled

--------------------------------------------------
I. LIGHTWEIGHT UI CONSISTENCY SWEEP
--------------------------------------------------

After the shared refactor, do a light consistency check.

Verify:
- both experiences show the full alphabet
- no broken labels
- no duplicated/missing letters
- no route breakage
- kids/adult styling remains appropriately distinct
- no disclosure arrows on cards/containers if that rule is already enforced app-wide

Do not redesign either full experience in this phase.

--------------------------------------------------
J. DATA SAFETY
--------------------------------------------------

Preserve:
- Kids Arabic progress
- Adult Arabic progress
- tracing progress
- XP/reward integrity
- audio/tracing support where already working
- route stability
- lesson completion state

Requirements:
- no destructive migrations
- no reset of progress
- no hidden regressions due to id changes
- no accidental removal of alphabet entries

--------------------------------------------------
K. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- shared catalog contains the full alphabet
- both Kids and Adult surfaces read from the shared source
- canonical ordering is consistent
- compatibility/id mapping works safely if introduced
- no letters are missing from either experience
- existing tracing/vector support still resolves correctly
- no regressions in routing or progress lookup

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - Kids Arabic catalog/state
   - Adult Arabic catalog/state
   - mismatches found
   - missing/duplicate letters found

3. Shared foundation summary
   - canonical shared model introduced
   - what fields it includes
   - how both systems now use it

4. Coverage summary
   - confirmation that Kids has full alphabet coverage
   - confirmation that Adults have full alphabet coverage
   - any fallback/compatibility notes

5. Compatibility summary
   - id normalization/aliasing decisions
   - how old progress/routes were preserved safely

6. UX separation summary
   - how Kids remains easier/friendlier
   - how Adults remain calm and easy

7. Data safety summary
   - confirmation that no progress/state was lost

8. Validation
   - analyzer/tests run
   - results

9. FINAL AUDIT
   - what was completed
   - regressions found/fixed
   - remaining follow-up items
   - technical debt intentionally left for later

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- Kids and Adult Arabic now use the same shared alphabet foundation
- both experiences support the full alphabet
- ids/order/naming are unified safely
- duplicate static alphabet data is reduced or removed
- Kids remains easier and more guided
- Adults remain clean and easy
- no progress, routing, or tracing behavior is broken
- the product is now ready for future Arabic learning expansion on top of one shared source of truth

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild the Kids Arabic or Adult Arabic UIs from scratch
- flatten both experiences into one generic interface
- break progress by renaming ids without compatibility handling
- remove tracing or audio support
- reduce alphabet coverage in either mode
- broaden this into a full Arabic curriculum redesign

Stay focused on auditing, unifying, and sharing the Arabic alphabet foundation while preserving age-appropriate presentation.

--------------------------------------------------

“And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

===== END PHASE 30 PROMPT =====
