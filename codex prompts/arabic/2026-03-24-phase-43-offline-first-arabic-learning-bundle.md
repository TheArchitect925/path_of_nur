# Phase 43 Prompt — Offline-First Arabic Learning Bundle

PRIMARY OBJECTIVE === BUILDING A RELIABLE OFFLINE-FIRST ARABIC LEADING BUNDLE SO LETTERS, WORDS, PHRASES, AUDIO, AND CORE LEARNING FLOWS WORK SMOOTHLY WITHOUT NETWORK DEPENDENCE

You are working in the existing Flutter codebase for Path of Nūr.

This is a targeted production-ready reliability phase built on top of:
- shared Arabic alphabet foundation
- shared positional-form foundation
- shared Arabic audio manifest
- shared beginner words and phrases foundation
- Kids Arabic tracing / reading / review systems
- Adult Arabic alphabet / words / reading-helper systems
- unified continuity/resume layer
- shared review layer
- Arabic search/filter
- calm Arabic progress dashboard
- Qur’an readiness bridge

DO NOT rebuild Kids or Adult Arabic learning systems. DO NOT change the core curriculum or UX direction. Build safely on top of the current implementation so Arabic learning remains dependable offline.

--------------------------------------------------
CORE RULES
--------------------------------------------------
- Audit first before editing
- Preserve all current Arabic learning flows, routing, progress, tracing, reading, audio behavior, and shared foundations
- Treat offline reliability as the source of truth for this phase
- Do not introduce destructive migrations
- Do not break existing online behavior while improving offline support
- Prefer stable bundled/local assets over fragile runtime assumptions
- Keep Kids and Adults distinct in presentation, but share the same underlying offline reliability improvements
- Run analyzer/tests and summarize results

--------------------------------------------------
PHASE OBJECTIVES
--------------------------------------------------

1. Audit the full Arabic learning asset/data dependency chain

2. Ensure core Arabic learning works reliably offline, including:
   - letters
   - positional forms
   - words
   - phrases
   - review/continue logic
   - progress dashboard data
   - core pronunciation audio where supported

3. Reduce runtime dependency on non-local asset assumptions

4. Improve startup/load reliability and playback reliability for Arabic learning surfaces

5. Leave the Arabic system more robust, cache-safe, and production-ready for real-world offline use

--------------------------------------------------
A. AUDIT CURRENT OFFLINE DEPENDENCIES
--------------------------------------------------

Audit the full Arabic learning stack and identify what already works offline versus what is still fragile.

Inspect:
- shared Arabic alphabet data
- shared positional-form data
- shared words/phrases data
- shared audio manifest
- Kids Arabic letter/word/phrase/audio flows
- Adult Arabic letter/word/phrase/audio flows
- Qur’an readiness bridge usage of Arabic learning assets
- search/filter indexing inputs
- continuity/review/progress data sources
- any dynamic asset lookup or runtime fallback logic
- any network assumptions hidden in playback or asset loading

Audit these questions:
- Which Arabic learning data is already bundled locally?
- Which Arabic audio assets are bundled versus assumed externally?
- Are there any runtime failures if assets are unavailable?
- Do any surfaces stall or degrade badly offline?
- Is audio playback dependent on online fetches or fragile lookup timing?
- Are search/filter indices derived locally and safely?
- What are the highest-priority offline risks for real users?

--------------------------------------------------
B. DEFINE THE OFFLINE BUNDLE SCOPE
--------------------------------------------------

Define what the “core offline Arabic bundle” must include.

At minimum, aim to support offline:
- shared alphabet catalog
- positional forms
- beginner words
- mini phrases
- review/continue/progress logic
- search/filter for locally available Arabic learning content
- core pronunciation audio for supported letters/words/phrases where already part of the product

Requirements:
- choose a realistic, high-value offline bundle scope
- prefer dependable core learning over trying to solve every edge case at once
- document clearly in the final summary what is guaranteed offline and what is still best-effort

--------------------------------------------------
C. HARDEN LOCAL DATA OWNERSHIP
--------------------------------------------------

Make sure core Arabic learning data is safely local and offline-available.

Requirements:
- no runtime dependence on remote content for core Arabic learning
- shared foundations must remain available without network
- search/filter/review/continue should work from local data and local progress state
- avoid duplicated local caches of the same shared data unless necessary

The goal is one stable local truth for Arabic learning content.

--------------------------------------------------
D. HARDEN LOCAL AUDIO AVAILABILITY
--------------------------------------------------

Audit and improve Arabic learning audio reliability offline.

Requirements:
- use bundled/local audio where that is already the intended product path
- ensure audio lookups do not fail silently due to fragile asset assumptions
- if some audio is missing, fail gracefully without breaking the learning flow
- do not rebuild the whole audio system; harden the manifest/lookup/loading path

If practical, improve:
- preload behavior for high-frequency audio
- faster first-play reliability
- reduced playback lag for common letter audio

