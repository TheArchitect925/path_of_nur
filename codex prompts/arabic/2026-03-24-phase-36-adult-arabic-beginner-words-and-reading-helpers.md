===== PHASE 36 PROMPT — ADULT ARABIC BEGINNER WORDS AND READING HELPERS =====

PRIMARY OBJECTIVE === BUILDING ADULT ARABIC BEGINNER WORDS, JOINED-LETTER VISUALIZATION, AND SIMPLE READING HELPERS USING THE SHARED ALPHABET, POSITIONAL-FORM, AUDIO, AND WORD/PHRASE FOUNDATIONS

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready enhancement phase built on top of:
- the shared Arabic alphabet foundation
- the shared positional-form (joining) foundation
- the shared Arabic audio manifest
- the shared beginner words and phrases foundation

DO NOT rebuild Kids Arabic or Adult Arabic from scratch. DO NOT break tracing, reading, review, routing, progress, or shared data models. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve shared foundations (alphabet, forms, audio, words/phrases)
- Preserve Adult Arabic routing, progress, and content continuity
- Do not flatten Adult and Kids experiences into one UI
- Keep Adult Arabic:
  - clean
  - calm
  - easy
  - explanation-friendly
- Avoid heavy grammar systems in this phase
- No destructive migrations
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Build Adult Arabic beginner word learning using the shared words/phrases foundation

2. Add joined-letter visualization using the shared positional-form foundation

3. Provide simple reading helpers that make Arabic words easier to understand and pronounce

4. Strengthen Adult Arabic as a usable learning surface, not just an alphabet reference

5. Keep everything consistent with the shared foundations while preserving adult UX clarity

--------------------------------------------------
A. AUDIT CURRENT ADULT ARABIC WORD/READING STATE
--------------------------------------------------

Audit the Adult Arabic experience after the shared words/phrases phase.

Inspect:
- current Adult Arabic pages
- alphabet overview and letter detail pages
- any existing word or reading helpers
- shared word/phrase foundation introduced previously
- shared positional-form data
- shared audio mapping
- navigation and page entry points

Audit these questions:
- Are beginner words currently surfaced in Adult Arabic?
- If so, are they using the shared foundation or still page-local?
- How are positional forms currently explained?
- Are adults able to connect letters → words clearly?
- Is audio easy to access for words?
- What is missing for a beginner adult learner to start reading?
- Where should word learning best live in the Adult IA?

--------------------------------------------------
B. CREATE AN ADULT BEGINNER WORDS SURFACE
--------------------------------------------------

Create or refine an Adult Arabic Beginner Words surface using the shared words/phrases foundation.

Requirements:
- use the shared canonical word set
- present words clearly and cleanly
- ensure:
  - Arabic text
  - transliteration
  - simple meaning/gloss
- allow easy navigation between words
- keep UI calm and uncluttered

This should feel like:
- a clean learning list or card flow
- not a kids-style game
- not an academic-heavy list

--------------------------------------------------
C. ADD JOINED-LETTER VISUALIZATION
--------------------------------------------------

Use the shared positional-form foundation to help adults understand how words are formed.

For each word:
- show how letters appear in context
- optionally highlight:
  - isolated form vs joined form
- visually connect:
  - letters → word

Requirements:
- keep it simple and readable
- do not overload with linguistic jargon
- avoid turning this into a full grammar lesson
- use shared positional-form data as the source of truth

This is one of the most important value adds for adult learners.

--------------------------------------------------
D. ADD SIMPLE READING HELPERS
--------------------------------------------------

Provide lightweight reading assistance.

Possible helpers:
- break word into letters visually (subtle)
- highlight letter boundaries
- show how letters connect
- optional “tap letter inside word” if safe and simple

Requirements:
- do not introduce complex parsing systems
- keep interaction minimal and intuitive
- use shared letter ids where needed
- no heavy UI clutter

Goal:
- help the adult “see” how to read the word

--------------------------------------------------
E. AUDIO INTEGRATION FOR WORDS
--------------------------------------------------

Use the shared audio foundation to support pronunciation.

Requirements:
- tap word → play pronunciation
- allow replay
- keep behavior consistent with other audio surfaces
- no duplicated audio lookup logic

Optional:
- subtle UI feedback when audio plays

--------------------------------------------------
F. ADD NEXT-STEP GUIDANCE FOR ADULTS
--------------------------------------------------

Provide clear next actions.

Examples:
- Next word
- Continue learning
- Review letters used in this word
- Go back to alphabet

Requirements:
- keep it minimal
- avoid multiple competing CTAs
- ensure the adult always knows what to do next

--------------------------------------------------
G. KEEP ADULT UX CLEAN AND DISTINCT
--------------------------------------------------

Ensure the Adult experience remains:
- calm
- clean
- readable
- not playful like Kids

Requirements:
- avoid cartoon styling
- avoid reward-heavy UI
- maintain consistent spacing and typography
- align with existing Adult Learn surfaces

--------------------------------------------------
H. CONNECT TO SHARED FOUNDATIONS
--------------------------------------------------

Ensure Adult Arabic reading helpers use:

- shared alphabet ids
- shared positional-form data
- shared audio mapping
- shared words/phrases

Requirements:
- no duplicated static data
- no drift between Kids and Adults
- keep ownership centralized

--------------------------------------------------
I. LIGHTWEIGHT IA REFINEMENT
--------------------------------------------------

Place the Adult words/reading helpers cleanly.

Possible placements:
- a Beginner Words page under Adult Arabic
- a section within the Adult Arabic hub
- a continuation after alphabet learning

Requirements:
- routing must be clear
- do not create duplicate navigation paths
- keep flow intuitive

--------------------------------------------------
J. DATA SAFETY
--------------------------------------------------

Preserve:
- Adult Arabic progress (if any)
- Kids Arabic stability
- shared alphabet and positional-form integrity
- shared audio mappings
- routing continuity

Requirements:
- no destructive migrations
- no reset of progress
- no breaking of shared data models

--------------------------------------------------
K. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- Adult words surface uses shared word foundation
- positional-form data is correctly displayed
- audio plays correctly for words
- navigation between words works
- no regression to shared foundations
- Kids Arabic remains unaffected

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - current Adult Arabic word/reading state
   - gaps identified
   - chosen placement

3. Adult words/reading summary
   - how words are presented
   - how navigation works

4. Joined-letter visualization summary
   - how forms are shown
   - how shared positional data is used

5. Reading helper summary
   - what helpers were added
   - how they improve clarity

6. Audio summary
   - how shared audio is used for words

7. Data safety summary
   - confirmation no progress/state was lost

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

- Adult Arabic includes a clean beginner words learning surface
- words use the shared words/phrases foundation
- joined-letter visualization is clear and helpful
- audio works consistently
- reading helpers improve clarity without clutter
- Kids Arabic remains distinct and unaffected
- no regressions introduced into shared foundations or routing
- Adult Arabic now feels like a real beginner learning experience, not just a reference

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild Adult Arabic from scratch
- flatten Kids and Adult experiences
- introduce heavy grammar systems
- break shared canonical ids/order
- duplicate word/phrase data locally
- introduce destructive migrations

Stay focused on Adult Arabic beginner words, joined-letter visualization, and reading helpers using the shared foundation.

--------------------------------------------------

“And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

===== END PHASE 36 PROMPT =====
