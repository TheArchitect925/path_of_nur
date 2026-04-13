===== PHASE 11 — NEXT WAVE WEBP MIGRATION — REPEAT VERIFIED WORKFLOW FOR THE NEXT HEAVIEST RUNTIME ASSET FOLDERS =====

PRIMARY OBJECTIVE === IDENTIFY THE NEXT HIGHEST-IMPACT RUNTIME PNG ASSET FOLDERS AFTER THE COMPLETED HIGH-IMPACT SET, THEN EXECUTE THE SAME VERIFIED WORKFLOW: READINESS → CONVERSION → REFERENCE MIGRATION → POLICY TIGHTENING → AUDIT → VERIFIED CLEANUP

Context:
You are working inside the existing Flutter repo for “Path of Nūr”.

The previous high-impact WebP migration workflow has already been completed for:
- `assets/images/backgrounds` (with `Loading.png` intentionally preserved)
- `assets/images/wudu`
- `assets/images/prophets`

That workflow included:
- readiness audit
- real PNG → WebP conversion
- verified runtime reference migration
- policy/allowlist tightening
- post-migration audit
- verified legacy PNG cleanup

Now repeat that same disciplined production-ready workflow for the next heaviest runtime PNG asset folders.

This is a planning-and-execution orchestration phase.
Do not go haywire.
Do not skip audit gates.
Do not delete files for no reason.
Do not jump straight to broad conversion without selecting the next target folders based on actual size and runtime usage.

---

## PRIMARY GOALS

1. Identify the next heaviest runtime PNG asset folders under `assets/` after the already-migrated high-impact set.
2. Exclude folders already completed in prior phases unless there is a justified unresolved exception.
3. Rank the remaining runtime PNG folders by:
   - total PNG bytes
   - file count
   - live runtime usage relevance
4. Select the best next migration batch.
5. Execute the same safe workflow for that batch:
   - readiness audit
   - real conversion
   - verified reference migration
   - policy tightening
   - post-migration audit
   - verified legacy cleanup
6. Keep the work reviewable and production-safe.

---

## 🚨 CRITICAL SAFETY RULES

1. AUDIT FIRST before choosing the next folders.
2. DO NOT reprocess the already-completed high-impact folders unless a specific unresolved issue requires it.
3. DO NOT delete PNGs before conversion, reference migration, validation, and policy truth all line up.
4. DO NOT use a blind one-size-fits-all compression mode.
5. DO NOT broaden scope to the entire repo in one pass unless the audit proves it is small and safe.
6. DO NOT touch native/platform PNG assets.
7. DO NOT mix unrelated asset-integrity debt into this phase except to report it separately.
8. If uncertainty exists, classify it for manual review rather than forcing conversion.
9. Keep each step deterministic and reviewable.
10. At the very end, provide one clean summary of what was selected, what was done, and what remains.

---

## STEP 1 — DISCOVERY / PRIORITIZATION AUDIT

Audit the remaining runtime PNG asset tree under `assets/` excluding the already-migrated folders:
- `assets/images/backgrounds`
- `assets/images/wudu`
- `assets/images/prophets`

Produce a ranked list of the next heaviest runtime PNG folders by:
- folder path
- PNG file count
- total PNG bytes
- whether assets appear to be:
  - scenic/art-heavy
  - sharp-edged illustrations
  - text-bearing graphics
  - icon-like / UI-like
  - mixed / manual review

Also note:
- existing sibling `.webp` counts
- live runtime reference density if reasonably detectable
- any obvious blockers

Output a concise ranked shortlist.

---

## STEP 2 — SELECT THE NEXT MIGRATION BATCH

Based on the audit, choose the next safest and highest-value migration batch.

Selection rules:
1. Prefer folders with strong size payoff.
2. Prefer folders with clear asset type consistency.
3. Avoid folders with severe unresolved integrity debt until isolated.
4. Keep the batch manageable and reviewable.

Expected output:
- selected folder(s)
- why they were selected
- why other candidates were deferred

If the next best move is a single folder, choose one.
If two or three folders form a coherent safe batch, that is acceptable.

---

## STEP 3 — READINESS AUDIT FOR THE SELECTED BATCH

For the chosen folder(s), perform a readiness pass similar to the prior successful workflow:

For each PNG in scope, report:
- path
- file size
- sibling `.webp` exists or not
- likely asset type
- recommended mode:
  - LOSSLESS
  - LOSSY_Q85
  - MANUAL_REVIEW
