===== PHASE FIX V1A PROMPT — QUR’AN ROUTE INTEGRITY + QUR’AN HUB REGROUPING =====

PRIMARY OBJECTIVE === BUILDING A SAFE, CONTROLLED QUR’AN ROUTE FIX + HUB STRUCTURE CLEANUP FOR PATH OF NŪR

You are working in the existing Path of Nūr codebase.

This is a CONTROLLED IMPLEMENTATION phase.
This is NOT a full navigation rebuild.
This phase is focused on:
1. approved Qur’an route integrity fixes
2. approved Qur’an hub/island regrouping
3. approved Qur’an quote visibility cleanup
4. approved Qur’an search-scope hardening

Do not widen scope beyond the Qur’an area and the already-approved deep-link fixes.

========================================================
GOVERNING CONTEXT
========================================================

Follow the previously established main navigation understanding.

Important confirmed rules:
- keep the 5-tab shell intact
- `/quran*` is the sole canonical Qur’an owner
- preserve compatibility aliases where needed
- prefer redirect over deletion
- do not remove routes/pages for no reason
- do not merge unrelated features
- do not redesign Kids, Learn ownership, or Journey architecture in this phase

========================================================
APPROVED SCOPE FOR THIS PHASE
========================================================

Implement only these approved items:

A. ROUTE INTEGRITY
1. Add a canonical routed Qur’an-owned destination for `QuranReflectionsPage`
2. Ensure all current Qur’an hub references to reflections resolve correctly
3. Fix deep-link specificity:
   - `pathofnur://prayer` -> `/worship/prayer`
   - `pathofnur://dhikr` -> `/worship/dhikr`

B. QUR’AN HUB REGROUPING
4. On the main Qur’an page, rename the current `Read` island to `Continue`
5. Create a new island: `Read Qur’an`
   - this must take the user to the Surah List
6. Create a new island: `Journey of the Qur’an`
   - this should include the Qur’an journey islands
   - include `Journey of the Qur’an`
7. Create a new island: `Understanding Surah’s`
   - move `Understanding Al-Fatiha` under this island
8. Create or regroup `Qur’an Learning`
   - move these under it:
     - `Short Surah`
     - `Study`
     - `Memorize`
     - `Words`
     - `Topics`

C. QUR’AN SEARCH
9. Ensure Qur’an search is scoped to search across all relevant Qur’an-related material already present in the app, including where applicable:
   - surahs
   - ayah text
   - Qur’an learning content
   - English translation text
   - transliteration text
   - topics/words-related Qur’an content
10. Reuse existing data/index/search surfaces where possible
11. Do not invent entirely new data sources if they do not already exist

D. QUR’AN QUOTE DISPLAY
12. Show the Qur’an quote at the top ONLY on the main Qur’an page
13. Remove that quote block from downstream Qur’an pages/subpages where it is currently repeated

========================================================
OUT OF SCOPE — DO NOT TOUCH
========================================================

Do NOT:
- delete pages
- remove legacy aliases entirely
- merge Learn pages
- change child-profile Learn behavior
- redesign Kids IA
- relabel Journey “Browse All”
- add Garden onward actions
- perform broad Learn ownership cleanup
- broadly rename unrelated routes
- do layout consistency cleanup outside the Qur’an scope
- remove Growth/Journey alias families
- rebuild unrelated UI surfaces

Also do NOT silently invent new major pages unless absolutely necessary.
Prefer regrouping existing destinations and reusing existing surfaces.

========================================================
MANDATORY AUDIT-FIRST STEPS
========================================================

Before editing, verify and document:

1. all Qur’an route declarations relevant to:
   - `/quran`
   - `/quran/*`
   - `/learn/quran*`
   - `/learn/hub/quran*`

2. all current references from the main Qur’an hub and Learn Qur’an hub to:
   - Read / Continue
   - Search
   - Study
   - Memorize
   - Words
   - Topics
   - Short Surah
   - Understanding Al-Fatiha
   - Journey of the Qur’an
   - Reflections

3. whether existing destination pages already exist for:
   - Surah List
   - Journey of the Qur’an
   - Understanding Al-Fatiha
   - Short Surah
   - Study
   - Memorize
   - Words
   - Topics

4. where the Qur’an quote component/block is currently rendered across the Qur’an family

5. how current Qur’an search is wired:
   - current search provider / data source / indexed content
   - whether translations and transliteration are already searchable
   - whether Qur’an learning content is already searchable

6. whether any of the regrouped items currently depend on top-level placement for behavior
Do not guess. Verify first.

========================================================
IMPLEMENTATION REQUIREMENTS
========================================================

A. CANONICAL QUR’AN REFLECTIONS ROUTE
- Add one canonical route under the Qur’an namespace
- ensure coherent route name and path
- make current hub navigation resolve
- preserve compatibility if anything already points at an older name/path

B. DEEP LINKS
- update only:
  - `pathofnur://prayer` -> `/worship/prayer`
  - `pathofnur://dhikr` -> `/worship/dhikr`
- leave other deep-link behavior unchanged unless a tiny safe consistency fix is required

C. MAIN QUR’AN HUB REGROUPING
Treat the main Qur’an page as the canonical Qur’an front door.

Required target island structure:

