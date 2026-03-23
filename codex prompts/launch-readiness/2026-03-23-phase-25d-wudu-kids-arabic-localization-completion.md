===== PHASE 25D PROMPT — WUDU + KIDS ARABIC LOCALIZATION COMPLETION =====

PRIMARY OBJECTIVE === BUILDING LOCALIZATION COMPLETION FOR WUDU AND KIDS ARABIC WITHOUT DESTABILIZING CURRENT BEHAVIOR

You are working in the existing Path of Nūr codebase.

This is a CONTROLLED LOCALIZATION phase.
This is NOT a feature expansion phase.
This is NOT a broad architecture rewrite.
This is NOT a generic cleanup sweep.

Previous phases completed live localization for:
- Qur’an
- Growth
- Games

This phase must finish the next safe localization target areas:
- Wudu
- Kids Arabic

========================================================
CORE GOAL
========================================================

Substantially reduce or eliminate the remaining runtime bridge/helper localization dependence on live Wudu and Kids Arabic surfaces, while improving real non-English locale coverage for the ARB keys introduced so far.

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

Target only these areas:

1. Wudu live surfaces
2. Kids Arabic live surfaces
3. newly added non-English ARB entries related to those surfaces

For each target area:
- identify remaining runtime bridge/helper usage
- move safe live strings into generated ARB localization
- keep only genuinely necessary formatting helpers
- improve non-English locale coverage for the relevant keys
- preserve current UX, behavior, and test stability

========================================================
MANDATORY AUDIT-FIRST TASKS
========================================================

Before editing, verify and document:

1. which Wudu strings still depend on `wudu_localizations.dart`
2. which Kids Arabic strings still depend on `kids_arabic_runtime_localizations.dart`
3. which helper methods are truly formatting/dynamic helpers vs simple string wrappers
4. which new or existing ARB keys are still missing meaningful non-English translations
5. which tests may need updating due to localization-backed copy changes

Do not guess.

========================================================
IMPLEMENTATION RULES
========================================================

1. Move simple live strings to ARB-backed localization first.
2. Keep only genuinely necessary helper/formatting bridge logic.
3. Do not pretend a helper is removable if it still provides real dynamic formatting value.
4. Improve non-English locale coverage honestly.
5. Preserve current user flow and meaning.
6. Keep blast radius small.
7. Do not start unrelated copy rewrites.

========================================================
TESTING REQUIREMENTS
========================================================

Run:
- flutter gen-l10n
- flutter analyze
- relevant Wudu tests
- relevant Kids Arabic tests
- any localization-sensitive tests affected by this phase

Do not weaken tests just to pass.

========================================================
OUTPUT FORMAT
========================================================

Return exactly:

1. Audit Findings Before Changes
2. Remaining Wudu/Kids Arabic Localization Debt Before Phase
3. Files Changed
4. What Was Implemented
5. Wudu Localization Results
6. Kids Arabic Localization Results
7. Non-English Coverage Results
8. What Was Explicitly Not Changed
9. Remaining Localization Debt After Phase
10. Tests Added / Updated / Run
11. Final Audit Summary

========================================================
FINAL AUDIT SUMMARY FORMAT
========================================================

At the end provide:

- analyzer_passing: yes/no
- wudu_live_localization_completed: yes/no/partial
- kids_arabic_live_localization_completed: yes/no/partial
- wudu_bridge_usage_reduced: yes/no/partial
- kids_arabic_bridge_usage_reduced: yes/no/partial
- non_english_coverage_improved: yes/no/partial
- unrelated_scope_expanded: yes/no
- biggest_localization_debt_remaining: <text>

========================================================
FINAL RULE
========================================================

This phase is a Wudu + Kids Arabic localization completion pass only.

Do not broaden scope.
Do not restructure unrelated feature ownership.
Do not remove/delete records, routes, or features for no reason.

===== END =====
