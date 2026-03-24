# PHASE V10 PROMPT — COMPANION SURFACES LIGHTWEIGHT BUILDOUT

## PRIMARY OBJECTIVE === BUILDING COMPANION SURFACES LIGHTWEIGHT BUILDOUT

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows:
- V4: Navigation stabilization
- V5: Alias integrity + `learnLegacy` clarification
- V6: Hidden metadata ownership cleanup
- V7: Visible fallback audit
- V8: Companion surface ownership audit
- V9: Companion surfaces definition

Current state after V9:
- ownership is now clearly defined
- three missing product-owned surfaces were identified:
  - `/learn/seerah`
  - `/learn/character`
  - `/learn/daily-wisdom`
- these should now be built as **real lightweight production-safe V1 surfaces**
- current broad fallback links should remain intact unless a new surface is safely live and clearly better

This phase is a **real build phase**, but it should remain disciplined:
- no fake placeholder junk
- no giant overbuild
- no breaking existing flows
- no deleting broad fallbacks recklessly

**Critical safety rule:**  
Do not go haywire deleting routes, data, records, widgets, or current flows for no reason.  
Build on top of what already exists.  
Only remap fallback links if the new owned surface is clearly live, route-safe, and semantically correct.

> “And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

---

## TASK TYPE

Feature implementation, route wiring, lightweight content/data scaffolding, and safe Journey integration for the three companion surfaces.

---

## PRODUCT GOAL

Build first real owned versions of:

### 1. Seerah Companion Surface
Canonical route:
- `/learn/seerah`

### 2. Character / Adab Companion Surface
Canonical route:
- `/learn/character`

### 3. Daily Wisdom / Reflection Companion Surface
Canonical route:
- `/learn/daily-wisdom`

These should be:
- real app surfaces
- production-safe
- visually aligned with Path of Nūr
- lightweight but meaningful
- ready for future expansion
- wired cleanly into Learn and Journey without destabilizing current behavior

---

## EXECUTION RULES

1. **Audit adjacent existing systems before building.**
2. **Reuse existing page shells, styling, cards, shared widgets, and content patterns where practical.**
3. **Do not rebuild Prophets, Hadith, History, Divine Life, Notes, Journal, or Qur’an systems.**
4. **Do not create empty placeholder pages with no structure.**
5. **Keep V1 lightweight, but real.**
6. **Preserve localization readiness.**
7. **Preserve current routes and current fallback behavior unless explicit remapping is safe.**
8. **If remapping any fallback links, do so narrowly and only after the owned page exists.**
9. **Run analyzer and relevant tests at the end.**
10. **Provide a full audit summary at the end, including what was built and what still remains for future phases.**

---

# IMPLEMENTATION SCOPE

## A. Audit and reuse adjacent existing surfaces

Before coding, inspect relevant adjacent surfaces and reuse where sensible:
- Learn landing/category structures
- Prophets page
- Hadith landing
- History archive
- Divine Life / Life landing
- Qur’an reflections / study surfaces
- shared app page scaffolds
- shared premium cards
- journey related-tools patterns
- existing search/filter chips if reusable

Do not duplicate existing patterns if there is already a good shared implementation.

---

## B. Build `/learn/seerah` — Seerah Companion Surface

### Goal
Create a real adult/main Seerah home that can become the owner of:
- `seerah-journey`
- `seerah-hijrah`
- `seerah-madinah-society`

### Route
Add canonical route:
- `/learn/seerah`

### V1 scope
Build a meaningful landing surface with sections such as:

#### 1. Hero / introduction
- what Seerah is
- why it matters
- calm premium visual treatment

#### 2. Key periods / entry cards
Examples:
- Early Makkah
- Hijrah
- Madinah Society
- Major Events / Turning Points

#### 3. Continue your journey block
- tie to journey progress if easily reusable
- otherwise use a lightweight continue/related card pattern

#### 4. Companion modules
Show related owned links to:
- Prophets
- Hadith
- History archive
- Qur’an-linked study where relevant

#### 5. Explore deeper section
A curated set of internal links, not generic dumps

### Data/content model
Create a lightweight Seerah companion model if needed:
- section id
- title
- subtitle
- description
- route target / filter target
- optional related source tags

Prefer a simple local structured model over hardcoded UI sprawl.

### Design direction
- calm
- story/timeline feel
- premium cards
- clearly adult/main surface, not kids-only

### Important
Do not overbuild a full timeline engine yet unless one already exists and is trivial to reuse.

---

## C. Build `/learn/character` — Character / Adab Companion Surface

### Goal
Create a true owner for:
- `beautiful-character`

### Route
Add canonical route:
- `/learn/character`

### V1 scope
Build a meaningful landing surface with sections such as:

#### 1. Hero / purpose
- character, adab, and daily conduct focus

#### 2. Core traits grid/list
Examples:
- sincerity
- patience
- gratitude
- mercy
- humility
- honesty
- respect
- self-control

#### 3. Practical life scenarios
Small entry blocks/cards like:
- family
- speech
- anger
- neighbors
- intentions
- consistency

#### 4. Related source modules
Curated handoff to:
- Hadith
- Divine Life / Life lessons
- Qur’an reflections where relevant

#### 5. Continue journey block
if journey reuse is easy and safe

### Data/content model
Create a lightweight trait/scenario model if needed:
- id
- title
- subtitle
- description
- route target
- source type or supporting content tags

### Important
This should not become just a duplicate of Divine Life Lessons.
It should feel like a more focused character/adab companion owner.

---

## D. Build `/learn/daily-wisdom` — Daily Wisdom / Reflection Companion Surface

