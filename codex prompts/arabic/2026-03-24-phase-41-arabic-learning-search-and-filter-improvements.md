# AGENTS.md instructions for /Users/shahabmansoor/Developer/path_of_nur

## My request for Codex:
===== PHASE 41 PROMPT — ARABIC LEARNING SEARCH AND FILTER IMPROVEMENTS =====

PRIMARY OBJECTIVE === BUILDING A CLEAN, FAST, SHARED SEARCH AND FILTER EXPERIENCE ACROSS ARABIC LEARNING SO USERS CAN FIND LETTERS, WORDS, PHRASES, AND REVIEW TARGETS EASILY

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready discovery and navigation phase built on top of:
- shared Arabic alphabet foundation
- shared positional-form foundation
- shared Arabic audio manifest
- shared beginner words and phrases foundation
- Kids Arabic learning flows
- Adult Arabic learning flows
- shared continuity / resume layer
- shared gentle review layer
- Qur’an readiness bridge

DO NOT rebuild the Kids or Adult Arabic systems. DO NOT break tracing, reading, review, audio, routing, progress, or shared catalog behavior. Build safely on top of the current implementation.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve all shared Arabic foundations
- Preserve Kids and Adult UX separation
- Keep search/filter logic shared beneath distinct presentations
- Keep the UX calm, fast, and simple
- Do not introduce dense enterprise-style search UI
- Avoid duplicated search/filter logic across pages
- No destructive migrations
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Audit current Arabic learning discovery and navigation across Kids and Adults

2. Build a shared search/filter layer for Arabic learning content including:
   - letters
   - words
   - phrases
   - review targets
   - beginner Qur’an bridge snippets where appropriate

3. Surface clean search/filter experiences in Kids and Adults with age-appropriate presentation differences

4. Improve findability without cluttering the experience

--------------------------------------------------
A. AUDIT CURRENT DISCOVERY FLOWS
--------------------------------------------------

Audit all current Arabic learning discovery/navigation surfaces.

Inspect:
- Kids Arabic landing pages
- Adult Arabic landing pages
- alphabet overview pages
- words/phrases pages
- review/practice surfaces
- continuity/resume surfaces
- Qur’an readiness bridge surfaces
- any existing search or filter UI already present
- any page-local search logic
- any hardcoded category chips or browsing shortcuts

Audit these questions:
- Where can users currently browse letters, words, phrases, and review items?
- Is anything currently searchable?
- Are there duplicated page-local filters?
- Are some surfaces too broad or too hard to navigate without search?
- What are the highest-value search targets for Kids?
- What are the highest-value search targets for Adults?
- What should be shared beneath the UI versus presentation-specific?
- What is the safest search/filter scope for this phase?

--------------------------------------------------
B. DEFINE A SHARED ARABIC SEARCH INDEX MODEL
--------------------------------------------------

Create a shared Arabic learning search/index model that can represent searchable items across modes.

It may include only what is genuinely useful and safe, such as:
- canonical item id
- item type (letter, word, phrase, review target, bridge snippet)
- display title
- Arabic text
- transliteration
- simple meaning / gloss where applicable
- keywords/tags if useful
- route target metadata
- mode availability (kids/adult/both)

Requirements:
- one maintainable shared source for discovery
- compatible with shared foundations
- not bloated with speculative fields
- explicit enough to support clean filtering and routing

--------------------------------------------------
C. BUILD A SHARED SEARCH / FILTER SERVICE
--------------------------------------------------

Create a shared search/filter layer that can:
- search letters by name/transliteration/Arabic glyph where appropriate
- search words and phrases
- filter by content type
- optionally filter by review/unfinished/continue-relevant status if already safe

Requirements:
- centralize logic
- avoid page-local search implementations
- keep search fast
- keep ranking simple and understandable
- do not overbuild a complex search engine

This is a practical learning-content finder, not a global full-text system.

--------------------------------------------------
D. SUPPORT HIGH-VALUE FILTERS
--------------------------------------------------

Add a small, high-value filter model.

Possible filters:
- Letters
- Words
- Phrases
- Review
- Continue
- Beginner Qur’an bridge

Requirements:
- use only filters that are truly useful
- keep the number of filters small
- avoid clutter
- ensure the same underlying filter logic can support both Kids and Adults

If some filters should only appear in one mode, keep the shared logic but present them selectively.

--------------------------------------------------
E. KIDS SEARCH / FILTER PRESENTATION
--------------------------------------------------

Surface Kids search/filter in a simpler, more guided way.

Requirements:
- easy to understand
- minimal UI complexity
- likely simple chips + lightweight search entry
- no dense result lists
- keep the tone child-friendly and parent-friendly

