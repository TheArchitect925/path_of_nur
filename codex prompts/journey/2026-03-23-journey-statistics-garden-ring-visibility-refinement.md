# ===== PHASE PROMPT — JOURNEY STATISTICS / GARDEN / RING VISIBILITY REFINEMENT =====

## PRIMARY OBJECTIVE === BUILDING JOURNEY STATISTICS / GARDEN / RING VISIBILITY REFINEMENT

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows the unlinked functionality / orphaned pages audit.

Key audit findings:
- there are not many truly orphaned Journey/Growth pages
- the main issue is **secondary discoverability**
- ring functionality is real, but it exists as **summary/progression data and components**, not as a hidden finished standalone page
- the correct improvement is **better visibility and explanation inside Journey**, not reviving a separate “rings page”
- the next highest-value discoverability improvements in Journey are:
  - stronger visibility for **Statistics**
  - stronger visibility for **Garden**
  - better explanation/surfacing of **ring/progress metrics**
  - optional stronger visibility for **Ocean** depth if safe

This phase should improve the user’s understanding of Growth/Journey depth without redesigning the whole Journey IA.

**Critical safety rule:**  
Do not go haywire deleting pages, routes, widgets, data, or current Journey flows for no reason.  
Do not rebuild a separate rings page unless a real finished one already exists.  
Do not redesign the entire Growth/Journey system.  
Only improve discoverability, clarity, and safe surfacing of what already exists.

> “And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

---

## TASK TYPE

Discoverability refinement, Journey/Growth exposure audit, and safe linking/presentation improvements.

---

## PRODUCT GOAL

Make the Growth/Journey experience feel deeper and clearer by surfacing already-live areas more intentionally:
- Statistics
- Garden
- ring/progress explanation
- optionally Ocean depth where helpful

This phase should:
1. audit the current Journey/Growth hubs,
2. identify the best exposure points,
3. improve visibility of the strongest secondary pages,
4. clarify ring/progress metrics without inventing a fake standalone surface,
5. preserve routing and current ownership.

---

## EXECUTION RULES

1. **Audit first before editing.**
2. **Do not rebuild Journey architecture.**
3. **Do not create a fake standalone rings page just because rings exist as data/components.**
4. **Prefer a few strong discoverability improvements over many noisy links.**
5. **Keep the UI calm and premium.**
6. **Reuse existing page shell and card patterns.**
7. **Preserve localization readiness.**
8. **Run analyzer and relevant tests at the end.**
9. **Provide one full audit summary at the end.**

---

# IMPLEMENTATION SCOPE

## A. Audit current Journey/Growth exposure first

Inspect at minimum:
- `growth_home_page.dart`
- `growth_browse_all_page.dart`
- `growth_tracking_dashboard_page.dart`
- relevant journey/growth route files
- any summary providers or ring/progress data providers already used in the UI
- Home references to Journey/Growth where relevant

Determine:
- what is already strongly exposed
- what is weakly exposed
- what ring/progress metrics currently show and where
- whether Statistics and Garden deserve stronger placement
- whether Ocean is already sufficiently exposed or still too buried

---

## B. Improve Statistics discoverability

Strengthen access to the existing Journey Statistics surface.

Possible safe improvements:
- better placement on the Growth home page
- stronger card copy/title/subtitle
- better Browse All exposure
- better explanation of why the user would open Statistics

Do not add clutter.
Do not create duplicate entry points everywhere.

---

## C. Improve Garden discoverability

Strengthen access to the existing Garden surface.

Possible safe improvements:
- stronger Growth home exposure
- better descriptive copy
- clearer “why this matters” framing
- better placement relative to other Growth tools

The Garden should feel like a real part of the Journey system, not a side page.

---

## D. Improve ring/progress visibility without a separate rings page

This is the most important part.

Audit how ring/progress data is currently surfaced and improve it in a safe way.

Possible safe directions:
- a ring/progress summary module inside Growth home
- better explanation inside Statistics
- better explanation inside Progress
- a clearer card that introduces what the rings/progress metrics mean
- stronger links from summary metrics to the correct existing owner page

Important:
- do not invent a standalone rings page unless one already truly exists
- if rings are component-level metrics, keep them integrated into the correct Growth owners

Clarify for the user:
- what the rings/progress metrics represent
- where they can go to see more
- how this fits into the Journey system

---

## E. Optionally improve Ocean depth exposure if clearly safe

Ocean is already reachable, but the audit suggested `oceanCommunityDetails` is mostly second-step.

If there is a very safe improvement:
- strengthen Ocean visibility from Growth
- or make community depth slightly more discoverable

Do not force this if it adds clutter.
This is secondary to Statistics/Garden/rings.

---

## F. Improve copy and discoverability cues

Where useful:
- refine Journey card labels/subtitles
- make Statistics, Garden, and progress/rings feel distinct
- reduce vague labels
- make entry points more understandable

Examples of distinctions that should be clearer:
- Statistics = measures and trends
- Garden = visual growth metaphor / progress state
- Progress/rings = daily/ongoing completion signals
- Ocean = personal + community drop contribution

---

## G. Keep ownership and routes stable

Do not:
- rename routes broadly
- move ownership away from Journey/Growth
- remove current access paths
- revive retired placeholder concepts like old `journey-rings` pages

This phase is about **clearer surfacing**, not architecture change.

---

## H. Optional small Home discoverability improvement

If there is one extremely safe, high-value win:
- consider a better Home shortcut or search/discovery cue into **Growth Statistics** or **Garden**

Only do this if:
- the placement is obvious
- the feature is clearly production-ready
- it does not require redesign

Do not make Home noisy.

---

## I. Add focused tests and validation

Add/update focused tests for:
- Journey/Growth route exposure
- surfaced Statistics/Garden entry integrity
- ring/progress module route behavior if changed
- no regressions to existing Journey routing

Run:
- `flutter analyze`
- relevant focused tests

---

# VALIDATION

After implementation, validate:

1. `/journey` still works correctly
2. Statistics is more clearly discoverable
3. Garden is more clearly discoverable
4. ring/progress metrics are more understandable and visibly owned
5. no fake standalone rings page was introduced unless a real one existed
6. Ocean exposure remains coherent if touched
7. no routing regressions were introduced
8. `flutter analyze` passes
9. relevant tests pass
10. localization remains valid

---

# DELIVERABLES

Provide a concise summary with:

1. **Audit findings before changes**
   - what was already exposed
   - what was weakly exposed
   - how rings/progress were actually implemented

2. **Discoverability improvements**
   - Statistics visibility improvements
   - Garden visibility improvements
   - ring/progress visibility/explanation improvements
   - Ocean improvement if any

3. **Files changed**
   - updated files
   - new tests/docs if any

4. **Validation**
   - analyzer
   - tests
   - behavior stability

5. **Final audit**
   - whether Journey/Growth now better exposes its depth
   - whether rings are now clearer to users
   - what the next highest-value discoverability phase should be

# END OF PROMPT
