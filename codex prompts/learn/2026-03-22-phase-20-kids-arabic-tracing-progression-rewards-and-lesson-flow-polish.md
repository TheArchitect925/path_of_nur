===== PHASE 20 PROMPT — KIDS ARABIC TRACING PROGRESSION, REWARDS, AND LESSON FLOW POLISH =====

PRIMARY OBJECTIVE === BUILDING A GUIDED KIDS ARABIC TRACING EXPERIENCE WITH PROGRESSION, REWARDS, AND SMOOTH LESSON FLOW ON TOP OF THE EXISTING VECTOR TRACING ENGINE

You are working in the existing Flutter codebase for Path of Nūr.

This phase builds on top of the existing tracing system. DO NOT rebuild the tracing engine. DO NOT change vector logic. This phase focuses on UX, progression, and rewards.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve tracing engine behavior
- Preserve existing progress/state
- Do not introduce strict scoring
- Do not break fallback system
- Keep UX simple and child-friendly
- Use existing XP/reward system safely
- No destructive changes

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Add guided progression between letters
2. Add completion feedback UI
3. Add XP/reward integration
4. Improve lesson flow (next/retry/continue)
5. Keep experience calm, clear, and motivating

--------------------------------------------------
A. AUDIT CURRENT FLOW
--------------------------------------------------

Inspect:
- tracing completion trigger
- lesson page structure
- progress provider
- XP/reward hooks
- navigation between letters

Identify:
- where completion is detected
- how next letter is determined
- how progress is stored

--------------------------------------------------
B. ADD COMPLETION UI STATE
--------------------------------------------------

When tracing completes:

Show:
- success visual (glow / highlight)
- short encouraging message

Ensure:
- no clutter
- no blocking interactions
- fits kids design system

--------------------------------------------------
C. ADD ACTION BUTTONS
--------------------------------------------------

After completion, show:

- Next Letter
- Try Again

Requirements:
- Next → moves to next letter
- Try Again → resets tracing
- buttons should be clear and touch-friendly

--------------------------------------------------
D. PROGRESSION FLOW
--------------------------------------------------

Implement simple progression:

- define letter order
- allow:
  - next letter navigation
  - optional previous letter
- do not lock letters aggressively in this phase

Ensure:
- no dead ends
- always clear next action

--------------------------------------------------
E. XP / REWARD INTEGRATION
--------------------------------------------------

On completion:
- trigger XP gain using existing system

Requirements:
- no duplicate XP on repeated completion
- no reward inflation
- reuse existing reward hooks

Optional:
- show small XP feedback

--------------------------------------------------
F. PROGRESS TRACKING
--------------------------------------------------

Ensure:
- completed letters are tracked
- progress is saved safely
- reopening app restores correct state

Do not:
- reset old progress
- introduce risky migrations

--------------------------------------------------
G. OPTIONAL LIGHT POLISH
--------------------------------------------------

If safe:

- subtle animation on completion
- slight glow effect
- simple “Great job!” style feedback

Do NOT:
- add loud effects
- clutter UI

--------------------------------------------------
H. LESSON FLOW IMPROVEMENT
--------------------------------------------------

Improve navigation:

- clear “next” action
- smooth transitions
- consistent layout

Ensure:
- no confusion about next step
- no broken navigation

--------------------------------------------------
I. DATA SAFETY
--------------------------------------------------

Preserve:
- all tracing progress
- XP system integrity
- lesson state
- routing

--------------------------------------------------
J. TESTING
--------------------------------------------------

Test:

- completion triggers correctly
- XP triggers once
- next letter navigation works
- retry resets correctly
- progress persists
- no regression in tracing behavior

Run analyzer/tests.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed
2. Flow audit findings
3. Completion UX summary
4. Progression implementation
5. XP integration summary
6. Data safety summary
7. Validation results
8. FINAL AUDIT

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- tracing now leads into clear next steps
- completion feels rewarding
- XP is applied safely
- lesson flow is intuitive
- no regressions introduced
- kids experience feels guided and engaging

--------------------------------------------------

“And whoever does an atom’s weight of good will see it.” — Qur’an 99:7

===== END PHASE 20 PROMPT =====
