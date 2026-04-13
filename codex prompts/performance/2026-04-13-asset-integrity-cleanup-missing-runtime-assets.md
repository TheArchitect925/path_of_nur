===== PHASE 12 — ASSET INTEGRITY CLEANUP — MISSING RUNTIME ASSET REFERENCES (KIDS STORIES / QURAN TEACHER) =====

PRIMARY OBJECTIVE === AUDIT AND FIX THE EXISTING MISSING RUNTIME ASSET REFERENCE DEBT, ESPECIALLY IN `kids_stories` AND `quran_teacher`, WITHOUT MIXING IT UP WITH THE PNG → WEBP MIGRATION WORKFLOW

Context:
You are working inside the existing Flutter repo for “Path of Nūr”.

Separate from the WebP migration, prior audits identified broader asset-integrity issues:
- missing runtime asset references
- especially around:
  - `assets/images/kids_stories/...`
  - `assets/images/quran_teacher/...`

These are not primarily a format-conversion problem.
They are a runtime asset integrity problem:
- references may point to files that do not exist
- paths may be stale, misnamed, mis-cased, or mismatched
- some referenced assets may be genuinely absent from the repo

This phase is for asset-integrity cleanup only.

Do not go haywire.
Do not delete files for no reason.
Do not mix this with broad PNG/WebP policy work unless a tiny related fix is required.
Do not invent fake placeholder assets unless explicitly approved.

---

## PRIMARY GOALS

1. Audit the missing runtime asset references related to:
   - `kids_stories`
   - `quran_teacher`
2. Identify the exact root cause for each missing reference:
   - file missing from repo
   - path typo
   - filename mismatch
   - casing mismatch
   - wrong extension
   - wrong folder ownership
   - stale dead reference
   - manual review
3. Fix the references safely where the correct asset already exists somewhere in the repo.
4. Clearly separate cases where the asset is truly absent and cannot be fixed by path correction alone.
5. Keep runtime behavior safe and production-ready.
6. Preserve localization, routing, and current architecture.

---

## 🚨 CRITICAL SAFETY RULES

1. AUDIT FIRST before editing.
2. DO NOT blindly mass-replace file paths.
3. DO NOT create fake placeholder assets just to silence missing-path issues.
4. DO NOT delete asset references unless you verify they are stale and no longer used.
5. DO NOT rename large sets of files unless truly necessary and clearly safer than changing references.
6. DO NOT touch native/platform asset packaging unless directly relevant.
7. If the correct asset exists, prefer fixing the reference rather than duplicating files.
8. If the asset does not exist, report it explicitly as a real content gap.
9. Keep changes narrow and reviewable.
10. At the end, provide one clean summary of what was fixed, what remains missing, and what needs follow-up.

---

## STEP 1 — DISCOVERY AUDIT

Audit the repo for missing runtime asset references related to:
- `kids_stories`
- `quran_teacher`

Search:
- Dart runtime code
- asset resolver/helper files
- content/config/data files
- any JSON/YAML/constants used for asset paths
- `pubspec.yaml` if relevant

For each missing reference, record:
- referencing file
- referenced asset path
- whether the file exists exactly
- whether a likely matching asset exists elsewhere
- likely root cause classification

Root cause categories:
- MISSING_FILE
- PATH_TYPO
- FILENAME_MISMATCH
- CASE_MISMATCH
- WRONG_EXTENSION
- WRONG_FOLDER
- STALE_REFERENCE
- MANUAL_REVIEW

Output a concise audit summary before making changes.

---

## STEP 2 — MATCH / RECONCILIATION PASS

For each broken reference:
1. Search the repo for likely candidate assets with similar names.
2. Determine whether a correct existing file can be matched confidently.
3. If a confident match exists:
   - fix the runtime reference to the correct path
4. If multiple possible matches exist:
   - classify as MANUAL_REVIEW unless one is clearly the true intended asset
5. If no asset exists:
   - classify as TRUE_MISSING_ASSET
   - do not fabricate a replacement

