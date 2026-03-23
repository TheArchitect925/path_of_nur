===== PHASE 19 PROMPT — WUDU TRAINER COMPLETION, RESUME, RESTART, AND QUIZ-READY ARCHITECTURE =====

PRIMARY OBJECTIVE === BUILDING A PRODUCTION-READY WUDU TRAINER WITH RESUME, RESTART, COMPLETION STATE, SAFE REWARDS, AND QUIZ-READY STRUCTURE

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready enhancement phase built on top of the existing Wudu Trainer, Learning Hub, and Ibadah & Practice systems. DO NOT rebuild the trainer from scratch. DO NOT remove existing learning routes, notes, progress, XP, drops, or reward systems. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve the existing Wudu Trainer flow, Learning Hub routing, Ibadah & Practice structure, progress models, XP, drops, and page scaffolding
- Do not delete user learning progress
- Do not introduce duplicate reward grants
- Keep the trainer calm, clear, and production-safe
- Build on top of the current Wudu Trainer page/flow rather than replacing it blindly
- Prepare the architecture for future quiz mode without actually building the full quiz in this phase
- No unnecessary package churn
- At the end, provide a concise audit summary

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Add resume behavior so users can continue the Wudu Trainer from where they left off

2. Add restart behavior so users can intentionally begin the trainer again from Step 1

3. Add real completion tracking and final completion state

4. Make XP / reward / Ocean Drop awarding safe and non-duplicative

5. Add a review-all-steps mode or equivalent lightweight re-entry path after completion

6. Leave the Wudu Trainer architecture ready for a future quiz/check-your-understanding phase

--------------------------------------------------
A. AUDIT (MANDATORY FIRST STEP)
--------------------------------------------------

Audit the current Wudu Trainer implementation before editing.

Inspect:
- current Wudu Trainer page flow
- current step model and step storage
- current navigation logic
- current completion behavior if any
- current reward integration if any
- current Learning progress / completion models
- any existing resume/restart patterns used elsewhere in Learn
- any existing final-completion page/pattern used in the app
- any existing “review again” or “continue where you left off” patterns

Audit these questions:
- Does the trainer currently save the current step?
- Is there any existing completion record for this trainer?
- What happens if the user exits midway?
- What happens if the user completes it and reopens it?
- Where is reward logic currently applied, if anywhere?
- What is the safest progress model to use?
- How can the trainer be made quiz-ready without overbuilding?

--------------------------------------------------
B. ADD RESUME BEHAVIOR
--------------------------------------------------

Implement safe resume behavior for the Wudu Trainer.

Requirements:
- if the user leaves the trainer mid-way, they can return and continue from the last meaningful step
- resume behavior should be clear and stable
- partial progress should not break the trainer flow
- if the trainer is already completed, reopen behavior should be intentional and understandable
- do not create fragile widget-only state; persist resume state through the existing app patterns where appropriate

Possible safe outcomes:
- reopen trainer at last incomplete/current step
- surface “Continue Wudu Trainer” state if the app already supports that pattern cleanly

Do not overcomplicate with multi-device sync logic unless already supported.

--------------------------------------------------
C. ADD RESTART TRAINER ACTION
--------------------------------------------------

Implement a clean “Start Again” / “Restart Trainer” action.

Requirements:
- user can intentionally restart from Step 1
- restart should not create duplicate historical records or duplicated rewards
- existing completion state should be handled safely
- restart should be a deliberate user action, not accidental

If the trainer is completed, the user should still be able to:
- review all steps
- restart intentionally

--------------------------------------------------
D. REAL COMPLETION STATE
--------------------------------------------------

Add a real completion state for the Wudu Trainer.

Requirements:
- when the user reaches the end and completes the trainer, the system should mark it as completed
- completion state should be persisted safely
- completion should survive app restart
- trainer reopen behavior after completion should be sensible

Also add a final completion screen or completion section that feels rewarding and calm.

Possible content on completion:
- gentle congratulatory message
- confirmation of completion
- clear next actions:
  - review steps
  - restart trainer
  - continue learning in Ibadah & Practice

Keep it production-safe and not overly gamey.

--------------------------------------------------
E. SAFE XP / REWARD / OCEAN DROP LOGIC
--------------------------------------------------

Make reward logic safe and explicit.

Requirements:
- award XP for meaningful trainer completion
- add an Ocean Drop if this fits the existing project-wide rule for meaningful learning completion
- do not duplicate rewards when:
  - reopening the trainer
  - reviewing steps after completion
  - restarting the trainer
