# Phase V5 Prompt — Navigation Gap Audit + Legacy Route Normalization

## PRIMARY OBJECTIVE === BUILDING NAVIGATION GAP AUDIT + LEGACY ROUTE NORMALIZATION

You are working in the existing Flutter codebase for **Path of Nūr**.

This is an **audit-first stabilization phase** that follows the completed Navigation System Stabilization pass.

The previous pass successfully:
- split oversized Learn routing into focused route builders
- preserved canonical routes
- retained compatibility aliases safely
- kept deep links and route names intact
- preserved onboarding, shared-device, child-learning, and shell behavior

This phase is **not** a redesign.

This phase should find and clean up the remaining hidden navigation inconsistencies, legacy route ownership gaps, and transitional references that still exist after V4.

**Critical safety rule:**  
Do not go haywire deleting routes, pages, route names, metadata, or records for no reason.  
Preserve current behavior unless something is clearly obsolete, safely replaced, and validated.

> “And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

---

## TASK TYPE

Navigation audit, legacy route normalization, alias integrity validation, taxonomy alignment, and safe cleanup of transitional route references.

---

## PRODUCT GOAL

After V4, platform navigation is cleaner, but there are still likely gaps such as:
- lingering `learnLegacy` ownership
- transitional metadata references
- taxonomy targets that may still point to old route patterns
- compatibility redirects that may not consistently preserve path/query behavior
- route names and paths that are still technically stable but not fully normalized

This phase should:
1. audit all remaining legacy navigation seams,
2. normalize what is safe,
3. preserve all behavior,
4. document what remains deferred,
5. leave the routing system even easier to scale and reason about.

---

## EXECUTION RULES

1. **Audit first before editing.**
2. **Do not remove working functionality.**
3. **Do not rename route names unless absolutely unavoidable.**
4. **Do not break deep links, pushNamed calls, query forwarding, or path parameter forwarding.**
5. **Prefer canonical route targets over legacy metadata where safe.**
6. **Use redirects or compatibility wrappers instead of destructive removal unless fully proven safe.**
7. **Preserve localization.**
8. **Preserve test coverage and add targeted tests if needed.**
9. **At the very end, run a final audit summary so one full summary can be reviewed and fixed if needed.**

---

# IMPLEMENTATION SCOPE

## A. Audit remaining legacy navigation seams

Perform a targeted audit of the current routing/navigation system after V4.

Specifically inspect:

- `app_router.dart`
- `router_policies.dart`
- `learn_routes.dart`
- all new route builder files under `lib/app/routes/learn`
- taxonomy / route-target mapping files
- learning journey metadata that may still point to old routes
- any route helper / canonical route helper files
- deep-link mapping helpers
- test coverage around route behavior

Identify all remaining examples of:

### 1. Legacy or transitional route ownership
Examples to check:
- `learnLegacy`
- old Learn-owned hub route assumptions
- compatibility aliases that are still treated as semi-canonical in metadata
- routes that still have legacy naming but canonical replacements now exist

### 2. Taxonomy / metadata drift
Check whether:
- Learn taxonomy route targets still point at old aliases where canonical targets now exist
- Learning Journey metadata still references transitional paths
- category/subcategory descriptors still point to compatibility routes instead of canonical routes
- route-name usage is consistent with intended ownership

### 3. Alias integrity gaps
Audit all retained alias redirects and verify:
- query parameters are forwarded
- path parameters are forwarded
- redirect targets are canonical
- no alias uses its own duplicate pageBuilder when redirect is sufficient
- no redirect loops
- no inconsistent handling between similar alias groups

### 4. Hidden non-tab compatibility layers
Check for:
- `/growth/*`
- `/journey/tracking`
- old Learn section aliases
- legacy hidden hub routes
- old path patterns still referenced in chips/cards/metadata/tests

### 5. Route-name consistency
Audit whether:
- route names still match feature ownership
- names imply old ownership even when path is canonical elsewhere
- any naming debt should be documented even if not changed yet

---

## B. Normalize `learnLegacy` safely

Audit the current role of `learnLegacy`.

Determine:
- whether it is still used in live routing
- whether it is only metadata/backward-compatibility
- whether it is referenced by tests, taxonomy, or journey metadata
- whether it should remain as a compatibility route, redirect, or internal marker

Then implement the safest next step:

### Allowed outcomes
- keep it but document it clearly
- convert it to a clearly marked compatibility redirect
- reduce references to it where canonical routes are now safe
- remove only if fully unused and fully safe

### Rules
- do not remove it blindly
- do not break any hidden navigation
- document the final ownership decision

---

## C. Normalize taxonomy and metadata route targets

Audit route targets used by:
- Learn taxonomy
- category descriptors
- subcategory descriptors
- journey island metadata
- learning journey stage metadata
- cross-domain navigation chips/helpers

Where safe:
- update route targets to canonical destinations
- stop pointing metadata at compatibility aliases if canonical paths/names now exist
- preserve route names where that is safest
- keep product IA unchanged

### Goal
The data layer should increasingly point at canonical route ownership, not transitional aliases.

---

## D. Strengthen redirect helper coverage

