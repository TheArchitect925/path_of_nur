# Phase 3 — Daily Dua Content Service (Path of Nur)

PRIMARY OBJECTIVE === BUILD A TRUSTED, CONTEXT-AWARE DAILY DUA CONTENT SERVICE ON TOP OF THE VERIFIED DUA DATASET

You are working in the existing Path of Nūr Flutter codebase.

This phase comes AFTER:
- Phase 1 — dua QA fixes
- Phase 1.5 — category normalization
- Phase 1.75 — contextual orchestration metadata
- Phase 2 — Hisn al-Muslim alignment / release trust pass

This phase is about building the first orchestration/service layer for duas only.

CRITICAL RULES:
- Audit first before making any changes
- Do not assume the current repo structure; inspect it carefully
- Reuse existing repository/provider/service patterns wherever practical
- Do not redesign unrelated app architecture
- Do not break current dua browsing/detail flows
- Do not modify hadith/ayah systems in this phase
- Do not implement widgets, lock screen, watch, or UI surfaces in this phase
- Do not generate or rewrite sacred content
- Only orchestrate and select from trusted existing dua entries
- Do not surface `needs_review` or excluded items by default
- Do not delete or mutate records for no reason
- Keep the implementation production-ready, deterministic, and maintainable

WHEN UNSURE:
- Prefer a conservative rule-based service over a clever but fragile one
- Flag ambiguity instead of inventing behavior
- Keep changes minimal and well-contained

TARGET SCOPE:
- Build a dua-only orchestration layer
- Feed future surfaces, but do not implement those surfaces yet
- Support context-aware selection for in-app usage first

==================================================
PHASE 0 — AUDIT FIRST (MANDATORY)
==================================================

Before changing code, audit the repo and summarize:

1. Existing dua architecture
- current dua model(s)
- repositories
- providers
- browse/filter/search logic
- detail page ownership
- category/grouping logic
- whether there is already any “daily content” or recommendation logic

2. Existing orchestration/recommendation patterns elsewhere
- any content bundling systems
- daily card systems
- reminder/prompt systems
- watch/widget/live activity selection patterns that may inform service shape later

3. Existing context sources the app already has access to
- time of day
- prayer context / next prayer / current prayer
- weather support if any
- date / weekday / Islamic date / Ramadan logic if any
- travel/location signals if any
- recently shown content history if any

4. Existing trust and metadata fields on dua entries
- verificationStatus
- primaryCategory
- secondaryCategories
- timeContexts
- dateContexts
- weatherContexts
- locationContexts
- prayerContexts
- situationContexts
- surfaceEligibility
- priorityScore
- tags / isCore / whenToSay

5. Best integration point
- where this service should live in the repo
- what should consume it first
- what should remain untouched for now

Provide a concise audit summary BEFORE implementation.
Do not skip this step.

==================================================
PRIMARY GOAL OF THIS PHASE
==================================================

Build a Daily Dua Content Service that can answer:

- what dua should the app surface right now?
- what dua bundle should be shown for the current moment?
- what short dua prompt is best for a compact future surface?
- what should be shown after salah, in the morning, at night, during rain, on Friday, in Ramadan, etc.?

This service is a rule-based orchestration layer on top of the trusted dua dataset.

It is NOT:
- a content generator
- a widget implementation
- a UI redesign
- a full multi-content spiritual engine yet

==================================================
DESIGN PRINCIPLES
==================================================

1. Trusted-only by default
The service must only select from release-safe duas:
- preferred: verified_strong
- optionally: selected verified_general if explicitly allowed by policy
- never default to needs_review or excluded items

2. Deterministic and explainable
Selection should be rule-based and understandable, not random magic.

3. Context-aware but conservative
Use strong context matches first.
Do not over-trigger weak contexts.

4. Surface-aware design readiness
Even though this phase does not implement widgets/watch/lock screen, design the service so it can later support:
- in_app
- daily_card
- home_widget
- lockscreen
- watch
- standby

5. No duplicate logic across surfaces
One central service should become the source of truth for future dua surfacing.

==================================================
PHASE 1 — DEFINE THE SERVICE CONTRACT
==================================================

Create a clean service contract for dua orchestration.

Examples of useful API methods:
- getCurrentDuaPrompt(...)
- getDailyDuaBundle(...)
- getPostSalahDua(...)
- getMorningDuaBundle(...)
- getEveningDuaBundle(...)
- getContextualDuaCandidates(...)
- getCompactDuaPrompt(...)

You do not need to implement every possible method above if a smaller cleaner API is better.
But the contract should support:
- single best match
- small ranked candidate list
- richer in-app bundle

Keep interfaces clean and extensible.

==================================================
PHASE 2 — CONTEXT INPUT MODEL
==================================================

