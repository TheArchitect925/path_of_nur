===== PHASE 23 PROMPT — KIDS ARABIC MASTERY SYSTEM, PROGRESS MAP, AND REVIEW FLOW =====

PRIMARY OBJECTIVE === BUILDING A KIDS ARABIC MASTERY SYSTEM WITH A PROGRESS MAP, COMPLETED LETTER OVERVIEW, REVIEW FLOW, AND NEXT-STEP GUIDANCE ON TOP OF THE EXISTING TRACING EXPERIENCE

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready enhancement phase built on top of the existing Kids Arabic tracing, progression, and reward systems. DO NOT rebuild the tracing engine. DO NOT introduce strict scoring or handwriting recognition. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve tracing behavior, progress, rewards, and routing
- Keep the experience child-friendly and visually clear
- Do not add strict grading
- Do not create a complicated spaced-repetition engine in this phase
- Reuse existing progress/state systems where possible
- No destructive migrations
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Add a Kids Arabic progress map
2. Show completed / in-progress / not-started letters clearly
3. Add a simple review flow for weaker or incomplete letters
4. Add a clear “next recommended letter” flow
5. Make the Arabic learning experience feel like a guided mastery journey

--------------------------------------------------
A. AUDIT CURRENT KIDS ARABIC STATE
--------------------------------------------------

Inspect:
- kids_arabic_progress_provider.dart
- kids_arabic_lesson_page.dart
- tracing completion flow
- reward/progression hooks
- letter ordering / lesson ordering
- any current progress summary UI

Audit these questions:
- What progress states already exist?
- What counts as completed today?
- Is there already enough data to distinguish started vs completed?
- How should review candidates be identified safely?
- Where should the mastery map live in the current Kids Arabic IA?

--------------------------------------------------
B. BUILD A PROGRESS MAP
--------------------------------------------------

Create a visual Arabic alphabet progress map.

Requirements:
- show all letters in a clear ordered layout
- indicate:
  - not started
  - in progress
  - completed
- keep it visually friendly for children and understandable for parents
- tapping a letter should open or resume that letter lesson where appropriate

Do not overcomplicate with heavy analytics.

--------------------------------------------------
C. DEFINE SIMPLE MASTERY STATES
--------------------------------------------------

Implement a simple mastery model using existing safe data where possible.

Suggested states:
- not started
- practicing / in progress
- completed

Optional only if already safe:
- review recommended

Requirements:
- do not invent strict mastery scoring
- do not invalidate old progress
- keep the logic understandable and maintainable

--------------------------------------------------
D. ADD NEXT RECOMMENDED LETTER FLOW
--------------------------------------------------

Provide a clear next-step recommendation.

Requirements:
- if the child is following the main sequence, surface the next letter
- if a review is more important, optionally suggest review first
- keep the recommendation simple and obvious
- avoid confusing multiple competing CTAs

Examples:
- Continue with Laam
- Review Ba
- Resume Meem

--------------------------------------------------
E. ADD REVIEW FLOW
--------------------------------------------------

Create a simple review pathway for letters that should be revisited.

Possible candidates:
- started but not completed letters
- letters completed long ago if safe data exists
- letters intentionally marked for retry/review if such signals exist

Requirements:
- keep review logic simple
- no harsh “weakness” language
- present review as positive reinforcement
- allow a child to re-open and retrace a letter easily

Do not build a full adaptive-learning engine in this phase.

--------------------------------------------------
F. ADD COMPLETED LETTERS OVERVIEW
--------------------------------------------------

Provide a clear completed letters summary.

Requirements:
- make it easy to celebrate progress
- visually distinguish completed letters
- integrate naturally with the progress map or mastery page
- optionally show a simple count such as “8 letters completed” if the data already exists cleanly

--------------------------------------------------
G. OPTIONAL LIGHT POLISH IF SAFE
--------------------------------------------------

If low-risk and natural, add:
- small mastery badges
- section labels like Continue / Review / Completed
- gentle streak or practice-today cue if already supported safely

Do not let this become noisy or overly game-like.

--------------------------------------------------
H. IA / PAGE PLACEMENT
--------------------------------------------------

Place the mastery experience where it best fits the existing Kids Arabic flow.

Possible safe outcomes:
- a dedicated Kids Arabic progress/mastery page
- a section inside the Kids Arabic landing page
- a lightweight overview card plus detail page

Requirements:
- keep routing clear
- do not duplicate too many surfaces
- ensure the child always has a clear next action

--------------------------------------------------
I. DATA SAFETY
--------------------------------------------------

Preserve:
- tracing progress
- XP/reward integrity
- lesson completion history
- supported vector/fallback flow
- existing routing and lesson order

Requirements:
- no destructive migrations
- no reset of progress
- no breaking of current Kids Arabic lessons

--------------------------------------------------
J. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- progress map renders letters with the correct state
- next recommended letter logic works
- review flow surfaces the correct candidates
- tapping a mapped letter opens/resumes the correct lesson
- completed letters overview is accurate
- no regressions to current progress/tracing flow

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - current progress model
   - chosen mastery-state approach
   - chosen placement for the mastery experience

3. Progress map summary
   - how letters are displayed
   - how states are shown

4. Next-step and review summary
   - how next letter is chosen
   - how review candidates are chosen

5. Completed overview summary
   - how completed letters/progress are surfaced

6. Data safety summary
   - confirmation that no progress/state was lost

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

- Kids Arabic has a visible progress/mastery experience
- letters clearly show not-started / in-progress / completed states
- a clear next recommended letter exists
- a simple review flow exists
- completed progress is visible and motivating
- no regressions are introduced
- the Kids Arabic feature now feels like a real guided mastery journey

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild the tracing engine
- add strict grading
- add handwriting recognition
- build a complex adaptive-learning system
- reset user progress
- clutter the kids experience with too many stats

Stay focused on mastery visibility, next-step guidance, review flow, and progress clarity.

--------------------------------------------------

“And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

===== END PHASE 23 PROMPT =====