Audit all redirect helpers and alias handling patterns.

If useful, consolidate repeated logic into reusable helpers for:
- query forwarding
- path forwarding
- alias-to-canonical conversion
- canonical route generation

### Important
Do not overengineer a framework.
Keep it lightweight and production-ready.

Possible safe improvements:
- shared redirect helper for canonical Learn aliases
- shared helper for preserving query parameters consistently
- small utility for canonical route target creation

---

## E. Improve route ownership clarity in code and docs

Where useful, improve documentation/comments so it is obvious:
- which routes are canonical
- which are aliases only
- which are compatibility paths retained for deep-link stability
- which ownership decisions are still transitional
- what remains deferred to future cleanup

This can live in:
- route comments
- a concise internal navigation audit doc
- route registry comments
- memory docs if this repo uses them

Do not write bloated docs. Keep them concise and durable.

---

## F. Audit in-app callers of old route patterns

Inspect in-app navigation callers such as:
- `context.pushNamed(...)`
- `context.go(...)`
- chips
- cards
- journey links
- Qur’an contextual links
- taxonomy-driven link targets
- any helper-generated navigation targets

Identify any places still sending users to:
- non-canonical aliases
- transitional paths
- legacy targets

Where safe:
- normalize callers to canonical destinations
- preserve compatibility where external/deep links still need old aliases

### Goal
Internal app navigation should prefer canonical routes even if external compatibility aliases remain.

---

## G. Preserve all core behavior

Do not break any of the following:

- onboarding redirect flow
- shared-device profile picker flow
- child-profile Learn restrictions
- deep-link mapping behavior
- shell route behavior
- tab highlighting / current tab resolution
- canonical top-level tabs
- Qur’an route integrity
- Learn category routing
- kids flows
- games / quizzes flows
- FAQ / notes / tools flows

---

## H. Add or update targeted tests

If current coverage is missing for the areas touched, add targeted tests for:

### 1. Alias redirect integrity
- alias path forwards query params correctly
- alias path forwards path params correctly
- alias reaches canonical route

### 2. Canonical route preference
- taxonomy/metadata points to canonical targets where expected
- internal callers resolve to canonical routes

### 3. Legacy route stability
- retained compatibility paths still resolve safely
- `learnLegacy` behavior is stable based on the chosen outcome

### 4. Deep-link safety
- deep-link mapping still resolves correctly after normalization

Do not add noisy tests. Add targeted, useful tests.

---

## I. Keep scope intentionally controlled

For this phase:

### DO:
- audit all remaining legacy navigation seams
- normalize metadata to canonical targets where safe
- validate redirects thoroughly
- clarify `learnLegacy`
- update internal callers to canonical routes where safe
- add focused tests
- document what remains deferred

### DO NOT:
- redesign Learn IA
- redesign Journey IA
- aggressively delete compatibility aliases
- rename route names broadly
- invent a new routing framework
- move unrelated feature code around

---

# VALIDATION

After implementation, validate all of the following:

## Core behavior
1. app still boots
2. router still initializes correctly
3. guards still work
4. shell navigation still works
5. current tab detection still works

## Canonical routes
6. canonical top-level tabs still resolve
7. canonical `/quran/*` routes still resolve
8. canonical `/learn/explore` still resolves
9. canonical Learn category routing still resolves

## Compatibility routes
10. retained aliases still resolve correctly
11. query forwarding works
12. path parameter forwarding works
13. no redirect loops introduced

## Legacy normalization
14. `learnLegacy` behavior is now clearly defined
15. taxonomy/metadata is more aligned with canonical ownership
16. internal callers prefer canonical targets where safe

## Tests / code health
17. analyzer passes
18. targeted route/deeplink tests pass
19. no localization regressions introduced

---

# DELIVERABLES

Implement the audit + normalization pass.

Then provide a concise summary with:

1. **Audit findings before changes**
   - remaining legacy seams found
   - where taxonomy/metadata drift was found
   - which alias integrity gaps existed
   - status of `learnLegacy`

2. **Files changed**
   - updated files
   - new tests/docs/helpers created

3. **Canonical normalization decisions**
   - what was normalized to canonical ownership
   - what remains compatibility-only
   - what was intentionally left deferred

4. **Legacy route decision**
   - final `learnLegacy` outcome
   - why that decision was chosen

5. **Alias integrity**
   - confirm query/path forwarding behavior
   - note any remaining deferred alias groups

6. **Internal navigation callers**
   - what was updated to canonical targets
   - what was intentionally preserved for compatibility

7. **Validation**
   - analyzer results
   - tests run
   - route/deeplink behavior confirmation

8. **Final audit**
   - whether routing is now cleaner, safer, and more canonical than after V4
   - what the next highest-value cleanup phase should be

---

# IMPORTANT SAFETY / PRODUCT RULE

This is a **tightening pass**, not a redesign.

Do not remove or rename things recklessly.
Do not break hidden compatibility.
Do not delete anything just because it looks old.

Build on top of what exists.
Normalize carefully.
Preserve behavior.
Audit thoroughly.
At the end, provide one clear full summary so follow-up fixes can be done efficiently.

# END OF PROMPT
