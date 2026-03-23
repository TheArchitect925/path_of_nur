===== PHASE 18 PROMPT — WUDU TRAINER PAGE, LEARNING HUB ISLAND, AND IBADAH & PRACTICE ROUTING =====

PRIMARY OBJECTIVE === BUILDING A REAL WUDU TRAINER EXPERIENCE AND SURFACING IT UNDER LEARNING HUB → IBADAH & PRACTICE

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready enhancement phase built on top of the existing Learning Hub, Ibadah & Practice, and learning-content systems. DO NOT rebuild the Learning Hub. DO NOT remove existing worship-learning content, routes, notes, progress, XP, drops, or page structure. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve existing Learning Hub routing, Ibadah & Practice structure, learning progress, notes, bookmarks, XP, drops, and page scaffolding
- Do not delete or replace existing worship-learning content unless a tiny routing correction is needed
- Reuse existing shared island/page components where possible
- Build the Wudu Trainer as a real production-safe feature, not a placeholder shell
- Keep the UX calm, guided, and clear
- Do not overbuild advanced quiz/audio/animation systems in this phase
- No unnecessary package churn
- At the end, provide a concise audit summary

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Build a real Wudu Trainer page/flow using the created Wudu step assets and structured content

2. Create and surface a Wudu Trainer island under the existing Learning Hub → Ibadah & Practice page

3. Ensure the Wudu Trainer route is correctly linked and production-safe

4. Add lightweight progress/completion handling so the trainer feels like a real learning experience

5. Safely hook the trainer into existing XP / reward / learning-completion systems where appropriate

--------------------------------------------------
A. AUDIT (MANDATORY FIRST STEP)
--------------------------------------------------

Audit the current implementation before editing.

Inspect:
- Learning Hub structure
- Ibadah & Practice page and its current islands/cards
- current worship-learning routes and destination pages
- any existing Wudu-related pages, lessons, cards, or seeded content
- shared island/card components
- shared page shell/scaffolding components
- existing learning progress/completion models
- existing XP / drops reward integration for learning actions
- any existing image asset structure for learning modules
- current routing patterns used by Ibadah & Practice destinations

Audit these questions:
- Does a Wudu page already exist in any form?
- Where exactly should the Wudu Trainer island be placed inside Ibadah & Practice?
- What shared page shell should the trainer use?
- What is the safest completion/progress pattern already used elsewhere in Learn?
- How should XP and drops be awarded without duplication?
- Are the Wudu assets already in the codebase, and how should they be referenced?
- Is there already a canonical worship-learning detail page pattern that should be reused?

--------------------------------------------------
B. CREATE THE WUDU TRAINER EXPERIENCE
--------------------------------------------------

Build a real Wudu Trainer page or flow.

The trainer should use the Wudu steps already created and present them as a guided sequence.

At minimum, the trainer should include the following steps in order:
1. Begin with a Sincere Intention (Niyyah)
2. Prepare Clean Water
3. Recite Bismillah
4. Wash Your Hands
5. Rinse Your Mouth
6. Sniff Water into Your Nostrils
7. Blow Your Nose
8. Wash Your Face
9. Wash Your Arms
10. Wipe Your Head
11. Wash Your Feet
12. Recite the Shahada
13. Dua (Supplication)
14. Clean Up After Yourself

Requirements:
- each step should have:
  - image
  - title
  - supporting subtitle/explanation
- keep the layout calm and readable
- support step-by-step progression
- support reviewing prior/next steps
- avoid visual clutter
- keep content production-safe and consistent with the app’s tone

--------------------------------------------------
C. USE THE EXISTING WUDU ASSETS CLEANLY
--------------------------------------------------

Use the Wudu images already created as the visual basis for the trainer.

Requirements:
- wire the existing assets safely
- use a clean asset naming/reference pattern
- do not duplicate assets unnecessarily
- support the current text-in-image card versions for now if that is what exists
- if both clean and text-card versions exist, choose the most appropriate version for the trainer and explain the decision in the final summary

Keep the architecture ready for future clean/no-text asset replacement if needed.

--------------------------------------------------
D. STEP CONTENT MODEL
--------------------------------------------------

Create or refine a structured content model for the Wudu Trainer.

This may include fields such as:
- id
- step number
- title
- subtitle
- image asset path
- optional transliteration
- optional extra teaching note
- completion state if needed

Requirements:
- keep the model simple and production-ready
- avoid hardcoding the entire sequence directly inside a giant widget if a small reusable data layer is cleaner
- make it easy to update or extend later

--------------------------------------------------
E. TRAINER NAVIGATION AND UX
--------------------------------------------------

The Wudu Trainer should feel like a guided learning experience.

Include:
- current step indicator
- previous / next controls
- clear primary action to continue
- ability to revisit previous steps
- final completion state/screen

Requirements:
- keep interaction simple and child-friendly but still appropriate for all users
- do not create a heavy wizard framework if a lighter page flow works
- support smaller screens
- preserve good spacing and readability

