===== PHASE 37 PROMPT — UNIFIED CONTINUE ARABIC LEARNING / RESUME FLOW =====

PRIMARY OBJECTIVE === BUILDING ONE COHERENT “CONTINUE ARABIC LEADING” / RESUME EXPERIENCE ACROSS KIDS AND ADULT ARABIC LEARNING MODES SO USERS CAN RETURN TO THE RIGHT NEXT STEP WITHOUT FRAGMENTATION

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready UX and continuity phase built on top of:
- the shared Arabic alphabet foundation
- the shared positional-form foundation
- the shared Arabic audio foundation
- the shared beginner words and phrases foundation
- Kids Arabic tracing / reading / review systems
- Adult Arabic alphabet / words / reading-helper systems

DO NOT rebuild Kids Arabic or Adult Arabic from scratch. DO NOT break tracing, reading, review, routing, progress, or shared catalog behavior. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve all current Arabic learning systems and routing
- Preserve Kids/Adult UX separation
- Do not flatten Kids and Adults into one generic UI
- Create one shared continuity/resume layer beneath them
- Keep the resume experience calm, clear, and helpful
- Avoid destructive migrations
- Do not create duplicate resume cards all over the app
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Audit the current “continue”, “resume”, and last-opened logic across Kids and Adult Arabic learning flows

2. Create a unified Arabic learning continuity layer that can safely answer:
   - what the user last worked on
   - what the next recommended step is
   - whether they should continue, review, or move forward

3. Build a clean “Continue Arabic Learning” experience that works across:
   - Kids letter tracing
   - Kids reading / review / word practice
   - Adult alphabet learning
   - Adult beginner words / reading helpers

4. Reduce fragmentation and duplicated entry points while preserving age-appropriate presentation

--------------------------------------------------
A. AUDIT CURRENT CONTINUITY / RESUME BEHAVIOR
--------------------------------------------------

Audit all current Arabic learning entry points and continuity behaviors.

Inspect:
- Kids Arabic landing pages
- Kids tracing lesson entry/resume logic
- Kids reading/review/practice entry points
- Adult Arabic landing pages
- Adult alphabet/word reading entry points
- any existing “continue learning” cards/buttons
- any saved last-opened lesson/letter/word state
- current progress providers and route/state persistence
- any page-local logic that guesses “next item” independently

Audit these questions:
- What resume logic already exists in Kids?
- What resume logic already exists in Adults?
- Is last-opened state stored anywhere today?
- Is there already enough data to determine:
  - last active letter
  - last active word/phrase
  - next recommended item
  - unfinished item
- Are there duplicated “continue” surfaces that conflict or drift?
- What is the cleanest place to surface a unified Continue Arabic Learning entry?
- What should remain presentation-specific between Kids and Adults?

--------------------------------------------------
B. DEFINE A SHARED ARABIC CONTINUITY MODEL
--------------------------------------------------

Create a shared continuity/resume model that can safely represent Arabic learning state across modes.

It may include only what is genuinely useful and safe, such as:
- learner mode (kids/adult)
- content type (letter, word, phrase, review, reading, tracing)
- canonical item id
- canonical route target or target parameters
- last opened timestamp if useful
- next recommended item metadata
- resume vs review vs continue-forward intent

Requirements:
- one maintainable shared source of truth
- not bloated
- safe for both Kids and Adults
- compatible with current routing and progress models

--------------------------------------------------
C. BUILD A SHARED CONTINUE / RESUME SERVICE OR PROVIDER
--------------------------------------------------

Create a shared Arabic learning continuity layer that can answer questions like:
- What should this user continue next?
- What was the last Arabic item they touched?
- Is there an unfinished item to resume?
- Should they continue forward or review?

Requirements:
- centralize the logic
- avoid page-local duplicated decision trees
- reuse current progress data where possible
- keep behavior deterministic and understandable
- do not overbuild a complex recommendation engine

This is a continuity layer, not an AI tutor.

--------------------------------------------------
D. SURFACE A UNIFIED “CONTINUE ARABIC LEARNING” ENTRY
--------------------------------------------------

Add a clean unified Continue Arabic Learning entry point.

Possible safe placements:
- Arabic learning landing page
- Learn hub Arabic section
- Kids Arabic landing + Adult Arabic landing with shared underlying logic
- a shared Arabic overview surface if one already exists

Requirements:
- one clear primary resume path
- avoid multiple conflicting continue cards
- preserve Kids/Adult UX differences in styling and wording
- same underlying logic, different presentation if needed

Examples:
- Kids: “Continue Arabic”
- Adults: “Resume Arabic”
- Both should point to the correct next activity for that learner

