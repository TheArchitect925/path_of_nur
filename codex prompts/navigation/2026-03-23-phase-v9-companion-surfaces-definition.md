# ===== PHASE V9 PROMPT — COMPANION SURFACES DEFINITION =====

## PRIMARY OBJECTIVE === BUILDING COMPANION SURFACES DEFINITION

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows:
- V4: Navigation stabilization
- V5: Alias integrity + `learnLegacy` clarification
- V6: Hidden metadata ownership cleanup
- V7: Visible fallback audit
- V8: Companion surface ownership audit

Current state after V8:
- routing is stable
- canonical ownership is much cleaner
- remaining unresolved visible fallbacks are no longer routing debt
- they are now **missing product surfaces**

This phase is **not** a cleanup pass.  
This phase is a **product architecture + feature definition pass**.

The goal is to define the actual companion surfaces that should exist in the product so remaining broad fallbacks can later be retired safely.

**Critical safety rule:**  
Do not go haywire deleting routes, pages, data, records, or existing flows for no reason.  
Do not replace broad fallback behavior unless a clearly better owned surface is designed and wired safely.  
Build on top of what already exists.

> “And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

---

## TASK TYPE

Feature architecture, IA definition, data ownership definition, route planning, and production-ready surface specification for unresolved companion experiences.

---

## PRODUCT GOAL

Define the real product-owned surfaces for the remaining unresolved areas:

### 1. Seerah Companion Surface
Should own:
- `seerah-journey`
- `seerah-hijrah`
- `seerah-madinah-society`

### 2. Character / Adab Companion Surface
Should own:
- `beautiful-character`

### 3. Daily Wisdom / Reflection Companion Surface
Should own:
- `wisdom-daily-quote`

These surfaces should be:
- product-correct
- route-ownable
- future-scalable
- aligned with the app’s calm premium aesthetic
- connected to existing Learn / Journey / Qur’an / Hadith structures
- designed so future implementation can happen cleanly

This phase should define them properly first, instead of forcing bad routing shortcuts.

---

## EXECUTION RULES

1. **Audit existing relevant surfaces first before defining anything new.**
2. **Reuse existing product structures where sensible.**
3. **Do not rebuild existing Learn, Prophets, Hadith, History, or Journey systems if they already partially solve parts of the problem.**
4. **Do not overbuild implementation in this phase unless a small safe scaffold is clearly helpful.**
5. **Prefer production-ready architecture over placeholder thinking.**
6. **Keep everything tied to real product ownership.**
7. **Preserve localization readiness.**
8. **Preserve current visible behavior unless a new surface scaffold is added safely.**
9. **At the end, provide one full audit + definition summary and identify the next build phase.**

---

# IMPLEMENTATION SCOPE

## A. Audit adjacent existing surfaces first

Before defining new companion surfaces, audit existing adjacent product surfaces to avoid duplication.

Inspect relevant areas such as:

- Learn hub / category structure
- Prophets / stories surfaces
- Hadith surfaces
- History archive / timeline surfaces
- Divine life / character lessons
- Journey detail and lesson related-tools patterns
- Qur’an learning
- any reflection / journal / daily content surfaces already present
- kids Seerah surfaces if relevant as inspiration only, not as direct owners

For each unresolved companion area, identify:
- what already exists
- what partially overlaps
- what clearly does not exist yet
- what should be reused vs newly defined

---

## B. Define the Seerah Companion Surface

### Goal
Create a clear product definition for a true Seerah-owned companion surface.

### It should answer:
- What is the main purpose of this surface?
- What user problem does it solve better than generic Learn fallback?
- What route should own it?
- What content blocks should it contain?
- How should it relate to:
  - Prophets
  - Hadith
  - History archive
  - Qur’an references
  - Journey lessons

### Expected direction
This should likely be:
- a top-level Learn-owned companion destination, not hidden fallback
- story + timeline + companion-learning oriented
- centered on the life of the Prophet ﷺ and key periods/events
- able to serve both broad Seerah browsing and specific entry links like Hijrah / Madinah society

### Define at minimum:
- recommended canonical route
- page purpose
- section structure
- key cards/modules
- how `seerah-journey`, `seerah-hijrah`, `seerah-madinah-society` should map into it
- whether one Seerah surface is enough for V1 or whether sub-surfaces are needed
- whether existing history data or prophets data should be reused

---

## C. Define the Character / Adab Companion Surface

### Goal
Create a real owner for character/adab learning rather than a broad legacy fallback.

### It should answer:
- Is this a sub-surface of Divine Life Lessons, or does it need its own owned landing?
- What exactly should it contain?
- What route should own it?
- How should it differ from generic life-lesson content?
- How should it support `beautiful-character` and future character-related journey tools?

### Expected direction
This should likely include:
- core traits / virtues
- real-life behavior themes
- linked hadith / ayah support
- practical application / reflection
- smooth connection to journey lessons

### Define at minimum:
- recommended canonical route
- page purpose
- content blocks
- relationship to existing life/divine lessons surfaces
- whether this is a dedicated page or a deeper owned tab/section inside an existing surface
- how `beautiful-character` should route here later

