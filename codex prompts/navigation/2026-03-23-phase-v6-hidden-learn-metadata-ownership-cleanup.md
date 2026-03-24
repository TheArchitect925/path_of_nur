# Phase V6 Prompt — Hidden Learn Metadata Ownership Cleanup

## PRIMARY OBJECTIVE === BUILDING HIDDEN LEARN METADATA OWNERSHIP CLEANUP

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows the completed navigation stabilization work from V4 and the navigation gap audit from V5.

Current state after V5:
- active surfaced Learn discovery is already mostly canonical
- retained Learn aliases are tested and stable
- `learnLegacy` is now understood as a **hidden compatibility surface**
- the remaining navigation debt is primarily in **hidden catalog and Learning Journey metadata**
- these hidden references are not safe to rewrite blindly

This phase is a **narrow audit + normalization pass** focused on hidden Learn metadata ownership only.

**Critical safety rule:**  
Do not go haywire deleting routes, metadata, records, lesson links, journey links, or screens for no reason.  
Do not replace hidden route targets blindly.  
Only normalize references that are clearly safe and clearly mapped to canonical feature-owned destinations.

> “And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

---

## TASK TYPE

Audit hidden Learn metadata, normalize safe legacy route targets, preserve hidden compatibility where still required, and document unresolved ownership cleanly.

---

## PRODUCT GOAL

After V5, the routing system is stable, but hidden route ownership debt remains in:
- hidden Learn catalog items
- Learning Journey registry metadata
- Learning Journey lesson content
- related hidden widgets / metadata-driven navigation

This phase should:
1. audit all hidden `learnLegacy` references,
2. determine which ones are still truly needed,
3. replace only clearly safe ones with canonical destinations,
4. preserve hidden compatibility where ownership is still ambiguous,
5. leave behind a cleaner, more explicit metadata ownership model.

This is **not** an IA redesign.  
This is **not** broad route deletion.  
This is **not** a user-facing routing rewrite.

---

## EXECUTION RULES

1. **Audit first before editing.**
2. **Do not remove `learnLegacy` unless it is fully proven unused and safe.**
3. **Do not rewrite hidden metadata links unless the canonical replacement is clearly correct.**
4. **Do not guess route ownership.**
5. **If a metadata link is ambiguous, keep it and document it instead of forcing a rewrite.**
6. **Preserve route names and deep-link behavior unless a change is fully safe.**
7. **Preserve localization.**
8. **Add focused tests if metadata-driven navigation behavior changes.**
9. **Run analyzer and summarize final results.**
10. **At the very end, provide one full audit summary so the next phase can be planned cleanly.**

---

# IMPLEMENTATION SCOPE

## A. Audit all hidden `learnLegacy` references

Audit all remaining hidden compatibility references, including at minimum:

- `learn_category_catalog.dart`
- `learning_journey_registry.dart`
- `learning_journey_lesson_content.dart`
- `learning_journey_widgets.dart`

For each `learnLegacy` usage, determine:
- is it active or only hidden
- is it user-reachable through normal surfaced discovery
- is it only used through metadata/journey fallback flows
- does it have an obvious canonical replacement
- is the current target still semantically correct
- would changing it alter behavior unexpectedly

Create a classified list of hidden references:
- **safe to normalize**
- **needs compatibility retention**
- **ambiguous / defer**

---

## B. Normalize only clearly safe metadata route targets

For hidden metadata links that are clearly safe:
- replace `learnLegacy` route targets with canonical feature-owned route targets
- prefer existing canonical routes
- preserve query/path parameter behavior
- preserve user intent of the original metadata link

Examples of acceptable replacements only if clearly correct:
- hidden content links → canonical `/learn/explore`
- hidden Qur’an learning links → canonical `/quran/*`
- hidden Prophets links → canonical `/learn/prophets`
- hidden Quizzes links → canonical `/learn/quizzes`

