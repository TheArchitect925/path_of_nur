===== PHASE 54 PROMPT — SHARED ARABIC VOCABULARY THEMES (THEMED WORD & PHRASE PACKS) =====

PRIMARY OBJECTIVE === BUILDING SHARED, CURATED ARABIC VOCABULARY THEMES (DAILY WORDS, PRAYER WORDS, QUR’AN-LINKED WORDS) USING THE LESSON-PACK FRAMEWORK AND ENSURING THEY ARE EASILY ACCESSIBLE FROM EXISTING ARABIC LEARNING PAGES

You are working in the existing Flutter codebase for Path of Nūr.

This phase builds on top of:
- shared Arabic alphabet foundation
- shared positional-form foundation
- shared Arabic audio manifest
- shared words/phrases foundation (Phase 35)
- shared lesson-pack framework (Phase 46)
- Kids Arabic learning flows
- Adult Arabic learning flows
- unified continuity/resume layer (Phase 37)
- shared gentle review layer (Phase 38)
- Arabic search/filter (Phase 41)
- Qur’an readiness bridge (Phases 40, 44, 53)

DO NOT rebuild Kids or Adult Arabic systems. DO NOT create isolated content that is hard to discover. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve all shared foundations and current learning flows
- Use the shared lesson-pack framework as the base
- Ensure all new vocabulary content is reachable from existing pages
- Keep Kids simpler and more guided; Adults cleaner and more direct
- Avoid content duplication or drift
- No destructive migrations
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Create shared Arabic vocabulary themes using reusable lesson packs

2. Introduce high-value themed packs such as:
   - Daily Words
   - Prayer Words
   - Qur’an-Linked Words

3. Ensure all new themed content is discoverable through existing Arabic learning surfaces

4. Strengthen connections between:
   - letters → words → phrases → Qur’an

--------------------------------------------------
A. AUDIT CURRENT WORD / PHRASE CONTENT
--------------------------------------------------

Audit all current Arabic word and phrase content.

Inspect:
- shared words/phrases foundation
- Kids Arabic word sets
- Kids mini phrase sets
- Adult Arabic word/reading helpers
- Qur’an bridge snippets and words used there
- any duplicated or page-local word datasets

Audit questions:
- Which words are already present and high quality?
- Which words overlap with Qur’an snippets?
- Which words are suitable for themed grouping?
- Where is content duplicated or drifting?
- What content should be promoted into shared themed packs?

--------------------------------------------------
B. DEFINE THEMED VOCABULARY PACKS
--------------------------------------------------

Create a small, curated set of themed packs.

Minimum set:
- Daily Words (common, everyday Arabic)
- Prayer Words (terms used in salah and dhikr)
- Qur’an-Linked Words (words that appear in bridge snippets/surahs)

Each pack should:
- use shared word/phrase ids
- have a clear title and summary
- include a small, high-quality set (not large and noisy)

Document:
- words included
- why they were chosen
- how they connect to learning progression

--------------------------------------------------
C. BUILD USING THE SHARED LESSON-PACK FRAMEWORK
--------------------------------------------------

Use the existing lesson-pack model to define each theme.

Requirements:
- no new parallel data structures
- pack references shared content units by id
- pack ordering is explicit and consistent
- packs are reusable across Kids and Adults

--------------------------------------------------
D. ENSURE ACCESS THROUGH EXISTING PAGES
--------------------------------------------------

Mandatory:

All themed packs must be accessible through existing surfaces, such as:
- Kids Arabic landing page
- Adult Arabic landing page
- Continue Arabic Learning
- Review / Practice
- Search / Filter
- Qur’an bridge pages where relevant

Requirements:
- no orphan packs
- no hidden routes
- no need to “know where to go”
- integrate into existing discovery patterns

--------------------------------------------------
E. KIDS PRESENTATION
--------------------------------------------------

Kids should see themed packs as:
- simple, friendly islands/cards
- guided entry points
- small, focused sets

Requirements:
- visual, encouraging
- not overwhelming
- consistent with Kids UI

--------------------------------------------------
F. ADULT PRESENTATION
--------------------------------------------------

Adults should see themed packs as:
- clean list sections
- grouped modules
- easy browsing

Requirements:
- minimal, readable
- not playful
- consistent with Adult UI

--------------------------------------------------
G. CONNECT THEMES TO AUDIO AND READING
--------------------------------------------------

Ensure each word/phrase:
- has audio (from shared audio manifest)
- supports tap-to-hear
- works with reading helpers where applicable

Requirements:
- no duplicated audio logic
- consistent playback behavior

--------------------------------------------------
H. CONNECT THEMES TO QUR’AN BRIDGE
--------------------------------------------------

Where applicable:
- highlight words that appear in Qur’an bridge snippets
- allow gentle linkage:
  - “Seen in Qur’an”
  - “Used in this surah”

Requirements:
- minimal, not cluttered
- helpful, not forced

--------------------------------------------------
I. INTEGRATE WITH REVIEW / CONTINUITY
--------------------------------------------------

Ensure themed packs work with:
- continuity layer (resume)
- review layer (revisit)
- search/filter

Requirements:
- packs can be suggested as next steps
- no duplicate logic
- no conflict with existing flows

--------------------------------------------------
J. AVOID DUPLICATION AND DRIFT
--------------------------------------------------

Requirements:
- all words/phrases come from shared foundation
- no page-local redefinition
- no inconsistent transliteration/meaning
- no duplicate audio mapping

--------------------------------------------------
K. LIGHTWEIGHT UX SWEEP
--------------------------------------------------

After integration:

Check:
- themed packs appear in expected places
- labels are clear
- no duplicate entry points
- no disclosure arrows on cards/containers if rule enforced
- navigation is smooth

--------------------------------------------------
L. DATA SAFETY
--------------------------------------------------

Preserve:
- all progress
- XP/reward system
- routing
- shared foundations

Requirements:
- no destructive migrations
- no reset of progress
- no broken routes

--------------------------------------------------
M. TESTING
--------------------------------------------------

Add/update tests for:

- themed packs resolve correct content
- packs appear in Kids and Adult surfaces
- routing works from all entry points
- audio plays correctly
- no regressions in tracing/reading/review flows

Run analyzer/tests.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed
2. Audit findings
3. Themed pack definitions
4. Integration summary
5. Kids vs Adult presentation summary
6. Data safety summary
7. Validation results
8. FINAL AUDIT

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- themed vocabulary packs exist and are high quality
- all packs are accessible through existing pages
- Kids and Adults both benefit with appropriate UI
- audio and reading helpers work consistently
- no duplication or drift introduced
- no regressions in existing systems

--------------------------------------------------

“And We have certainly made the Qur’an easy for remembrance.” — Qur’an 54:17

===== END PHASE 54 PROMPT =====
