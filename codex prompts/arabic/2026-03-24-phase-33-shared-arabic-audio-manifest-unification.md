===== PHASE 33 PROMPT — SHARED ARABIC AUDIO MANIFEST UNIFICATION =====

PRIMARY OBJECTIVE === BUILDING ONE SHARED ARABIC AUDIO MANIFEST AND LOOKUP LAYER USED BY BOTH KIDS AND ADULT ARABIC LEARNING EXPERIENCES

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready shared-foundation phase built on top of the unified Arabic alphabet foundation and shared positional-form foundation. DO NOT rebuild Kids Arabic or Adult Arabic audio UX from scratch. DO NOT break tracing, reading, review, progress, routing, or shared catalog behavior. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve the shared Arabic alphabet foundation and shared positional-form foundation
- Preserve Kids Arabic and Adult Arabic routing, progress, lesson continuity, and current audio behavior
- Do not flatten Kids and Adults into one shared UI
- Unify the audio/source mapping beneath both experiences
- Keep Kids presentation simpler and more guided
- Keep Adults cleaner and more direct
- No destructive migrations
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Audit all current Arabic letter/word audio lookup behavior across Kids and Adults

2. Identify duplicated, drifting, or page-local Arabic audio mappings

3. Create one shared Arabic audio manifest / lookup layer

4. Refactor both Kids and Adult Arabic experiences to use that shared audio layer safely

5. Preserve age-appropriate playback behavior while removing duplicated static mapping ownership

--------------------------------------------------
A. AUDIT CURRENT ARABIC AUDIO USAGE
--------------------------------------------------

Audit the full Arabic learning audio setup across both Kids and Adults.

Inspect:
- Kids Arabic letter pronunciation usage
- Kids word/reading-mode audio usage
- Adult Arabic letter pronunciation usage
- Adult Qur’anic Arabic seed/audio mapping
- any page-local audio path lookup logic
- any audio asset naming conventions
- any existing helper functions/services for audio playback or asset resolution
- any places where audio paths are duplicated, hardcoded, or inferred inconsistently

Audit these questions:
- Where are Kids currently getting letter audio from?
- Where are Adults currently getting letter audio from?
- Are the actual source paths the same but referenced differently?
- Are there duplicated asset path strings in multiple files?
- Do word-level and letter-level audio need separate lookup layers, or can they share the same manifest structure?
- What shared audio metadata already exists in the alphabet catalog?
- What adult compatibility or alias handling is still needed?
- What should remain presentation-specific and not be moved into the shared audio layer?

--------------------------------------------------
B. DEFINE A SHARED ARABIC AUDIO MODEL
--------------------------------------------------

Create a production-safe shared audio model/manifest for Arabic learning.

The shared model may include only what is genuinely useful and safe, such as:
- canonical letter id
- canonical audio asset path for the letter
- optional word audio mapping structure if already supported safely
- optional pronunciation key / alias metadata if needed for compatibility
- lookup helpers by canonical id
- lookup helpers by legacy adult seed id where necessary

Requirements:
- one canonical source of truth
- maintainable and explicit
- compatible with both Kids and Adults
- avoid speculative over-modeling

--------------------------------------------------
C. CENTRALIZE LETTER AUDIO LOOKUP
--------------------------------------------------

Make sure both Kids and Adults resolve letter pronunciation from the same shared audio source.

Requirements:
- eliminate duplicated page-local path ownership where safe
- keep canonical ids as the main lookup path
- preserve adult compatibility lookup if needed
- ensure missing-audio fallback remains graceful
- do not break current audio playback UI

This phase should unify the source mapping, not necessarily redesign playback UX.

--------------------------------------------------
D. HANDLE WORD / READING AUDIO SAFELY
--------------------------------------------------

If Kids word-reading mode or related Arabic reading surfaces already use word-level audio, audit and unify only what is safe.

Requirements:
- do not force an overgeneralized manifest if word audio is still sparse or localized
- unify shared word-audio metadata only if it is genuinely beneficial and stable
- otherwise, keep word audio local while cleaning up letter-audio ownership first