### Rules
- do not rewrite broad groups with search/replace
- do not assume one canonical destination fits all legacy references
- each hidden reference must be justified by actual meaning

---

## C. Preserve ambiguous hidden references safely

If a hidden metadata route target is still meaningful but does not yet have a clean feature-owned replacement:
- keep it as `learnLegacy`
- add a concise comment or ownership marker if helpful
- document it in the backlog / audit output

The correct outcome for ambiguous references is **retention + documentation**, not forced normalization.

---

## D. Clarify metadata ownership in code

Where useful, add concise comments to make hidden ownership clearer, for example:
- hidden compatibility route target
- legacy library-style Learn destination retained for old journey metadata
- canonical replacement not yet semantically one-to-one

Do not spam comments everywhere.  
Only annotate where it improves future safety.

---

## E. Audit hidden catalog visibility rules

Inspect hidden catalog items and verify:
- they are still intentionally hidden
- they are not accidentally appearing in surfaced discovery
- any hidden item still pointing to `learnLegacy` is either safe or explicitly deferred

Do not redesign catalog visibility.  
Just verify it and normalize safe ownership where appropriate.

---

## F. Audit metadata-driven journey links

Inspect Learning Journey metadata-driven navigation and determine:
- which hidden links are still semantically correct
- which should now point to canonical feature routes
- which still rely on `learnLegacy` because no clean replacement exists

Be especially careful not to break:
- older lesson/tool links
- fallback content browsing behavior
- hidden educational flows that still depend on broad library-style Learn access

---

## G. Add focused regression coverage

Add or update targeted tests for any metadata-driven navigation that changes.

Useful coverage may include:
- hidden catalog route target normalization
- metadata link resolves to canonical target where expected
- retained hidden compatibility targets remain stable
- no broken hidden route resolution introduced

Do not add noisy tests.  
Add focused safety coverage only.

---

## H. Keep visible product behavior unchanged

This phase should not change:
- surfaced Learn landing behavior
- top-level tabs
- shell navigation
- canonical Qur’an behavior
- active quiz/kids/FAQ/tools routing
- child restrictions
- deep link mapping
- compatibility alias behavior already protected in V5

This is a hidden metadata ownership pass only.

---

# VALIDATION

After implementation, validate all of the following:

## Hidden metadata safety
1. all audited hidden `learnLegacy` references are classified
2. clearly safe references were normalized
3. ambiguous references were preserved and documented
4. no blind route replacement occurred

## Visible behavior stability
5. surfaced Learn discovery still behaves the same
6. canonical top-level routes still resolve
7. alias tests still pass
8. no deep-link behavior regressed

## Code health
9. analyzer passes
10. targeted tests pass
11. localization unchanged unless absolutely required

---

# DELIVERABLES

Implement the hidden metadata ownership cleanup pass.

Then provide a concise summary with:

1. **Audit findings before changes**
   - all hidden `learnLegacy` seams found
   - which were safe to normalize
   - which were ambiguous
   - which were intentionally retained

2. **Files changed**
   - updated files
   - new tests/docs/helpers created

3. **Normalization decisions**
   - which hidden metadata links were changed to canonical targets
   - why each class of change was safe
   - what remained compatibility-only

4. **Retained legacy ownership**
   - which `learnLegacy` references were intentionally preserved
   - why they were preserved

5. **Validation**
   - analyzer results
   - tests run
   - confirmation that visible behavior stayed unchanged

6. **Final audit**
   - whether hidden Learn metadata ownership is now cleaner
   - what the next highest-value cleanup phase should be

---

# IMPORTANT SAFETY / PRODUCT RULE

This is a **narrow metadata ownership cleanup pass**.

Do not redesign IA.  
Do not remove compatibility aggressively.  
Do not mass-rewrite hidden route targets without semantic verification.  
Do not delete records or links for no reason.

Normalize carefully.  
Preserve behavior.  
Document ambiguity honestly.

# END OF PROMPT