### Goal
Create a lightweight owned page for:
- `wisdom-daily-quote`

### Route
Add canonical route:
- `/learn/daily-wisdom`

### V1 scope
Keep this intentionally light but real:

#### 1. Today’s wisdom card
- one featured reflection / quote / reminder
- source label/chip
- brief context or lesson

#### 2. One practical step
- a short “carry this today” style action

#### 3. Related owner handoff
- link to source owner if the wisdom comes from Qur’an / Hadith / Life / Prophets etc.

#### 4. Recent rhythm strip
- a small list/carousel of recent wisdom entries if easy

### Data/content model
Create a lightweight daily wisdom entry model if needed:
- id
- title
- body
- source label
- source route target
- theme/category
- optional day rotation key

Keep it local/simple for V1.
Do not build a giant scheduling engine.
Do not turn this into journaling.

### Important
This is a calm daily companion, not Notes, not Journal, not a fake notification center.

---

## E. Route wiring

Add canonical routes for the new surfaces in the correct Learn route ownership files.

Preferred canonical routes:
- `/learn/seerah`
- `/learn/character`
- `/learn/daily-wisdom`

Ensure:
- route names are clear
- route ownership is obvious
- they are grouped in the right route file(s)
- route naming is consistent with current conventions

Do not break existing routing organization from V4/V5.

---

## F. Learn IA integration

Integrate these surfaces into Learn in the safest, clearest way.

### At minimum:
Make sure these surfaces are reachable from the app in a reasonable way.

Possible safe integration approaches:
- add them to the relevant Learn category/subcategory structures
- add owned entry cards in the relevant category page
- add supporting links from existing surfaces

### Recommended ownership:
- Seerah → Learn / Core Knowledge or Prophets-adjacent owned entry
- Character → Learn / Character & Adab
- Daily Wisdom → Learn / Discovery or Tools/Explore depending on current IA fit

Do not do a major IA redesign.
Add only the necessary owned integration points.

---

## G. Safe remapping of existing fallback links

Only after the new surfaces exist and are route-safe, narrowly remap the clearly safe visible fallbacks:

### Safe candidates to remap in this phase
- `seerah-journey` -> `/learn/seerah`
- `seerah-hijrah` -> `/learn/seerah` with a focused entry state or section anchor if practical
- `seerah-madinah-society` -> `/learn/seerah` with a focused entry state or section anchor if practical
- `beautiful-character` -> `/learn/character`
- `wisdom-daily-quote` -> `/learn/daily-wisdom`

### Rules
- only remap if the surface is live and meaningful
- preserve intent
- use focused query parameters/entry-state if helpful
- do not force complex deep section logic if it is not yet clean
- if one of these still feels unsafe after implementation, leave it and document it honestly

---

## H. Keep implementation lightweight but real

For V1:
### DO implement
- route
- page
- owned structure
- curated sections
- small supporting data models
- safe Learn/Journey wiring
- safe fallback remaps where justified

### DO NOT implement yet
- giant content engines
- advanced search systems
- full timeline visualizations
- heavy CMS-style management
- massive datasets
- analytics complexity
- overcomplicated filtering

---

## I. Use production-safe UI quality

All three surfaces should:
- use existing page shell patterns
- use premium cards / calm styling
- feel consistent with Path of Nūr
- not look like dev placeholders
- have clean spacing and readable structure

If titles/subtitles/body copy are needed, make them user-ready and calm.

---

## J. Localization readiness

Keep all new strings localization-ready.
Do not leave hardcoded user-facing text scattered carelessly.
If localization files must be touched, do so cleanly.

---

## K. Tests and validation

Add/update targeted tests as needed for:
- new route integrity
- Learn integration visibility if applicable
- safe fallback remapping behavior
- no regressions in existing route tests

Do not add noisy tests.
Add useful regression coverage.

---

# VALIDATION

After implementation, validate all of the following:

## New surfaces
1. `/learn/seerah` works
2. `/learn/character` works
3. `/learn/daily-wisdom` works

## Integration
4. each surface is reachable from Learn in a sensible way
5. any new Journey remaps work correctly
6. visible fallback actions only changed where safe

## Stability
7. no routing regressions introduced
8. deep-link behavior still works
9. shell/tab behavior still works
10. no alias integrity regressions introduced

## Code health
11. `flutter analyze` passes
12. relevant tests pass
13. localization remains valid

---

# DELIVERABLES

Provide a concise summary with:

1. **Audit findings before build**
   - what adjacent surfaces were reused
   - what was newly needed

2. **Surfaces built**
   - Seerah companion surface
   - Character / Adab companion surface
   - Daily Wisdom / Reflection companion surface

3. **For each surface**
   - route
   - purpose
   - main sections built
   - data/content model used
   - Learn IA placement

4. **Fallback remaps**
   - which existing broad fallback actions were remapped
   - what route they now target
   - which fallbacks were intentionally left unchanged

5. **Files changed**
   - updated files
   - new files
   - tests/docs added

6. **Validation**
   - analyzer
   - tests
   - behavior stability

7. **Final audit**
   - whether the three missing surfaces are now real owned product destinations
   - what the next best phase should be

---

# IMPORTANT SAFETY / PRODUCT RULE

This is a **lightweight real build phase**.

Do not:
- overbuild
- create fake placeholder junk
- remove broad fallbacks before replacements are truly usable
- rebuild unrelated systems
- delete records or routes for no reason

Do:
- create real owned surfaces
- integrate safely
- remap only where justified
- leave the app cleaner and more product-correct than before

# END OF PROMPT