Define a lightweight input model for selection context.

Possible fields:
- currentDateTime
- weekday
- islamicDate context if available
- timeOfDay
- prayerContext
- weatherContext
- locationContext
- situationContext
- surface
- maxItems
- allowGeneralVerified
- excludeRecentlySeen

If some inputs are not yet available in the repo, keep the model ready for them but do not fabricate runtime sources.
Use only what the repo can reliably provide now.

==================================================
PHASE 3 — RULE-BASED SELECTION LOGIC
==================================================

Implement a conservative ranking/selection strategy.

Suggested ranking priority:
1. trust eligibility
2. exact context match
3. strong primaryCategory match
4. matching secondary/context metadata
5. surface eligibility
6. priorityScore
7. repetition avoidance
8. fallback quality

Example behavior:
- morning + in_app -> prefer morning/upon_waking duas
- after_salah -> prefer after_salah duas
- rain -> prefer rain/weather duas
- friday -> allow Friday-relevant duas if present
- ramadan/laylat_al_qadr -> allow date-specific duas
- before_sleep -> prefer sleep/night duas

Rules:
- exact match beats broad match
- do not force all metadata dimensions to match
- empty metadata should not beat strong contextual matches
- if no strong exact context exists, fall back gracefully to trusted high-priority daily duas

==================================================
PHASE 4 — REPETITION AVOIDANCE
==================================================

Implement simple repetition avoidance.

Requirements:
- avoid showing the exact same dua too often when multiple good candidates exist
- keep logic lightweight and deterministic
- if the repo already has a suitable local persistence pattern, reuse it
- if not, add a minimal safe local history mechanism

Do NOT overengineer.
A simple recent-history exclusion or soft penalty is enough.

==================================================
PHASE 5 — IN-APP FIRST OUTPUTS
==================================================

This phase should prepare output shapes for in-app consumption first.

Support at least:
1. A single “best current dua” prompt
2. A small ranked candidate list for the current context
3. A richer in-app daily bundle (for example 1–3 duas depending on context)

The output model should contain enough information for future UI surfaces, such as:
- id
- title
- arabic
- translation
- transliteration if needed
- source/trust info
- why it was selected (optional but useful for debugging)
- compact/full suitability metadata if needed

==================================================
PHASE 6 — FUTURE SURFACE READINESS (NO UI YET)
==================================================

Design the service so future consumers can use it for:
- home page daily spiritual card
- dua card
- home widget
- lock screen prompt
- watch prompt
- standby mode

But do NOT build those consumers yet.

This phase is service groundwork only.

==================================================
PHASE 7 — SAFETY RULES
==================================================

The service must:
- never default to weak/unreviewed duas
- not leak excluded content into public flows
- not assume all entries have perfect metadata
- handle sparse or missing metadata gracefully
- not crash when context signals are unavailable
- have safe fallbacks

Fallback behavior:
- if no strong contextual result exists, return a trusted general-purpose daily dua
- if multiple equal candidates exist, use deterministic ordering with light rotation support

==================================================
PHASE 8 — INTEGRATION
==================================================

Integrate the service into the codebase in a minimal, production-safe way.

Do:
- add repository/provider/service wiring as needed
- expose the service through the app’s existing architectural patterns
- add targeted tests where practical

Do NOT:
- refactor half the repo
- rewrite all dua browsing
- couple the service tightly to widget/watch code yet

==================================================
PHASE 9 — TESTING / VALIDATION
==================================================

Validate:
1. service selects only trusted duas by default
2. morning contexts return sensible morning candidates
3. after_salah returns post-salah/focused candidates
4. rain/weather contexts return weather duas when available
5. fallback works when no exact context exists
6. repetition avoidance works simply and safely
7. sparse metadata does not cause crashes
8. analyzer passes on changed files
9. any targeted tests pass

==================================================
EXPECTED DELIVERABLE
==================================================

After implementation, provide:

1. Audit findings
- current dua architecture
- current context sources
- best integration point chosen

2. Files changed

3. Service design summary
- contract/API
- input model
- output model
- ranking strategy
- trust gating behavior

4. Integration summary
- how the service is exposed
- what currently consumes it
- what is intentionally left for later

5. Validation summary
- analyzer/test results
- fallback behavior confirmed
- repetition avoidance confirmed

6. Follow-up recommendations
- what should consume this next
- what to build in Phase 3.5 / 4

==================================================
IMPORTANT IMPLEMENTATION BOUNDARY
==================================================

Build only the Daily Dua Content Service.
Do not expand this into the full Daily Spiritual Content Service yet.

The broader future system may later include:
- ayah
- hadith
- reflection
- Names of Allah

But this phase is dua-first, trusted, context-aware, and in-app ready.

===== END =====