- centralize reward logic in a safe place
- if repeat completions are intentionally not rewardable, enforce that clearly
- if repeat completions are partially rewardable, implement only if the existing architecture safely supports it

Explain the final reward policy clearly in the summary.

--------------------------------------------------
F. REVIEW-ALL-STEPS MODE
--------------------------------------------------

After the trainer is completed, the user should still be able to review the Wudu steps without confusion.

Requirements:
- support a “Review Steps” or equivalent mode/path
- make it obvious that the user is revisiting, not re-earning completion
- keep the review experience simple and useful
- do not block learning review behind completion logic

This can be:
- a dedicated action on the completion state
- a reopen behavior with review mode
- a step overview entry point if it fits the existing page cleanly

--------------------------------------------------
G. QUIZ-READY ARCHITECTURE
--------------------------------------------------

Do not build the full quiz in this phase, but prepare the Wudu Trainer for it.

Requirements:
- structure the trainer content/data so it can later support quiz prompts such as:
  - step ordering
  - what comes next
  - which action belongs in wudu
- avoid hardcoding everything into a monolithic page widget
- ensure the step model/content layer can be reused later by a quiz module
- keep this lightweight and forward-compatible

No actual full quiz flow is required in this phase unless a tiny hook is helpful and safe.

--------------------------------------------------
H. WUDU TRAINER PAGE POLISH
--------------------------------------------------

Refine the existing trainer UX so it feels more complete.

Check and improve where needed:
- progress indicator clarity
- step position display
- navigation button wording
- final-step handling
- spacing/consistency
- completion-state transitions
- resume/restart visibility

Requirements:
- do not redesign the whole page unnecessarily
- keep the UI calm and child-friendly but useful for all users
- maintain consistency with Path of Nūr page styles

--------------------------------------------------
I. ROUTING / ENTRY BEHAVIOR
--------------------------------------------------

Ensure the Wudu Trainer behaves correctly from its surfaced entry point under:
Learning Hub -> Ibadah & Practice -> Wudu Trainer

Requirements:
- if the user has partial progress, entry behavior should make sense
- if completed, entry behavior should make sense
- preserve back navigation
- do not create duplicate confusing routes for resume/review/restart unless required

Prefer one clean canonical route with state-aware behavior.

--------------------------------------------------
J. DATA SAFETY
--------------------------------------------------

Preserve:
- current Wudu Trainer structure
- Learning Hub routing
- Ibadah & Practice island structure
- user progress
- XP and drop systems
- page scaffolding and localization patterns

Requirements:
- no destructive migrations
- no user progress loss
- no duplicated reward history
- backwards compatibility for any newly introduced progress fields/state

--------------------------------------------------
K. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- trainer resume state is saved and restored correctly
- trainer restart resets step flow safely
- completion state is persisted
- reopening after completion behaves correctly
- XP / Ocean Drop reward logic does not duplicate
- review mode works after completion
- existing Wudu Trainer route still works from Ibadah & Practice

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - current Wudu Trainer state/progress behavior
   - reward constraints found
   - chosen resume/completion strategy and why

3. Resume/restart summary
   - how resume works
   - how restart works
   - entry behavior from Ibadah & Practice

4. Completion summary
   - how completion is tracked
   - what final completion state was added
   - how review-after-completion works

5. Rewards summary
   - XP policy
   - Ocean Drop policy if applied
   - how duplicate rewards were prevented

6. Quiz-readiness summary
   - what structural improvements were made to support future quiz mode

7. Data safety summary
   - confirmation that no user data/progress was lost

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

- Wudu Trainer resumes safely from last progress
- Wudu Trainer can be restarted intentionally
- completion is tracked properly
- final completion state feels real and polished
- review-after-completion is possible
- XP / Ocean Drop rewards are safe and non-duplicative
- architecture is cleaner and ready for future quiz mode
- existing routing and learning systems are preserved
- no user data/progress is broken

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild the Wudu Trainer from scratch
- build the entire quiz system yet
- redesign all of Ibadah & Practice
- introduce risky multi-path routing
- scatter reward logic across page widgets
- break existing trainer access or progress

Stay focused on Wudu Trainer completion, resume, restart, safe rewards, and quiz-ready structure.

--------------------------------------------------

“Indeed, Allah loves those who purify themselves.” — Qur’an 2:222

===== END PHASE 19 PROMPT =====
