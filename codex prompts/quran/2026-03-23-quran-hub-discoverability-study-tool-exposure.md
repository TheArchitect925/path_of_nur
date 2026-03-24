# PHASE PROMPT — QUR’AN HUB DISCOVERABILITY + STUDY TOOL EXPOSURE

## PRIMARY OBJECTIVE === BUILDING QUR’AN HUB DISCOVERABILITY + STUDY TOOL EXPOSURE

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows an audit of unlinked functionality and orphaned features.

Key audit finding:
- there are not many truly orphaned pages
- the main issue is **secondary discoverability**
- the highest-value discoverability gap is inside the **main Qur’an hub**

The audit identified these live but weakly exposed Qur’an study surfaces:
- `quranKnowledgeSearch`
- `quranSurahInsightsBrowse`
- `quranTopicExplorer`
- `quranTopWords`
- `quranWordReview`

These are already implemented and route-backed, but they are not strongly surfaced from the main `/quran` hub.

This phase should improve discoverability of these existing tools from the main Qur’an hub in a clean, production-safe way.

**Critical safety rule:**  
Do not go haywire deleting routes, pages, widgets, or current hub behavior for no reason.  
Do not redesign the whole Qur’an IA.  
Do not rebuild existing tools.  
Only improve exposure and discoverability of already-live study surfaces.

> “And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

---

## TASK TYPE

Discoverability refinement, Qur’an hub exposure audit, and safe linking improvements.

---

## PRODUCT GOAL

Make the main Qur’an hub a better entry point to the broader study layer, without cluttering it or turning it into a giant dump of links.

Users should more clearly discover existing study tools such as:
- knowledge search
- surah insights browse
- topic exploration
- top words
- word review

This phase should:
1. audit the current Qur’an hub structure,
2. determine the best exposure pattern for these tools,
3. add clear owned entry points from the main Qur’an hub,
4. preserve current routes and behavior,
5. keep the experience calm and premium.

---

## EXECUTION RULES

1. **Audit first before editing.**
2. **Do not rebuild the existing Qur’an tools.**
3. **Do not redesign the entire Qur’an hub.**
4. **Prefer a small number of strong entry points over many weak ones.**
5. **Keep the UI calm and uncluttered.**
6. **Reuse existing page shell and card patterns.**
7. **Preserve localization readiness.**
8. **Run analyzer and relevant tests at the end.**
9. **Provide one full summary at the end.**

---

# IMPLEMENTATION SCOPE

## A. Audit the current Qur’an hub first

Inspect at minimum:
- `quran_app_hub_page.dart`
- `learn_quran_hub_page.dart`
- relevant Qur’an route files
- any companion/secondary study entry surfaces
- current handoffs from `/quran` to deeper study pages

Determine:
- what is already strongly exposed
- what is only exposed from secondary hubs
- what feels hidden despite being product-ready
- what should be surfaced directly from the main Qur’an hub

---

## B. Improve exposure of the broader study layer

Safely expose the most valuable existing study tools from the main Qur’an hub.

Priority candidates:
- `quranKnowledgeSearch`
- `quranSurahInsightsBrowse`
- `quranTopicExplorer`
- `quranTopWords`
- `quranWordReview`

For each surfaced tool:
- use clear user-facing labeling
- make the purpose obvious
- avoid overly technical names if the UI wording can be improved
- keep the route target canonical

---

## C. Keep the hub structured and calm

Do not just add a long list of buttons.

Use a structured approach such as:
- a “Study tools” section
- a “Deeper exploration” section
- or another clean grouping that fits the current page design

The hub should remain:
- readable
- premium
- not cluttered
- easy to scan

---

## D. Improve copy and discoverability cues

Where useful:
- refine titles/subtitles for surfaced study cards
- explain briefly why each tool is useful
- help users distinguish search vs insights vs topics vs vocabulary/review

Do not add excessive text.

---

## E. Preserve current ownership and routes

Do not:
- rename route names broadly
- move ownership out of Qur’an
- replace working tools
- remove secondary access paths

This phase is about **exposure**, not restructuring.

---

## F. Add focused tests and validation

Add/update focused tests for:
- Qur’an hub route exposure
- surfaced tool route integrity
- no regressions to existing Qur’an routing

Run:
- `flutter analyze`
- relevant focused tests

---

# VALIDATION

After implementation, validate:

1. `/quran` still works correctly
2. the main Qur’an hub now exposes the broader study layer more clearly
3. surfaced study tools route correctly
4. no clutter or obvious UX regression was introduced
5. no routing regressions were introduced
6. `flutter analyze` passes
7. relevant tests pass
8. localization remains valid

---

# DELIVERABLES

Provide a concise summary with:

1. **Audit findings before changes**
   - what was already exposed
   - what was weakly exposed

2. **Discoverability improvements**
   - which study tools are now surfaced from the main Qur’an hub
   - how they are grouped
   - how copy/labels improved

3. **Files changed**
   - updated files
   - new tests/docs if any

4. **Validation**
   - analyzer
   - tests
   - behavior stability

5. **Final audit**
   - whether the main Qur’an hub now better represents the broader study layer
   - what the next highest-value discoverability phase should be

# END OF PROMPT
