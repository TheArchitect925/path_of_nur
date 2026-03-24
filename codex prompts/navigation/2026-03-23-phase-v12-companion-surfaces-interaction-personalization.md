# ===== PHASE V12 PROMPT — COMPANION SURFACES INTERACTION + PERSONALIZATION =====

## PRIMARY OBJECTIVE === BUILDING COMPANION SURFACES INTERACTION + PERSONALIZATION

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows:
- V4: Navigation stabilization
- V5: Alias integrity + `learnLegacy` clarification
- V6: Hidden metadata ownership cleanup
- V7: Visible fallback audit
- V8: Companion surface ownership audit
- V9: Companion surfaces definition
- V10: Companion surfaces lightweight buildout
- V11: Companion surfaces content depth + refinement

Current state after V11:
- the following are now real owned surfaces:
  - `/learn/seerah`
  - `/learn/character`
  - `/learn/daily-wisdom`
- routing is stable
- content depth is better
- source handoffs are stronger
- what is now missing is **interaction quality, personalization, and stronger user continuity**

This phase is not about rebuilding the surfaces.
This phase is about making them feel more alive, useful, and personally relevant.

**Critical safety rule:**  
Do not go haywire deleting routes, data, records, widgets, or current flows for no reason.  
Build on top of the existing companion surfaces.  
Do not introduce heavy infrastructure or overcomplicated systems.

> “And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

---

## TASK TYPE

Interaction refinement, lightweight personalization, progress continuity, and UX polish for the companion surfaces.

---

## PRODUCT GOAL

Strengthen the three owned companion surfaces so they support:
- better return visits
- light personalization
- stronger continuity from Journey
- calmer but more interactive user experience

Focus on:

### 1. `/learn/seerah`
Improve guided entry, section focus, and return continuity

### 2. `/learn/character`
Improve action-oriented use, scenario relevance, and practical follow-up

### 3. `/learn/daily-wisdom`
Improve daily freshness, lightweight save/revisit flow, and source follow-up

Keep this:
- lightweight
- production-safe
- calm
- coherent with the app
- not overengineered

---

## EXECUTION RULES

1. **Audit the current V11 implementation first.**
2. **Do not rebuild architecture or content systems.**
3. **Prefer lightweight local-state or existing persistence patterns where practical.**
4. **Do not add heavy recommendation engines or backend-like personalization.**
5. **Reuse existing Journey/progress/persistence hooks if safe.**
6. **Keep routing stable.**
7. **Preserve localization readiness.**
8. **Add focused tests only where useful.**
9. **Run analyzer and relevant tests at the end.**
10. **Provide a full audit summary at the end.**

---

# IMPLEMENTATION SCOPE

## A. Audit current interaction gaps first

Audit:
- Seerah companion page
- Character companion page
- Daily Wisdom companion page
- companion models/content
- journey handoff behavior
- persistence options already available in app

Identify:
- where continuity is weak
- where interaction is too static
- where users cannot easily resume, save, or follow up
- where personalization would help most without overbuilding

---

## B. Improve `/learn/seerah` interaction + continuity

### Goal
Make Seerah feel like a guided companion rather than a static page.

### Add/strengthen areas such as:
1. focused section entry polish
   - strengthen `focus=hijrah`
   - strengthen `focus=madinah-society`
   - optional focus chips / highlighted section state

2. lightweight resume continuity
   - remember last opened Seerah focus/section if practical
   - show a “continue exploring” card if safe and useful

3. deeper action cues
   - clearer next steps from each Seerah period
   - stronger handoff wording to History / Hadith / Qur’an linked modules

Do not build a massive progress system.

---

## C. Improve `/learn/character` interaction + practical use

### Goal
Make Character more actionable and habit-forming.

### Add/strengthen areas such as:
1. “focus on one trait” behavior
   - allow selecting a trait and emphasizing it in the page
   - optional lightweight remembered focus

2. practical scenario follow-through
   - make scenario cards more interactive/useful
   - connect them to source/supporting modules more clearly

