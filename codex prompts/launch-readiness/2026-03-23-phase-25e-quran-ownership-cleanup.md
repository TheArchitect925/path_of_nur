===== PHASE 25E PROMPT — QUR’AN OWNERSHIP CLEANUP =====

PRIMARY OBJECTIVE === BUILDING CANONICAL QUR’AN OWNERSHIP CLEANUP FOR PATH OF NŪR WITHOUT BREAKING COMPATIBILITY

You are working in the existing Path of Nūr codebase.

This is a CONTROLLED ARCHITECTURE CLEANUP phase.
This is NOT a broad rebuild.
This is NOT a feature expansion phase.
This is NOT a generic cleanup sweep.

Previous phases already stabilized:
- route integrity
- key regression coverage
- major live localization on Qur’an/Growth/Games
- additional live localization on Wudu/Kids Arabic

This phase must now simplify Qur’an ownership and reduce duplicate product framing.

========================================================
CORE GOAL
========================================================

Make `/quran*` the clearly dominant and canonical Qur’an owner in product framing, routing intent, and user discovery, while preserving backward compatibility and avoiding abrupt removal of legacy surfaces.

========================================================
CURRENT PROBLEM TO SOLVE
========================================================

The app still carries duplicate or blurred Qur’an ownership because:
- `/quran*` is canonical
- but Learn-owned Qur’an surfaces still remain live
- especially `LearnQuranHubPage`, which can read like a parallel Qur’an product surface
- duplicate product-language and duplicate discovery entry points create structural ambiguity

This phase is about clarifying ownership, not deleting useful content.

========================================================
APPROVED DIRECTION
========================================================

Unless code evidence proves a strong reason otherwise, treat this as the intended direction:

1. `/quran*` is the sole canonical Qur’an owner.
2. Learn may link into Qur’an-related learning destinations.
3. Learn should not present a parallel full Qur’an hub/product.
4. Compatibility aliases may remain, but should stop behaving like co-equal surfaced owners.
5. Strong existing Qur’an surfaces should be preserved, not rebuilt.

========================================================
STRICT DO-NOT-DO RULES
========================================================

Do NOT:
- delete routes, pages, or user data for no reason
- break existing callers
- remove compatibility aliases entirely in this phase
- redesign the whole Learn IA
- redesign Kids IA
- unify notes/reflections/journal yet
- do broad localization rewrites
- do broad public-beta polish
- go haywire and remove/delete records or functionality for no reason

========================================================
PHASE SCOPE
========================================================

This phase should focus on:

1. `LearnQuranHubPage`
2. Learn-owned Qur’an routes and entry points
3. canonical `/quran*` ownership enforcement in discovery
4. duplicate Qur’an-facing product language
5. compatibility-preserving demotion of secondary ownership

========================================================
MANDATORY AUDIT-FIRST TASKS
========================================================

Before editing, verify and document:

1. every currently live Learn-owned Qur’an route and entry point
2. every place `LearnQuranHubPage` is still surfaced or linked
3. whether any Learn-owned Qur’an entry still provides unique value not already represented under `/quran*`
4. which routes are canonical owners vs compatibility-only
5. whether any existing tests assume Learn-owned Qur’an surfaces remain primary
6. whether any user-facing labels still imply parallel Qur’an ownership

Do not guess.

========================================================
IMPLEMENTATION RULES
========================================================

1. Preserve strong Qur’an features.
2. Reduce duplicate ownership, not feature depth.
3. Prefer demotion, redirect, or reframing over deletion.
4. Keep compatibility aliases functioning unless clearly safe to demote further.
5. Make discovery surfaces point clearly to canonical `/quran*` ownership.
6. If `LearnQuranHubPage` still has unique value, reduce its framing so it behaves like a scoped learning entry rather than a second Qur’an home.
7. If `LearnQuranHubPage` has no meaningful unique value, demote it safely behind canonical `/quran*` routing and discovery.

========================================================
PREFERRED CLEANUP DIRECTION
========================================================

Target outcomes should lean toward:

- `/quran` remains the only true Qur’an home
- Learn category/taxonomy entries that refer to Qur’an should point to:
  - canonical Qur’an hub
  - or clearly scoped Qur’an learning sub-destinations
- `LearnQuranHubPage` should either:
  - become a smaller scoped learning surface with non-duplicative framing
  - or be demoted from discovery in favor of `/quran`
- any duplicate “Qur’an Study” / “Return to Qur’an Home” / “Reflect” framing should be simplified so ownership is obvious

========================================================
COMPATIBILITY RULES
========================================================

- Preserve compatibility routes unless clearly safe to convert to redirects
- Do not remove legacy Learn-owned Qur’an route families entirely in this phase
- If a route is kept for compatibility, avoid surfacing it as primary discovery
- Redirect is preferred over deletion if behavior is compatibility-only

========================================================
TESTING REQUIREMENTS
========================================================

Run:
- flutter analyze
- relevant Qur’an routing/integrity tests
- any Learn/Qur’an discovery tests affected
- router smoke/deep-link tests if touched

Do not weaken tests just to pass.
If expectations change, explain why and ensure the new expectation reflects the approved canonical ownership direction.

========================================================
OUTPUT FORMAT
========================================================

Return exactly:

1. Audit Findings Before Changes
2. Current Qur’an Ownership Map
3. Files Changed
4. What Was Implemented
5. Qur’an Ownership Cleanup Results
6. Compatibility Preservation Notes
7. What Was Explicitly Not Changed
8. Remaining Ownership Debt
9. Tests Added / Updated / Run
10. Final Audit Summary

========================================================
FINAL AUDIT SUMMARY FORMAT
========================================================

At the end provide:

- analyzer_passing: yes/no
- quran_canonical_owner_is_clearer: yes/no/partial
- learn_quran_parallel_framing_reduced: yes/no/partial
- learn_owned_quran_discovery_demoted: yes/no/partial
- compatibility_aliases_preserved: yes/no
- quran_routes_or_features_removed: yes/no
- unrelated_scope_expanded: yes/no
- biggest_quran_ownership_debt_remaining: <text>

========================================================
FINAL RULE
========================================================

This phase is a Qur’an ownership cleanup pass only.

Do not broaden scope.
Do not restructure unrelated feature families.
Do not remove/delete records, routes, or features for no reason.

===== END =====
