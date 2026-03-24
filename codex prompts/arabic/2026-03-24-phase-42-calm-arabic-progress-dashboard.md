# Phase 42 Prompt — Calm Arabic Progress Dashboard (Kids + Adults)

PRIMARY OBJECTIVE === BUILDING A CALM, NON-PRESSURE ARABIC PROGRESS DASHBOARD THAT SUMMARIZES LETTERS, WORDS, PHRASES, AND CONTINUITY FOR BOTH KIDS AND ADULTS USING SHARED FOUNDATIONS

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready visibility phase built on top of:
- shared Arabic alphabet foundation
- shared positional-form foundation
- shared audio manifest
- shared words/phrases foundation
- Kids tracing/reading/review systems
- Adult alphabet/words/reading helpers
- unified continuity/resume layer (Phase 37)
- shared gentle review layer (Phase 38)
- Arabic search/filter (Phase 41)

DO NOT rebuild Kids or Adult Arabic experiences. DO NOT introduce pressure-heavy analytics. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve all progress, routing, and shared foundations
- Keep the dashboard calm, readable, and helpful
- No scores, grades, or competitive elements
- No destructive migrations
- Reuse existing progress signals (completed/started/last-opened)
- Avoid duplicating logic across pages
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Create a shared Arabic progress dashboard foundation
2. Surface simple summaries:
   - letters completed
   - words/phrases completed
   - recent activity
   - next step (continue/review)
3. Provide parent-friendly clarity without pressure
4. Keep Kids and Adults distinct in presentation

--------------------------------------------------
A. AUDIT CURRENT PROGRESS SIGNALS
--------------------------------------------------

Inspect:
- kids_arabic_progress_provider.dart
- adult Arabic progress (letters/words)
- continuity layer outputs
- review layer outputs
- any existing summary cards

Identify available signals:
- completed letters count
- started/in-progress items
- completed words/phrases
- last activity
- recommended next action

--------------------------------------------------
B. DEFINE A SHARED PROGRESS SUMMARY MODEL
--------------------------------------------------

Create a shared model for summaries, e.g.:
- total letters
- completed letters
- total words/phrases
- completed words/phrases
- last activity item
- next recommended item (from continuity)
- optional simple streak (if already safe)

Keep it minimal and derived from existing data.

--------------------------------------------------
C. BUILD THE DASHBOARD SURFACE
--------------------------------------------------

Create a progress dashboard entry.

Possible placements:
- Kids Arabic landing (simple card)
- Adult Arabic landing (clean card)
- optional dedicated detail page

Requirements:
- not cluttered
- clear at a glance
- uses islands/cards consistent with app style
- no disclosure arrows on cards if that rule is enforced

--------------------------------------------------
D. KIDS PRESENTATION
--------------------------------------------------

Kids dashboard should be:
- visual and encouraging
- simple counts (e.g., “8 letters learned”)
- highlight latest achievement/milestone
- show “Continue” as primary CTA

Avoid dense stats.

--------------------------------------------------
E. ADULT PRESENTATION
--------------------------------------------------

Adult dashboard should be:
- clean and minimal
- show counts and simple breakdown
- show last activity
- show next step

Avoid gamified visuals.

--------------------------------------------------
F. CONNECT TO CONTINUITY & REVIEW
--------------------------------------------------

Integrate:
- primary CTA → Continue Arabic Learning
- secondary CTA → Review

Use shared continuity/review services. Do not duplicate logic.

--------------------------------------------------
G. HANDLE EMPTY / FIRST-TIME STATES
--------------------------------------------------

- No progress → show “Start Arabic”
- Some progress → show resume + simple stats
- Completed set → show review suggestion

Keep states calm and clear.

--------------------------------------------------
H. LIGHTWEIGHT POLISH
--------------------------------------------------

Optional:
- progress rings/bars (simple)
- “Today” or “Recent” chip
- latest achievement (from milestones)

Do not over-design.

--------------------------------------------------
I. DATA SAFETY
--------------------------------------------------

Preserve:
- all progress
- XP/rewards
- routing
- shared foundations

No destructive changes.

--------------------------------------------------
J. TESTING
--------------------------------------------------

Test:
- summary values are correct
- continue/review CTAs route correctly
- empty states behave correctly
- no regressions in learning flows

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed
2. Audit findings
3. Shared progress model summary
4. Kids dashboard summary
5. Adult dashboard summary
6. Routing summary
7. Data safety summary
8. Validation results
9. FINAL AUDIT

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- users can see Arabic learning progress clearly
- Kids view is encouraging and simple
- Adult view is clean and informative
- continue/review actions are obvious
- no pressure or grading introduced
- no regressions in existing systems

--------------------------------------------------

“And whoever does an atom’s weight of good will see it.” — Qur’an 99:7
