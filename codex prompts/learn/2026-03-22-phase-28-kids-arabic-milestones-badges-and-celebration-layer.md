===== PHASE 28 PROMPT — KIDS ARABIC MILESTONES, BADGES, AND CELEBRATION LAYER =====

PRIMARY OBJECTIVE === BUILDING A KIDS ARABIC MILESTONE AND REWARDS LAYER WITH LETTER/WORD MILESTONES, BADGES, CELEBRATION MOMENTS, AND PARENT-FRIENDLY PROGRESS VISIBILITY

You are working in the existing Flutter codebase for Path of Nūr.

This phase builds on top of the existing Kids Arabic tracing, reading, review, progression, and audio systems. DO NOT rebuild those systems. DO NOT introduce pressure-heavy gamification. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve tracing, reading, review, audio, XP, and progress systems
- Keep the experience calm, child-friendly, and encouraging
- Do not introduce competitive systems like leaderboards
- Do not create reward inflation or duplicate milestone grants
- Reuse existing XP/reward/progress hooks where practical
- Keep parent-facing visibility simple and helpful
- No destructive migrations
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Add Kids Arabic milestones
2. Add simple badges or achievement markers
3. Add calm celebration moments for milestone completion
4. Surface progress in a parent-friendly, readable way
5. Make the learning journey feel rewarding without pressure

--------------------------------------------------
A. AUDIT CURRENT KIDS ARABIC PROGRESS AND REWARD STATE
--------------------------------------------------

Inspect:
- kids_arabic_progress_provider.dart
- tracing completion state
- reading/review completion state
- mastery/progress map
- any existing XP/reward hooks already used by Kids Arabic
- any current celebration UI states
- any current completed letters/words counters

Audit these questions:
- What events are already tracked reliably?
- What counts as a safe milestone signal today?
- Is there already enough data to detect:
  - first letter completed
  - first 3 letters
  - first 5 letters
  - first word
  - 5 words completed
  - alphabet section completion
- Where should badge/milestone UI live in the current Kids Arabic IA?
- What should remain a light celebration versus a durable achievement record?

--------------------------------------------------
B. DEFINE A SIMPLE MILESTONE SYSTEM
--------------------------------------------------

Create a simple milestone structure using existing safe progress data.

Possible milestone examples:
- First Letter Completed
- 3 Letters Completed
- 5 Letters Completed
- 10 Letters Completed
- First Word Completed
- 3 Words Completed
- 5 Words Completed
- Completed Today
- Finished a Review Session
- Finished a Beginner Set

You may refine the milestone list based on the real data available, but the system must be:
- simple
- motivating
- durable
- easy to understand
- safe to compute from existing progress

Do not overbuild a giant achievement system in this phase.

--------------------------------------------------
C. ADD BADGES / ACHIEVEMENT MARKERS
--------------------------------------------------

Add a lightweight badge or achievement marker system.

Requirements:
- badges should be visually friendly and calm
- they should feel like encouragement, not competition
- badges should be tied to real milestone completion
- keep the system small and high quality
- badges may be icons, chips, stamps, or card-style achievements depending on what best fits the app

Do not clutter the Kids Arabic screens with too many tiny badges everywhere.

--------------------------------------------------
D. ADD CELEBRATION MOMENTS
--------------------------------------------------

When a milestone is reached, add a calm celebration moment.

Possible components:
- soft glow
- badge reveal
- milestone card
- short encouraging message
- small XP pulse if already safe and aligned with the reward model

Requirements:
- celebration should feel special but not loud
- no overly arcade-like effects
- no duplicate celebration for the same milestone
- should fit with the existing delight layer and kids tone

--------------------------------------------------
E. PARENT-FRIENDLY PROGRESS VISIBILITY
--------------------------------------------------

Surface a simple view of what the child has achieved.

Possible information:
- letters completed
- words completed
- latest milestone
- current recommended next step
- review status if already supported

Requirements:
- easy to understand at a glance
- not a dense analytics dashboard
- should help a parent know where the child is in the journey
- can live as a summary card, progress page section, or milestone area depending on the current IA

--------------------------------------------------
F. CONNECT MILESTONES TO EXISTING FLOW
--------------------------------------------------

Ensure milestones connect naturally to the existing Kids Arabic journey.

Requirements:
- milestones should reflect tracing/reading/review work already being done
- avoid creating disconnected “achievement only” UI
- a milestone should support the next step, not distract from it
- use existing progress/mastery systems rather than inventing a parallel truth

--------------------------------------------------
G. SAFE DUPLICATE-PROTECTION
--------------------------------------------------

Milestones and badges must only unlock once per intended achievement.

Requirements:
- no duplicate badge unlocks
- no repeated celebration spam for the same milestone
- no duplicate XP if milestones also surface reward feedback
- use a centralized safe milestone-check model where practical

If a milestone state model is needed, keep it minimal and backward-compatible.

--------------------------------------------------
H. OPTIONAL LIGHT POLISH IF SAFE
--------------------------------------------------

If low-risk and natural, add:
- badge gallery section
- milestone timeline card
- “latest achievement” chip
- gentle progress ring for letters/words completed

Do not let this turn into a heavy dashboard.

--------------------------------------------------
I. IA / PAGE PLACEMENT
--------------------------------------------------

Place milestones and badges where they best fit the current Kids Arabic experience.

Possible safe outcomes:
- a milestone section on the Kids Arabic landing page
- a badge summary on the mastery/progress page
- a dedicated but lightweight achievements page
- milestone cards integrated into the progress map

Requirements:
- routing should stay clear
- avoid duplicating too many surfaces
- keep the main child journey understandable

--------------------------------------------------
J. DATA SAFETY
--------------------------------------------------

Preserve:
- tracing progress
- reading/review progress
- XP/reward integrity
- existing lesson completion state
- mastery map state
- audio/lesson routing

Requirements:
- no destructive migrations
- no reset of progress
- no duplicate reward grants
- no breakage of current Kids Arabic features

--------------------------------------------------
K. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- milestone detection works correctly
- milestone unlocks only once
- badge state is stored/retrieved safely if introduced
- celebration triggers only on new milestone completion
- parent-friendly progress summary reflects real progress
- no regressions to tracing, reading, review, or XP flows

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - current progress/reward state
   - chosen milestone model
   - chosen badge/celebration placement

3. Milestone summary
   - milestone list implemented
   - unlock logic
   - any persistence introduced

4. Badge / celebration summary
   - how badges are shown
   - how celebration moments work
   - how duplicate unlocks were prevented

5. Parent-friendly progress summary
   - what is surfaced
   - where it appears
   - how it supports next-step clarity

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

- Kids Arabic has a real milestone system
- badges/achievement markers are visible and motivating
- milestone celebrations feel calm and rewarding
- parents can understand progress at a glance
- duplicate milestone/reward grants are prevented
- no regressions are introduced
- the Kids Arabic journey now feels rewarding and memorable

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild tracing, reading, review, or audio systems
- introduce leaderboards or competitive mechanics
- create noisy or pressure-heavy gamification
- build a heavy analytics dashboard
- reset user progress
- overcomplicate milestone logic beyond the current safe data model

Stay focused on milestones, badges, celebration, and parent-friendly visibility.

--------------------------------------------------

“And whoever does an atom’s weight of good will see it.” — Qur’an 99:7

===== END PHASE 28 PROMPT =====