3. lightweight personal action layer
   - simple “practice today” / “reflect on this” style callout
   - no heavy task engine
   - no giant habit tracker rebuild

This should stay calm and practical.

---

## D. Improve `/learn/daily-wisdom` interaction + revisit quality

### Goal
Make Daily Wisdom feel fresh and revisit-friendly.

### Add/strengthen areas such as:
1. better daily rotation behavior
   - stable daily selection or similarly calm behavior
   - avoid noisy randomness

2. lightweight save/revisit ability
   - bookmark/favorite/save for later if there is a safe reuse pattern
   - or a simple recent/seen state if more appropriate

3. stronger source follow-up
   - make it easier to go from wisdom entry to the owning surface

4. better “carry this today” continuity
   - reinforce the practical step without turning it into a task engine

Do not turn this into notifications, journaling, or a social feed.

---

## E. Shared personalization / persistence layer

If useful, add a lightweight companion preferences/state model using existing app persistence conventions.

Possible examples:
- last viewed Seerah focus
- selected Character trait
- recent or saved Daily Wisdom entries
- dismissed/seen states

### Rules
- prefer simple local persistence
- keep ownership clean
- do not build a broad settings framework just for this
- keep the model scoped to companion surfaces only

---

## F. Polish source handoffs and entry intent

Where useful:
- improve entry chip labels
- improve focus-aware headers/subtitles
- improve “continue” copy
- improve contextual handoff wording

Do not add clutter.
Keep the tone calm and premium.

---

## G. Optional Learn / Journey refinement

If there is a very small, safe win:
- improve how Journey lands into the new surfaces
- improve how Learn cards open them
- improve focus-aware entry states

Do not redesign Learn or Journey IA.

---

## H. Localization quality

If new strings are needed:
- add them cleanly
- keep them localization-ready
- do not scatter hardcoded user-facing strings

If non-English ARBs still contain English fallback from V10/V11:
- keep the structure intact
- do not block this phase on full translation work
- report it clearly in the summary

---

## I. Tests and validation

Add/update focused tests for:
- focus entry behavior
- lightweight persistence if added
- route stability
- daily wisdom selection behavior if changed

Do not add noisy tests.
Add useful coverage only.

---

# VALIDATION

After implementation, validate all of the following:

## Seerah
1. `/learn/seerah` still works
2. focus entry behavior is improved and stable
3. continuity/resume behavior works if added

## Character
4. `/learn/character` still works
5. trait focus behavior works if added
6. scenario/action flow is more useful

## Daily Wisdom
7. `/learn/daily-wisdom` still works
8. daily selection behavior is stable
9. save/revisit or recent-state behavior works if added

## Stability
10. Journey handoffs still work
11. Learn integration still works
12. no routing regressions introduced
13. deep-link behavior still works

## Code health
14. `flutter analyze` passes
15. relevant tests pass
16. localization remains valid

---

# DELIVERABLES

Provide a concise summary with:

1. **Audit findings before interaction work**
   - what felt static
   - what continuity/personalization gaps were found

2. **Seerah improvements**
   - focus/continuity/interactions improved

3. **Character improvements**
   - trait/scenario/practical action behavior improved

4. **Daily Wisdom improvements**
   - daily rotation/save/revisit/source handoff improved

5. **Shared persistence/personalization changes**
   - what lightweight state model was added or refined

6. **Files changed**
   - updated files
   - new files/tests/docs if any

7. **Validation**
   - analyzer
   - tests
   - behavior stability

8. **Final audit**
   - whether the companion surfaces now feel more interactive and personally useful
   - what the next highest-value phase should be

---

# IMPORTANT SAFETY / PRODUCT RULE

This is an **interaction + personalization phase**.

Do not:
- rebuild architecture
- add heavyweight systems
- create noisy gamification here
- break routing/ownership
- delete things for no reason

Do:
- improve continuity
- improve personal usefulness
- keep the experience calm
- build lightweight, real interaction quality

# END OF PROMPT