1. `Continue`
- renamed from current `Read`
- purpose: resume / continue reading flow

2. `Read Qur’an`
- dedicated browse/start-reading entry
- opens Surah List

3. `Journey of the Qur’an`
- contains Qur’an journey-related items
- include `Journey of the Qur’an`

4. `Understanding Surah’s`
- contains `Understanding Al-Fatiha`

5. `Qur’an Learning`
- contains:
  - `Short Surah`
  - `Study`
  - `Memorize`
  - `Words`
  - `Topics`

Important:
- regroup existing destinations first
- do not destroy working functionality
- if an item currently points to an imperfect but existing destination, improve it only if it is clearly safe and within scope
- if a destination is unclear, preserve behavior and document it rather than inventing a risky mapping

D. QUR’AN SEARCH HARDENING
- expand or normalize Qur’an search behavior so it searches across all relevant existing Qur’an-related material
- include translations and transliteration if those sources already exist in the searchable pipeline or can be safely added with existing local data
- include Qur’an learning content only if it already exists in an accessible searchable form
- if some requested search scope cannot be safely included in this phase, document the gap precisely instead of faking completeness

E. QUOTE VISIBILITY CLEANUP
- keep the Qur’an quote block on the main Qur’an page only
- remove it from downstream Qur’an subpages that currently show it
- preserve any other page-specific headers or contextual text not part of the shared quote block

F. QUR’AN OWNERSHIP HARDENING
- preserve Learn-owned Qur’an compatibility aliases
- where clearly alias-only, prefer redirect behavior instead of parallel live ownership
- do not remove aliases in this phase
- do not break callers

========================================================
DESTINATION MAPPING RULES
========================================================

Apply these intent rules carefully:

- `Continue` = resume current/last reading
- `Read Qur’an` = Surah List
- `Understanding Al-Fatiha` belongs under `Understanding Surah’s`
- `Short Surah`, `Study`, `Memorize`, `Words`, `Topics` belong under `Qur’an Learning`
- `Journey of the Qur’an` belongs under `Journey of the Qur’an`

If a current destination is semantically weak:
- keep behavior only if it is the safest temporary mapping
- clearly document it
- do not silently overreach

========================================================
TESTING REQUIREMENTS
========================================================

Add or update tests to verify:

1. `QuranReflectionsPage` has a working canonical route
2. Qur’an hub reflections action navigates successfully
3. Learn Qur’an hub reflections action navigates successfully
4. `pathofnur://prayer` resolves to `/worship/prayer`
5. `pathofnur://dhikr` resolves to `/worship/dhikr`
6. main Qur’an page shows the updated island structure
7. `Continue` still preserves reading/resume behavior
8. `Read Qur’an` opens the Surah List
9. `Understanding Al-Fatiha` is surfaced under `Understanding Surah’s`
10. `Short Surah`, `Study`, `Memorize`, `Words`, and `Topics` appear under `Qur’an Learning`
11. Qur’an quote block appears on main Qur’an page only
12. downstream Qur’an pages no longer show that shared quote block
13. Learn-owned Qur’an compatibility routes still resolve safely
14. `/learn/browse` redirects to `/learn/explore` if you convert it and only if safe

Do not weaken or remove existing tests unless absolutely necessary and fully justified.

========================================================
CHANGE CONTROL RULES
========================================================

- change only files needed for this scoped fix
- preserve backward compatibility
- prefer redirect over deletion
- avoid unrelated cleanup
- do not remove records, routes, or screens for no reason
- do not rebuild the entire Qur’an UI from scratch if regrouping can be done incrementally
- if some requested search scope cannot be fully implemented safely in this phase, document exact blockers and leave stable behavior intact

========================================================
OUTPUT FORMAT
========================================================

Return exactly:

1. Audit Findings Before Changes
2. Files Changed
3. What Was Implemented
4. Qur’an Hub Regrouping Results
5. Search Scope Results
6. Quote Visibility Results
7. What Was Explicitly Not Changed
8. Compatibility Notes
9. Tests Added / Updated
10. Remaining Decisions Deferred
11. Final Audit Summary

========================================================
FINAL AUDIT SUMMARY FORMAT
========================================================

At the end provide:

- reflections_route_added: yes/no
- reflections_route_path: <path or none>
- reflections_route_name: <name or none>
- prayer_deeplink_fixed: yes/no
- dhikr_deeplink_fixed: yes/no
- quran_hub_regrouped: yes/no
- continue_island_renamed: yes/no
- read_quran_island_added: yes/no
- journey_of_quran_island_added: yes/no
- understanding_surahs_island_added: yes/no
- quran_learning_grouped: yes/no
- quran_search_scope_expanded: yes/no/partial
- quran_quote_main_page_only: yes/no
- quran_aliases_preserved: yes/no
- learn_browse_redirected: yes/no
- tests_passing: yes/no
- remaining_manual_decisions_count: <number>

========================================================
FINAL RULE
========================================================

This is a CONTROLLED QUR’AN FIX + REGROUPING phase.

Do not expand scope.
Do not perform unrelated cleanup.
Do not delete records or routes for no reason.
Do not restructure unrelated feature families.
Do not go haywire and remove/delete existing records or functionality for no reason.

===== END =====