- notable risks / comments

Also identify:
- naming/path mismatches
- weird duplicates
- text-bearing assets
- files that should be held out initially

Determine readiness status:
- READY
- READY_WITH_NOTES
- BLOCKED

Do not bulk-convert yet until this readiness pass is complete.

---

## STEP 4 — EXECUTE REAL CONVERSION

If readiness is acceptable:
- generate real sibling `.webp` files on disk
- preserve folder structure and filenames
- keep original PNGs in place
- skip existing sibling WebPs unless overwrite is explicitly justified and safe
- use lossless vs lossy based on the readiness classification

Suggested command patterns:
- Lossy: `cwebp -q 85 -m 6 -af "input.png" -o "output.webp"`
- Lossless: `cwebp -lossless -z 9 "input.png" -o "output.webp"`

Log:
- source
- destination
- mode
- original size
- new size
- delta

Do not modify runtime references in this step.

---

## STEP 5 — VERIFIED RUNTIME REFERENCE MIGRATION

After conversion:
- audit active runtime references for the converted assets
- replace `.png` → `.webp` only where the sibling `.webp` exists and the reference is a real live runtime path
- do not touch comments/docs/non-runtime references
- keep any intentional PNG holdouts unchanged

Run analyzer on changed files.

---

## STEP 6 — POLICY / ALLOWLIST TIGHTENING

After verified runtime reference migration:
- remove any temporary broad allowlist coverage for the newly migrated runtime folders
- retain only explicit, justified PNG exceptions
- preserve native/platform PNG exemptions
- confirm policy/CI passes for the right reasons

Do not leave folder-wide exemptions in place if no longer justified.

---

## STEP 7 — POST-MIGRATION AUDIT

Re-run the WebP migration audit for the newly selected batch and report:
- PNG count before/after
- WebP count before/after
- exact bytes saved
- MB saved
- percentage saved
- top file/folder savings
- any files where WebP became larger
- remaining intentional PNG holdouts
- stale runtime refs or none
- policy result

Keep the report exact and filesystem-based.

---

## STEP 8 — VERIFIED LEGACY PNG CLEANUP

Only after:
- sibling WebPs exist
- live runtime references are migrated
- policy passes
- audit confirms correctness

Then:
- delete only the verified legacy PNGs for the newly migrated batch
- keep intentional holdouts
- keep ambiguous files
- validate after cleanup

Do not broaden cleanup outside the selected batch.

---

## SPECIAL HANDLING FOR EXISTING ASSET-INTEGRITY DEBT

Keep unrelated asset-integrity debt separate and report it distinctly, especially if encountered in candidate folders, such as:
- missing `kids_stories` assets
- missing `quran_teacher` assets
- broken refs unrelated to PNG → WebP format migration

Do not let unrelated debt silently contaminate the conversion workflow.
If encountered:
- classify it
- report it
- proceed only where safe

---

## IMPLEMENTATION / SCRIPTING

Reuse existing scripts where practical, for example:
- readiness audit helpers
- conversion scripts
- policy check scripts
- audit scripts
- cleanup scripts

Only create new scripts if truly needed.
Prefer extending the proven workflow rather than inventing a parallel system.

Keep tooling:
- deterministic
- narrow in scope
- safe to rerun
- clearly logged

---

## DELIVERABLES

At the end, provide a concise summary with:

1. Which folder(s) were chosen as the next migration batch
2. Why they were chosen
3. Files/scripts created or updated
4. Readiness status
5. Total PNGs processed
6. Total WebPs created
7. Total runtime references migrated
8. Policy tightening result
9. Exact storage savings for this batch
10. Total verified legacy PNGs deleted
11. Any intentional PNG holdouts kept
12. Any blockers / manual review items
13. Recommended next phase after this batch

---

## NEXT PHASE — DO NOT IMPLEMENT YET

After this batch is complete:
- continue the same workflow for the next remaining heaviest runtime folders
- separately address asset-integrity debt that is not really a WebP migration problem
- consider tightening repo asset policy further only after enough runtime PNG debt is removed

---

## FINAL REQUIREMENT

At the very end, provide one clean final summary in one place:
- what folders were selected
- what was converted
- what was migrated in runtime references
- what policy exemptions were removed
- what exact storage savings were achieved
- what PNGs were deleted
- what intentional holdouts remain
- what the next safest step is

Do not go haywire.
Do not delete records/files for no reason.
Prefer the proven staged workflow over aggressive repo-wide conversion.

===== END =====
