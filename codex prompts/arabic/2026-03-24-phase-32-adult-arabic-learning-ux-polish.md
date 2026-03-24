# Phase 32 Prompt — Adult Arabic Learning UX Polish On Top Of The Shared Foundation

PRIMARY OBJECTIVE === BUILDING A CLEANER, EASIER, AND MORE COHESIVE ADULT ARABIC LEARNING EXPERIENCE USING THE SHARED ARABIC ALPHABET AND POSITIONAL-FORM FOUNDATIONS

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready UX and content-ownership phase built on top of the shared Arabic alphabet and shared positional-form foundations. DO NOT rebuild the Adult Arabic system from scratch. DO NOT break Kids Arabic, tracing, routing, audio, progress, or the shared catalog architecture. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve the shared Arabic alphabet foundation and shared positional-form foundation
- Preserve Adult Arabic routing, progress, lesson continuity, audio behavior, and content integrity
- Do not flatten Adult Arabic into the Kids experience
- Adults should remain easy, calm, and clean, but less playful than Kids
- Reduce duplication, drift, and weak presentation patterns
- Keep scope focused on Adult Arabic UX polish and consistency, not a full curriculum rewrite
- No destructive migrations
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Audit the current Adult Arabic learning experience end to end

2. Refine Adult Arabic so it feels:
   - easier
   - cleaner
   - calmer
   - more cohesive
   - more directly useful

3. Ensure Adult Arabic fully and correctly uses the shared alphabet/positional-form foundations

4. Improve clarity of:
   - alphabet browsing
   - letter detail views
   - positional-form explanation
   - audio/help access
   - progression/next-step guidance

5. Leave Adult Arabic visually and structurally distinct from Kids while still benefiting from the same shared source of truth

--------------------------------------------------
A. AUDIT THE CURRENT ADULT ARABIC EXPERIENCE
--------------------------------------------------

Audit the full Adult Arabic learning flow before editing.

Inspect:
- Adult Arabic entry points
- alphabet overview/list/grid
- letter detail pages
- positional-form explanation surfaces
- any adult-focused Qur’anic Arabic teaching pages
- audio usage
- next/back progression
- current reliance on shared alphabet and shared positional-form data
- any page-local duplicated strings/data that should now come from the shared foundations

Audit these questions:
- What is the current Adult Arabic landing experience?
- Is the adult flow easy to understand on first entry?
- Are letters surfaced clearly and consistently?
- Are adult pages still carrying duplicated static alphabet or form metadata after the shared-foundation refactor?
- Is the explanation level appropriate for adults, or is it either too sparse or too cluttered?
- Is navigation between letters/forms smooth?
- Is there a clear next step for an adult learner?
- What presentation issues make the adult experience feel less polished than it could be?

--------------------------------------------------
B. CLEAN UP THE ADULT ARABIC INFORMATION ARCHITECTURE
--------------------------------------------------

Refine the Adult Arabic information architecture so it feels intentional and easy to follow.

Possible sections may include only where supported cleanly:
- Alphabet Overview
- Letter Details
- Positional Forms
- Pronunciation / Audio
- Continue Learning
- Practice / Review
- Beginner Words later if already lightly linked

Requirements:
- keep the flow simple
- reduce confusion and duplicated entry points
- ensure the most useful surfaces are most visible
- avoid making the adult experience feel fragmented or overly academic

Do not turn this into a full Learn-wide redesign.

--------------------------------------------------
C. IMPROVE THE ADULT ALPHABET OVERVIEW
--------------------------------------------------

Refine the adult alphabet overview/list/grid so it is clearer and more useful.

Requirements:
- use the shared alphabet foundation as the source of truth
- ensure all 28 letters are present and ordered correctly
- make browsing calm and readable
- provide a clear way to open a specific letter detail
- optionally show subtle progress/completion cues only if they already exist safely
- avoid clutter and unnecessary decorative noise

The adult overview should feel cleaner and more direct than Kids.

--------------------------------------------------
D. IMPROVE LETTER DETAIL PAGES
--------------------------------------------------

Refine Adult Arabic letter detail pages so they present the right amount of information cleanly.

A good adult detail surface may include:
- Arabic glyph
- Arabic/English display name
- transliteration
- sound hint
- positional forms
- simple explanation
- pronunciation/audio access
- next/previous navigation where appropriate

Requirements:
- use the shared alphabet and positional-form foundations
- remove duplicated or inconsistent data where safe
- keep the page easy and readable
- do not overload adults with unnecessary complexity in this phase

--------------------------------------------------
E. IMPROVE POSITIONAL-FORM EXPLANATION
--------------------------------------------------

Use the new shared positional-form foundation to make Adult Arabic clearer.

