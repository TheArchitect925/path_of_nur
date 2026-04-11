# Phase Content 1 — Dua Stub Completion

===== PHASE CONTENT 1 — DUA STUB COMPLETION =====

PRIMARY OBJECTIVE === REPLACE THE 15 GENERIC DUA PLACEHOLDERS WITH REAL SOURCE-BACKED DUAS

You are working in the existing Path of Nūr repo.

Context:
The dua dataset in:
- lib/features/learn/dua/data/dua_seed_data.dart

currently reports:
- totalItems: 180
- completeItems: 165
- stubItems: 15

The remaining stubs are placeholder entries from:
- stub_138_planned_dua
through
- stub_152_planned_dua

These placeholder entries are mostly in:
- daily_life
- situational

They currently have empty content fields and should be replaced with real, source-backed duas.

CRITICAL RULES
- Audit first before editing.
- Replace the stubs with real duas; do not add filler text.
- Keep the schema consistent with existing DuaItem entries.
- Use source-safe, mainstream duas only.
- Preserve localization-friendly structure.
- Do not invent unsourced duas.
- Keep naming clean and production-ready.
- Do not modify unrelated dua entries unless necessary for consistency.
- At the end, summarize exactly which stubs were replaced with which duas.

==================================================
PHASE 1 — AUDIT
==================================================

Audit the existing dua dataset and confirm:
1. the exact 15 stubs still present
2. their categories and current placeholder state
3. the current field structure expected by DuaItem
4. any existing category/tag/source conventions to preserve

==================================================
PHASE 2 — REPLACEMENT PLAN
==================================================

Replace the 15 stubs with a practical, source-backed completion set focused on:
- daily life
- situational use cases

Prefer high-value common duas such as:
- entering home
- leaving home
- entering bathroom
- leaving bathroom
- before eating
- after eating
- before sleep
- waking up
- dressing
- entering masjid
- leaving masjid
- distress/anxiety
- sadness
- anger
- difficulty / ease / debt relief

If some of these already exist elsewhere in the dataset, avoid duplication and choose other practical source-backed duas.

==================================================
PHASE 3 — IMPLEMENTATION RULES
==================================================

For each replacement:
- assign a real stable id
- set a clear title
- fill arabic
- fill transliteration
- fill translation
- fill whenToSay
- fill sourceType
- fill sourceRef
- assign appropriate difficulty
- assign sensible tags
- set audioKey using the project naming pattern
- set isCore appropriately
- set verificationStatus appropriately
- set completionStatus to complete

Do not leave placeholder titles like “Planned Dua 138”.

==================================================
PHASE 4 — DUPLICATION CHECK
==================================================

Before finalizing:
- verify none of the newly added duas already exist in the dataset under another id/title
- if duplicates exist, choose a different source-backed dua instead of duplicating

==================================================
PHASE 5 — CONSISTENCY PASS
==================================================

Ensure:
- category assignment is correct
- tags are consistent with current dataset style
- verification statuses align with existing conventions
- ids and audio keys are clean
- no empty fields remain on those 15 entries

==================================================
PHASE 6 — VALIDATION
==================================================

Validate:
1. stub count goes from 15 to 0
2. completeItems updates correctly
3. no placeholder ids/titles remain for those entries
4. no duplicate dua entries were introduced
5. file remains analyzer-safe
6. dataset remains easy to extend later

==================================================
DELIVERABLE FORMAT
==================================================

After completion, provide:
1. which 15 stubs were replaced
2. the final list of added dua topics
3. any duplicates avoided
4. updated dataset counts
5. any follow-up scholarly QA notes

IMPORTANT:
This phase is about finishing the remaining placeholder gap in the dua dataset cleanly and safely.
Do not over-scope into hadith/ayah orchestration yet.

===== END =====
