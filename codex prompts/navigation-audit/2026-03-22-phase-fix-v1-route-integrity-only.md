===== PHASE FIX V1 PROMPT — ROUTE INTEGRITY ONLY =====

PRIMARY OBJECTIVE === BUILDING ROUTE INTEGRITY FIXES FOR PATH OF NŪR

You are working in the existing Path of Nūr codebase.

This is a CONTROLLED IMPLEMENTATION phase.
This is NOT the full navigation cleanup.
This phase is ONLY for already-approved route integrity fixes.

Before doing anything, fully follow the previously provided MAIN UNDERSTANDING / DECISION CONTEXT prompt.

========================================================
APPROVED SCOPE FOR THIS PHASE
========================================================

Implement only these approved items:

1. Add a canonical routed Qur’an-owned destination for `QuranReflectionsPage`.
2. Ensure all current hub references to reflections resolve correctly.
3. Fix deep-link specificity:
   - `pathofnur://prayer` -> `/worship/prayer`
   - `pathofnur://dhikr` -> `/worship/dhikr`
4. Preserve existing Learn-owned Qur’an compatibility aliases.
5. Where already safe and clearly alias-only, convert compatibility routes to redirect behavior rather than parallel live ownership.
6. Review `/learn/browse` and convert it to redirect-only compatibility ONLY if there is no unique UI behavior that would be lost.

========================================================
OUT OF SCOPE — DO NOT TOUCH
========================================================

Do NOT:
- delete pages
- remove legacy routes
- merge Learn pages
- change child-profile Learn behavior
- redesign Kids IA
- remap Qur’an “Memorize”
- relabel Journey “Browse All”
- add Garden onward actions
- do broad route renaming
- perform layout/UI consistency cleanup
- remove Growth/Journey alias families
- remove Learn-owned Qur’an aliases entirely

========================================================
MANDATORY AUDIT-FIRST STEPS
========================================================

Before editing, verify and document:

1. all route declarations relevant to:
   - `/quran*`
   - `/learn/quran*`
   - `/learn/hub/quran*`
   - `/worship*`
   - deep-link mappings

2. all references to the reflections route from:
   - `QuranAppHubPage`
   - `LearnQuranHubPage`
   - any other hubs or cards

3. whether a route constant or route-name pattern already exists that should be reused

4. whether `/learn/browse` contains unique behavior that would be lost if converted to redirect-only

Do not guess. Verify first.

========================================================
IMPLEMENTATION REQUIREMENTS
========================================================

A. QUR’AN REFLECTIONS ROUTE
- Add one canonical route under the Qur’an namespace
- Use naming consistent with the existing `/quran*` route family
- Ensure route name and path are both coherent
- Make hub navigation resolve without breaking existing callers
- Keep implementation minimal and clean

B. DEEP LINKS
- Update deep-link resolution so prayer and dhikr open their true subpages
- Leave all other deep-link mappings unchanged unless a tiny consistency fix is clearly required

C. QUR’AN OWNERSHIP HARDENING
- Preserve compatibility aliases
- If a Learn-owned Qur’an alias is already clearly alias-only, prefer redirect behavior
- Do not remove alias routes in this phase
- Do not break external or internal callers

D. `/learn/browse`
- Inspect whether it is truly alias-only
- If yes, convert it to redirect `/learn/explore`
- If not, leave it intact and document why

========================================================
TESTING REQUIREMENTS
========================================================

Add or update tests to verify:

1. `QuranReflectionsPage` has a working canonical route
2. Qur’an hub reflections action navigates successfully
3. Learn Qur’an hub reflections action navigates successfully
4. `pathofnur://prayer` resolves to `/worship/prayer`
5. `pathofnur://dhikr` resolves to `/worship/dhikr`
6. Learn-owned Qur’an compatibility routes still resolve safely
7. `/learn/browse` redirects to `/learn/explore` if converted

Also:
- do not weaken existing tests
- do not delete tests unless absolutely necessary and fully justified

========================================================
CHANGE CONTROL RULES
========================================================

- change only files needed for this scoped fix
- preserve backward compatibility
- prefer redirect over deletion
- avoid unrelated cleanup
- do not remove records, routes, or screens for no reason
- if a route is ambiguous, preserve behavior and document the ambiguity rather than overreaching

========================================================
OUTPUT FORMAT
========================================================

Return exactly:

1. Audit Findings Before Changes
2. Files Changed
3. What Was Implemented
4. What Was Explicitly Not Changed
5. Route Integrity Results
6. Compatibility Notes
7. Tests Added / Updated
8. Remaining Decisions Deferred
9. Final Audit Summary

========================================================
FINAL AUDIT SUMMARY FORMAT
========================================================

At the end provide:

- reflections_route_added: yes/no
- reflections_route_path: <path or none>
- reflections_route_name: <name or none>
- prayer_deeplink_fixed: yes/no
- dhikr_deeplink_fixed: yes/no
- quran_aliases_preserved: yes/no
- learn_browse_redirected: yes/no
- tests_passing: yes/no
- remaining_manual_decisions_count: <number>

========================================================
FINAL RULE
========================================================

This is ROUTE INTEGRITY ONLY.

Do not expand scope.
Do not perform unrelated cleanup.
Do not delete records or routes for no reason.
Do not restructure ownership beyond what is explicitly approved.

===== END =====
