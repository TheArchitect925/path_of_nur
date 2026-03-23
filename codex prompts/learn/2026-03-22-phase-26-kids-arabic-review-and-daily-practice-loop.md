===== PHASE 26 PROMPT — KIDS ARABIC REVIEW AND DAILY PRACTICE LOOP =====

PRIMARY OBJECTIVE === BUILDING A KIDS ARABIC REVIEW AND PRACTICE LOOP WITH CONTINUE, REVIEW, UNFINISHED ITEMS, AND DAILY PRACTICE FLOW

You are working in the existing Flutter codebase for Path of Nūr.

This phase builds on top of the existing Kids Arabic tracing, mastery, word, and reading systems. DO NOT rebuild the tracing engine or reading mode. DO NOT introduce strict testing or pressure-based scoring. This phase focuses on repetition, review, and habit-friendly guided practice.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve existing Kids Arabic progress, rewards, lesson routing, and reading/tracing systems
- Keep UX calm, child-friendly, and easy to resume
- Do not introduce strict grading
- Do not build a complex spaced-repetition engine in this phase
- Reuse existing progress and mastery data where possible
- No destructive migrations
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Add a Review and Practice loop for Kids Arabic
2. Surface unfinished letters and words clearly
3. Surface completed items that are good candidates for gentle review
4. Add a simple “Practice Today” / “Continue Learning” style entry point
5. Make the Kids Arabic experience feel repeatable and habit-friendly

--------------------------------------------------
A. AUDIT CURRENT KIDS ARABIC STATE
--------------------------------------------------

Inspect:
- Kids Arabic mastery/progress state
- tracing lesson completion state
- word completion state if present
- reading mode flow
- current landing/entry pages for Kids Arabic
- any existing “continue” or “resume” logic
- XP/reward hooks that may already exist

Audit these questions:
- How are letters currently marked started/completed?
- How are words currently marked started/completed?
- Is there already enough data to identify unfinished items safely?
- What is the safest review-candidate logic using current data?
- Where should the review/practice experience live in the current Kids Arabic IA?

--------------------------------------------------
B. ADD A REVIEW / PRACTICE ENTRY SURFACE
--------------------------------------------------

Create a clear entry point for review and daily practice.

Possible safe outcomes:
- a Review & Practice section on the Kids Arabic landing page
- a dedicated Kids Arabic review page
- a “Practice Today” card plus a fuller review page

Requirements:
- keep it visually clear and lightweight
- make it obvious what the child should do next
- avoid clutter and too many competing CTAs
- fit the existing Kids Arabic design language

--------------------------------------------------
C. SURFACE UNFINISHED ITEMS
--------------------------------------------------

Add a clear unfinished/resume flow.

This should surface:
- started but not completed letters
- started but not completed words
- any lesson recently opened but not finished, if supported safely

Requirements:
- resume should feel easy and obvious
- use positive language
- do not frame it as failure
- allow one-tap resume into the correct lesson or word activity

Examples:
- Continue Ba
- Finish tracing Meem
- Resume word practice

--------------------------------------------------
D. ADD GENTLE REVIEW FLOW
--------------------------------------------------

Create a simple review flow for items that are already completed but worth revisiting.

Possible candidates:
- completed letters
- completed words
- recently completed items for reinforcement
- items explicitly retried by the child, if such signals exist

Requirements:
- keep review logic simple and understandable
- do not build a strict spaced-repetition engine
- do not label items as “weak” in harsh language
- present review as positive practice and confidence-building

Examples:
- Review completed letters
- Practice words again
- Refresh your favorites

--------------------------------------------------
E. ADD A DAILY PRACTICE LOOP
--------------------------------------------------

Create a simple daily-practice concept.

Requirements:
- suggest a small manageable set for today
- mix Continue + Review if that makes sense
- keep it calm and short
- avoid turning the experience into pressure or grind

Possible structure:
- Continue one unfinished item
- Review one completed letter
- Practice one word

Use existing data safely rather than inventing complex scheduling logic.

--------------------------------------------------
F. CLEAR NEXT-STEP GUIDANCE
--------------------------------------------------

At any point, the child/parent should know the next action.

Requirements:
- surface one primary CTA where possible
- avoid too many simultaneous next actions
- clearly distinguish:
  - Continue
  - Review
  - Practice Today
- keep wording simple and child-friendly

--------------------------------------------------
G. OPTIONAL LIGHT POLISH IF SAFE
--------------------------------------------------

If low-risk and natural, add:
- simple progress summary such as completed letters/words count
- a gentle “practiced today” indicator
- small section headers like Continue / Review / Today

Do not let this become a stats-heavy dashboard.

--------------------------------------------------
H. IA / PAGE PLACEMENT
--------------------------------------------------

Place the review/practice flow where it best fits the existing Kids Arabic experience.

Requirements:
- routing should be clear
- do not duplicate too many surfaces
- keep the main child journey understandable
- review/practice should feel like a natural next layer after mastery and reading mode

--------------------------------------------------
I. DATA SAFETY
--------------------------------------------------

Preserve:
- tracing progress
- mastery/progress map state
- word and reading progress
- XP/reward integrity
- lesson routing and sequence

Requirements:
- no destructive migrations
- no reset of progress
- no breakage of current Kids Arabic features

--------------------------------------------------
J. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- unfinished items are surfaced correctly
- review candidates are surfaced correctly
- Practice Today / Continue flow chooses sensible items
- tapping a review/resume item opens the correct destination
- no regressions to current mastery, tracing, or reading flows

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - current progress/resume state
   - chosen review logic
   - chosen page/IA placement

3. Review / Practice summary
   - how unfinished items are surfaced
   - how review items are surfaced
   - how daily practice is constructed

4. UX summary
   - main CTAs
   - next-step guidance
   - any light polish added

5. Data safety summary
   - confirmation that no progress/state was lost

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

- Kids Arabic has a clear review/practice loop
- unfinished items can be resumed easily
- completed items can be reviewed gently
- a simple daily practice flow exists
- next-step guidance is clear
- no regressions are introduced
- Kids Arabic now feels like a repeatable learning habit, not just a one-time activity set

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild tracing or reading mode
- add strict grading or timed drills
- build a complex spaced-repetition engine
- add pressure-heavy gamification
- reset user progress
- clutter the kids experience with too many stats or controls

Stay focused on review, daily practice, unfinished-item resume, and calm repetition.

--------------------------------------------------

“And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

===== END PHASE 26 PROMPT =====