--------------------------------------------------
E. HANDLE MODE-SPECIFIC NEXT STEPS
--------------------------------------------------

The continuation logic should work appropriately for both Kids and Adults.

Kids may continue into:
- next tracing letter
- unfinished tracing lesson
- review item
- next word
- reading/review practice

Adults may continue into:
- next letter
- next word
- positional-form review
- reading helper continuation

Requirements:
- preserve each mode’s teaching style
- do not send Kids into Adult surfaces or Adults into Kids surfaces
- keep route targets mode-correct and age-appropriate
- keep the logic centralized beneath the UI

--------------------------------------------------
F. SUPPORT RESUME, REVIEW, AND CONTINUE-FORWARD INTENTS
--------------------------------------------------

The continuity system should distinguish between:
- Resume unfinished
- Continue forward
- Review recommended

Requirements:
- keep the logic simple and safe
- unfinished work should usually win over forward progression when appropriate
- review should be suggested gently, not aggressively
- do not create confusing multi-choice overload in the primary entry point

If a secondary action is shown, keep it minimal.

--------------------------------------------------
G. PRESERVE SHARED FOUNDATIONS
--------------------------------------------------

Ensure the continuity system uses shared canonical ids and content metadata.

Requirements:
- rely on shared alphabet ids
- rely on shared words/phrases ids where needed
- support Kids tracing/vector/fallback state safely
- support Adult reading/helper state safely
- no drifting local identifiers

--------------------------------------------------
H. LIGHTWEIGHT UI / COPY SWEEP
--------------------------------------------------

After the continuity layer is added, do a light polish pass on the affected resume/continue surfaces.

Check:
- CTA wording clarity
- title/subtitle consistency
- no duplicate competing continue sections
- no disclosure arrows on cards/containers if that rule is already enforced app-wide
- clean state when there is nothing meaningful to resume
- graceful empty state for first-time users

Do not redesign entire Arabic learning pages in this phase.

--------------------------------------------------
I. FIRST-TIME AND EMPTY-STATE HANDLING
--------------------------------------------------

Handle users who have:
- never started Arabic learning
- completed everything currently available in a mode
- no unfinished work
- partial work but no meaningful last-opened state

Requirements:
- first-time users should get a clear start point
- completed users should get a meaningful next/review suggestion
- empty states should be calm and useful
- do not show broken or vague continue UI

--------------------------------------------------
J. DATA SAFETY
--------------------------------------------------

Preserve:
- Kids Arabic progress
- Adult Arabic progress/continuity
- tracing state
- reading/review state
- routing and shared foundation integrity
- audio and positional-form consumers

Requirements:
- no destructive migrations
- no reset of progress
- no hidden regressions from canonical id usage
- no broken route targets

--------------------------------------------------
K. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- shared continuity layer resolves the correct next target for Kids
- shared continuity layer resolves the correct next target for Adults
- unfinished items are resumed correctly
- continue-forward works correctly when nothing is unfinished
- review intent is surfaced safely where intended
- first-time user fallback works correctly
- no regressions are introduced into Kids/Adult routing or progress lookup

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - current Kids continuity/resume behavior
   - current Adult continuity/resume behavior
   - duplication/fragmentation found
   - chosen shared continuity model scope

3. Shared continuity foundation summary
   - model/provider/service introduced
   - what it tracks
   - how it decides resume vs continue vs review

4. UI summary
   - where Continue Arabic Learning / Resume Arabic is surfaced
   - how Kids and Adults differ in presentation
   - how first-time and empty states are handled

5. Routing summary
   - how correct next targets are resolved safely
   - how mode-specific routing is preserved

6. Data safety summary
   - confirmation that no progress/routing/shared-foundation integrity was lost

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

- there is one shared Arabic continuity/resume foundation used beneath both Kids and Adults
- users have a clear Continue Arabic Learning / Resume Arabic entry
- unfinished items resume correctly
- forward progression works when appropriate
- review suggestions are gentle and non-confusing
- Kids and Adults remain distinct in presentation
- no regressions are introduced into routing, progress, tracing, reading, review, or shared foundations
- Arabic learning now feels like one coherent journey instead of fragmented islands

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild Kids or Adult Arabic from scratch
- flatten Kids and Adults into one generic interface
- build a complex recommendation engine
- break canonical ids or routing
- introduce destructive migrations
- redesign the whole Learn hub in this phase

Stay focused on shared Arabic continuity/resume logic and a unified Continue Arabic Learning experience.

--------------------------------------------------

“And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

===== END PHASE 37 PROMPT =====
