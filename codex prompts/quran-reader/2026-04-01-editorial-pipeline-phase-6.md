# ===== PHASE X PROMPT phase 6 — QURAN EXPLANATION EDITORIAL PIPELINE, COVERAGE GOVERNANCE, AND SAFE CONTENT EXPANSION =====

PRIMARY OBJECTIVE === BUILDING QURAN EXPLANATION EDITORIAL PIPELINE, COVERAGE GOVERNANCE, AND SAFE CONTENT EXPANSION

You are working in the existing Flutter codebase for Path of Nūr.

Always ensure the system is not going haywire and removing deleting records for no reason.

Instead of only doing a v1 or placeholder let’s always build out everything into a production ready product.

===== QURAN EXPLANATION SOURCE & VALIDATION RULE =====

All Qur’an explanation content MUST follow authentic tafsir methodology.

When generating explanation content:

1. Determine the meaning using:
   - Qur’an (cross-referenced ayahs)
   - authentic tafsir grounding (e.g., Ibn Kathir-level understanding)
   - widely accepted interpretations from mainstream Sunni scholarship

2. Then simplify into Path of Nūr language:
   - simple
   - standard
   - kids

3. STRICT RULES:
   - Do NOT copy tafsir text directly
   - Do NOT invent interpretations
   - Do NOT introduce speculative or modern reinterpretations without grounding
   - Do NOT introduce sectarian, fringe, polemical, or weakly grounded claims
   - If meaning is unclear or disputed, keep explanation general and safe

4. PRIORITY:
   - accuracy over creativity
   - clarity over depth
   - simplicity without distortion

5. If uncertain:
   - fallback to a safe, widely accepted general meaning
   - never guess or over-interpret

===== END =====

At the very end, audit everything and provide one full summary.

TASK TYPE
Production-ready editorial pipeline and governance system for Qur’an explanation content expansion.

GOAL
Build the internal structure and tooling needed so Path of Nūr can safely expand ayah explanation coverage over time without becoming inconsistent, messy, or inaccurate.

This phase should:
- define a governed editorial structure for explanation content
- make it easy to add more ayahs safely
- make coverage visible
- identify missing detail levels
- make future review easier
- avoid uncontrolled ad hoc content growth
- prepare the system for later multilingual and scholar-reviewed expansion

IMPORTANT PRODUCT DIRECTION
This phase is not about a public CMS or admin panel.
It is about making the codebase itself safe, organized, scalable, and editorially disciplined.

The result should allow future contributors or future Codex phases to expand content without:
- changing meaning randomly
- breaking tone consistency
- duplicating entries
- forgetting kids/simple/deep coverage
- creating invalid or partial data silently

EXECUTION RULES
1. Audit first before editing.
2. Reuse the explanation domain/data model already in place.
3. Do not introduce a heavy backend or external CMS in this phase.
4. Keep everything local-first and repository-friendly.
5. Preserve the existing reader integrations.
6. Keep governance light but real.
7. Preserve localization readiness.
8. Run analyzer on changed files and summarize results.
9. At the end provide one full audit summary and implementation summary.

AUDIT REQUIREMENTS

A. Audit current explanation content organization
Identify:
- where explanation data currently lives
- how entries are grouped
- whether there are duplicate or inconsistent patterns
- how easy it currently is to add more ayahs
- whether missing detail levels are visible or hidden
- whether metadata/source refs are structured consistently

B. Audit editorial safety gaps
Identify risks such as:
- missing kids/simple/deep coverage not being obvious
- inconsistent tone across files
- duplicate entries for the same ayah
- invalid empty strings passing as content
- source metadata inconsistencies
- lack of any coverage index or quality flags

C. Audit future expansion pressure
Assess the safest structure for expansion toward:
- more short surahs
- more beginner/foundational ayahs
- more study ayahs
- eventual broad/full Qur’an coverage
- future multilingual explanation support

IMPLEMENTATION REQUIREMENTS

D. Add editorial content grouping strategy
Refactor or formalize the explanation data organization into clear groups.

Preferred grouping examples:
- by surah range
- by juz group
- by rollout pack
- by foundations/common recitation/kids pack

Choose the cleanest structure for this repo.

Requirements:
- easy to find an ayah’s entry
- easy to add new ayahs
- easy to review a pack
- easy to avoid duplicates

E. Add coverage index / manifest
Create a structured internal coverage manifest for explanation content.