Requirements:
- show isolated / initial / medial / final forms in a clean way
- explain letter changes in context simply
- use consistent terminology
- keep the experience more explanation-friendly than Kids, but still easy
- avoid dense linguistic jargon unless it is clearly useful and already part of the product voice

This should make adult learners feel the system is understandable, not intimidating.

--------------------------------------------------
F. IMPROVE ADULT AUDIO ACCESS
--------------------------------------------------

Refine the adult pronunciation/audio experience where appropriate.

Requirements:
- keep letter audio or pronunciation access clear and easy
- ensure adult pages use the shared audio/source mapping where intended
- remove duplicated page-local lookup logic if safe
- keep behavior consistent
- do not build a whole new audio subsystem in this phase

This phase may lightly improve adult audio discoverability without changing the underlying audio architecture too broadly.

--------------------------------------------------
G. ADD CLEARER NEXT-STEP GUIDANCE FOR ADULTS
--------------------------------------------------

Adults should know what to do next.

Possible guidance patterns:
- Next Letter
- Continue with the next letter in order
- Review forms again
- Resume where you left off

Requirements:
- keep guidance clear but not overbearing
- avoid too many competing CTAs
- make the flow feel intentional
- preserve route continuity and existing progress where present

--------------------------------------------------
H. REMOVE DUPLICATION AND PAGE-LOCAL DRIFT
--------------------------------------------------

After the shared-foundation work, clean up any remaining duplicated or drifting adult-only alphabet/form metadata.

Requirements:
- move safe shared concerns to the shared foundation where appropriate
- reduce duplicated static values in adult pages
- preserve adult-specific explanation/presentation content where it truly belongs
- keep ownership boundaries clean

The goal is:
- shared data in shared layers
- adult presentation in adult layers

--------------------------------------------------
I. KEEP ADULTS DISTINCT FROM KIDS
--------------------------------------------------

Adult Arabic should remain distinct from Kids Arabic.

Adults should feel:
- calmer
- cleaner
- more direct
- more self-guided
- less playful

Requirements:
- do not copy Kids styling wholesale
- do not add childish reward-heavy presentation to adult pages
- do not remove useful adult explanation in pursuit of oversimplification

--------------------------------------------------
J. LIGHTWEIGHT VISUAL / COPY CONSISTENCY SWEEP
--------------------------------------------------

Run a lightweight polish pass across affected adult pages.

Check:
- titles and subtitles
- spacing and hierarchy
- section labels
- transliteration consistency
- positional-form labels
- CTA wording
- empty/loading/error fallback quality
- no disclosure arrows on cards/containers if that rule is already enforced app-wide

Do not do a full design-system rewrite in this phase.

--------------------------------------------------
K. DATA SAFETY
--------------------------------------------------

Preserve:
- adult routing and lesson continuity
- any adult progress state
- shared canonical ids/order
- shared positional-form correctness
- audio mappings
- Kids Arabic stability

Requirements:
- no destructive migrations
- no reset of progress
- no breaking of shared-catalog consumers
- no regressions introduced into Kids through shared-model changes

--------------------------------------------------
L. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- Adult Arabic surfaces use the shared alphabet foundation correctly
- Adult Arabic surfaces use shared positional-form data correctly
- all 28 letters still appear in the adult experience
- next-step / navigation flow works where updated
- adult compatibility data still resolves safely
- no regressions are introduced into Kids or shared foundation behavior

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - current Adult Arabic strengths/weaknesses
   - duplication/drift found
   - key polish targets selected

3. Adult UX summary
   - overview improvements
   - detail-page improvements
   - positional-form explanation improvements
   - audio/next-step improvements

4. Shared-foundation usage summary
   - what adult surfaces now read from the shared alphabet/form source
   - what adult content intentionally remains local

5. Data safety summary
   - confirmation that no progress/routing/shared-foundation integrity was lost

6. Validation
   - analyzer/tests run
   - results

7. FINAL AUDIT
   - what was completed
   - regressions found/fixed
   - remaining follow-up items
   - technical debt intentionally left for later

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- Adult Arabic feels cleaner, easier, and more cohesive
- all 28 letters remain correctly surfaced
- adult pages clearly use the shared alphabet and positional-form foundations
- duplication and naming drift are reduced
- adults have clearer next-step guidance
- Kids remain distinct and unaffected in presentation
- no regressions are introduced into shared foundations, tracing, audio, routing, or progress

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild the Adult Arabic system from scratch
- flatten Kids and Adults into one shared UI
- introduce advanced grammar-heavy curriculum redesign
- break canonical ids/order
- remove audio/tracing/shared-foundation support
- broaden into full phrase/word curriculum work in this phase

Stay focused on Adult Arabic UX polish and shared-foundation correctness.
