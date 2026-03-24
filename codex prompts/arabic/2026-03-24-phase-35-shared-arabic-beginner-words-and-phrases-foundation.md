===== PHASE 35 PROMPT — SHARED ARABIC BEGINNER WORDS AND PHRASES FOUNDATION =====

PRIMARY OBJECTIVE === BUILDING ONE SHARED ARABIC BEGINNER WORDS AND PHRASES FOUNDATION USED BY BOTH KIDS AND ADULT ARABIC LEARNING EXPERIENCES

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready shared-foundation phase built on top of the unified Arabic alphabet foundation, shared positional-form foundation, and shared Arabic audio direction. DO NOT rebuild Kids Arabic or Adult Arabic experiences from scratch. DO NOT break tracing, reading, review, routing, progress, or shared alphabet behavior. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve the shared Arabic alphabet foundation and shared positional-form foundation
- Preserve Kids Arabic and Adult Arabic routing, progress, audio behavior, tracing behavior, and lesson continuity
- Do not flatten Kids and Adults into one UI
- Unify beginner word and phrase content beneath both experiences
- Keep Kids simpler, more guided, and more visual
- Keep Adults cleaner, more direct, and explanation-friendly
- No destructive migrations
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Audit all current Arabic beginner word and phrase content across Kids and Adults

2. Identify duplicated, drifting, or page-local word/phrase metadata

3. Create one shared Arabic beginner words and phrases foundation

4. Refactor both Kids and Adult Arabic experiences to use that shared source safely

5. Preserve presentation differences while removing duplicated static ownership

--------------------------------------------------
A. AUDIT CURRENT WORDS AND PHRASES ACROSS KIDS AND ADULTS
--------------------------------------------------

Audit the full Arabic learning content surfaces across both Kids and Adults.

Inspect:
- Kids Arabic beginner word sets
- Kids Arabic mini phrase sets
- Kids Arabic reading mode word cards
- Adult Arabic beginner word/reading helpers if any exist
- any page-local word datasets
- any phrase cards, phrase pages, or reading helpers
- transliteration, meaning, and audio references for words/phrases
- any places where word composition is implied from letters but not stored centrally
- any routing and lesson flow that depends on local word/phrase data

Audit these questions:
- What beginner words already exist for Kids?
- What mini phrases already exist for Kids?
- What beginner words/phrases already exist for Adults, if any?
- Are word strings duplicated in multiple places?
- Are transliteration or meaning strings drifting between Kids and Adults?
- Are audio references duplicated or inconsistent?
- Which words/phrases are strongest and worth promoting into the shared foundation?
- Which content is too experimental or page-local to promote right now?
- What metadata should be shared centrally versus kept presentation-specific?

--------------------------------------------------
B. DEFINE A SHARED WORD / PHRASE MODEL
--------------------------------------------------

Create a production-safe shared data model for Arabic beginner words and phrases.

The shared model may include only what is genuinely useful and safe, such as:
- canonical id
- Arabic text
- transliteration
- simple meaning / gloss
- type (word or phrase)
- difficulty / level if already useful
- letters used / canonical letter ids where safely derivable
- audio asset path / lookup key if already supported
- category / grouping tag if helpful (for example: beginner word, dhikr phrase, daily phrase, greeting)

Requirements:
- one canonical source of truth
- maintainable and explicit
- compatible with both Kids and Adults
- not bloated with speculative fields

--------------------------------------------------
C. BUILD A SHARED BEGINNER WORDS SET
--------------------------------------------------

Create a shared beginner Arabic words set suitable for both Kids and Adults, with different presentation layers on top.

Requirements:
- start with a curated, high-quality set
- use simple, readable Arabic
- keep meanings beginner-friendly
- ensure the set is consistent with the shared alphabet/positional-form foundation
- avoid fake breadth
- prefer a smaller real set over a large weak one

Document in the final summary:
- what words were chosen
- why they were chosen
- how they support both Kids and Adults differently

--------------------------------------------------
D. BUILD A SHARED MINI PHRASES SET
--------------------------------------------------

Create a shared mini-phrase set suitable for both Kids and Adults.

Requirements:
- keep phrases very short and meaningful
- ensure they are beginner-friendly and high-recognition
- align with the app’s tone and learning direction
- avoid making this a full curriculum explosion in one phase

Examples may include:
- short dhikr phrases
- simple daily expressions
- short meaningful Arabic phrases already appropriate to the product

Use only what is genuinely useful and product-safe.

--------------------------------------------------
E. REFRACTOR KIDS TO USE THE SHARED FOUNDATION
--------------------------------------------------

