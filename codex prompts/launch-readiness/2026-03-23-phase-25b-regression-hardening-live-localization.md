# Phase 25B Prompt — Regression Hardening + Live Localization Payoff

PRIMARY OBJECTIVE === BUILDING REGRESSION TRUST AND LIVE LOCALIZATION READINESS FOR PATH OF NŪR

You are working in the existing Path of Nūr codebase.

This is a CONTROLLED STABILIZATION phase.
This is NOT a feature expansion phase.
This is NOT a broad architecture rewrite.
This is NOT a generic cleanup sweep.

This phase exists to make the current app more trustworthy and beta-ready by fixing:
1. red high-signal regression coverage
2. live runtime-localization shim debt on user-facing surfaces

========================================================
CORE UNDERSTANDING
========================================================

The app is now materially stronger in:
- shell routing
- Learn destination mapping
- Kids discovery routing
- Games hub discovery
- Qur’an search
- general top-level navigation stability

The main blockers now are:
- red regression coverage in key user-facing flows
- runtime-localization shim reliance on live surfaces
- lingering duplicate ownership/product-language debt, especially around Qur’an
- fragmented writing/retention system

This phase ONLY handles the first two blockers:
- regression hardening
- live localization payoff

========================================================
STRICT DO-NOT-DO RULES
========================================================

Do NOT:
- delete routes, pages, records, or content for no reason
- broaden feature scope
- rebuild Learn IA
- redesign Kids IA
- perform full Qur’an ownership cleanup yet
- unify notes/reflections/journal yet
- remove compatibility aliases entirely
- do unrelated polish passes
- rewrite strong surfaces from scratch
- go haywire and remove/delete records for no reason

If something is outside this phase, document it and leave it alone.

========================================================
PHASE SCOPE
========================================================

A. REGRESSION HARDENING
Target the current red high-signal failures first:

1. `test/app/quran_route_integrity_test.dart`
2. `test/features/journey/growth_home_ia_test.dart`
3. `test/features/learn/salah/wudu_trainer_page_test.dart`
4. `test/features/learn/learn_placeholder_containment_test.dart`

B. LIVE LOCALIZATION PAYOFF
Target active runtime-localization shim usage on live surfaces, prioritizing:

1. Qur’an live surface copy
2. Growth live surface copy
3. Games hub live surface copy
4. Wudu live surface copy
5. Kids Arabic live surface copy

Important:
- migrate live user-facing strings toward generated ARB-backed localization where safely possible
- remove runtime shim dependence incrementally, not recklessly
- do not break current copy behavior or locale fallbacks
- if a full migration is too risky for a surface in this phase, reduce the debt safely and document the remainder

========================================================
MANDATORY AUDIT-FIRST STEPS
========================================================

Before editing, verify and document:

1. exact current cause of each failing test:
   - real product bug
   - stale test expectation
   - harness/setup issue
   - timing/pump issue
   - copy/localization drift
   - route/action mismatch

2. which runtime-localization shim files are still active on current live surfaces

3. which strings can be safely moved to ARB localization in this phase without broad product rewrites

4. which surfaces are truly user-facing/live vs internal/secondary/compatibility-only

Do not guess.
Identify root cause before changing product code or tests.

========================================================
IMPLEMENTATION RULES
========================================================

1. Fix real product behavior first when it is wrong.
2. Fix tests second when product behavior is already correct and the tests are stale.
3. Preserve working user flows.
4. Preserve backward compatibility.
5. Prefer targeted string migration over broad localization rewrites.
6. Keep the current UX intact unless a failing regression proves something is wrong.
7. Keep strong surfaces strong; do not destabilize them to chase cleanup purity.

========================================================
REGRESSION TARGETS — REQUIRED HANDLING
========================================================

A. QUR’AN REFLECTIONS CTA FLOW
- verify actual current intended reflections CTA behavior from hub surfaces
- repair route/action behavior if broken
- if behavior is already correct, update the test to match current approved behavior
- preserve canonical `/quran*` ownership direction