Be careful with:
- path casing
- singular/plural folder mismatches
- extension drift (`.png`, `.webp`, `.jpg`)
- old renamed folders
- duplicate copies in unexpected locations

---

## STEP 3 — FIX ONLY VERIFIED ISSUES

Apply only narrow verified fixes such as:
- correcting asset path strings
- correcting file extension references
- correcting folder path ownership
- updating resolver mappings
- removing a stale dead mapping only if clearly obsolete and unused

Do NOT:
- invent content
- create new art assets unless an approved source file already exists and only needs moving/renaming
- broadly refactor unrelated asset systems

If a real missing asset is discovered:
- leave the runtime/content gap clearly reported
- do not hide it with fake data

---

## STEP 4 — PUBSPEC / DECLARATION CHECK

Inspect `pubspec.yaml` only if relevant.

Rules:
1. If the missing issue is purely a bad path and assets are already directory-declared, avoid unnecessary pubspec changes.
2. If a real asset exists but is outside declared paths and should be loaded at runtime, update pubspec only if necessary and clearly justified.
3. Keep changes minimal.

---

## STEP 5 — VALIDATION

After the fixes:
1. Re-run the missing-reference audit for the targeted domains.
2. Confirm which references are now resolved.
3. Confirm which references remain truly missing.
4. Run `flutter analyze` on changed files.
5. If practical, run a lightweight asset consistency scan.
6. Confirm no unrelated runtime asset paths were changed.

---

## STEP 6 — REPORT TRUE CONTENT GAPS

For any issues not fixable by path correction, produce a clean list of actual missing content.

Group them by:
- KIDS_STORIES_MISSING_CONTENT
- QURAN_TEACHER_MISSING_CONTENT
- AMBIGUOUS_MANUAL_REVIEW

For each unresolved item, include:
- missing path
- where it is referenced
- why it could not be safely auto-fixed

This is important so we separate:
- engineering/path debt
from
- actual content creation debt

---

## IMPLEMENTATION APPROACH

Reuse existing audit helpers if useful.
You may create a small scoped helper script if it improves determinism, for example:
- `tooling/scripts/audit_missing_runtime_assets.sh`

If you create a script:
- keep it focused on audit/reporting
- keep it safe to rerun
- do not let it mutate assets by default

If no script is needed, targeted fixes are acceptable.

---

## IMPORTANT NON-GOALS

Do NOT do these in this phase:
- do not run broad PNG cleanup
- do not continue WebP migration for unrelated folders
- do not tighten asset policy broadly
- do not fabricate art/content for truly missing assets
- do not redesign the kids stories or quran teacher feature flow

This phase is about correctness of asset references and content integrity.

---

## PATH OF NŪR APP-SPECIFIC EXPECTATIONS

Be especially careful with:
- kids content data sources
- learning/story asset resolvers
- quran teacher lesson asset mappings
- any centralized helper that may fan out broken references widely

If a single resolver bug is causing many broken paths, fix the root source rather than patching dozens of call sites.

---

## DELIVERABLES

At the end, provide a concise summary with:

1. Files changed
2. Whether an audit/helper script was created
3. Total missing runtime asset references audited
4. Total safely fixed
5. Total classified as true missing assets
6. Total manual-review ambiguities
7. Whether `pubspec.yaml` changed
8. Analyzer / validation results
9. Clean list of unresolved real content gaps
10. Recommended next phase

---

## NEXT PHASE — DO NOT IMPLEMENT YET

After this is complete:
- create a focused content-fill phase for any truly missing story/teacher assets
- continue the staged WebP workflow for the next heaviest runtime asset folders
- optionally add a stricter asset-integrity check into CI once the broken references are resolved

---

## FINAL REQUIREMENT

At the very end, provide one full clean summary:
- what broken references were fixed
- what root causes were found
- what assets are truly missing
- what still needs manual/content work
- what the next safest step is

Do not go haywire.
Do not delete records/files for no reason.
Prefer narrow verified fixes over aggressive refactors.

===== END =====
