# ===== PHASE CONTENT DEPTH 3 PROMPT — DAILY WISDOM DATASET VARIETY + PRACTICAL STEP REFINEMENT =====

## PRIMARY OBJECTIVE === BUILDING DAILY WISDOM DATASET VARIETY + PRACTICAL STEP REFINEMENT

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows the latest content audit, the Seerah depth pass, and the Character scenario depth pass.

Current state from the audit:
- `/learn/daily-wisdom` is the strongest lightweight companion surface
- ownership is already correct
- the main weaknesses are:
  - long-session value is still thin
  - several entries share a similar reflective tone
  - some practical steps feel templated
  - source-owner diversity can still improve as the dataset grows
- the next highest-value need is **dataset variety, tonal differentiation, and stronger practical-step quality**

This phase is a **content-depth and dataset refinement phase**, not a routing or architecture phase.

**Critical safety rule:**  
Do not go haywire deleting routes, pages, content models, datasets, or working flows for no reason.  
Build on top of the existing Daily Wisdom companion surface.  
Do not turn this into a quote spam feed, journaling system, or notifications engine.

> “And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

---

## TASK TYPE

Curated dataset expansion, tonal variety refinement, practical-step quality improvement, and source-owner integrity strengthening for `/learn/daily-wisdom`.

---

## PRODUCT GOAL

Strengthen `/learn/daily-wisdom` so it feels:
- richer over repeated visits
- calmer but less samey
- more useful in day-to-day life
- clearly connected to real source owners
- still lightweight and premium

The surface should remain:
- calm
- concise
- reflective
- practical
- production-safe
- lightweight

But it should gain one more layer of variety and usefulness.

---

## EXECUTION RULES

1. **Audit the current Daily Wisdom implementation first.**
2. **Do not redesign routing or ownership.**
3. **Do not rebuild Journal, Notes, Qur’an, Hadith, or reminders systems.**
4. **Prefer quality over quantity.**
5. **Increase tonal variety without becoming noisy or casual.**
6. **Keep practical steps realistic and calm.**
7. **Preserve localization readiness.**
8. **Add focused tests only where useful.**
9. **Run analyzer and relevant tests at the end.**
10. **Provide one full summary at the end.**

---

# IMPLEMENTATION SCOPE

## A. Audit current Daily Wisdom content first

Inspect at minimum:
- `learn_companion_content.dart`
- `daily_wisdom_companion_page.dart`
- any supporting companion models/content helpers
- any current daily selection / recent / saved behavior already present

Confirm:
- which wisdom entries already exist
- which themes are currently represented
- where tone feels repetitive
- where practical steps are too formulaic
- where owner diversity is weak
- where the page still feels too thin for repeat visits

---

## B. Expand the wisdom dataset thoughtfully

Add/refine entries across a balanced theme spread such as:
- mercy
- gratitude
- patience
- trust
- sincerity
- humility
- remembrance
- service
- hope
- reflection
- forgiveness
- steadiness

You do not need to add all of these if some are already present.
Prioritize the most useful gaps.

For each new or refined entry, include:
- strong title
- concise reflective body
- calm practical step
- clear source label / owner handoff
- enough distinction that entries do not all sound alike

Important:
Do not bulk-add filler entries.
A smaller, higher-quality dataset is better.

---

## C. Improve tonal variety

Right now the audit says several entries feel too similar in reflective tone.

Refine the dataset so the tone varies appropriately across entries, for example:
- some more comforting
- some more gently challenging
- some more gratitude-centered
- some more action-oriented
- some more contemplative

All while staying:
- calm
- premium
- spiritually appropriate
- consistent with the app

Do not become preachy, noisy, or overly dramatic.

---

## D. Improve practical-step quality

Refine “carry this today” / practical-step guidance so it feels:
- specific
- realistic
- not repetitive
- not overly generic
- not like a task-engine checklist

Examples of good direction:
- one calm behavioral shift
- one small reflection cue
- one relational action
- one remembrance-oriented act
- one intention reset

The practical step should feel like something a real user could actually carry into the day.

---

## E. Strengthen source-owner integrity

Improve source-owner mapping and handoff clarity.

For each wisdom entry, confirm or refine:
- its source label
- its destination handoff
- whether the owner is best represented by:
  - Qur’an
  - Hadith
  - Life / Divine Life
  - Prophets
  - another owned surface if appropriate

Avoid:
- generic handoffs
- mismatched owner labels
- repetitive routing patterns where a better owner exists

---

## F. Improve repeat-visit value lightly

If safe and useful, add small refinements that make repeat visits better, such as:
- slightly more varied recent entries
- better grouping of saved/recent items
- more meaningful source chips or theme chips
- better entry previews

Do not build a large review engine or archive system.

---

## G. Keep implementation lightweight but real

### DO:
- refine and expand the dataset thoughtfully
- improve tonal variation
- improve practical-step usefulness
- strengthen source-owner clarity
- lightly improve repeat-visit value

### DO NOT:
- build a giant wisdom CMS
- add dozens of filler entries
- turn this into journaling or reminders
- redesign the page architecture
- create noisy UI

---

## H. Tests and validation

Add/update focused tests if needed for:
- route stability
- content integrity
- daily selection behavior if affected
- source-owner mapping if a clean test is practical

Run:
- `flutter analyze`
- relevant focused tests

---

# VALIDATION

After implementation, validate:

1. `/learn/daily-wisdom` still works
2. the dataset feels richer and less repetitive
3. practical steps feel more varied and useful
4. source-owner handoffs remain semantically correct
5. repeat-visit value is improved without clutter
6. no routing regressions introduced
7. `flutter analyze` passes
8. relevant tests pass
9. localization remains valid

---

# DELIVERABLES

Provide a concise summary with:

1. **Audit findings before changes**
   - which themes/tone areas were weak
   - what was prioritized

2. **Dataset refinements**
   - what entries/themes were added or refined
   - how tonal variety improved
   - how practical steps improved

3. **Source-owner improvements**
   - what handoffs/labels were strengthened
   - why

4. **Repeat-visit refinements**
   - any small improvements made for revisit value

5. **Files changed**
   - updated files
   - new tests/docs if any

6. **Validation**
   - analyzer
   - tests
   - behavior stability

7. **Final audit**
   - whether `/learn/daily-wisdom` now feels richer and more durable
   - what the next highest-value phase should be

# END OF PROMPT