Optional if it fits cleanly:
- “Start from beginning”
- “Continue where you left off”

Do not overbuild beyond this phase.

--------------------------------------------------
F. COMPLETION / PROGRESS HANDLING
--------------------------------------------------

Add lightweight completion/progress behavior so the trainer feels real.

Possible production-safe scope:
- save current step or completion state
- mark trainer as completed once the user finishes
- allow restart/review after completion

Requirements:
- reuse existing learning progress systems where safe
- do not create duplicate progress records
- avoid risky migrations
- keep old systems intact
- if partial progress is stored, handle it gracefully

--------------------------------------------------
G. XP / DROPS / REWARD INTEGRATION
--------------------------------------------------

Integrate the Wudu Trainer into the app’s progression systems in a safe and centralized way.

Requirements:
- award XP on meaningful completion
- add an Ocean Drop if that fits the current project rule for meaningful learning actions
- do not double-award rewards on repeated opens/reviews unless the product already supports repeatable completions in a controlled way
- keep reward logic centralized, not scattered through UI widgets

If safest, award on:
- trainer completion
rather than every single step tap

Explain the final reward logic clearly in the audit summary.

--------------------------------------------------
H. SURFACE WUDU TRAINER UNDER IBADAH & PRACTICE
--------------------------------------------------

Create and add a Wudu Trainer island under the existing Ibadah & Practice page.

Requirements:
- match the existing island/card style
- place it in a sensible order among other worship-practice content
- do not clutter the page
- ensure it routes directly to the new Wudu Trainer experience
- preserve the structure of the existing Ibadah & Practice page

This should be the canonical surfaced entry point.

--------------------------------------------------
I. ROUTING FROM LEARNING HUB
--------------------------------------------------

Ensure the routing chain is correct and production-safe:

Learning Hub
-> Ibadah & Practice
-> Wudu Trainer island
-> Wudu Trainer page

Requirements:
- preserve back navigation
- use existing route conventions where possible
- do not create duplicate confusing entry paths
- if a direct route from another page already exists, preserve it safely
- no dead taps or placeholder routes

--------------------------------------------------
J. PAGE DESIGN / CONSISTENCY
--------------------------------------------------

The Wudu Trainer page must feel like part of Path of Nūr.

Requirements:
- reuse shared page shell/background treatment where appropriate
- keep typography and spacing consistent
- use the island/card language already established in Learn
- calm, clean design
- no disclosure arrows on island-style surfaces if that rule is already enforced app-wide

Do not turn this into a full design-system rewrite.

--------------------------------------------------
K. OPTIONAL LIGHTWEIGHT ENHANCEMENTS IF SAFE
--------------------------------------------------

If they fit cleanly and do not destabilize scope, you may add:
- completion badge or checkmark
- “review all steps” overview
- final encouragement card/message after completion

Only include these if they are safe, lightweight, and production-ready.

--------------------------------------------------
L. DATA SAFETY
--------------------------------------------------

Preserve:
- existing learning routes
- existing worship-learning content
- notes/bookmarks/progress
- XP and drops systems
- page scaffolding and navigation

Requirements:
- no destructive migrations
- no deletion of user data
- no breaking of current Ibadah & Practice destinations
- if new progress records are added, keep backwards compatibility safe

--------------------------------------------------
M. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- Wudu Trainer island appears on Ibadah & Practice page
- tapping the island opens the Wudu Trainer
- Wudu Trainer renders the step sequence correctly
- next/previous progression works
- completion handling works safely
- XP / drop reward logic does not duplicate incorrectly
- existing Ibadah & Practice routes still work

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - current Ibadah & Practice structure
   - existing Wudu-related content/routes found
   - chosen route/surfacing approach and why

3. Wudu Trainer summary
   - page structure
   - step model
   - navigation/progression behavior
   - completion behavior

4. Ibadah & Practice summary
   - where the Wudu Trainer island was added
   - final routing behavior

5. Rewards/progress summary
   - XP logic
   - Ocean Drop logic if applied
   - completion tracking approach

6. Asset integration summary
   - which Wudu assets were used
   - any naming or structural cleanup

7. Data safety summary
   - confirmation that no user data/progress/routes were broken

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

- a real Wudu Trainer experience exists
- Wudu Trainer is surfaced as an island under Learning Hub → Ibadah & Practice
- the trainer uses the Wudu steps and assets in a guided sequence
- navigation and completion feel real and production-safe
- XP/rewards integrate safely
- existing Learn/Ibadah functionality is preserved
- no routes or user data are broken
- the feature feels like a natural part of Path of Nūr

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild the entire Learning Hub
- redesign all of Ibadah & Practice
- create a huge quiz/audio engine in this phase
- duplicate the trainer into multiple separate systems
- add risky reward logic scattered across the UI
- break existing routes or progress

Stay focused on building the Wudu Trainer feature and surfacing it correctly under Ibadah & Practice.

--------------------------------------------------

“Indeed, Allah loves those who purify themselves.” — Qur’an 2:222

===== END PHASE 18 PROMPT =====