Refactor Kids Arabic word/phrase surfaces to use the shared source where appropriate.

Requirements:
- preserve the kids-friendly experience
- keep Kids more visual, simpler, and more guided
- preserve current routing and progress where possible
- move shared content ownership into the shared layer
- keep kids-specific helper text, rewards, and guidance local where they belong

Do not flatten Kids presentation.

--------------------------------------------------
F. REFACTOR ADULTS TO USE THE SHARED FOUNDATION
--------------------------------------------------

Refactor Adult Arabic word/phrase surfaces to use the shared source where appropriate.

Requirements:
- preserve the adult experience as calm, direct, and explanation-friendly
- use shared words/phrases as the source of truth
- allow adult-specific explanation or breakdown content to remain local where it genuinely belongs
- avoid duplicated static datasets in adult pages

Do not flatten Adult presentation.

--------------------------------------------------
G. CONNECT TO SHARED AUDIO / LETTER FOUNDATIONS
--------------------------------------------------

Where appropriate, connect the new shared word/phrase foundation to:
- shared alphabet ids
- shared positional forms
- shared audio mappings or audio-ready fields

Requirements:
- do not over-engineer a full morphology engine
- only connect letters/ids where it is safe and useful
- keep audio references centralized where possible
- prepare the codebase for future reading helpers, phrase audio, and join-letter visuals

--------------------------------------------------
H. KEEP KIDS AND ADULTS DISTINCT IN PRESENTATION
--------------------------------------------------

Kids should still feel:
- simpler
- more guided
- more visual
- more encouraging

Adults should still feel:
- cleaner
- more direct
- more self-guided
- more explanation-friendly

This phase unifies content/data ownership, not the UI.

--------------------------------------------------
I. LIGHTWEIGHT IA / CONTENT SWEEP
--------------------------------------------------

After the shared refactor, run a light sweep of affected surfaces.

Check:
- no duplicated word/phrase ownership remains where safely removable
- transliteration consistency
- meaning/gloss consistency
- no missing audio references where intended
- no broken cards or routes
- no disclosure arrows on cards/containers if that rule is already enforced app-wide

Do not redesign the full Kids or Adult reading experiences in this phase.

--------------------------------------------------
J. DATA SAFETY
--------------------------------------------------

Preserve:
- Kids Arabic progress
- Adult Arabic continuity
- tracing/reading/review flows
- route stability
- audio behavior
- shared alphabet and positional-form foundations

Requirements:
- no destructive migrations
- no reset of progress
- no hidden regressions due to word/phrase source changes
- no breaking of current learning flows

--------------------------------------------------
K. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- shared word/phrase foundation contains the intended canonical content
- Kids surfaces read from the shared source where intended
- Adult surfaces read from the shared source where intended
- transliteration/meaning consistency is preserved
- letter-id linkage works safely where added
- no regressions are introduced into routing, progress, tracing, reading, or audio flows

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - current Kids word/phrase usage
   - current Adult word/phrase usage
   - duplication/drift found
   - chosen shared model scope

3. Shared words/phrases foundation summary
   - model introduced
   - what content it covers
   - what metadata is shared centrally

4. Refactor summary
   - how Kids now use the shared foundation
   - how Adults now use the shared foundation
   - what intentionally remains local

5. Shared-content summary
   - beginner words selected
   - mini phrases selected
   - why they were chosen

6. Data safety summary
   - confirmation that no progress/state/route continuity was lost

7. Validation
   - analyzer/tests run
   - results

8. FINAL AUDIT
   - what was completed
   - regressions found/fixed
   - remaining follow-up items
   - technical debt intentionally left for later

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- Kids and Adult Arabic now use one shared beginner words and phrases foundation where intended
- duplicated static word/phrase ownership is reduced
- shared words/phrases are high-quality, curated, and beginner-safe
- Kids remain simpler and more guided in presentation
- Adults remain cleaner and more direct in presentation
- no regressions are introduced into tracing, reading, routing, progress, or audio behavior
- the app is now ready for stronger shared reading helpers and phrase-based Arabic learning expansion

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild Kids or Adult Arabic reading experiences from scratch
- flatten Kids and Adults into one generic interface
- introduce a full grammar/morphology engine
- break shared canonical ids/order
- remove supported audio/tracing/reading behavior
- broaden into full assessment or curriculum redesign in this phase

Stay focused on shared beginner words and phrases content ownership and safe refactoring beneath both Arabic learning experiences.

--------------------------------------------------

“And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

===== END PHASE 35 PROMPT =====
