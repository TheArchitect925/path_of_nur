===== PHASE 19 PROMPT — KIDS ARABIC VECTOR TRACING EXPANSION PACK 1 =====

PRIMARY OBJECTIVE === BUILDING THE NEXT PRODUCTION-SAFE BATCH OF VECTOR-TRACED ARABIC LETTERS ON TOP OF THE NEW KIDS TRACING ENGINE

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready enhancement phase built on top of the existing Kids Arabic tracing engine. DO NOT rebuild the tracing engine. DO NOT remove the working vector tracing system introduced for Alif, Ba, and Meem. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve the existing working tracing engine
- Preserve current tracing behavior for Alif, Ba, and Meem
- Extend the vector tracing system cleanly instead of duplicating logic
- Keep V1 forgiving and child-friendly
- Do not introduce strict scoring or stroke-order enforcement
- Keep the fallback path for unsupported letters working
- Reuse the existing kids UI, lesson shell, and progress model where practical
- No destructive changes
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Expand the real vector tracing rollout beyond Alif, Ba, and Meem

2. Add the next clean batch of letters:
   - Noon
   - Seen
   - Laam
   - Kaaf
   - Haa

3. Tune the tracing templates and simple completion thresholds per letter so the experience remains forgiving but believable

4. Ensure the lesson flow and UI correctly surface the newly supported vector letters

5. Preserve safe fallback behavior for letters not yet upgraded to vector tracing

--------------------------------------------------
A. AUDIT THE CURRENT TRACING ENGINE
--------------------------------------------------

Inspect:
- kids_arabic_vector_tracing.dart
- kids_arabic_tracing_pad.dart
- kids_arabic_lesson_page.dart
- kids_arabic_progress_provider.dart
- current lesson sequencing and any letter metadata/catalog driving Kids Arabic

Audit these questions:
- How are Alif, Ba, and Meem currently defined?
- Which parts of the vector template system are reusable as-is?
- How are thresholds currently tuned?
- How does the lesson page decide whether to use vector tracing versus the legacy fallback?
- Are there any shape types that will need special handling for the next batch?
- Is the current stroke smoothing/completion logic robust enough for more curved or segmented letters?

--------------------------------------------------
B. ADD NEW VECTOR LETTER TEMPLATES
--------------------------------------------------

Add production-safe vector tracing templates for:
- Noon
- Seen
- Laam
- Kaaf
- Haa

Each template should include the same structured data pattern already used for the existing vector letters, such as:
- id
- display name
- outline builder
- ordered vector strokes
- simple progress/alignment/effort thresholds

Requirements:
- the visible guide and the evaluated tracing path must continue to come from the same vector truth
- keep the letter guide visually clear and child-friendly
- ensure the new templates are maintainable and easy to extend later
- if any letter requires multiple strokes or more complex shaping, model that cleanly rather than hacking around it

--------------------------------------------------
C. TUNE COMPLETION LOGIC PER LETTER
--------------------------------------------------

The next letter batch introduces more shape variety. Tune completion heuristics safely.

Requirements:
- keep the system forgiving
- do not introduce strict grading
- allow children to succeed through reasonable tracing effort
- prevent obviously accidental or tiny scribbles from immediately counting as full completion
- tune thresholds per letter where needed instead of using one crude global value for everything

If a letter has a more complex outline:
- adjust effort/progress/alignment thresholds sensibly
- document any special tuning in the final summary

--------------------------------------------------
D. ENSURE CLEAN LESSON FLOW INTEGRATION
--------------------------------------------------

Update the Kids Arabic lesson flow so the newly supported vector letters appear cleanly in the right places.

Requirements:
- newly supported letters should use the real vector tracing engine automatically
- unsupported letters should continue using the existing safe fallback without breaking the broader Kids Arabic flow
- do not create duplicate lesson entries or confusing branching
- preserve progress behavior and lesson continuity

If the current lesson flow is messy:
- do lightweight cleanup only where needed to support the expanded vector rollout

--------------------------------------------------
E. IMPROVE VECTOR/FALLBACK BOUNDARY
--------------------------------------------------

Strengthen the coexistence between:
- vector-traced letters
- legacy fallback letters

Requirements:
- the app should clearly and safely know which letters use the real vector system
- avoid brittle if/else logic spread across multiple UI files
- centralize the supported-letter decision where practical
- ensure the fallback remains stable until more letters are upgraded

Do not remove the fallback system in this phase.

--------------------------------------------------
F. OPTIONAL LIGHT POLISH IF SAFE
--------------------------------------------------

If small and low-risk, add one or more lightweight polish improvements only if they fit naturally into the current tracing system:

Possible safe options:
- subtle ghost-stroke preview for the active letter
- slightly richer completion glow/celebration
- gentle haptic or sound hook if already easy and consistent with the app architecture

Requirements:
- keep this optional and secondary
- do not let polish derail the core expansion work
- do not add noisy or distracting effects

--------------------------------------------------
G. KEEP THE UX CHILD-FRIENDLY
--------------------------------------------------

As more letters are added, preserve the V1 design goals:
- visual clarity
- smooth tracing
- forgiving success feedback
- calm and fun presentation
- no overcomplicated controls

Check:
- color picker still works
- reset still clears cleanly
- completion state remains readable
- tracing surface still feels smooth and uncluttered

--------------------------------------------------
H. DATA / STATE SAFETY
--------------------------------------------------

Preserve:
- existing progress for Alif, Ba, Meem
- lesson completion behavior
- XP/reward flow remaining tied to lesson completion unless already safely reused
- current Kids Arabic routing and page structure
- fallback support for unsupported letters

Requirements:
- no destructive migrations
- no reset of progress
- no breakage of the broader Kids Arabic section

--------------------------------------------------
I. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- new vector templates exist for Noon, Seen, Laam, Kaaf, and Haa
- newly supported letters use vector tracing instead of fallback
- Alif, Ba, and Meem still work
- unsupported letters still fall back safely
- completion heuristics remain stable for the expanded set
- reset and color behavior still work across vector letters
- no regressions in tracing pad rendering or interaction

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - current tracing engine state
   - any constraints discovered when expanding beyond the first 3 letters

3. Vector expansion summary
   - letters added
   - how their outlines/strokes are stored
   - any per-letter tuning applied

4. Lesson flow summary
   - how new letters are surfaced
   - how vector/fallback coexistence is handled

5. UX/polish summary
   - any optional polish added
   - confirmation that tracing remains child-friendly

6. Data safety summary
   - confirmation that no progress/state was lost

7. Validation
   - analyzer/tests run
   - results

8. FINAL AUDIT
   - what was completed
   - regressions found/fixed
   - remaining rollout follow-ups
   - technical debt intentionally left for later

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- Noon, Seen, Laam, Kaaf, and Haa are added as real vector-traced letters
- Alif, Ba, and Meem continue to work
- vector letters continue using the same visible/evaluated path truth
- lesson flow correctly surfaces supported vector letters
- unsupported letters still work via fallback
- tracing remains smooth, forgiving, and child-friendly
- no progress/state is lost
- the tracing engine is now proven across a broader set of Arabic letter shapes

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild the tracing engine
- add strict scoring
- add stroke-order enforcement
- try to implement the whole alphabet at once
- remove the legacy fallback entirely
- broaden this into full gamification or handwriting recognition

Stay focused on expanding the working vector tracing engine to the next high-value batch of Arabic letters.

--------------------------------------------------

“And We have certainly made the Qur’an easy for remembrance.” — Qur’an 54:17

===== END PHASE 19 PROMPT =====
