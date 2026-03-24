# Phase 48 Prompt — Gentle Mini Assessments (Recognition-Only, No Pressure)

PRIMARY OBJECTIVE === BUILDING A CALM, RECOGNITION-BASED MINI ASSESSMENT LAYER FOR ARABIC LEARNING THAT HELPS REINFORCE LETTERS, WORDS, AND PHRASES WITHOUT GRADING OR PRESSURE

You are working in the existing Flutter codebase for Path of Nur.

This phase builds on top of:
- shared Arabic alphabet foundation
- shared positional-form foundation
- shared audio manifest
- shared words/phrases foundation
- Kids Arabic tracing / reading / review systems
- Adult Arabic reading helpers
- shared continuity/resume layer
- shared gentle review layer
- search/filter
- calm progress dashboard
- Qur’an readiness bridge
- parent-friendly overview

DO NOT rebuild learning systems. DO NOT introduce scoring, timers, or pass/fail mechanics. Build a gentle, supportive assessment experience.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve all existing flows (tracing, reading, review, audio, routing, progress)
- No scores, grades, timers, or pressure
- Keep UX calm, encouraging, and brief
- Reuse shared data and continuity/review signals
- Centralize logic (no page-local duplication)
- No destructive migrations
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Add short, optional mini assessments for:
   - letters
   - words
   - phrases

2. Focus on recognition (see/hear → pick/confirm), not production

3. Use results to gently inform:
   - continue
   - review

4. Integrate seamlessly with existing pages (no new isolated flows)

--------------------------------------------------
A. AUDIT CURRENT CAPABILITIES
--------------------------------------------------

Inspect:
- shared alphabet/words/phrases data
- audio layer (tap-to-hear)
- continuity/review outputs
- Kids and Adult entry points
- any existing quiz-like components

Identify:
- safest question types to implement now
- available data for distractors (wrong options)
- best surfaces to insert assessments (end of lesson, review, or dedicated light page)

--------------------------------------------------
B. DEFINE QUESTION TYPES (V1)
--------------------------------------------------

Implement a small set of recognition-only question types:

1) See → Choose (Letter/Word/Phrase)
- Show Arabic text
- Provide 3–4 options (same type)
- User selects the matching item

2) Hear → Choose
- Play audio
- Provide 3–4 options
- User selects what they heard

3) Match (optional, simple)
- Pair item to meaning or transliteration

Requirements:
- keep sets small (1–3 questions per session)
- use shared canonical ids
- avoid trick questions

--------------------------------------------------
C. BUILD A SHARED ASSESSMENT MODEL
--------------------------------------------------

Create a minimal shared model:

- questionId
- itemId (letter/word/phrase)
- type (see→choose, hear→choose)
- options[]
- correctOptionId
- route target (for follow-up)

Requirements:
- centralized generation
- deterministic and simple
- derived from shared foundations

--------------------------------------------------
D. BUILD ASSESSMENT GENERATOR
--------------------------------------------------

Create a shared generator/service that:
- selects 1–3 items based on:
  - recent activity
  - review candidates
  - current progression
- creates options (including distractors from same type)

Requirements:
- small, fast
- no heavy randomness
- avoid repeating identical sets too often

--------------------------------------------------
E. UX FLOW (CALM, BRIEF)
--------------------------------------------------

Flow:
1. Intro card: “Let’s practice”
2. 1–3 quick questions
3. Immediate gentle feedback per question
4. End card with:
   - Continue
   - Review (if helpful)

Requirements:
- no timers
- no scores
- no “fail”
- quick exit anytime

Kids:
- simpler visuals, larger taps

Adults:
- cleaner, minimal UI

--------------------------------------------------
F. FEEDBACK (NON-PRESSURE)
--------------------------------------------------

On answer:
- Correct → subtle positive (check, soft glow)
- Not correct → gentle hint (“Try again” / highlight)

Requirements:
- no red/error states
- no negative language
- allow retry within the same question

--------------------------------------------------
G. INTEGRATE WITH CONTINUITY / REVIEW
--------------------------------------------------

After assessment:
- If struggles detected → suggest Review
- Otherwise → Continue

Requirements:
- use shared review/continuity services
- no duplicate logic
- keep suggestions minimal

--------------------------------------------------
H. INTEGRATE INTO EXISTING SURFACES
--------------------------------------------------

Surface assessments via:
- Continue Arabic Learning (secondary option)
- Review section (optional “Quick practice”)
- End-of-lesson nudge

Requirements:
- no new top-level maze
- no orphan pages
- reuse existing navigation

--------------------------------------------------
I. HANDLE STATES
--------------------------------------------------

- First-time → skip or offer “Try a quick practice”
- Low data → use simplest questions
- Completed → optional review set

Graceful, calm states only.

--------------------------------------------------
J. DATA SAFETY
--------------------------------------------------

Preserve:
- progress
- XP/rewards (no direct rewards here unless already safe)
- routing
- shared foundations

Requirements:
- no destructive migrations
- no duplicate reward triggers
- no impact on tracing/reading flows

--------------------------------------------------
K. TESTING
--------------------------------------------------

Add/update tests for:
- generator creates valid questions
- correct option mapping
- distractor selection valid
- routing after assessment works
- integration with review/continue
- no regressions in core flows

Run analyzer/tests.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed
2. Audit findings
3. Question types implemented
4. Generator/service summary
5. UX flow summary (Kids vs Adults)
6. Integration summary (continuity/review)
7. Data safety summary
8. Validation results
9. FINAL AUDIT

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- mini assessments exist and are optional
- recognition-based only (no pressure)
- 1–3 quick questions per session
- feedback is calm and encouraging
- integrates with continue/review flows
- no regressions in existing systems

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- add scoring, grades, timers
- build a full quiz engine
- create a separate assessment product
- duplicate logic across pages
- break routing or progress
- redesign the Learn hub

Stay focused on gentle, supportive recognition checks.
