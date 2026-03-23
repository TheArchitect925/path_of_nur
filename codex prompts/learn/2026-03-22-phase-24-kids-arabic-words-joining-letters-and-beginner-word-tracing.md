===== PHASE 24 PROMPT — KIDS ARABIC WORDS, JOINING LETTERS, AND BEGINNER WORD TRACING =====

PRIMARY OBJECTIVE === BUILDING A KIDS ARABIC BEGINNER WORDS SYSTEM THAT INTRODUCES JOINING LETTERS, SIMPLE WORD RECOGNITION, AND SHORT WORD TRACING ON TOP OF THE EXISTING LETTER TRACING EXPERIENCE

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready enhancement phase built on top of the existing Kids Arabic tracing, progression, and mastery systems. DO NOT rebuild the tracing engine. DO NOT introduce advanced grammar teaching or strict handwriting validation. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve existing tracing behavior, progress, rewards, and routing
- Keep the experience child-friendly, visual, and simple
- Reuse existing letter data and tracing systems where practical
- Keep V1 focused on short beginner words and gentle joining awareness
- Do not introduce strict scoring
- No destructive migrations
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Introduce kids to simple joined Arabic letters in context
2. Add beginner word tracing with very short words
3. Help children see how letters look inside words
4. Keep the experience calm, forgiving, and visually guided
5. Build a bridge from letter tracing to reading readiness

--------------------------------------------------
A. AUDIT CURRENT KIDS ARABIC SYSTEM
--------------------------------------------------

Inspect:
- current letter tracing flow
- progress/mastery system
- supported vector letters
- fallback letters
- lesson ordering
- any existing Arabic word or reading content already in the kids section

Audit these questions:
- Which letters are already strong enough to reuse in beginner words?
- Which joined forms can be introduced safely without overcomplicating V1?
- Is there already a page or route where word practice best belongs?
- What existing audio/pronunciation support can be reused later or now if low-risk?

--------------------------------------------------
B. DEFINE A BEGINNER WORD SET
--------------------------------------------------

Create a curated beginner word set.

Requirements:
- very short words only
- visually simple
- appropriate for children
- built from letters that are already reasonably supported where possible
- small enough to feel high-quality and production-safe

Prefer:
- a limited starter set over a broad weak list

Document in the final summary:
- which words were chosen
- why they were chosen

--------------------------------------------------
C. INTRODUCE JOINING LETTER AWARENESS
--------------------------------------------------

Add a gentle introduction to joining letters.

Requirements:
- show that letters can look different inside words
- do not turn this into a heavy theory lesson
- keep the explanation visual and beginner-friendly
- avoid advanced terminology overload

Possible safe approaches:
- short visual comparison cards
- “letter alone” vs “letter in a word”
- tiny helper captions

--------------------------------------------------
D. BUILD BEGINNER WORD TRACING
--------------------------------------------------

Create a word-tracing experience for the selected short words.

Requirements:
- keep tracing forgiving
- reuse the existing tracing architecture where practical
- if full vector word tracing is too heavy for all words in this phase, implement a safe structured approach that still feels real and not fake
- ensure the child can trace the visible word form directly
- keep the visual target and the evaluation truth aligned as much as possible

Do not over-engineer strict word validation.

--------------------------------------------------
E. KEEP LETTER-TO-WORD CONTINUITY
--------------------------------------------------

The new word experience should feel connected to the existing letter system.

Requirements:
- children should understand that words are made from letters they have learned
- where helpful, surface the letters used in the word
- keep the transition from single-letter tracing to word tracing intuitive

--------------------------------------------------
F. ADD SIMPLE WORD-LEVEL PROGRESSION
--------------------------------------------------

Provide a simple progression through the beginner word set.

Requirements:
- clear next word
- retry option
- completed word visibility
- no confusing dead ends

Do not build a huge reading curriculum yet.

--------------------------------------------------
G. OPTIONAL LIGHT AUDIO SUPPORT IF SAFE
--------------------------------------------------

If low-risk and already easy to reuse, add lightweight pronunciation support.

Possible safe uses:
- tap word to hear pronunciation
- simple audio cue for the full word

Requirements:
- optional
- non-blocking
- calm and child-friendly
- do not let audio derail the main tracing build if it is not already easy to integrate

--------------------------------------------------
H. PAGE / IA PLACEMENT
--------------------------------------------------

Place this feature in the Kids Arabic flow cleanly.

Possible safe outcomes:
- a new Beginner Words page under Kids Arabic
- a next-step stage after mastery of a starter letter set
- a dedicated island/card in Kids Arabic learning

Requirements:
- routing should be clear
- do not clutter the existing letter-tracing flow
- keep progression understandable for parents and children

--------------------------------------------------
I. DATA SAFETY
--------------------------------------------------

Preserve:
- existing tracing progress
- mastery/progress map behavior
- XP/reward integrity
- lesson routing
- fallback/vector coexistence

Requirements:
- no destructive migrations
- no reset of progress
- no breakage of current Kids Arabic lessons

--------------------------------------------------
J. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- beginner word set is surfaced correctly
- joined-letter awareness content renders correctly
- word tracing flow works
- next/retry flow works for beginner words
- completed word progress is stored safely if introduced
- no regressions to the current letter-tracing flow

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - current Kids Arabic readiness for word tracing
   - chosen word-set approach
   - chosen page/IA placement

3. Beginner word summary
   - words chosen
   - why they were chosen
   - how joining awareness is introduced

4. Word tracing summary
   - how tracing works
   - how forgiving completion is handled
   - how letter-to-word continuity is preserved

5. Progression summary
   - how next/retry/completed flow works for words

6. Data safety summary
   - confirmation that no progress/state was lost

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

- Kids Arabic now includes a beginner word experience
- children can see simple joined-letter forms in context
- a short curated word set exists
- beginner word tracing works in a forgiving way
- the feature feels like a natural bridge from letters to reading
- no regressions are introduced
- the Kids Arabic system continues to feel like a guided learning journey

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild the tracing engine
- introduce advanced Arabic grammar
- introduce strict word-shape scoring
- try to build a full reading curriculum in one phase
- reset user progress
- clutter the kids experience with too much theory

Stay focused on joining-letter awareness, beginner words, and a clean bridge from letter tracing to early reading.

--------------------------------------------------

“And We have certainly made the Qur’an easy for remembrance.” — Qur’an 54:17

===== END PHASE 24 PROMPT =====