B. GROWTH BROWSE ALL EXPECTATION DRIFT
- inspect current live text and current runtime localization behavior
- fix copy/test mismatch safely
- do not introduce brittle capitalization-dependent expectations if localization is still transitioning
- preserve the real Browse All flow

C. WUDU TRAINER HARNESS / TIMING
- fix missing Material/context issues in tests or product widgets if truly needed
- resolve `pumpAndSettle` timeout causes safely
- do not weaken test value just to make it pass
- preserve resume/restart/review/completion behavior

D. LEARN PLACEHOLDER CONTAINMENT / TAJWEED DRIFT
- inspect actual visible copy and containment expectations
- align either production wording or test expectation based on which is truly correct now
- preserve truthful containment behavior

========================================================
LOCALIZATION PAYOFF RULES
========================================================

Target live surfaces first.

Preferred order:
1. Qur’an
2. Growth
3. Games
4. Wudu
5. Kids Arabic

For each surface:
- identify runtime shim usage
- move safe live strings into ARB-backed localization
- update generated localization usage where appropriate
- keep fallbacks stable
- avoid mixing multiple competing localization strategies on the same screen if a clean small migration is possible

If a surface cannot be safely completed in this phase:
- reduce the shim footprint
- document exact remaining debt
- do not fake completion

========================================================
OUT OF SCOPE — EXPLICITLY DEFER
========================================================

Do NOT do these in this phase:
- remove `LearnQuranHubPage`
- merge Learn and Qur’an ownership
- unify notes/reflections/journal
- redesign Journal architecture
- trim all alias families
- full Settings/Profile cleanup
- broader copy polish outside the targeted live surfaces
- add new features or content breadth

========================================================
TESTING REQUIREMENTS
========================================================

Run and stabilize:
- `flutter analyze`
- router smoke/deep-link baseline tests if affected
- the focused failing regression slice
- any updated localization-related tests if needed

At minimum, explicitly re-run and report status for:
- `test/app/quran_route_integrity_test.dart`
- `test/features/journey/growth_home_ia_test.dart`
- `test/features/learn/salah/wudu_trainer_page_test.dart`
- `test/features/learn/learn_placeholder_containment_test.dart`

Do not weaken tests just to get green.
If a test changes, explain why the previous expectation was wrong or stale.

========================================================
CHANGE CONTROL RULES
========================================================

- change only files needed for this scoped phase
- preserve state/data/progress behavior
- preserve route compatibility
- avoid unrelated cleanup
- do not remove records/routes/pages for no reason
- document all explicitly deferred items
- if a localization migration touches shared code, keep the blast radius minimal

========================================================
OUTPUT FORMAT
========================================================

Return exactly:

1. Audit Findings Before Changes
2. Failing Regression Root Causes
3. Localization Debt Findings
4. Files Changed
5. What Was Implemented
6. Regression Hardening Results
7. Localization Payoff Results
8. What Was Explicitly Not Changed
9. Remaining Risks
10. Final Audit Summary

========================================================
FINAL AUDIT SUMMARY FORMAT
========================================================

At the end provide:

- analyzer_passing: yes/no
- quran_route_integrity_test_passing: yes/no
- growth_home_ia_test_passing: yes/no
- wudu_trainer_page_test_passing: yes/no
- learn_placeholder_containment_test_passing: yes/no
- runtime_quran_localization_reduced: yes/no/partial
- runtime_growth_localization_reduced: yes/no/partial
- runtime_games_localization_reduced: yes/no/partial
- runtime_wudu_localization_reduced: yes/no/partial
- runtime_kids_arabic_localization_reduced: yes/no/partial
- unrelated_scope_expanded: yes/no
- biggest_issue_remaining_after_phase: <text>

========================================================
FINAL RULE
========================================================

This phase is about trust and readiness.

Make the current app more stable.
Make the live copy more truthful.
Do not broaden scope.
Do not remove/delete records, routes, or features for no reason.
