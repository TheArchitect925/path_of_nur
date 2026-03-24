# PHASE V11 PROMPT — COMPANION SURFACES CONTENT DEPTH + REFINEMENT

## PRIMARY OBJECTIVE === BUILDING COMPANION SURFACES CONTENT DEPTH + REFINEMENT

You are working in the existing Flutter codebase for **Path of Nūr**.

This phase follows:
- V4: Navigation stabilization
- V5: Alias integrity + `learnLegacy` clarification
- V6: Hidden metadata ownership cleanup
- V7: Visible fallback audit
- V8: Companion surface ownership audit
- V9: Companion surfaces definition
- V10: Companion surfaces lightweight buildout

Current state after V10:
- the following are now real owned surfaces:
  - `/learn/seerah`
  - `/learn/character`
  - `/learn/daily-wisdom`
- visible broad fallback actions were safely remapped
- routing/ownership is now in a good place
- the next need is **content depth, curation, and refinement**
- this is no longer a routing phase

**Critical safety rule:**  
Do not go haywire deleting routes, pages, content models, records, or current flows for no reason.  
Build on top of the new owned surfaces.  
Do not replace working structure with overbuilt systems.

> “And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

---

## TASK TYPE

Content-depth expansion, curation refinement, supporting data enhancement, and UX polish for the three new companion surfaces.

---

## PRODUCT GOAL

Strengthen the three new owned surfaces so they feel more complete, useful, and intentionally curated:

### 1. Seerah Companion Surface
Make it feel like a true guided entry into Seerah, not just a landing page.

### 2. Character / Adab Companion Surface
Make it feel more practical, behavioral, and scenario-based.

### 3. Daily Wisdom / Reflection Companion Surface
Make it feel richer and more durable without becoming noisy or bloated.

This should remain:
- lightweight
- production-safe
- clean
- scalable
- aligned with the calm premium app feel

---

## EXECUTION RULES

1. **Audit the current V10 implementation first.**
2. **Build on top of the new surfaces instead of rethinking ownership again.**
3. **Do not rebuild unrelated systems like Prophets, Hadith, History, Divine Life, Journal, Notes, or Qur’an.**
4. **Prefer curated quality over quantity.**
5. **Do not turn any of these into giant CMS-style systems yet.**
6. **Preserve localization readiness.**
7. **Keep routing stable.**
8. **Add only focused tests where useful.**
9. **Run analyzer and relevant tests at the end.**
10. **At the end, provide one clear full summary and an audit of what still remains.**

---

# IMPLEMENTATION SCOPE

## A. Audit the current V10 surfaces first

Audit the current implementation of:
- `seerah_companion_page.dart`
- `character_companion_page.dart`
- `daily_wisdom_companion_page.dart`
- companion content/data models
- Learn taxonomy integration
- related journey remap behavior

Identify:
- where each page still feels thin
- which sections need stronger curation
- which source handoffs are weak
- where structured content should be improved
- any obvious polish or UX inconsistencies

Do not start changing things before doing this audit.

---

## B. Deepen `/learn/seerah`

### Goal
Make Seerah feel more like a meaningful guided companion surface.

### Add/strengthen areas such as:
#### 1. Better key period coverage
Refine and deepen sections like:
- Early Makkah
- Hijrah
- Madinah Society
- Major Turning Points
- Farewell / Final Sermon

#### 2. Clearer period cards / modules
Each period should feel useful, not just decorative:
- short description
- why it matters
- what the user can explore next
- related companion links

#### 3. Better source handoffs
Add curated related links to:
- History archive
- Hadith
- Qur’an-linked learning
- Prophets where appropriate

#### 4. Journey-aware companion context
If easy and safe, improve “continue your journey” relevance and how journey users land in Seerah.

### Important
Do not build a huge dynamic timeline engine unless there is already a trivial reusable base.
Keep it curated and structured.

---

## C. Deepen `/learn/character`

### Goal
Make Character / Adab feel more practical and behavior-oriented.

### Add/strengthen areas such as:
#### 1. Stronger trait definitions
Refine trait cards so they feel substantial:
- what the trait is
- why it matters
- practical expression

#### 2. Better real-life scenarios
Deepen scenarios like:
- family
- speech
- neighbors
- intentions
- consistency
- anger/self-control if appropriate

#### 3. Better related source handoffs
Curated links to:
- Hadith
- Divine Life / Life lessons
- Qur’an reflections

