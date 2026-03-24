# ===== PHASE QURAN ENRICHMENT PROMPT — CREDIBILITY + KNOWLEDGE-TYPE LAYER =====

## PRIMARY OBJECTIVE === BUILDING CREDIBILITY + KNOWLEDGE-TYPE LAYER

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows:
- ayah + surah enrichment
- thematic map layer
- reference explanation layer
- surah study hub expansion
- high-value surah coverage
- Journey ↔ Qur’an integration
- reader UX polish
- memorization + review system
- adaptive study modes
- Qur’an learning path system

Current state:
- the Qur’an system is now rich and interconnected
- users see many types of references:
  - Hadith
  - character lessons
  - Seerah links
  - thematic links
  - journey connections
  - world/signs content
- BUT the system does not clearly communicate:
  👉 what type of knowledge each reference represents  
  👉 how “strong” or “direct” the connection is  

This creates a subtle trust and clarity gap.

This phase introduces:
👉 a **Credibility + Knowledge-Type Layer**

This will:
- clarify what kind of connection the user is seeing
- improve trust
- improve understanding
- prevent confusion between:
  - direct meaning vs interpretation vs thematic link

---

## TASK TYPE

Semantic labeling, credibility signaling, UX clarity, and lightweight knowledge classification.

---

## PRODUCT GOAL

For every reference shown in the Qur’an reader (or related surfaces), the user should understand:

### 1. What type of knowledge this is
Examples:
- Direct Qur’anic meaning
- Hadith connection
- Thematic connection
- Character lesson
- Seerah context
- Journey/learning connection

### 2. How strong the connection is
Examples:
- Direct / explicit
- Strong contextual
- Related / thematic
- Reflective / interpretive

This should:
- improve user trust
- reduce confusion
- make the system feel more intelligent and intentional

---

## EXECUTION RULES

1. **Audit first before editing.**
2. **Do not overcomplicate classification.**
3. **Keep labels simple and understandable.**
4. **Do not introduce academic jargon.**
5. **Do not clutter the UI with too many tags.**
6. **Preserve existing enrichment logic.**
7. **Reuse existing reference models where possible.**
8. **Keep the UI calm and premium.**
9. **Run analyzer and relevant tests at the end.**
10. **Provide a full audit summary.**

---

# IMPLEMENTATION SCOPE

## A. Audit current reference system

Inspect:
- `quran_ayah_enrichment_provider.dart`
- `quran_reference_graph_provider.dart`
- `quran_reference_viewer.dart`
- any reference models/descriptors
- reference detail sheet (if implemented)
- thematic mapping layer
- surah insights

Determine:
- what types of references currently exist
- how they are currently labeled (if at all)
- where confusion might occur
- where users cannot distinguish between types of connections

---

## B. Define a simple knowledge-type model

Introduce a lightweight classification model such as:

### Knowledge Type
- quran-direct
- hadith
- theme
- character
- seerah
- journey
- signs/world
- reflection

### Connection Strength
- direct
- strong
- related
- reflective

Keep this:
- simple
- extensible
- readable

Do NOT:
- create dozens of categories
- overfit the system

---

## C. Attach classification to references

Update reference models so each reference includes:
- knowledge type
- connection strength

This can be:
- explicit in curated mappings
- inferred via simple rules
- assigned through enrichment providers

---

## D. Improve reference UI labeling

In the reader and/or detail sheet:

### Show:
- clear category label
- optional subtle strength indicator

Examples:
- “Hadith • Direct”
- “Theme • Related”
- “Character • Reflective”
- “Seerah • Strong”

Keep:
- compact
- readable
- consistent

Do not:
- create large banners
- clutter chips excessively

---

## E. Improve explanation layer clarity

In the reference detail sheet:
- include knowledge type and strength
- improve “why this is related” using classification
- make explanation more trustworthy

Example:
- “This hadith directly explains the concept mentioned in this ayah”
- “This is a thematic connection highlighting a recurring concept”

---

## F. Improve chip grouping (optional)

If helpful:
- group references by type
- order by strength

Example:
1. Direct / strongest connections
2. Strong contextual
3. Related / thematic
4. Reflective

Only do this if it improves clarity without clutter.

---

## G. Ensure consistency across systems

Apply the same classification across:
- ayah-level references
- surah-level insights
- thematic layer
- learning paths
- journey integration

Avoid:
- inconsistent labeling between surfaces

---

## H. Keep UI calm

Avoid:
- too many labels
- visual noise
- confusing terminology

Goal:
- clarity without distraction

---

## I. Add focused tests

Test:
- classification assignment
- UI labeling consistency
- route integrity
- no regressions in enrichment

Run:
- `flutter analyze`
- relevant tests

---

# VALIDATION

After implementation:

1. references clearly show their type
2. users can distinguish direct vs thematic vs reflective links
3. explanation layer is clearer
4. UI remains calm
5. no routing regressions
6. `flutter analyze` passes
7. tests pass

---

# DELIVERABLES

Provide:

1. audit findings
2. classification model added
3. UI changes
4. explanation improvements
5. files changed
6. validation results
7. final audit

---

# END OF PROMPT