Be honest about current coverage in the final summary.

--------------------------------------------------
E. PRESERVE KIDS / ADULT UX DIFFERENCES
--------------------------------------------------

Keep the UI and behavior distinct where appropriate.

Kids may still use:
- more guided replay
- easier tap targets
- softer feedback

Adults may still use:
- cleaner direct access
- fewer playful cues
- more explanation-friendly layout

Requirements:
- unify the audio source mapping beneath them
- do not flatten the presentation layer

--------------------------------------------------
F. REDUCE PAGE-LOCAL DRIFT
--------------------------------------------------

Remove duplicated or drifting audio path logic from individual Kids/Adult pages where safely possible.

Requirements:
- shared audio mapping should live in shared foundations
- page-local code should request audio through the shared source
- preserve local page behavior that is truly presentation-specific
- keep ownership boundaries clean

Goal:
- shared audio data in shared layers
- playback UX in experience-specific layers

--------------------------------------------------
G. KEEP COMPATIBILITY SAFE
--------------------------------------------------

If adult surfaces still rely on legacy seed ids or compatibility identifiers, handle them safely.

Requirements:
- no broken audio due to id normalization
- compatibility aliases should continue to resolve
- no progress/routing breakage due to audio-layer refactor
- explain clearly in the final summary how compatibility was preserved

--------------------------------------------------
H. LIGHTWEIGHT UX / FAILURE-STATE SWEEP
--------------------------------------------------

Run a light sweep of affected Arabic audio surfaces.

Check:
- tap-to-play still works
- replay still works where intended
- missing-audio fallback remains graceful
- no broken controls
- no disclosure arrows on cards/containers if that rule is already enforced app-wide
- labels/tooltips remain clear if present

Do not redesign the full audio UI in this phase.

--------------------------------------------------
I. DATA SAFETY
--------------------------------------------------

Preserve:
- Kids Arabic progress
- Adult Arabic continuity
- tracing/reading/review flow
- shared canonical ids/order
- shared positional-form correctness
- route stability
- current audio behavior

Requirements:
- no destructive migrations
- no reset of progress
- no hidden regressions due to audio lookup changes
- no removal of existing supported audio

--------------------------------------------------
J. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- shared audio manifest resolves all intended canonical letter audio paths
- legacy adult id compatibility resolves correctly
- Kids surfaces read audio from the shared source where intended
- Adult surfaces read audio from the shared source where intended
- missing-audio fallback behaves safely
- no regressions are introduced into shared foundation, tracing, reading, or routing behavior

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - current Kids audio usage
   - current Adult audio usage
   - duplication/drift found
   - chosen shared audio model scope

3. Shared audio foundation summary
   - model/manifest introduced
   - what it covers
   - how canonical and legacy lookup work

4. Refactor summary
   - how Kids now use the shared audio source
   - how Adults now use the shared audio source
   - what intentionally remains local

5. Compatibility summary
   - how legacy adult ids/audio lookups were preserved safely

6. Data safety summary
   - confirmation that no progress/state/audio continuity was lost

7. Validation
   - analyzer/tests run
   - results

8. FINAL AUDIT
   - what was completed
   - regressions found/fixed
   - remaining follow-up items
   - technical debt intentionally left for later

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- Kids and Adult Arabic now use one shared Arabic audio source/manifest for letters where intended
- duplicated audio lookup logic is reduced
- canonical and legacy adult ids resolve safely
- Kids remain simpler and more guided in presentation
- Adults remain cleaner and more direct in presentation
- no tracing, reading, routing, or progress regressions are introduced
- the app is now ready for future shared words/phrases/audio expansion from one cleaner audio foundation

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild Kids or Adult Arabic audio UX from scratch
- flatten Kids and Adults into one generic interface
- break canonical ids/order
- remove existing supported audio
- broaden into full shared word/phrase curriculum design in this phase
- introduce destructive migrations or route changes

Stay focused on shared Arabic audio foundation unification and safe refactoring beneath both Arabic learning experiences.

--------------------------------------------------

“And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

===== END PHASE 33 PROMPT =====
