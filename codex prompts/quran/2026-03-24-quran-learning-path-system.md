# ===== PHASE QURAN ENRICHMENT PROMPT — QUR’AN LEARNING PATH SYSTEM =====

## PRIMARY OBJECTIVE === BUILDING QUR’AN LEARNING PATH SYSTEM

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows:
- ayah + surah enrichment
- thematic map layer
- reference explanation layer
- surah study hub expansion
- high-value surah coverage
- Journey ↔ Qur’an integration
- reader UX polish
- memorization (hifz) + study bridge
- adaptive study modes
- lightweight spaced repetition + review rhythm

Current state:
- the Qur’an experience is now rich, flexible, and connected
- users can read, reflect, study, memorize, and review
- BUT the system is still mostly tool-based
- the next highest-value step is to turn these capabilities into **guided paths**

This phase introduces:
👉 a **Qur’an Learning Path System**

So users can follow structured paths such as:
- Beginner Understanding
- Theme Study
- Memorization Support
- Reflection Journey
- Surah Study Path

This is **not** a giant LMS or course engine.
It is a **lightweight, guided path layer** built on top of the existing Qur’an system.

**Critical safety rule:**  
Do not go haywire deleting current reader behavior, routes, study tools, memorization tools, or enrichment systems for no reason.  
Do not rebuild the whole Journey system inside Qur’an.  
Build a focused path layer that reuses the existing reader, study, and reference infrastructure safely.

---

## TASK TYPE

Guided learning architecture, path modeling, curated path flows, and safe integration into the existing Qur’an experience.

---

## PRODUCT GOAL

Help users move from:
- powerful tools
to
- guided learning experiences

Users should be able to choose a path based on intent, for example:

### 1. Beginner Understanding
- gentle introduction
- meaning and themes
- key surahs / key ayahs
- no overload

### 2. Theme Study
- pick a theme
- explore ayahs, surahs, and references around it
- connect to owned surfaces

### 3. Memorization Support
- study + understand + retain
- easier entry into review and memorization flow

### 4. Reflection Path
- calmer reflective study
- meaning and practical takeaways
- lighter pace

### 5. Surah Study Path
- structured study around selected high-value surahs

The system should remain:
- calm
- lightweight
- structured
- user-friendly
- future-scalable

---

## EXECUTION RULES

1. **Audit first before editing.**
2. **Do not build a giant course platform.**
3. **Reuse existing reader, surah study, thematic map, memorization, and review systems.**
4. **Prefer a small number of strong curated paths over many weak ones.**
5. **Do not duplicate Journey architecture unnecessarily.**
6. **Keep routing stable.**
7. **Preserve localization readiness.**
8. **Run analyzer and relevant tests at the end.**
9. **Provide a full audit summary at the end.**

---

# IMPLEMENTATION SCOPE

## A. Audit current Qur’an study capabilities first

Inspect at minimum:
- Qur’an hub and learning hub pages
- reader entry points
- thematic map layer
- surah study structures
- memorization/review system
- adaptive study modes
- Journey ↔ Qur’an integration
- any existing path/journey models that can be reused safely

Determine:
- what building blocks already exist
- what kinds of guided flows are already partially present
- what can become learning paths without heavy new infrastructure

---

## B. Define a lightweight path model

Create a simple structured path model if needed, such as:
- id
- title
- subtitle
- description
- path type
- entry route
- steps/modules
- difficulty / intensity label
- optional theme tags
- optional recommended surahs/ayahs
- optional linked owner surfaces

Keep it lightweight and maintainable.
Do not overengineer a course engine.

---

## C. Create a curated V1 path set

Build a focused first set of learning paths, such as:

### 1. Beginner Understanding
- low-friction intro to Qur’an study
- key surahs
- meaning-first
- calm study prompts

### 2. Theme Study
- uses thematic map layer
- lets user follow a meaningful topic path

### 3. Memorization Support
- combines memorization review with understanding/context

### 4. Reflection Path
- emphasizes understanding and personal reflection
- lighter, calmer, non-academic

### 5. Surah Study Path
- deeper guided study for selected surahs

You may refine names if the current product language suggests better ones.

---

## D. Define path step structure

Each path should have a small number of clear steps, for example:
- open reader in a certain mode
- read a selected surah/ayah set
- study a theme
- open related owner surface
- review a memorization item
- reflect on a practical takeaway

Keep steps:
- meaningful
- simple
- reusing existing owned surfaces
- not too long

---

## E. Decide where the path system lives

Determine the best product owner surface.

Possible safe owners:
- Qur’an learning hub
- main Qur’an hub
- a dedicated Qur’an paths section/page if already justified

If a dedicated surface is needed, keep it lightweight and route-owned.
Do not create unnecessary duplication.

Possible canonical routes:
- `/quran/paths`
- `/quran/learning/paths`
- or another clean route consistent with the repo’s conventions

Choose what best fits the current architecture.

---

## F. Build path entry UI

Create a calm, structured entry surface for the paths.

This can include:
- path cards
- short explanations
- “best for you if…” style subtitles
- lightweight labels like:
  - beginner
  - reflection
  - memorization
  - thematic
  - study

Keep it premium and uncluttered.

---

## G. Build path-to-reader / path-to-surface handoffs

Each path should lead into real product experiences.

Examples:
- Beginner path → curated surah study + simple reflection
- Theme path → thematic map + reader in theme mode
- Memorization path → review list + memorization mode
- Reflection path → reader in reflection mode + daily wisdom tie-in
- Surah path → selected surah study hubs

Use:
- route parameters
- existing mode-aware reader entry
- existing owned surfaces

Do not build dummy steps.

---

## H. Add lightweight path continuity if safe

If practical:
- remember current path
- show “continue path”
- track simple progress through path steps

Keep this extremely lightweight.
Do not build a large progress-tracking framework.

---

## I. Integrate with existing Qur’an and Journey surfaces safely

If safe:
- expose Qur’an paths from the Qur’an hub
- optionally lightly expose from Journey where relevant
- optionally connect Daily Wisdom / companion learning when semantically appropriate

Do not redesign the app navigation.

---

## J. Add focused tests and validation

Add/update focused tests for:
- path model integrity
- route integrity
- path entry surface
- path → reader/surface handoff behavior
- no regressions to Qur’an routing

Run:
- `flutter analyze`
- relevant focused tests

---

# VALIDATION

After implementation, validate:

1. users can discover Qur’an learning paths clearly
2. paths feel meaningful and not fake
3. each path leads into real owned study experiences
4. routing remains stable
5. reader/memorization/thematic integrations still work
6. UI remains calm and premium
7. `flutter analyze` passes
8. relevant tests pass
9. localization remains valid

---

# DELIVERABLES

Provide:

1. **Audit findings before changes**
   - what building blocks already existed
   - what path opportunities were strongest

2. **Path system added**
   - what paths were created
   - where the system lives
   - how the model works

3. **Path handoffs**
   - how each path connects to real study experiences

4. **Continuity/progress behavior**
   - if any lightweight progress/continue behavior was added

5. **Files changed**
   - updated files
   - new model/page/provider/test files

6. **Validation**
   - analyzer
   - tests
   - study flow stability confirmation

7. **Final audit**
   - whether Qur’an learning now feels more guided
   - what the next highest-value follow-up phase should be

# END OF PROMPT
