===== PHASE X PROMPT phase 13 — SAFE INLINE EDITING, CHANGE HISTORY, VERSIONING, AND ROLLBACK CONTROLS =====

PRIMARY OBJECTIVE === BUILDING SAFE INLINE CONTENT EDITING, VERSIONING, AND ROLLBACK SYSTEM

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
Add safe inline editing, version tracking, and rollback controls to the Master Editorial Dashboard.

GOAL
Allow the app owner to:
- safely edit content inline (Qur’an explanations, hadith, stories, etc.)
- track all changes made to content
- compare versions
- revert to previous versions if something breaks
- maintain content integrity across all domains

This must be:
- safe
- reversible
- controlled
- non-destructive
- consistent across all content systems

IMPORTANT PRODUCT DIRECTION
This is NOT a free-form editing tool.
This is a **controlled editorial system**.

Every change must be:
- tracked
- reversible
- validated
- safe

No silent overwrites.

SECURITY / ACCESS RULES
1. Reuse dashboard access control:
   - hidden route
   - PIN (0786 initial)
   - session unlock
   - production flag

2. Editing must ONLY be available inside dashboard.
3. No editing exposed to normal users.

EXECUTION RULES
1. Audit first.
2. Reuse existing data models and dashboard structure.
3. Do NOT break content storage or reader logic.
4. Keep editing safe and constrained.
5. All edits must go through validation before saving.
6. All edits must create a new version entry.
7. Run analyzer and summarize.

AUDIT REQUIREMENTS

A. Identify editable content domains
Confirm which content can be edited:
- Qur’an explanations
- hadith entries
- stories
- duas/dhikr
- actions
- recommendation mappings
- tags and metadata
- NOT raw Qur’an Arabic text

B. Identify storage layer
Confirm how content is stored:
- local data files
- in-memory providers
- serialized JSON/maps

Ensure versioning can wrap around this safely.

IMPLEMENTATION REQUIREMENTS

A. Add version model
Create a model like:

ContentVersion:
- contentId
- contentType
- versionNumber
- updatedAt
- updatedBy (optional)
- changeSummary
- previousVersionRef
- contentSnapshot (full copy of content)

B. Add version storage
Store version history:
- locally (initial)
- structured and indexed by contentId

Limit:
- keep last N versions (e.g., 5–10)
- avoid infinite growth

C. Add inline editing UI

Inside dashboard:
- allow editing fields like:
  - simpleSummary
  - standardExplanation
  - kidsExplanation
  - keyLessons
  - reflectionPrompt
  - metadata

UI requirements:
- structured fields (NOT raw JSON editing)
- clear labels
- preview before save
- cancel option

D. Add validation before save

Before saving:
- check required fields
- check empty values
- check content length sanity
- ensure tafsir rule not violated structurally
- prevent accidental deletion of required fields

E. Add change summary input

When saving:
- require short note:
  - “Improved clarity”
  - “Fixed kids explanation”
  - etc.

F. Add version creation on every edit

Every save:
- creates new version entry
- links to previous version
- increments version number

G. Add version history viewer

For each content item:
- show list of versions
- show timestamp
- show change summary

Allow:
- viewing previous version
- comparing with current version

H. Add diff/compare view

Simple comparison:
- old vs new text
- highlight changes (basic is fine)

I. Add rollback functionality

Allow:
- revert to previous version

Rules:
- confirm before revert
- revert creates a NEW version (not overwrite)
- maintain history chain

J. Add safe edit constraints

Do NOT allow:
- deleting entire content object
- removing all explanation fields
- breaking required structure

K. Add “mark as reviewed” flow

After edit:
- allow marking content as:
  - reviewed
  - verified

Tie into Phase 12 scoring system.

L. Add edit lock / session safety (basic)

Prevent:
- accidental double edits
- inconsistent state during editing

Basic approach is enough.

M. Preserve performance

Ensure:
- versioning does not slow down reader
- version data is only used in dashboard
- main app reads latest version only

N. Preserve existing systems

Do NOT break:
- explanation retrieval
- readers (main/kids)
- actions
- recommendations
- dashboard views
- scoring system

O. Cleanup

Ensure:
- versioning logic is cleanly separated
- no duplication
- naming consistent

VALIDATION

1. Confirm editing works for multiple content types.
2. Confirm version history is created.
3. Confirm rollback restores previous content.
4. Confirm validation prevents bad saves.
5. Confirm readers still display latest version correctly.
6. Confirm scoring system updates after edits.
7. Confirm analyzer passes.

DELIVERABLES

- audit summary
- files changed
- version model design
- editing UI structure
- validation logic summary
- version storage strategy
- rollback behavior summary
- analyzer results
- follow-up recommendations for Phase 14

===== END =====
