# ===== PHASE QURAN ENRICHMENT PROMPT — DAILY QUR’AN COMPANION FLOW =====

## PRIMARY OBJECTIVE === BUILDING DAILY QUR’AN COMPANION FLOW

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

Current state:
- the system is now powerful
- but still requires user effort to navigate

This phase introduces:
👉 a **Daily Qur’an Companion Flow**

This is the missing layer that turns:
- features → into habit
- learning → into routine
- reading → into daily engagement

---

## TASK TYPE

Daily experience design, lightweight habit loop, and integration of reading + reflection + review.

---

## PRODUCT GOAL

Create a simple daily flow where the user gets:

1. A **daily ayah or short passage**
2. A **reflection or meaning cue**
3. A **related insight (Hadith / theme / character / sign)**
4. A **small practical takeaway**
5. Optional:
   - memorization / review suggestion
   - continue learning path

This should feel:
- calm
- meaningful
- short
- repeatable
- not overwhelming

---

## EXECUTION RULES

1. **Audit first before building.**
2. **Do not create a heavy notification/reminder system in this phase.**
3. **Do not duplicate Qur’an reader functionality.**
4. **Keep the flow lightweight and elegant.**
5. **Reuse existing enrichment, reference, and memorization systems.**
6. **Do not overwhelm the user with too many steps.**
7. **Preserve localization readiness.**
8. **Run analyzer and relevant tests at the end.**
9. **Provide a full summary at the end.**

---

# IMPLEMENTATION SCOPE

## A. Audit current daily/entry experiences

Inspect:
- Home page
- Learn landing
- Qur’an hub
- Journey landing
- Daily Wisdom surface
- any existing daily prompts or reminders

Determine:
- what already resembles a “daily” flow
- what is missing
- where this flow should live

---

## B. Define the Daily Qur’an flow structure

The flow should be simple and repeatable:

### Step 1: Daily ayah
- 1 ayah or short passage
- not too long

### Step 2: Meaning
- translation
- short reflection cue

### Step 3: Related insight
- 1–2 high-value references
- using existing enrichment system

### Step 4: Practical takeaway
- one calm action or reflection

### Step 5: Optional continuation
- open full reader
- explore theme
- review memorization
- continue learning path

---

## C. Decide where the flow lives

Choose a safe product location such as:
- Home (top or main card)
- Qur’an hub (featured daily section)
- Learn landing (featured module)
- or a lightweight `/quran/daily` route

Do NOT:
- duplicate it everywhere
- scatter it across the app

Pick one clear owner.

---

## D. Build a lightweight daily selection system

Implement a simple daily selection:
- stable per day
- predictable
- not random chaos

Possible:
- rotating curated list
- day-of-year index
- simple deterministic logic

Do NOT:
- build complex scheduling engines
- add backend dependencies

---

## E. Reuse enrichment system

For each daily ayah:
- use existing enrichment providers
- show:
  - 1–2 references
  - theme if available
  - category label

Keep it high-signal.

---

## F. Integrate with memorization + review

If the ayah is:
- already memorized → show review cue
- not memorized → allow “mark for memorization”

Keep this optional and subtle.

---

## G. Integrate with learning paths

If applicable:
- show “continue your path” or “start a path” suggestion
- connect daily flow to:
  - theme paths
  - beginner paths
  - reflection paths

---

## H. Keep UI calm and focused

Avoid:
- too many cards
- long scrolls
- multiple CTAs

Focus on:
- one main flow
- clear next action

---

## I. Optional lightweight persistence

If safe:
- track:
  - last seen daily ayah
  - whether user interacted
- allow:
  - revisit

Do not overbuild.

---

## J. Add focused tests

Test:
- daily selection logic
- route integrity
- integration with reader
- memorization interaction

Run:
- `flutter analyze`
- relevant tests

---

# VALIDATION

After implementation:

1. daily flow appears in chosen surface
2. daily ayah changes predictably
3. flow is calm and not overwhelming
4. references are meaningful
5. memorization integration works
6. learning path integration works
7. no routing regressions
8. `flutter analyze` passes
9. tests pass

---

# DELIVERABLES

Provide:

1. audit findings
2. daily flow design
3. location chosen
4. selection logic
5. integrations (reader, memorization, paths)
6. files changed
7. validation results
8. final audit

---

# END OF PROMPT
