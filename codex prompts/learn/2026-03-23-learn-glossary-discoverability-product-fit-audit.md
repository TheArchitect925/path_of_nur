# ===== PHASE PROMPT — LEARN GLOSSARY DISCOVERABILITY + PRODUCT FIT AUDIT =====

## PRIMARY OBJECTIVE === BUILDING LEARN GLOSSARY DISCOVERABILITY + PRODUCT FIT AUDIT

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows:
- the unlinked functionality / orphaned pages audit
- the Qur’an hub discoverability pass
- the Journey Statistics / Garden / ring visibility refinement pass

Key audit finding still outstanding:
- `learnGlossary` appears to be a real route-backed feature
- it is not strongly surfaced from the current Learn hub/taxonomy
- it is unclear whether this is:
  - a production-ready user-facing surface that deserves stronger discovery
  - a secondary utility that should remain lightly exposed
  - or a feature that still needs product shaping before being promoted

This phase should answer that clearly and make a safe improvement if the answer is obvious.

**Critical safety rule:**  
Do not go haywire deleting routes, glossary content, metadata, widgets, or Learn structures for no reason.  
Do not force-promote the Glossary if it is not product-ready.  
Audit first. Only make safe discoverability changes if clearly justified.

> “And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

---

## TASK TYPE

Feature discoverability audit, product-fit review, and safe Learn integration refinement.

---

## PRODUCT GOAL

Determine:
1. whether the Glossary is production-ready,
2. what problem it solves for users,
3. where it should live in Learn,
4. whether it should be strongly surfaced, lightly surfaced, or intentionally secondary,
5. whether any small safe exposure improvement should be made now.

This phase should avoid broad IA redesign and focus on a clear ownership/discoverability decision.

---

## EXECUTION RULES

1. **Audit first before editing.**
2. **Do not assume route-backed means product-ready.**
3. **Do not redesign the whole Learn hub.**
4. **Do not add noisy duplicate entry points.**
5. **Prefer one clear ownership decision over scattered weak exposure.**
6. **Preserve localization readiness.**
7. **Run analyzer/tests only if code is changed.**
8. **Provide a full audit summary at the end.**

---

# IMPLEMENTATION SCOPE

## A. Audit the Glossary surface first

Inspect at minimum:
- the route definition for `learnGlossary`
- the page/widget(s) backing the Glossary
- any dataset/models the Glossary uses
- current internal links into the Glossary if any
- Learn taxonomy/category structures
- search/discovery metadata if relevant

Determine:
- what the Glossary currently contains
- whether the UI feels production-ready
- whether it has enough content to justify promotion
- whether it is genuinely useful to users
- whether it duplicates other owned surfaces
- whether it is currently hidden intentionally or merely overlooked

---

## B. Evaluate product fit

Decide which of these is true:

### 1. STRONGLY SURFACE NOW
The Glossary is useful and ready, and it deserves a clear Learn entry.

### 2. LIGHTLY SURFACE ONLY
The Glossary is useful but secondary, so it should be accessible without being a major featured destination.

### 3. KEEP SECONDARY / DEFER
The Glossary exists but should remain secondary until content or UX is stronger.

### 4. INTERNAL / NOT READY
It is not yet ready for real promotion and should stay hidden.

Explain the reasoning clearly.

---

## C. If safe, improve discovery in the correct place

If the audit shows the Glossary is ready enough, implement the smallest safe discoverability improvement.

Possible safe options:
- add a Learn category/subcategory entry in the correct place
- add a Tools / Explore entry
- add a supporting card inside a relevant Learn page
- add a search/discovery keyword improvement if such metadata exists

Do NOT:
- add it everywhere
- create duplicate cards in multiple hubs
- over-promote it if it is only moderately ready

---

## D. Improve copy and framing if needed

If the feature is product-ready but the current framing is weak:
- improve the title/subtitle/description
- make it clear why a user would open it
- make it feel useful, not academic or buried

Keep copy concise and calm.

---

## E. Preserve route stability and ownership

Do not:
- rename routes broadly
- move ownership around unnecessarily
- remove the Glossary because it is weakly linked

This phase is about deciding the right exposure level.

---

## F. Add focused tests and validation

If code changes are made:
- add/update focused tests for route exposure and Learn discovery
- run `flutter analyze`
- run relevant focused tests

If no code changes are made:
- clearly state this was audit-only

---

# VALIDATION

After implementation (if any), validate:

1. the Glossary’s product role is clearly defined
2. any new exposure is appropriate and not noisy
3. Learn routing still works
4. no taxonomy/discovery regressions were introduced
5. `flutter analyze` passes if code changed
6. relevant tests pass if code changed
7. localization remains valid

---

# DELIVERABLES

Provide a concise summary with:

1. **Audit findings before changes**
   - what the Glossary currently is
   - how ready it feels
   - whether it is useful enough to surface

2. **Product-fit decision**
   - Strongly surface / lightly surface / defer / internal
   - why

3. **Discoverability improvements made**
   - only if any were actually made
   - where it is now exposed
   - why that placement is correct

4. **Files changed**
   - if any

5. **Validation**
   - analyzer/tests if applicable

6. **Final audit**
   - whether the Glossary is now appropriately exposed
   - what the next highest-value discoverability phase should be

# END OF PROMPT