It should make it easy to know:
- which ayahs have explanations
- which detail levels are present
- which entries are kids-ready
- which entries are partial
- which packs are complete

Possible fields:
- surahNumber
- ayahNumber
- hasSimple
- hasStandard
- hasDeep
- hasKids
- hasReflectionPrompt
- hasKeyLessons
- hasSourceRefs
- rolloutPack
- reviewStatus

This can be generated statically or maintained alongside the data if that is safer for the current architecture.

F. Add review status metadata
Introduce lightweight internal editorial status fields.

Examples:
- draft
- reviewed
- verified
- kids-reviewed
- needs-expansion

This metadata should remain internal-facing for now.
Do not clutter the public reader UI with it.

G. Add validation helpers
Create internal validation logic/helpers to catch content issues such as:
- duplicate ayah entries
- missing required simple/standard content for seeded packs
- empty strings masquerading as content
- invalid source metadata
- invalid enum mappings
- invalid fallback state assumptions

These do not need to be a full CI platform, but should exist in a clean, reusable form.
Prefer repo-native validation that future phases can run safely.

H. Add safe content authoring template
Create a canonical explanation-entry template or helper so future additions follow one shape and one tone.

The template should reinforce:
- simpleSummary
- standardExplanation
- deepExplanation
- kidsExplanation
- keyLessons
- reflectionPrompt
- sourceRefs
- review metadata

This should reduce drift and help Codex add future content correctly.

I. Add tone and writing rules directly into the code-adjacent editorial system
Create a lightweight editorial guidance file or inline content guidance structure that future phases can follow.

It should define:
- Path of Nūr tone
- beginner-friendly expectations
- kids-safe wording expectations
- prohibited behaviors
- fallback expectations
- explanation-length guidance per level

Do not make this fluffy.
Make it useful and enforceable.

J. Add expansion-ready rollout packs
Formalize the next content rollout packs after the initial seeded set.

Examples:
- Foundations Pack
- Common Salah Surahs Pack
- Beginner Core Ayahs Pack
- Kids Starter Pack
- Reflection Pack

Each pack should have:
- identity/name
- ayah scope
- expected detail levels
- review status or coverage expectations

This makes future work safer and more organized.

K. Add multilingual readiness hooks
Do not fully localize all explanation content here unless already easy and safe.
But prepare the data model/organization for future multilingual explanations cleanly.

Examples:
- explicit language ownership
- clear separation between UI localization and explanation content
- future-ready content containers or language-aware comments/structure

L. Add contributor-safe expansion notes
Create a concise contributor/editor guidance file for future explanation expansion.
This should explain:
- where to add entries
- how to avoid duplicates
- how to choose the right rollout pack
- how to follow tafsir sourcing rules
- how to write simple vs standard vs kids
- how to mark review status
- how to validate the additions

This is for internal repo use, not end-user UI.

M. Keep reader behavior unchanged
This phase must not destabilize the readers.
Explanation content organization/governance improvements should preserve:
- current main reader behavior
- current kids reader behavior
- settings persistence
- fallback behavior

N. Cleanup and normalization
Normalize any inconsistent explanation entries already present.
Examples:
- naming mismatches
- uneven sourceRef structure
- inconsistent empty/null usage
- inconsistent review metadata
- inconsistent rollout pack naming

O. Optional but helpful: add lightweight internal reporting
If practical and clean, add a developer-facing helper/provider/report that can summarize:
- total ayahs covered
- packs complete/incomplete
- entries missing kids mode
- entries missing deep mode
- entries pending review

This does not need to be user-facing.
Keep it internal and lightweight.

P. Safety / integrity
Do not regress:
- explanation lookup
- explanation rendering
- fallback logic
- main reader
- kids reader
- settings
- performance
- existing Qur’an features

VALIDATION
1. Confirm explanation entries are organized more cleanly.
2. Confirm coverage/manifest data is accurate.
3. Confirm duplicate/missing-content validation exists and works.
4. Confirm future contributors have a clean template/path to add content.
5. Confirm readers still behave the same.
6. Confirm no regressions in explanation display.
7. Confirm analyzer passes on changed files.

DELIVERABLES
After implementation, provide:
- audit summary
- files changed
- final content grouping strategy
- coverage manifest structure
- review status metadata design
- validation helpers added
- contributor/editor guidance added
- normalization/cleanup summary
- analyzer results
- recommended next rollout packs

===== END =====
