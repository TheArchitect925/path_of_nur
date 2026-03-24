# ===== PHASE CONTENT DEPTH 1 PROMPT — SEERAH PERIOD DEPTH EXPANSION =====

## PRIMARY OBJECTIVE === BUILDING SEERAH PERIOD DEPTH EXPANSION

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows the completed companion-surface ownership and build work.

Current state from the latest content audit:
- `/learn/seerah` is the strongest overall companion surface
- it already has clear ownership, meaningful focused entry states, and coherent handoffs
- the main weakness is not routing or ownership
- the main weakness is **content depth**, especially:
  - `turning-points`
  - `early-makkah`
  - `final-sermon`
- the audit also identified a good next expansion opportunity:
  - add one more curated layer for **Hudaybiyyah**, **Conquest of Makkah**, and **Farewell Hajj**

This phase is a **content-depth phase**, not a routing phase and not a broad system redesign.

**Critical safety rule:**  
Do not go haywire deleting routes, pages, content models, records, or current flows for no reason.  
Build on top of the existing Seerah companion surface.  
Do not try to build a giant Seerah encyclopedia.

> “And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

---

## TASK TYPE

Curated content expansion and structure refinement for `/learn/seerah`.

---

## PRODUCT GOAL

Strengthen `/learn/seerah` so it feels like a richer guided Seerah companion and less like a compact curated bridge.

The page should remain:
- calm
- premium
- readable
- structured
- lightweight
- future-scalable

But it should gain one more layer of meaningful depth.

---

## EXECUTION RULES

1. **Audit the current Seerah companion implementation first.**
2. **Do not redesign routing or ownership.**
3. **Do not rebuild Prophets, History, Hadith, or Qur’an systems.**
4. **Prefer curated depth over lots of filler cards.**
5. **Do not invent a giant timeline engine.**
6. **Keep focused entry behavior stable.**
7. **Preserve localization readiness.**
8. **Add focused tests only if useful.**
9. **Run analyzer and relevant tests at the end.**
10. **Provide one full audit summary at the end.**

---

# IMPLEMENTATION SCOPE

## A. Audit current Seerah content first

Inspect at minimum:
- `learn_companion_content.dart`
- `seerah_companion_page.dart`
- any supporting companion models/content helpers
- any focus-entry logic for:
  - `focus=hijrah`
  - `focus=madinah-society`

Confirm:
- what content exists today
- where current period depth is thin
- which cards are acting as bridges instead of meaningful content
- where supporting source handoffs are too compact

---

## B. Strengthen existing weak periods

Refine the current Seerah periods, especially:

### 1. Early Makkah
Strengthen:
- what happened in this phase
- why it matters spiritually and historically
- what the user should explore next

### 2. Turning Points
This is currently the thinnest area.
Deepen it so it feels like a real Seerah module rather than a shortcut bucket.

### 3. Final Sermon / Farewell
Strengthen:
- significance
- why it matters today
- what it connects to next

---

## C. Add one more curated layer for high-value Seerah moments

Add structured curated content for:
- **Hudaybiyyah**
- **Conquest of Makkah**
- **Farewell Hajj**

These do not need full subpages yet unless trivially reusable.
But they should meaningfully exist in the Seerah companion surface as real guided content.

For each, include:
- short title
- concise explanation
- why it matters
- what the user can explore next
- clean related-source handoff if appropriate

---

## D. Improve period/module usefulness

Each Seerah period/module should feel more useful, not just descriptive.

Improve:
- short descriptions
- “why this matters” clarity
- suggested next step
- related source handoffs

Do not make the page dense or cluttered.

---

## E. Improve supporting source handoffs

Strengthen curated links from Seerah into:
- History archive
- Hadith
- Qur’an-linked learning
- Prophets where relevant

Important:
- keep handoffs semantically correct
- avoid generic “more info” style links
- make them feel intentional

---

## F. Preserve and lightly improve focus entry behavior

If useful and safe:
- improve how the page lands when entered from Hijrah or Madinah-related journey actions
- make focused entry states feel slightly more intentional

Do not add a complicated state machine.

---

## G. Keep implementation lightweight but real

### DO:
- deepen current content
- add curated Seerah modules
- strengthen handoffs
- improve weak sections

### DO NOT:
- build a huge database
- create an encyclopedia
- redesign the Seerah surface completely
- duplicate full content from History/Hadith/Prophets

---

## H. Tests and validation

Add/update focused tests if needed for:
- route stability
- focus entry behavior
- content integrity if helpful

Run:
- `flutter analyze`
- relevant focused tests

---

# VALIDATION

After implementation, validate:

1. `/learn/seerah` still works
2. focus entry behavior still works
3. content depth is stronger
4. Hudaybiyyah / Conquest of Makkah / Farewell Hajj now exist meaningfully
5. source handoffs remain semantically correct
6. no routing regressions introduced
7. `flutter analyze` passes
8. relevant tests pass
9. localization remains valid

---

# DELIVERABLES

Provide a concise summary with:

1. **Audit findings before changes**
   - which Seerah areas were thin
   - what was prioritized

2. **Content expansion completed**
   - what was added/refined
   - how early Makkah / turning points / final sermon improved
   - how Hudaybiyyah / Conquest of Makkah / Farewell Hajj were added

3. **Source handoff improvements**
   - what was strengthened
   - why

4. **Files changed**
   - updated files
   - new tests/docs if any

5. **Validation**
   - analyzer
   - tests
   - behavior stability

6. **Final audit**
   - whether `/learn/seerah` now feels meaningfully deeper
   - what the next highest-value phase should be

# END OF PROMPT
