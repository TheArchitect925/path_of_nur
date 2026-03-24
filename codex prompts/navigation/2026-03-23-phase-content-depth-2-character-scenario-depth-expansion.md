# ===== PHASE CONTENT DEPTH 2 PROMPT — CHARACTER SCENARIO DEPTH EXPANSION =====

## PRIMARY OBJECTIVE === BUILDING CHARACTER SCENARIO DEPTH EXPANSION

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows the latest content audit and the Seerah depth pass.

Current state from the audit:
- `/learn/character` is the strongest practical-use companion surface
- ownership is already correct
- the main gap is **scenario depth and variation**
- current weaknesses identified in the audit:
  - `neighbors` is still broad
  - `consistency` is still broad
  - some cards feel structurally repetitive
  - the page risks feeling like a curated overlay on Divine Life rather than a deeper character/adab companion
- one strong next opportunity identified:
  - add a scenario lane such as **work/study pressure**

This phase is a **content-depth and scenario refinement phase**, not a routing or architecture phase.

**Critical safety rule:**  
Do not go haywire deleting routes, pages, content models, or working flows for no reason.  
Build on top of the existing Character / Adab companion surface.  
Do not duplicate Divine Life or Hadith systems blindly.

> “And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

---

## TASK TYPE

Curated scenario expansion and practical behavior refinement for `/learn/character`.

---

## PRODUCT GOAL

Strengthen `/learn/character` so it feels:
- more practical
- more behavior-oriented
- less repetitive in rhythm
- more useful in everyday life

The surface should remain:
- calm
- premium
- action-oriented
- lightweight
- source-connected
- production-safe

But it should gain one more layer of practical depth.

---

## EXECUTION RULES

1. **Audit the current Character companion implementation first.**
2. **Do not redesign routing or ownership.**
3. **Do not rebuild Divine Life, Hadith, or Qur’an systems.**
4. **Prefer depth in fewer strong scenarios over adding lots of weak ones.**
5. **Keep trait guidance distinct from scenario guidance.**
6. **Preserve localization readiness.**
7. **Add focused tests only where useful.**
8. **Run analyzer and relevant tests at the end.**
9. **Provide one full summary at the end.**

---

# IMPLEMENTATION SCOPE

## A. Audit current Character content first

Inspect at minimum:
- `learn_companion_content.dart`
- `character_companion_page.dart`
- any supporting companion models/content helpers
- any focus or personalization behavior already present

Confirm:
- which traits are already present
- which scenarios are already present
- where copy feels too similar in structure
- where scenario cards are too broad to feel useful
- where trait guidance and scenario guidance blur together

---

## B. Strengthen weaker existing scenarios

Specifically deepen and improve these weaker areas:

### 1. Neighbors
Make it feel more practical and specific:
- rights of neighbors
- everyday kindness
- boundaries, patience, and presence
- how this shows up in normal life

### 2. Consistency
Make it more useful and less abstract:
- small regular actions
- steadiness over intensity
- daily faithfulness in conduct and worship
- how to continue when motivation fluctuates

These should feel like strong real-life companion scenarios, not vague virtues.

---

## C. Add one new high-value scenario lane

Add a meaningful scenario such as:

### Work / Study Pressure
Examples of themes:
- pressure without losing adab
- intention and excellence
- stress, patience, and self-control
- character under workload
- consistency during busy seasons

If another scenario is clearly a better fit based on the current content structure, you may choose it instead — but it must be practical, high-value, and clearly distinct from what already exists.

For the new scenario, include:
- title
- concise explanation
- why it matters
- practical application
- clean supporting handoff(s)

---

## D. Improve trait/scenario distinction

Right now the audit suggests some repetition in rhythm.

Refine the page so:
- **traits** feel like core inner qualities / virtues
- **scenarios** feel like lived situations where those qualities are practiced

This distinction should be visible in:
- copy tone
- section descriptions
- card structure
- action framing

Do not radically redesign the page.  
Just make the distinction clearer and more useful.

---

## E. Strengthen practical application tone

For key scenarios, improve:
- “practice today”
- “carry this into your day”
- practical next-step language

The surface should feel grounded and behavioral, not just descriptive.

Do not create a full habit/task engine.

---

## F. Improve source handoffs where needed

Strengthen and refine handoffs from Character into:
- Hadith
- Divine Life / Life lessons
- Qur’an reflection

Important:
- keep them semantically correct
- make them feel intentional
- avoid generic or repetitive destination patterns

---

## G. Keep implementation lightweight but real

### DO:
- deepen a small number of scenarios well
- add one strong new scenario lane
- improve practical usefulness
- improve trait/scenario distinction
- strengthen source handoffs

### DO NOT:
- build a full character curriculum engine
- add lots of filler scenarios
- duplicate entire Divine Life modules
- redesign the whole page

---

## H. Tests and validation

Add/update focused tests if needed for:
- route stability
- content integrity
- focus behavior if affected

Run:
- `flutter analyze`
- relevant focused tests

---

# VALIDATION

After implementation, validate:

1. `/learn/character` still works
2. neighbors and consistency feel more specific and useful
3. the new scenario lane exists meaningfully
4. trait vs scenario distinction is clearer
5. practical application tone is stronger
6. source handoffs remain semantically correct
7. no routing regressions introduced
8. `flutter analyze` passes
9. relevant tests pass
10. localization remains valid

---

# DELIVERABLES

Provide a concise summary with:

1. **Audit findings before changes**
   - which scenario areas were weak
   - what was prioritized

2. **Scenario depth improvements**
   - how neighbors improved
   - how consistency improved
   - what new scenario lane was added
   - why these changes were useful

3. **Trait/scenario distinction improvements**
   - what was changed to reduce repetition and improve clarity

4. **Source handoff improvements**
   - what was strengthened
   - why

5. **Files changed**
   - updated files
   - new tests/docs if any

6. **Validation**
   - analyzer
   - tests
   - behavior stability

7. **Final audit**
   - whether `/learn/character` now feels more practical and distinct
   - what the next highest-value phase should be

# END OF PROMPT
