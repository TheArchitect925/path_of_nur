# ===== PHASE QURAN ENRICHMENT PROMPT — JOURNEY ↔ QUR’AN STUDY INTEGRATION =====

## PRIMARY OBJECTIVE === BUILDING JOURNEY ↔ QUR’AN STUDY INTEGRATION

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows:
- ayah + surah enrichment
- reference quality hardening
- thematic map layer
- ayah reference detail sheet
- surah study hub expansion
- high-value surah coverage expansion

Current state:
- Qur’an reader is now rich with references and themes
- Surah study is structured and meaningful
- High-value surahs are better covered
- Journey system exists and is strong
- BUT the connection between **Journey learning and Qur’an study** is still not fully integrated

This phase is about:
👉 making Qur’an study feel like a natural extension of Journey  
👉 making Journey feel grounded in Qur’an where appropriate  

This is one of the highest-value product integrations.

**Critical safety rule:**  
Do not go haywire deleting routes, lessons, journeys, or Qur’an systems for no reason.  
Do not force Qur’an links into journeys where they do not belong.  
Integrate where it is semantically correct and useful.

---

## TASK TYPE

Cross-system integration, contextual entry design, and study flow enhancement between Journey and Qur’an.

---

## PRODUCT GOAL

Allow users to:
- enter the Qur’an reader with context (from a Journey)
- see Qur’an content through the lens of what they are learning
- move naturally between Journey lessons and Qur’an study
- deepen reflection without friction

---

# IMPLEMENTATION SCOPE

## A. Audit current Journey → Qur’an connections

Inspect:
- `learning_journey_registry.dart`
- `learning_journey_lesson_content.dart`
- journey lesson “related tools” and “Explore now” actions
- existing Qur’an routes:
  - `/quran`
  - `/quran/learning`
  - reader entry points with parameters

Determine:
- which journeys already connect to Qur’an meaningfully
- which are weak or generic
- which lessons SHOULD connect to Qur’an but do not yet

---

## B. Define contextual Qur’an entry patterns

Create clean entry patterns such as:

### 1. Theme-based entry
Example:
- patience journey → Qur’an reader with patience-related ayahs highlighted

### 2. Surah-based entry
Example:
- Yusuf journey → Surah Yusuf with enriched study context

### 3. Focus-based entry
Example:
- character lesson → Qur’an reader with:
  - focus=character
  - relevant references emphasized

### 4. Reflection-based entry
Example:
- daily wisdom → Qur’an ayah with reflection context

These should use:
- query parameters
- existing enrichment systems
- no heavy new routing system

---

## C. Improve Journey lesson handoffs

For relevant lessons:
- replace generic “Explore Qur’an” style actions with:
  - contextual entry
  - clear intent
  - meaningful starting point

Example:
- instead of “Open Qur’an”
- use:
  - “Study this in the Qur’an”
  - “See how this appears in the Qur’an”

---

## D. Improve Qur’an reader contextual awareness

When entering from Journey:
- show a subtle contextual cue:
  - “You’re studying: Patience”
  - “From your Journey: Hijrah”
- highlight:
  - relevant ayahs
  - relevant themes
  - relevant references

Keep this:
- lightweight
- non-intrusive
- optional

---

## E. Strengthen bidirectional linking

Not just Journey → Qur’an

Also:
- Qur’an → Journey

Example:
- ayah about patience → link to patience journey
- ayah about gratitude → link to gratitude journey

Do this only when:
- the mapping is strong
- the journey exists
- it adds real value

---

## F. Avoid over-linking

Do NOT:
- attach Qur’an links to every lesson
- attach Journey links to every ayah
- create noisy navigation

Keep:
- high-signal connections only

---

## G. Add focused tests

Test:
- contextual route entry
- parameter passing
- reader highlighting/focus behavior
- route stability

Run:
- `flutter analyze`
- relevant tests

---

# VALIDATION

After implementation:

1. Journey → Qur’an transitions feel intentional
2. Qur’an reader can open with meaningful context
3. No routing regressions
4. No UI clutter introduced
5. No broken deep links
6. `flutter analyze` passes
7. tests pass

---

# DELIVERABLES

1. Audit findings
2. Entry patterns defined
3. Journey → Qur’an improvements
4. Qur’an → Journey improvements
5. Files changed
6. Validation
7. Final audit

---

# END OF PROMPT
