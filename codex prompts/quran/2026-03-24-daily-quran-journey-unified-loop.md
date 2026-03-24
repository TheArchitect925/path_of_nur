# ===== PHASE QURAN ENRICHMENT PROMPT — DAILY QUR’AN + JOURNEY UNIFIED LOOP =====

## PRIMARY OBJECTIVE === BUILDING DAILY QUR’AN + JOURNEY UNIFIED LOOP

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows:
- full Qur’an enrichment system
- thematic map layer
- reference explanation layer
- surah study expansion
- high-value surah coverage
- Journey ↔ Qur’an integration
- memorization + review system
- adaptive study modes
- learning path system
- credibility / knowledge-type layer
- daily Qur’an companion flow
- Journey ↔ Theme mapping system
- user intent personalization layer

Current state:
- the system has powerful components:
  - daily Qur’an flow
  - journeys
  - themes
  - learning paths
  - memorization/review
- BUT these still operate as **separate systems**

This phase creates:
👉 a **Unified Daily Loop**

So the user experiences:
- one cohesive daily journey
- not disconnected features

---

## TASK TYPE

Cross-system orchestration, daily experience design, and integration of:
- daily ayah
- user intent
- active journey
- theme mapping
- memorization/review

---

## PRODUCT GOAL

Turn the app into a **daily companion loop**:

### Daily Loop Flow

1. Daily Ayah  
2. Meaning / Reflection  
3. Related Theme  
4. Journey Connection  
5. Practical Action  
6. Optional Review / Memorization  

All connected seamlessly.

---

## EXECUTION RULES

1. **Audit first before editing.**
2. **Do not rebuild existing systems.**
3. **Do not introduce heavy orchestration engines.**
4. **Keep the flow calm, short, and meaningful.**
5. **Reuse existing systems (daily flow, journeys, themes, memorization).**
6. **Keep UX minimal and elegant.**
7. **Preserve localization readiness.**
8. **Run analyzer and tests at the end.**
9. **Provide a full summary.**

---

# IMPLEMENTATION SCOPE

## A. Audit current daily + journey + theme systems

Inspect:
- daily Qur’an flow
- Journey registry and active journey state
- theme mapping system
- user intent model
- memorization/review system
- home and Qur’an hub entry points

Determine:
- what already connects
- what is isolated
- where integration can be safely introduced

---

## B. Define unified daily loop model

Create a lightweight model that includes:
- daily ayah
- associated theme
- optional journey context
- optional memorization link
- practical action

Keep it:
- simple
- deterministic
- reusable

---

## C. Align daily ayah with journey + theme

Improve selection so:
- if user has an active journey → prefer ayah related to that journey’s theme
- if no journey → use curated rotation
- if user intent exists → influence selection

Do NOT:
- overfit selection logic
- create complex recommendation engines

---

## D. Improve daily flow structure

Ensure the flow shows:

1. Daily ayah  
2. Short meaning  
3. Theme connection  
4. Journey link (if relevant)  
5. Practical step  
6. Optional review/memorization  

Keep it:
- one screen or very short flow
- not multi-page complexity

---

## E. Integrate memorization/review

If:
- ayah is already memorized → show review prompt  
- not memorized → allow quick “mark for memorization”  

Keep subtle and optional.

---

## F. Improve entry points

Ensure unified loop is accessible from:
- Home (primary)
- Qur’an hub (secondary)
- Learn (optional)

Do NOT:
- duplicate everywhere
- clutter navigation

---

## G. Improve contextual messaging

Examples:
- “Today’s reflection for your journey: Patience”
- “Theme: Gratitude”
- “Continue your path”

Keep:
- subtle
- calm
- meaningful

---

## H. Keep UX minimal

Avoid:
- dashboards
- long flows
- multiple screens

Focus:
- 1 strong daily experience

---

## I. Add focused tests

Test:
- daily selection logic
- journey-theme alignment
- route stability
- memorization integration

Run:
- `flutter analyze`
- relevant tests

---

# VALIDATION

After implementation:

1. daily flow is unified
2. journey integration feels natural
3. theme mapping is visible and useful
4. memorization fits naturally
5. no routing regressions
6. UX remains calm
7. analyzer passes
8. tests pass

---

# DELIVERABLES

Provide:

1. audit findings
2. unified loop model
3. integration changes
4. files changed
5. validation results
6. final audit

---

# END OF PROMPT
