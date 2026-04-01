===== PHASE 5 PROMPT — DEEP UX POLISH & PROGRESSION CLARITY =====

PRIMARY OBJECTIVE === ENHANCE THE LEARNING EXPERIENCE TO FEEL CALM, GUIDED, AND REWARDING BY IMPROVING PROGRESSION CLARITY, MICRO-INTERACTIONS, VISUAL FEEDBACK, AND FLOW WITHOUT CHANGING CORE ARCHITECTURE OR BREAKING ROUTES

You are working in the existing Flutter codebase for “Path of Nūr”.

This pass happens after:
- IA audit
- visible island consolidation
- naming/copy cleanup
- Guided Learning Paths V1
- route/alias canonicalization

This is a UX + experience quality pass.

Core rule:
Do not go haywire and remove/delete records, routes, pages, content, or systems for no reason.
Do not re-architect Learn again.
Do not undo earlier phases.

This phase is about making the system FEEL right.

==================================================
PRODUCT GOAL
==================================================

The Learn experience should feel:
- calm
- guided
- lightweight
- rewarding
- clear on “what to do next”

Users should:
- always see their next step
- feel progress
- not feel lost
- not feel overwhelmed

==================================================
UX PRINCIPLES
==================================================

- Reduce friction
- Highlight the next action
- Show progress visually
- Reward completion subtly
- Keep the UI clean and quiet
- Avoid clutter and heavy UI elements
- Avoid “dashboard overload”

==================================================
SCOPE FOR THIS PASS
==================================================

A. Improve progression clarity
B. Improve path experience UX
C. Improve micro-interactions
D. Improve completion states
E. Improve Explore usability
F. Improve Kids discoverability cues
G. Improve empty/loading states
H. Improve visual hierarchy and spacing
I. Keep everything production-ready and consistent

==================================================
IMPLEMENTATION TASKS
==================================================

A. PROGRESSION CLARITY (MOST IMPORTANT)

Ensure the user ALWAYS sees a clear next step.

Enhance:
1. “Continue Your Journey”
   - must clearly show:
     - current path name
     - current step title
     - simple progress indicator (e.g., 3/7 steps)
   - must feel like the primary action

2. Path overview page
   - highlight the current step strongly
   - dim completed steps
   - clearly label next step

3. Add a lightweight progress bar or indicator for:
   - path progress
   - step completion

Important:
- do not overbuild complex progress UI
- keep it simple and readable

==================================================
B. PATH EXPERIENCE UX

Improve the flow inside a path:

- clear “Start Path” → “Continue” → “Next Step” flow
- ensure after completing a step:
  - user is guided to next step
  - no dead ends
- allow easy return to path overview

Optional small enhancements:
- “You’re on step X of Y”
- small contextual hint for what comes next

==================================================
C. MICRO-INTERACTIONS

Add subtle feedback, not heavy animations.

Examples:
- slight scale/opacity change on tap
- gentle transition between steps
- smooth scroll to next step
- subtle highlight when step becomes active

Avoid:
- flashy animations
- anything distracting

==================================================
D. COMPLETION STATES

Improve how completion feels:

1. Step completion
   - quick positive feedback
   - small visual confirmation (checkmark, glow, etc.)
   - optional small message

2. Path completion
   - clear “completed” state
   - calm but meaningful visual feedback
   - optional XP / Ocean drop trigger (reuse existing hooks)

Important:
- keep it spiritual, not gamified noise
- avoid arcade-style feedback

==================================================
E. EXPLORE PAGE IMPROVEMENT

The Explore page should feel organized, not like a dump.

Improve:
- grouping (Tools, Notes, FAQ, etc.)
- spacing and section headers
- readability
- visual hierarchy

Avoid:
- long flat lists
- inconsistent grouping

==================================================
F. KIDS DISCOVERABILITY CUES

Ensure Kids is:
- visible
- inviting
- easy to access

Possible improvements:
- small featured card
- friendly subtitle
- visual distinction (but still within theme)

Do not:
- bury kids
- over-promote kids for all users

==================================================
G. EMPTY / LOADING / ERROR STATES

Audit and improve:

- empty states (no progress yet)
- loading states
- error states

Requirements:
- calm tone
- helpful guidance
- no technical language
- consistent styling

==================================================
H. VISUAL HIERARCHY & SPACING

Audit:
- spacing between sections
- card density
- typography hierarchy
- contrast

Improve:
- breathing space
- readability
- consistent card sizing
- alignment with Path of Nūr theme

==================================================
I. KEEP ARCHITECTURE SAFE

Do NOT:
- change route ownership
- break canonical `/quran/*`
- remove legacy routes
- refactor Learn IA again
- duplicate content
- change domain models heavily

This is polish, not restructuring.

==================================================
J. LOCALIZATION

Ensure:
- all new user-facing text is localized
- no hardcoded strings
- reuse keys where possible
- add only necessary keys

Report:
- new keys
- reused keys
- updated locale files

==================================================
K. PERFORMANCE

Ensure:
- no heavy rebuild loops
- smooth scrolling
- no unnecessary re-renders
- animations remain lightweight

==================================================
DOCUMENTATION
==================================================

Create:
docs/learning_ux_polish_2026-03-31.md

Include:
- summary of UX improvements
- progression clarity changes
- path UX improvements
- completion state behavior
- Explore improvements
- Kids discoverability changes
- visual hierarchy adjustments
- localization impact
- performance notes
- follow-up ideas

==================================================
VALIDATION
==================================================

Before finishing, confirm:

1. Continue Your Journey clearly shows next step.
2. Path progress is visible and understandable.
3. Step completion feels responsive and positive.
4. Path completion is clear and meaningful.
5. No dead ends in path flow.
6. Explore page is more organized and readable.
7. Kids remains visible and accessible.
8. UI feels calmer and less cluttered.
9. No route breakage.
10. `/quran/*` remains untouched as canonical.
11. localization remains intact.
12. performance is smooth.
13. analyzer passes or issues are clearly explained.

==================================================
DELIVERABLES
==================================================

1. Implement UX polish changes.
2. Create UX polish documentation file.
3. Return a concise summary including:
   - files changed
   - UX improvements made
   - progression clarity improvements
   - path UX improvements
   - completion state behavior
   - Explore improvements
   - Kids visibility changes
   - localization keys added/reused
   - performance impact
   - analyzer results
4. At the end, audit your own implementation and provide one full summary for the next phase.

===== END PHASE 5 PROMPT — DEEP UX POLISH & PROGRESSION CLARITY =====