--------------------------------------------------
E. IMPROVE ASSET LOADING / PREFETCH WHERE SAFE
--------------------------------------------------

If useful and low-risk, add lightweight preloading/prefetch for high-value Arabic learning assets.

Examples:
- most common letter audio
- beginner word audio
- first lesson assets
- current “continue learning” target assets

Requirements:
- keep memory usage reasonable
- no huge eager-loading strategy that hurts startup
- target the most valuable assets first
- preserve stable fallback behavior if preloading is incomplete

--------------------------------------------------
F. ENSURE OFFLINE SEARCH / REVIEW / CONTINUITY
--------------------------------------------------

Make sure offline users can still:
- search letters/words/phrases
- get continue/review suggestions
- view progress summaries
- resume where they left off

Requirements:
- no network required for these core decisions
- all logic should derive from shared local foundations and local progress state
- no broken or empty continue/review surfaces just because the app is offline

--------------------------------------------------
G. HANDLE MISSING OR PARTIAL OFFLINE ASSETS GRACEFULLY
--------------------------------------------------

If certain Arabic audio or optional enrichment assets are unavailable, handle it cleanly.

Requirements:
- no crashes
- no broken pages
- calm fallback behavior
- core learning still works
- clearly degrade optional enhancements, not the core experience

Do not present alarming error states to the user for minor optional asset gaps.

--------------------------------------------------
H. KEEP KIDS AND ADULTS DISTINCT IN PRESENTATION
--------------------------------------------------

Offline hardening must not flatten the UX.

Kids should remain:
- guided
- visual
- simple
- encouragement-first

Adults should remain:
- calm
- clean
- direct
- explanation-friendly

This phase improves the reliability layer beneath both.

--------------------------------------------------
I. LIGHTWEIGHT PERFORMANCE / RELIABILITY SWEEP
--------------------------------------------------

After offline improvements, do a light reliability sweep.

Check:
- first open of Arabic learning surfaces
- first audio playback
- repeat playback
- resume into current lesson
- search responsiveness
- review/continue responsiveness
- no broken routes when offline

Optimize only where needed and safe.

--------------------------------------------------
J. DATA SAFETY
--------------------------------------------------

Preserve:
- Kids Arabic progress
- Adult Arabic progress
- tracing/reading/review state
- milestones/rewards integrity
- route continuity
- shared foundation correctness

Requirements:
- no destructive migrations
- no reset of progress
- no canonical id drift
- no hidden regressions introduced by offline hardening

--------------------------------------------------
K. TESTING
--------------------------------------------------

Add or update meaningful tests for:

- core shared Arabic data is available without network assumptions
- shared audio manifest resolves offline-safe assets where intended
- continue/review/progress/search logic works from local data
- missing optional audio/assets fail gracefully
- Kids and Adults still load correct route targets
- no regressions are introduced into tracing, reading, routing, or progress

If practical, include targeted offline-mode simulation or asset-unavailable test coverage.

Do not add fake tests. Add regression protection that matters.

Run analyzer/tests for changed areas and report clearly.

--------------------------------------------------
DELIVERABLES
--------------------------------------------------

1. Files changed

2. Audit findings
   - current offline-safe assets/data
   - current fragility points
   - chosen offline bundle scope

3. Offline bundle summary
   - what is now guaranteed offline
   - what remains optional/best-effort
   - what was hardened

4. Audio reliability summary
   - how audio lookup/loading was improved
   - any preload/prefetch behavior added
   - how missing audio is handled

5. Search/review/continue/progress summary
   - how these remain functional offline
   - what shared local data they rely on

6. Data safety summary
   - confirmation that no progress/state/routing/shared-foundation integrity was lost

7. Validation
   - analyzer/tests run
   - results

8. FINAL AUDIT
   - what was completed
   - regressions found/fixed
   - remaining offline follow-up items
   - technical debt intentionally left for later

--------------------------------------------------
SUCCESS CRITERIA
--------------------------------------------------

- core Arabic learning works reliably offline
- letters, words, phrases, review, continue, and progress remain usable without network
- core pronunciation audio is more reliable offline where supported
- missing optional assets degrade gracefully
- Kids and Adults remain distinct in presentation
- no regressions are introduced into tracing, reading, routing, progress, or shared foundations
- Arabic learning feels dependable and production-ready in real-world offline usage

--------------------------------------------------
DO NOT DO IN THIS PHASE
--------------------------------------------------

Do not:
- rebuild Kids or Adult Arabic systems from scratch
- flatten Kids and Adults into one generic offline UI
- redesign the whole Arabic curriculum
- introduce destructive migrations
- break canonical ids, route targets, or shared foundation integrity
- turn this into a giant caching platform rewrite beyond Arabic learning scope

Stay focused on offline-first Arabic asset/data reliability and safe hardening of the existing system.

--------------------------------------------------

“And say, ‘My Lord, increase me in knowledge.’” — Qur’an 20:114
