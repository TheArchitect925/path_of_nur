===== PHASE 20 PROMPT — WUDU TRAINER PRODUCTION-READINESS HARDENING =====

PRIMARY OBJECTIVE === BUILDING A PRODUCTION-READY WUDU TRAINER WITH STABLE STATE, SAFE COMPLETION, REVIEW/RESTART FLOW, AND REWARD DEDUPLICATION

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-readiness hardening phase built on top of the existing Wudu Trainer, Learning Hub, and Ibadah & Practice systems. DO NOT rebuild the trainer from scratch. DO NOT remove existing learning routes, progress, notes, XP, drops, or reward systems. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve the current Wudu Trainer flow, Learning Hub routing, Ibadah & Practice island structure, and existing progress/reward systems
- Do not delete user progress
- Do not create duplicate XP or Ocean Drop rewards
- Do not redesign the whole trainer unnecessarily
- Keep the trainer calm, readable, and production-safe
- Harden the architecture so the trainer behaves like a real shipped feature
- Keep the structure quiz-ready for later without building full quiz mode now
- No unnecessary package churn
- At the end, provide a concise audit summary

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Make Wudu Trainer state and progress persistence production-safe

2. Add reliable resume behavior from the last meaningful step

3. Add an intentional restart flow

4. Add real completion tracking and a polished completion state

5. Add review-after-completion flow

6. Make reward logic safe and non-duplicative

7. Improve edge-case handling, route behavior, and regression protection

--------------------------------------------------
A. AUDIT (MANDATORY FIRST STEP)
--------------------------------------------------

Audit the current Wudu Trainer implementation before editing.

Inspect:
- current Wudu Trainer page/flow
- current step data model
- current progress storage if any
- current completion state if any
- current reward logic if any
- current Learning Hub -> Ibadah & Practice -> Wudu Trainer route behavior
- current reopen behavior after partial progress
- current reopen behavior after completion
- current page shell/scaffolding
- current test coverage for trainer behavior

Audit these questions:
- Is current step state persisted or page-local only?
- What happens if the app closes mid-trainer?
- What happens when the trainer is completed and reopened?
- Is reward logic already present, and where does it live?
- What is the safest persistence model to use?
- What edge cases currently exist?
- What needs to change to make the trainer feel truly production-ready?

--------------------------------------------------
B. STABILIZE THE TRAINER STATE MODEL
--------------------------------------------------

Ensure the Wudu Trainer uses a stable structured state model rather than fragile widget-local behavior.

The trainer should safely track at least:
- current step index
- completion status
- whether rewards were already granted
- optional last-viewed timestamp if useful
- whether review mode is active if needed

Requirements:
- keep the model simple
- persist safely using existing app patterns
- avoid giant monolithic widget state
- prepare the content/state model for future quiz reuse without overbuilding

--------------------------------------------------
C. RESUME BEHAVIOR
--------------------------------------------------

Implement reliable resume behavior.

Requirements:
- if the user leaves the trainer mid-progress, reopening should continue from the last meaningful step
- the resume point must be persisted safely
- reopening from the Wudu Trainer island should be state-aware
- partial progress must not feel lost
- resume behavior should not be confusing after completion

If the trainer is already completed:
- reopening should either show a completion/review entry state or a sensible default landing state
- do not dump the user into a broken mid-flow state after completion

--------------------------------------------------
D. RESTART FLOW
--------------------------------------------------

Add a clear intentional restart flow.

Requirements:
- user can explicitly restart the trainer from Step 1
- restart should not silently happen on reopen
- restart should reset step progress safely
- restart must not grant duplicate completion rewards unless explicitly supported by the existing reward policy
- restart should remain available after completion

Use a calm and clear UX pattern.

--------------------------------------------------
E. REAL COMPLETION TRACKING
--------------------------------------------------

Add proper completion tracking.

Requirements:
- when the user reaches the final step and completes the trainer, completion is persisted
- completion survives app restarts
- completion should be distinguishable from partial progress
- completion behavior should be safe even if the user reaches the end multiple times

Completion should feel meaningful but calm.

--------------------------------------------------
F. POLISHED COMPLETION STATE
--------------------------------------------------

Create a real post-completion state/screen/section.

This should include:
- confirmation that Wudu Trainer is completed
- gentle encouragement
- clear next actions such as:
  - Review Steps
  - Start Again
  - Return to Ibadah & Practice

Requirements:
- keep it visually aligned with Path of Nūr
- do not make it noisy or game-heavy
- completion should feel intentional and polished

--------------------------------------------------
G. REVIEW-ALL-STEPS MODE
--------------------------------------------------

After completion, allow users to review the full Wudu sequence without confusion.

