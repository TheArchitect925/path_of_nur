# Phase 50 Prompt — Shared Arabic Content Authoring Framework

PRIMARY OBJECTIVE === BUILDING A SHARED ARABIC CONTENT AUTHORING FRAMEWORK SO ALL FUTURE LETTER, WORD, PHRASE, REVIEW, AND QUR’AN-BRIDGE CONTENT FOLLOWS ONE CONSISTENT, PRODUCTION-SAFE STRUCTURE

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready architecture and content-governance phase built on top of:
- shared Arabic alphabet foundation
- shared positional-form foundation
- shared Arabic audio manifest
- shared beginner words and phrases foundation
- Kids Arabic learning flows
- Adult Arabic learning flows
- continuity/resume and review layers
- Qur’an readiness bridge and short-surah bridge

DO NOT rebuild Kids Arabic, Adult Arabic, or Qur’an bridge experiences from scratch. DO NOT break tracing, reading, audio, routing, progress, or existing shared foundations. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve all current Arabic learning systems and route continuity
- Create one reusable authoring structure beneath all future Arabic content
- Do not flatten Kids and Adults into one UI
- Keep the framework maintainable, explicit, and scalable
- Avoid speculative over-modeling
- No destructive migrations
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Audit how Arabic learning content is currently authored across:
   - letters
   - words
   - phrases
   - review/practice items
   - Qur’an bridge snippets
   - short-surah bridge content
   - tajweed-linked bridge hints where applicable

2. Identify inconsistent or duplicated content patterns

3. Create one shared Arabic content authoring framework/model that can support current and future expansion

4. Refactor current content where safe so future additions follow the new structure

5. Ensure all new content created in future phases can plug into existing discovery surfaces cleanly

--------------------------------------------------
A. AUDIT CURRENT ARABIC CONTENT AUTHORING PATTERNS
--------------------------------------------------

Audit all current Arabic learning content sources.

Inspect:
- shared alphabet catalog
- shared positional-form data
- shared words/phrases foundation
- Kids Arabic lesson content
- Adult Arabic reading-helper content
- review/practice content sources
- Qur’an bridge snippet content
- short-surah bridge content
- any page-local text blocks or datasets
- any duplicated content metadata across Kids and Adults
- any hardcoded lesson-card metadata on pages

Audit these questions:
- How many different content-authoring patterns exist today?
- Which parts are already reusable?
- Which content is duplicated or drifting?
- Which metadata is repeated across multiple files/pages?
- What structure is missing that would make future content packs easier and safer to add?
- What content should stay shared versus presentation-specific?

--------------------------------------------------
B. DEFINE A SHARED ARABIC CONTENT UNIT MODEL
--------------------------------------------------

Create a shared authoring model for Arabic learning content units.

A content unit may represent:
- a letter lesson
- a word lesson
- a phrase lesson
- a review/practice item
- a Qur’an bridge snippet
- a short-surah readiness item
- a tajweed-connected bridge hint pack where appropriate

The shared model may include only what is genuinely useful and safe, such as:
- canonical content id
- title
- subtitle/summary
- audience/mode (kids/adult/both)
- content type
- related letter ids / word ids / phrase ids where useful
- audio reference keys if needed
- progression grouping / pack id if useful
- optional hint/support metadata
- optional route/discovery metadata only if truly needed

Requirements:
- one explicit, maintainable structure
- not bloated
- flexible enough for future growth
- compatible with current shared foundations

--------------------------------------------------
C. DEFINE A SHARED LESSON / PACK COMPOSITION MODEL
--------------------------------------------------

Build a clean composition model that can group content units into:
- lesson packs
- review packs
- bridge packs
- themed vocabulary packs
- future reading packs

Requirements:
- shared pack structure
- ordered content references
- easy to author and extend
- no duplication of embedded content objects where ids/references are better

This should work cleanly with the lesson-pack direction already introduced.

--------------------------------------------------
D. REFACTOR CURRENT CONTENT TO THE NEW FRAMEWORK WHERE SAFE
--------------------------------------------------

Migrate or adapt current Arabic learning content into the new authoring framework where it is safe and high value.

Prioritize:
- word/phrase content
- bridge snippet metadata
- review/practice grouping
- lesson-pack composition metadata

Requirements:
- do not break existing routes
- do not reset progress
- preserve canonical ids
- use compatibility shims where needed
- avoid huge destructive rewrites

--------------------------------------------------
E. KEEP KIDS AND ADULTS DISTINCT IN PRESENTATION
--------------------------------------------------

The authoring framework is shared beneath the UI.

Kids should still feel:
- guided
- simpler
- more visual
- encouragement-first

Adults should still feel:
- cleaner
- calmer
- more direct
- explanation-friendly

Requirements:
- shared content ownership, distinct presentation
- no flattening into one generic interface

--------------------------------------------------
F. ENSURE NEW CONTENT PLUGS INTO EXISTING PAGES
--------------------------------------------------

The new authoring framework must support existing discovery/access surfaces cleanly.

It must remain easy for future content to appear in:
- Kids Arabic landing pages
- Adult Arabic landing pages
- Continue Arabic Learning
- Review / Practice
- Search / Filter
- Qur’an bridge
- short-surah bridge
- relevant existing Learn pages

Requirements:
- no orphan content
- no hidden pack logic
- no page-local ad hoc integration required for every new lesson

--------------------------------------------------
G. DEFINE AUTHORING RULES / CONTENT GOVERNANCE
--------------------------------------------------

Create lightweight authoring rules for future contributors.

Document rules such as:
- when to create a new content unit
- when to create a new pack
- what metadata is required
- what stays shared vs local
- how Kids and Adults should reuse the same source differently
- how audio/letter/word references should be linked
- how route access should be handled

Requirements:
- keep rules practical and concise
- this should reduce future drift, not add bureaucracy

--------------------------------------------------
H. LIGHTWEIGHT IA / UX SAFETY SWEEP
--------------------------------------------------

After the refactor, verify that existing pages still surface content correctly.

Check:
- no missing titles/subtitles
- no broken discovery cards
- no broken search/filter entries
- no broken continue/review targets
- no disclosure arrows on cards/containers if that rule is already enforced
- no new hidden content islands

Do not redesign the UI in this phase.

--------------------------------------------------
I. DATA SAFETY
--------------------------------------------------

Preserve:
- Kids Arabic progress
- Adult Arabic progress
- shared alphabet and positional-form integrity
- audio mappings
- route continuity
- review/continuity behavior
- Qur’an bridge continuity

Requirements:
- no destructive migrations
- no reset of progress
- no hidden regressions from content-id or pack changes
- no broken canonical ids

--------------------------------------------------
J. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- shared content-unit model resolves current content correctly
- pack composition resolves correctly
- Kids and Adult surfaces still read intended content
- search/review/continue still resolve correct targets after refactor
- no route/content regressions are introduced
- shared authoring structure covers current high-value content types safely

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.
