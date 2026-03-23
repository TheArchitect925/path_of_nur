===== PHASE 25H PROMPT — PUBLIC-BETA POLISH PASS =====

PRIMARY OBJECTIVE === BUILDING A PUBLIC-BETA POLISH PASS FOR PATH OF NŪR WITHOUT DESTABILIZING THE APP

You are working in the existing Path of Nūr codebase.

This is a CONTROLLED POLISH phase.
This is NOT a broad rebuild.
This is NOT a feature expansion phase.
This is NOT a hidden architecture rewrite.

Previous phases already improved:
- route integrity
- regression trust
- live localization
- Qur’an ownership clarity
- writing-system cohesion
- Learn / Journey alias cleanup

This phase must now make the app feel more truthful, polished, and beta-ready.

========================================================
CORE GOAL
========================================================

Improve the trustworthiness and presentation quality of the live app by tightening:
- copy truthfulness
- empty states
- user-facing labels
- small UX inconsistencies
- compatibility-era surfaces still exposed to users

========================================================
CURRENT PROBLEM TO SOLVE
========================================================

The app may still contain:
- labels that overstate what a surface does
- empty states that feel unfinished or vague
- placeholder-era or compatibility-era wording
- copy mismatches between cards and destinations
- minor surface inconsistency that makes the app feel less production-ready

This phase is about polish, not rebuilding features.

========================================================
STRICT DO-NOT-DO RULES
========================================================

Do NOT:
- delete routes, pages, or user data for no reason
- reopen major architecture decisions
- redesign Learn IA
- redesign Journey IA
- redo Qur’an ownership work
- reopen writing-system architecture
- broaden scope into new features
- go haywire and remove/delete records or functionality for no reason

========================================================
PHASE SCOPE
========================================================

This phase should focus on:

1. user-facing labels on live surfaces
2. empty states and zero-state copy
3. compatibility-era pages still visible in discovery
4. small polish issues in strong existing screens
5. copy consistency between entry points and destinations
6. visible “coming soon” / roadmap / weak placeholder language still exposed to users

========================================================
MANDATORY AUDIT-FIRST TASKS
========================================================

Before editing, verify and document:

1. which live pages still contain misleading, placeholder-like, or over-promising copy
2. which empty states feel unfinished or unhelpful
3. which surfaced labels no longer match their destination/function
4. which compatibility-era pages are still visible to users and should be softened, hidden, reframed, or demoted
5. which strong surfaces only need polish rather than structural change

Do not guess.

========================================================
IMPLEMENTATION RULES
========================================================

1. Preserve working user flows.
2. Improve truthfulness before beauty.
3. Prefer small high-value polish over broad visual churn.
4. Keep labels aligned with real destinations and capabilities.
5. Improve empty states so they feel intentional, helpful, and product-ready.
6. Do not claim unfinished breadth through optimistic copy.
7. Keep blast radius small and safe.

========================================================
PREFERRED CLEANUP DIRECTION
========================================================

Target outcomes should lean toward:

- cards and labels accurately describe where they go
- empty states feel intentional and helpful
- compatibility-era pages no longer feel like primary product surfaces
- strong screens feel cleaner without being rebuilt
- user-facing copy sounds production-minded rather than placeholder-minded

Safe improvements may include:
- relabeling weak or misleading actions
- refining subtitles/descriptions
- improving empty-state guidance
- softening compatibility-era copy
- hiding or demoting low-value surfaced compatibility pages if already safe

Only implement what is grounded in the current product.

========================================================
COMPATIBILITY RULES
========================================================

- preserve compatibility routes unless clearly safe to hide from discovery
- do not break existing callers
- if a compatibility surface remains live, avoid presenting it like a primary polished destination
- prefer demotion/reframing over deletion

========================================================
TESTING REQUIREMENTS
========================================================

Run:
- flutter analyze
- relevant widget/tests touched by this phase
- any route/discovery tests affected by label or surface changes

Do not weaken tests just to pass.

========================================================
OUTPUT FORMAT
========================================================

Return exactly:

1. Audit Findings Before Changes
2. Current Public-Beta Polish Gaps
3. Files Changed
4. What Was Implemented
5. Copy Truthfulness Results
6. Empty-State / Zero-State Results
7. Compatibility-Surface Polish Results
8. What Was Explicitly Not Changed
9. Remaining Public-Beta Gaps
10. Tests Added / Updated / Run
11. Final Audit Summary

========================================================
FINAL AUDIT SUMMARY FORMAT
========================================================

At the end provide:

- analyzer_passing: yes/no
- copy_truthfulness_improved: yes/no/partial
- empty_states_improved: yes/no/partial
- misleading_labels_reduced: yes/no/partial
- compatibility_surfaces_less_prominent: yes/no/partial
- unrelated_scope_expanded: yes/no
- biggest_public_beta_gap_remaining: <text>

========================================================
FINAL RULE
========================================================

This phase is a public-beta polish pass only.

Do not broaden scope.
Do not restructure unrelated feature families.
Do not remove/delete records, routes, or features for no reason.

===== END =====