Requirements:
- review mode should make it easy to revisit steps
- review mode should not re-trigger completion rewards
- review mode should feel distinct from first-time progression
- reviewing should still be useful for learning

This may be:
- a review action from the completion screen
- a state-aware reopen path
- a step overview if that fits cleanly

--------------------------------------------------
H. SAFE XP / OCEAN DROP LOGIC
--------------------------------------------------

Make reward logic explicit, centralized, and safe.

Requirements:
- award XP for meaningful Wudu Trainer completion
- add an Ocean Drop if that matches the app’s meaningful-learning rule
- do not duplicate rewards when:
  - reopening completed trainer
  - reviewing steps
  - restarting and finishing again unless explicitly supported
- centralize reward logic outside ad hoc widget handling
- preserve existing reward systems

Prefer:
- one-time first-completion reward
unless the existing product architecture clearly supports something else safely

--------------------------------------------------
I. STATE-AWARE ENTRY FROM IBADAH & PRACTICE
--------------------------------------------------

Ensure the Wudu Trainer island behaves correctly depending on user state.

Possible expected behavior:
- not started -> open trainer at Step 1
- in progress -> resume at current step
- completed -> open completion/review entry state or sensible post-completion landing

Requirements:
- keep one clean canonical route
- do not create confusing duplicate entry flows
- preserve back navigation and route consistency

--------------------------------------------------
J. EDGE-CASE HARDENING
--------------------------------------------------

Handle the following safely:
- user exits mid-step
- app closes during progress
- user reopens after completion
- user restarts after completion
- user taps back/forth repeatedly
- reward logic races or double-fires
- stored progress exists but content order changes
- missing/invalid persisted state

Requirements:
- no crashes
- no broken route states
- no duplicated reward events
- graceful fallbacks

--------------------------------------------------
K. QUIZ-READY STRUCTURE (NO FULL QUIZ YET)
--------------------------------------------------

Prepare the trainer for future quiz mode.

Requirements:
- keep Wudu step content structured and reusable
- avoid hardcoding content into presentation widgets where a simple data layer is cleaner
- ensure future quiz generation could reuse:
  - step order
  - titles
  - descriptions
  - optional educational metadata
- do not build the actual quiz engine now

--------------------------------------------------
L. PAGE POLISH / UX SWEEP
--------------------------------------------------

Do a targeted polish sweep on the Wudu Trainer.

Check and improve:
- progress indicator clarity
- step numbering clarity
- next/back button wording
- final-step transition
- spacing consistency
- completion/review/restart affordances
- smaller-screen resilience

Do not redesign the whole page. Just make it feel shipped.

--------------------------------------------------
M. DATA SAFETY
--------------------------------------------------

Preserve:
- Learning Hub routing
- Ibadah & Practice structure
- existing progress
- XP and drop systems
- existing notes/bookmarks
- existing page scaffolding and localization patterns

Requirements:
- no destructive migrations
- no progress loss
- no route breakage
- no duplicated reward history
- backwards compatibility for any new trainer progress fields

--------------------------------------------------
N. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- trainer opens from Ibadah & Practice correctly
- partial progress is saved and resumed
- restart resets trainer safely
- completion is persisted
- completion state renders correctly
- review mode works after completion
- XP reward is granted once only
- Ocean Drop is granted once only if applied
- reopening/review/restart do not duplicate rewards
- invalid persisted state falls back safely

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - current trainer state/progress behavior
   - current reward behavior
   - key production gaps found

3. State/progress summary
   - how progress is stored
   - how resume works
   - how restart works

4. Completion summary
   - how completion is tracked
   - what completion UI/state was added
   - how review mode works

5. Rewards summary
   - XP policy
   - Ocean Drop policy if applied
   - how duplicate rewards were prevented

6. Quiz-readiness summary
   - what structural improvements support future quiz mode

7. Data safety summary
   - confirmation that no user progress/data/routes were broken

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

- Wudu Trainer resumes safely
- Wudu Trainer can be restarted intentionally
- completion is persisted correctly
- completion state feels polished and real
- review mode exists after completion
- XP / Ocean Drop rewards are safe and non-duplicative
- entry from Ibadah & Practice is state-aware
- architecture is cleaner and quiz-ready
- no user progress/data/routes are broken

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild the trainer from scratch
- build the full quiz system yet
- redesign all of Learning Hub or Ibadah & Practice
- scatter reward logic across page widgets
- add risky multi-route behavior
- break existing trainer access or progress

Stay focused on making the Wudu Trainer truly production-ready.

--------------------------------------------------

“Indeed, Allah loves those who purify themselves.” — Qur’an 2:222

===== END PHASE 20 PROMPT =====
