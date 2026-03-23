===== PHASE 3 PROMPT — QUR’AN READER / PLAYER AUDIT =====

PRIMARY OBJECTIVE === BUILDING / FIXING QUR’AN READER / PLAYER AUDIT

You are working inside the existing Path of Nūr codebase.

Your task in this phase is NOT to introduce new features yet unless a tiny repair is absolutely required to complete the audit safely. The purpose of this phase is to perform a thorough audit of the current Qur’an Reader player system so we can understand exactly what already exists, what still works, what is partially implemented, what regressed, and what enhancements make sense next.

This is an audit-first phase.

IMPORTANT SAFETY / EXECUTION RULES
- Do not do a broad rebuild.
- Do not delete existing player logic, data, routes, providers, services, UI controls, or models.
- Do not “clean up” by removing code unless it is clearly dead and you explicitly report it.
- Do not add speculative features in this phase.
- If you must make a tiny safe fix to allow the audit to complete properly, keep it minimal and report it clearly.
- Focus only on the Qur’an Reader / player system and directly related code paths.
- At the end, provide one consolidated audit summary with findings, gaps, risks, and enhancement recommendations.

==================================================
AUDIT GOAL
==================================================

Produce a clear audit of the current Qur’an Reader / player system covering:
1. what player capabilities already exist,
2. what UI and controls already exist,
3. what playback flows are implemented,
4. what synchronization/highlighting exists,
5. what persistence exists,
6. what routes/pages/components are involved,
7. what is broken, partial, missing, duplicated, or inconsistent,
8. what enhancements should be prioritized next.

==================================================
AREAS TO AUDIT
==================================================

Audit the full current Qur’an Reader / player stack, including but not limited to:

A) PLAYER UI / CONTROLS
Check what currently exists in the reader/player UI:
- play
- pause
- resume
- stop
- next ayah
- previous ayah
- next surah
- previous surah
- seek/progress bar
- restart ayah
- restart surah
- reciter selection
- playback speed
- repeat ayah
- repeat range
- loop surah
- auto-scroll toggle
- follow mode
- mini-player
- expanded player sheet
- download/offline controls
- translation toggle
- transliteration toggle
- bookmark/favorite/note/share controls
- sleep timer
- memorization controls
- any other current player actions

For each, determine:
- fully implemented
- partially implemented
- UI only / not wired
- wired but broken
- not present

B) PLAYBACK ARCHITECTURE
Audit how the player is structured:
- audio service / controller / repository
- Riverpod providers / notifiers / view models
- player state enums/models
- event streams/subscriptions
- playback source loading
- recitation source handling
- ayah/surah playback entry points
- whether playback is local, remote, cached, hybrid, or partially offline-capable

Document:
- what the current architecture is
- where the source of truth lives
- whether the state flow is clean or fragmented
- whether duplicate player logic exists in multiple places

C) ACTIVE AYAH SYNC / HIGHLIGHTING
Audit:
- whether active ayah highlighting exists
- how it is driven
- whether it uses timing metadata, ayah index, callbacks, polling, or another mechanism
- whether current ayah sync is accurate
- whether scrolling follows active ayah
- whether stale highlight bugs or offset issues exist
- whether this logic is clean, fragile, duplicated, or partially broken

D) CONTINUE / RESUME BEHAVIOR
Audit whether the reader remembers:
- last surah
- last ayah
- last page/scroll position
- last listening position
- last reciter
- last playback mode
- continue reading state
- continue listening state

Document whether each is:
- fully working
- partially working
- stored but not surfaced
- not implemented

E) ENTRY POINTS / ROUTING
Audit all player entry points:
- opening from Qur’an homepage
- opening from Surah List
- opening from ayah tap
- continue reading
- continue listening
- memorize/study related entry points if present
- any routes that incorrectly open the wrong screen, placeholder, or home page

F) USER EXPERIENCE / PRODUCT READINESS
Assess the player from a user-experience perspective:
- is the default player simple and usable
- is the player cluttered or underpowered
- are key controls missing
- is the distinction between reading, listening, studying, and memorizing clear or blurred
- does the player feel production-ready or pieced together
- where are the biggest friction points for daily use

==================================================
REQUIRED AUDIT OUTPUT FORMAT
==================================================

Provide the audit findings in a clean structured format.

1. CURRENT PLAYER INVENTORY
List every player feature/control you found and classify each as:
- Working
- Partial
- Broken
- UI-only
- Missing

2. FILE / COMPONENT MAP
List the main files, components, providers, services, controllers, and routes involved in the Qur’an Reader / player system.

3. PLAYBACK FLOW SUMMARY
Explain how playback currently works from:
- starting playback
- pausing/resuming
- changing ayah
- changing surah
- updating UI state
- completing playback

4. ACTIVE AYAH / HIGHLIGHT SUMMARY
Explain what currently drives active ayah highlighting and whether it is reliable.

5. CONTINUE / PERSISTENCE SUMMARY
Explain what is currently persisted and what is surfaced to the user.

6. GAPS / ISSUES / RISKS
Identify:
- broken behavior
- fragile architecture
- duplicate logic
- dead code
- UX confusion
- missing production-ready features

7. ENHANCEMENT RECOMMENDATIONS
Based only on the current actual codebase, recommend the best next enhancement phases in priority order.

For each recommended enhancement, include:
- why it matters
- whether it builds on existing foundations or needs new architecture
- implementation complexity: low / medium / high
- risk of regressions: low / medium / high

==================================================
SPECIFIC QUESTIONS CODEX MUST ANSWER
==================================================

At minimum, answer all of these:

1. What player options do we currently already have?
2. Which ones are actually working versus only partially present?
3. Do we already have support for:
   - reciter switching
   - playback speed
   - ayah repeat
   - range repeat
   - loop surah
   - bookmarks
   - notes
   - favorites
   - translation toggle
   - transliteration toggle
   - auto-scroll
   - continue listening
   - continue reading
   - memorization mode
   - study mode
   - mini-player
4. What currently happens when a user taps an ayah?
5. What currently happens when playback starts, pauses, resumes, or completes?
6. What currently drives active ayah highlighting?
7. Is the current player architecture clean enough to extend, or should future work first refactor specific pieces?
8. What are the strongest next features to add based on what already exists?

==================================================
AUDIT APPROACH
==================================================

Perform a real audit of the existing implementation:
- inspect reader pages
- inspect player widgets
- inspect audio services/controllers
- inspect provider/notifier wiring
- inspect routing
- inspect persistence/state restore logic
- inspect search/continue entry points if connected to reader behavior
- inspect any reader-related tests if present

Do not guess based on UI labels alone.
Verify wiring wherever possible.

==================================================
OPTIONAL MINIMAL FIX RULE
==================================================

If you discover a tiny defect that completely blocks meaningful auditing, you may make a minimal safe repair only if necessary.

Examples:
- a null provider crash preventing the player page from loading
- a broken import preventing analysis of the actual reader path
- a trivial route typo blocking access to the real player page

If you make any such repair:
- keep it minimal
- report it separately under “Minimal audit-enabling fixes made”

Do not convert this into a feature phase.

==================================================
FINAL OUTPUT REQUIRED FROM CODEX
==================================================

Return one final consolidated audit with:

1. Executive summary
2. Current player capability matrix
3. Main files/components involved
4. Current architecture summary
5. Working vs broken vs missing features
6. Active ayah highlight analysis
7. Continue/resume analysis
8. Top UX issues
9. Top technical risks
10. Recommended next enhancement phases in priority order
11. Minimal audit-enabling fixes made, if any

END OF PROMPT