#### 4. Better practical application tone
This surface should feel action-oriented and character-forming, not abstract.

### Important
Do not turn this into a duplicate of Divine Life Lessons.
It should stay a focused Character / Adab companion owner.

---

## D. Deepen `/learn/daily-wisdom`

### Goal
Make Daily Wisdom feel richer without becoming cluttered.

### Add/strengthen areas such as:
#### 1. More vetted wisdom entries
Expand the dataset thoughtfully.
Prefer a small high-quality set over bulk filler.

#### 2. Better rhythm / rotation behavior
If a simple clean selection approach is missing, add one.
Keep it lightweight.
Do not build a complex scheduling engine.

#### 3. Stronger source-owner handoff
If a wisdom item comes from Qur’an / Hadith / Life / Prophets, the page should make that relationship clearer.

#### 4. Better “carry this today” experience
The practical step/action should feel useful and calm.

### Important
Do not turn this into:
- journaling
- reminders engine
- notes system
- quote spam feed

It should remain a lightweight daily companion.

---

## E. Improve shared companion content structure if needed

If the current shared companion model/content file is getting cramped, refine it safely.

Possible improvements:
- better typed sections
- cleaner source link modeling
- explicit focus/entry-state support
- small helper methods for curated modules

Do not overengineer.

---

## F. Improve focused entry states where helpful

If safe and useful, improve focused entry handling for routes like:
- `/learn/seerah?focus=hijrah`
- `/learn/seerah?focus=madinah-society`

Only do this if it meaningfully improves the user experience and is cleanly supported by the existing page structure.

No overcomplicated deep-link state machines.

---

## G. Polish Learn integration where helpful

If the current Learn integration for these three surfaces still feels too thin:
- refine the entry cards
- improve taxonomy subtitles or routing targets if needed
- improve discoverability within the right category pages

Do not redesign Learn IA.
Only refine what is now live.

---

## H. Maintain safe Journey handoff behavior

Audit whether the remapped Journey tools now land well in the new surfaces.

If needed:
- improve the landing focus
- improve contextual titles/subtitles
- improve related section ordering

But do not rework journey architecture.

---

## I. Localization quality

Because these surfaces are now live, improve localization quality where practical.

If V10 propagated English fallback text into other locale ARBs:
- keep the structure intact
- do not break localization generation
- improve wording readiness where reasonable
- clearly report what still needs real translation later

Do not block the phase on full translation work unless explicitly requested.

---

## J. Tests and validation

Add/update focused tests as needed for:
- focused route entry behavior if added
- companion content integrity
- remapped journey handoff behavior
- route stability

Do not add noisy tests.
Add useful coverage only.

---

# VALIDATION

After implementation, validate all of the following:

## Seerah
1. `/learn/seerah` still works
2. focused entry states still work if added
3. content feels deeper and clearer
4. source handoffs are meaningful

## Character
5. `/learn/character` still works
6. trait/scenario sections feel more useful
7. source handoffs remain correct

## Daily Wisdom
8. `/learn/daily-wisdom` still works
9. wisdom entries feel richer and still calm
10. daily/practical step flow remains lightweight

## Stability
11. journey handoffs still work
12. learn integration still works
13. no routing regressions introduced
14. deep-link behavior still works

## Code health
15. `flutter analyze` passes
16. relevant tests pass
17. localization remains valid

---

# DELIVERABLES

Provide a concise summary with:

1. **Audit findings before refinement**
   - what felt thin
   - what was improved

2. **Seerah refinements**
   - sections/content improved
   - source handoffs improved
   - any focus behavior added

3. **Character refinements**
   - traits/scenarios/source handoffs improved

4. **Daily Wisdom refinements**
   - dataset/content improved
   - practical step/source owner flow improved

5. **Shared model/content changes**
   - what was refined in the companion content structure

6. **Files changed**
   - updated files
   - new files/tests/docs if any

7. **Validation**
   - analyzer
   - tests
   - behavior stability

8. **Final audit**
   - whether the three surfaces now feel stronger and more product-complete
   - what the next highest-value phase should be

---

# IMPORTANT SAFETY / PRODUCT RULE

This is a **depth and refinement phase**.

Do not:
- rebuild architecture
- overbuild infrastructure
- turn these into giant systems
- break current routing/ownership
- delete things for no reason

Do:
- deepen the surfaces thoughtfully
- improve curation
- improve source handoffs
- keep the experience calm, useful, and product-correct

# END OF PROMPT
