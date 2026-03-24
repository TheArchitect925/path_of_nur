# ===== PHASE QURAN ENRICHMENT PROMPT — USER INTENT PERSONALIZATION LAYER =====

## PRIMARY OBJECTIVE === BUILDING USER INTENT PERSONALIZATION LAYER

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows:
- ayah + surah enrichment
- thematic map layer
- reference explanation layer
- surah study hub expansion
- high-value surah coverage
- Journey ↔ Qur’an integration
- memorization + review system
- adaptive study modes
- learning path system
- credibility / knowledge-type layer
- daily Qur’an companion flow
- Journey ↔ Theme mapping system

Current state:
- the Qur’an ecosystem is now rich and connected
- users can read, reflect, study, memorize, review, and follow paths
- the missing layer is **personal intent**
- right now, the system is powerful, but still not fully tailored to what the user is trying to do in this session or over time

This phase introduces:
👉 a **User Intent Personalization Layer**

So the app can gently adapt based on what the user wants most right now, such as:
- understand more
- reflect more
- memorize
- study themes
- follow a guided path

This should make the system feel:
- more personal
- more coherent
- more helpful
- more intelligent without becoming complicated

This is **not** a heavy AI/recommendation phase.
This is a **lightweight intent and preference layer** built on top of the existing Qur’an system.

**Critical safety rule:**  
Do not go haywire deleting current reader behavior, routes, journeys, paths, study modes, or memorization flows for no reason.  
Do not build a giant preference engine.  
Do not introduce noisy onboarding or intrusive prompts.  
Keep this lightweight, calm, optional, and production-safe.

---

## TASK TYPE

Lightweight personalization, intent-aware defaults, guided entry refinement, and calm user-preference adaptation.

---

## PRODUCT GOAL

Allow the user to express or gradually establish an intent such as:

### 1. Understand more
- emphasize study and meaning
- stronger handoff to themes and surah insights

### 2. Reflect more
- emphasize reflection mode
- calmer prompts and daily flow

### 3. Memorize
- emphasize memorization mode
- review rhythm
- selected ayah revisit

### 4. Study themes
- emphasize theme mode
- thematic map and related journeys

### 5. Follow a guided path
- emphasize learning paths and continuity

Then use that intent to improve:
- default reader mode
- daily Qur’an flow
- path suggestions
- Journey ↔ Qur’an transitions
- relevant surface emphasis

---

## EXECUTION RULES

1. **Audit first before editing.**
2. **Do not build a heavy personalization/recommendation engine.**
3. **Keep this optional and respectful.**
4. **Prefer a small number of clear intents over many granular toggles.**
5. **Reuse existing study modes, daily flow, learning paths, and memorization systems.**
6. **Keep routing stable.**
7. **Preserve localization readiness.**
8. **Run analyzer and relevant tests at the end.**
9. **Provide one full audit summary at the end.**

---

# IMPLEMENTATION SCOPE

## A. Audit current entry and preference behavior first

Inspect at minimum:
- Qur’an hub
- daily Qur’an companion flow
- adaptive study modes
- memorization/review flows
- learning path system
- Journey ↔ Qur’an theme mapping
- any existing settings / persistence model that could safely store a lightweight user preference

Determine:
1. what already adapts to entry context
2. what is currently generic
3. where intent could improve user experience the most
4. what persistence model can be reused safely

---

## B. Define a lightweight intent model

Create a simple intent model if needed, such as:
- `understand`
- `reflect`
- `memorize`
- `themes`
- `guided_path`

Optional:
- `none` / unset

Keep it:
- small
- explicit
- easy to persist
- easy to explain to the user

Do not build a large preference taxonomy.

---

## C. Add one safe way to capture user intent

Provide a lightweight, calm way for the user to set or confirm their intent.

Possible safe approaches:
- a small selector in the Qur’an hub
- a lightweight card in the daily Qur’an flow
- a subtle “What do you want to focus on?” entry
- a settings preference for default Qur’an focus

Choose the simplest, clearest approach.

Do NOT:
- create a heavy onboarding wizard
- force the user to choose
- interrupt reading unnecessarily

---

## D. Persist intent lightly

If safe and useful:
- remember the user’s selected intent
- use it as a default for future sessions
- allow easy change later

Keep it local/simple.
Do not overengineer sync or profile complexity.

---

## E. Adapt key systems based on intent

Use the selected intent to improve defaults and emphasis.

### If intent = understand
- prefer study mode
- emphasize surah insights, themes, and related learning links

### If intent = reflect
- prefer reflection mode
- emphasize daily Qur’an flow and calm reflection prompts

### If intent = memorize
- prefer memorization mode
- emphasize review list and repetition-friendly entry points

### If intent = themes
- emphasize thematic map layer and theme-driven study

### If intent = guided_path
- emphasize Qur’an learning paths and continuation

Important:
- this should change emphasis, not remove features
- keep all capabilities available

---

## F. Adapt the Daily Qur’an Companion Flow

Improve the daily flow so it feels more relevant to the user’s intent.

Examples:
- Understand → stronger theme/study cue
- Reflect → lighter practical reflection cue
- Memorize → optional memorization/review nudge
- Themes → thematic follow-up
- Guided path → path continuation cue

Do not rebuild the daily flow.
Just personalize emphasis and next actions.

---

## G. Adapt Qur’an hub recommendations

If safe:
- adjust the order or emphasis of cards/modules in the Qur’an hub based on user intent
- or add a subtle “Recommended for your focus” section

Keep this minimal.
Do not make the hub unstable or crowded.

---

## H. Adapt Journey ↔ Qur’an handoffs

Where useful:
- when a Journey-to-Qur’an transition occurs, combine:
  - journey context
  - theme mapping
  - current user intent

Example:
- user intent = memorize
- journey theme = patience
- route into memorization-friendly Qur’an focus with patience-related ayahs

Keep this subtle and high-signal.

---

## I. Keep UX calm and reversible

Users should always be able to:
- change their focus easily
- still access all study tools
- not feel trapped in one mode

Avoid:
- hard-locking the experience
- over-personalizing
- hiding too much

---

## J. Add focused tests and validation

Add/update focused tests for:
- intent model/persistence
- intent-aware default routing or mode selection
- daily flow emphasis behavior
- no regressions to reader/hub/path stability

Run:
- `flutter analyze`
- relevant focused tests

---

# VALIDATION

After implementation, validate:

1. the user can choose or set a Qur’an learning intent
2. the preference persists if designed to persist
3. daily flow adapts meaningfully
4. reader/hub/path emphasis adapts usefully
5. no routes or study features break
6. personalization remains calm and optional
7. `flutter analyze` passes
8. relevant tests pass
9. localization remains valid

---

# DELIVERABLES

Provide:

1. **Audit findings before changes**
   - what already adapted
   - what was generic
   - where personalization had the highest value

2. **Intent model added**
   - what intents were supported
   - how they are stored
   - where users can set/change them

3. **System adaptations**
   - how daily flow changed
   - how hub/reader/path emphasis changed
   - how Journey ↔ Qur’an transitions improved

4. **Files changed**
   - updated files
   - new model/provider/test files

5. **Validation**
   - analyzer
   - tests
   - stability confirmation

6. **Final audit**
   - whether the Qur’an system now feels more personal and guided
   - what the next highest-value follow-up phase should be

# END OF PROMPT