Kids should feel:
- guided
- simple
- visual
- not overloaded

--------------------------------------------------
F. ADULT SEARCH / FILTER PRESENTATION
--------------------------------------------------

Surface Adult search/filter in a cleaner, more direct way.

Requirements:
- calm and efficient
- easy to browse letters/words/phrases
- more direct and less playful than Kids
- no unnecessary visual noise
- support practical discovery for adult learners

Adults should feel:
- clean
- self-guided
- clear
- not cluttered

--------------------------------------------------
G. ROUTE RESULTS TO THE CORRECT MODE-SPECIFIC DESTINATIONS
--------------------------------------------------

Search/filter results must open the correct surfaces.

Requirements:
- Kids results open Kids experiences
- Adult results open Adult experiences
- shared canonical ids are used beneath the UI
- no cross-mode leaks
- no ambiguous route targets
- review-target items should route to the right resume/review flow where supported

--------------------------------------------------
H. INTEGRATE REVIEW / CONTINUE SIGNALS WHERE USEFUL
--------------------------------------------------

If safe, allow search/filter to surface:
- unfinished items
- review suggestions
- continue targets

Requirements:
- do this only if it stays calm and useful
- do not overload the main search with too much state complexity
- keep “review” and “continue” as helpful filters, not noisy badges everywhere

--------------------------------------------------
I. HANDLE EMPTY, FIRST-TIME, AND NO-RESULT STATES
--------------------------------------------------

Handle:
- first-time users with no progress
- users with no review items
- no search results
- filters that currently yield no items

Requirements:
- calm empty states
- no broken lists
- useful fallback suggestions such as:
  - browse all letters
  - start with beginner words
  - continue Arabic learning

--------------------------------------------------
J. PRESERVE SHARED FOUNDATIONS
--------------------------------------------------

Ensure search/filter uses:
- shared alphabet ids
- shared words/phrases ids
- shared review/continuity metadata where appropriate
- shared audio-aware routing if needed

Requirements:
- no duplicated static datasets
- no page-local drift
- no bypassing shared foundations unnecessarily

--------------------------------------------------
K. LIGHTWEIGHT UX / COPY SWEEP
--------------------------------------------------

After integration, run a light polish pass on search/filter surfaces.

Check:
- search placeholder copy
- filter labels
- result-card clarity
- no disclosure arrows on cards/containers if that rule is already enforced app-wide
- spacing and chip consistency
- no duplicate competing search boxes

Do not redesign the entire Arabic learning UI in this phase.

--------------------------------------------------
L. DATA SAFETY
--------------------------------------------------

Preserve:
- Kids Arabic progress
- Adult Arabic progress
- tracing/reading/review flows
- continuity layer behavior
- shared foundations
- route integrity

Requirements:
- no destructive migrations
- no reset of progress
- no hidden regressions from canonical id usage
- no broken route targets

--------------------------------------------------
M. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- shared search index resolves the intended letters/words/phrases
- filter outputs are correct
- Kids search results route correctly
- Adult search results route correctly
- review/continue filters work safely where supported
- empty/no-result states behave correctly
- no regressions are introduced into routing, progress lookup, or shared foundation behavior

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - current discovery/search/filter situation
   - duplication/gaps found
   - chosen shared search/filter scope

3. Shared discovery foundation summary
   - search/index model introduced
   - filters introduced
   - what content types are covered

4. Kids summary
   - how Kids search/filter is presented
   - what route targets it supports

5. Adults summary
   - how Adult search/filter is presented
   - what route targets it supports

6. Routing summary
   - how result targets are resolved safely
   - how mode-specific destinations are preserved

7. Data safety summary
   - confirmation that no progress/state/routing/shared-foundation integrity was lost

8. Validation
   - analyzer/tests run
   - results

9. FINAL AUDIT
   - what was completed
   - regressions found/fixed
   - remaining follow-up items
   - technical debt intentionally left for later

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- there is one shared Arabic learning search/filter foundation beneath Kids and Adults
- users can easily find letters, words, phrases, and review targets
- Kids search/filter feels simpler and guided
- Adult search/filter feels cleaner and direct
- route targets are correct and mode-safe
- no regressions are introduced into tracing, reading, review, routing, progress, or shared foundations
- Arabic learning becomes easier to navigate and less fragmented

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild Kids or Adult Arabic from scratch
- flatten Kids and Adults into one generic search UI
- build a complex full-text search engine
- introduce destructive migrations
- break canonical ids, routing, or review/continuity systems
- redesign the full Learn hub in this phase

Stay focused on shared Arabic search/filter improvements and safe discovery/navigation.

--------------------------------------------------

“And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114

===== END PHASE 41 PROMPT =====