---

## D. Define the Daily Wisdom / Reflection Companion Surface

### Goal
Define the right owner for `wisdom-daily-quote`.

### Key challenge
This is currently ambiguous and should not be forced into Notes or Journal unless that is truly correct.

### It should answer:
- Is this a standalone surface?
- Is it a lightweight daily card feed?
- Is it a Learn-owned reflection page?
- Is it better as a small owned surface connected to Home / Learn / Journey?

### Expected direction
Keep V1 modest and useful:
- daily wisdom / quote / reflection style content
- optional ties to Qur’an / hadith / life lessons
- can later expand into loading screen content, widgets, daily cards, etc.

### Define at minimum:
- recommended canonical route
- ownership
- minimum content blocks
- how it differs from journal/notes
- whether it should be a lightweight page first instead of a full system
- how `wisdom-daily-quote` should map into it later

---

## E. Define route ownership and IA placement

For each companion surface, define:

### 1. Canonical route
Example style only — choose what is actually right:
- `/learn/seerah`
- `/learn/character`
- `/learn/daily-wisdom`

### 2. Learn hub placement
Decide where each belongs:
- standalone category/subcategory
- owned inside existing category
- tools/explore
- Qur’an & Hadith
- Prophets & Stories
- Character & Adab
- etc.

### 3. Journey integration
Define how Journey tools/lesson actions should later connect to these surfaces:
- direct route
- filtered entry
- section anchor
- themed mode

Do not wire everything yet unless trivial and safe.  
But define it clearly so the next implementation phase can build it cleanly.

---

## F. Define content/data ownership model

For each new surface, define the safest ownership model:

### Seerah
What data should power it?
- existing Seerah/kids Seerah data?
- history entries?
- prophets data?
- new companion-specific models?

### Character / Adab
What data should power it?
- divine life lessons?
- hadith themes?
- new trait cards?
- existing learn content detail models?

### Daily Wisdom
What data should power it?
- quote dataset?
- lightweight rotating content models?
- existing ayah/hadith/life-lesson snippets?
- future widget-ready daily entries?

Do not necessarily build the full data model yet unless a small scaffold is clearly beneficial.  
But define what the correct ownership should be.

---

## G. Create minimal implementation scaffolds only if helpful

If safe and useful, you may create **lightweight route/page scaffolds** for the new companion surfaces.

Allowed:
- route placeholders with clear ownership
- basic landing pages with structure
- TODO-safe production-friendly scaffolds
- integration comments
- localized titles/subtitles if truly needed

Not allowed:
- giant placeholder fake feature dumps
- empty shells with no structure
- rebuilding whole content systems prematurely

If you do create scaffolds, they should be:
- coherent
- production-safe
- clearly owned
- easy to build on in the next phase

---

## H. Preserve visible behavior for now

Important:
- Do not aggressively replace preserved broad fallbacks yet unless the new surface scaffold is genuinely ready and safe
- If a new scaffold is added, only wire obvious safe entry points
- Otherwise keep current fallback behavior and document future remapping

This phase is about defining the right surfaces first.

---

## I. Add supporting docs / backlog if useful

If helpful, create concise docs for:
- companion surface ownership decisions
- route ownership decisions
- implementation backlog for V10
- what content/data each surface should consume

Keep them concise and useful.

---

# VALIDATION

After implementation/definition work, validate all of the following:

## Architecture
1. each unresolved area now has a clear product owner decision
2. each surface has a proposed canonical route
3. each surface has a clear IA placement
4. each surface has defined relationship to adjacent existing systems

## Safety
5. no current visible behavior was broken
6. no deep-link behavior was broken
7. no route cleanup regressions introduced

## Code health
8. analyzer passes
9. tests pass if any route/page scaffolds were added or changed
10. localization remains valid

---

# DELIVERABLES

Provide a concise summary with:

1. **Audit findings**
   - adjacent existing surfaces reviewed
   - what overlaps already existed
   - what was missing

2. **Companion surface decisions**
   - Seerah companion surface
   - Character / Adab companion surface
   - Daily Wisdom / Reflection companion surface

3. **For each surface**
   - purpose
   - canonical route
   - IA placement
   - section/content structure
   - data/content ownership model
   - whether a scaffold was created

4. **Journey integration plan**
   - how current fallback items should later map into the new surfaces

5. **Files changed**
   - updated files
   - new scaffold pages/routes/docs/tests

6. **Validation**
   - analyzer
   - tests
   - behavior stability confirmation

7. **Final audit**
   - whether ownership is now clearly defined
   - what the next implementation phase should be

---

# IMPORTANT SAFETY / PRODUCT RULE

This is a **feature definition phase**, not a mass implementation phase and not another routing cleanup pass.

Do not:
- force replacements
- overbuild
- delete broad fallbacks prematurely
- invent disconnected placeholder pages

Do:
- define real owned surfaces
- make future routing/product decisions obvious
- create only minimal safe scaffolds if they genuinely help

# END OF PROMPT
