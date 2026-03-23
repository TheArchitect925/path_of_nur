# Phase 25C Prompt — Live Localization Completion + Bridge Reduction

PRIMARY OBJECTIVE === BUILDING LIVE LOCALIZATION COMPLETION FOR PATH OF NŪR AFTER REGRESSION HARDENING

You are working in the existing Path of Nūr codebase.

This is a CONTROLLED LOCALIZATION COMPLETION phase.
This is NOT a feature expansion phase.
This is NOT a broad architecture rewrite.
This is NOT a generic cleanup sweep.

The previous phase succeeded:
- analyzer is passing
- high-signal regression slice is passing
- runtime-localization shim reliance on live surfaces was reduced

This phase must finish the next safe chunk of localization payoff.

========================================================
CORE GOAL
========================================================

Substantially reduce or eliminate remaining runtime-localization bridge/shim dependence on live user-facing surfaces, while improving non-English readiness through proper ARB-backed localization coverage.

========================================================
STRICT DO-NOT-DO RULES
========================================================

Do NOT:
- delete routes, pages, records, or user data
- redesign Learn IA
- redesign Kids IA
- perform Qur’an ownership cleanup yet
- unify notes/reflections/journal yet
- remove compatibility aliases
- widen scope into unrelated polish
- rewrite strong screens from scratch
- go haywire and remove/delete records for no reason

========================================================
PHASE SCOPE
========================================================

Prioritize these surfaces in this order:

1. Qur’an live surfaces
2. Growth live surfaces
3. Games hub live surfaces
4. Wudu live surfaces
5. Kids Arabic live surfaces

For each target area:
- identify remaining runtime localization bridge/shim usage
- move safe live strings into generated ARB localization
- reduce helper/bridge usage where safe
- improve non-English locale coverage for newly added keys
- preserve current UX, route behavior, and semantics

Important:
- do not fake “full localization completion” if some bridges are still genuinely needed
- reduce the bridge footprint honestly and document the exact remainder

========================================================
MANDATORY AUDIT-FIRST TASKS
========================================================

Before editing, verify and document:

1. which bridge/shim-backed strings are still active on each targeted live surface
2. which newly added ARB keys from the last phase are still missing in non-English locale files
3. which generated AppLocalizations getters already exist and can be adopted immediately
4. which bridge/helper methods are still required after this pass
5. whether any tests need to be updated due to localization-backed copy changes

Do not guess.

========================================================
IMPLEMENTATION RULES
========================================================

1. Complete ARB-backed localization for live user-facing strings first.
2. Improve non-English locale coverage for the new keys introduced previously.
3. Prefer clean AppLocalizations usage over runtime extension lookups when safe.
4. If a helper/bridge remains necessary, narrow its scope instead of pretending it is gone.
5. Preserve product meaning, flow, and behavior.
6. Keep blast radius small.
7. Do not start unrelated copy rewrites.

========================================================
TESTING REQUIREMENTS
========================================================

Run:
- flutter analyze
- localization-affected widget/tests where relevant
- prior stabilized regression tests if touched
- any generated localization workflows required by this phase

Do not weaken tests just to pass.

========================================================
OUTPUT FORMAT
========================================================

Return exactly:

1. Audit Findings Before Changes
2. Remaining Localization Debt Before Phase
3. Files Changed
4. What Was Implemented
5. Surface-by-Surface Localization Completion Results
6. Non-English Coverage Results
7. What Was Explicitly Not Changed
8. Remaining Localization Debt After Phase
9. Tests Added / Updated / Run
10. Final Audit Summary

========================================================
FINAL AUDIT SUMMARY FORMAT
========================================================

At the end provide:

- analyzer_passing: yes/no
- quran_live_localization_completed: yes/no/partial
- growth_live_localization_completed: yes/no/partial
- games_live_localization_completed: yes/no/partial
- wudu_live_localization_completed: yes/no/partial
- kids_arabic_live_localization_completed: yes/no/partial
- runtime_bridge_usage_reduced_further: yes/no
- non_english_coverage_improved: yes/no/partial
- unrelated_scope_expanded: yes/no
- biggest_localization_debt_remaining: <text>
