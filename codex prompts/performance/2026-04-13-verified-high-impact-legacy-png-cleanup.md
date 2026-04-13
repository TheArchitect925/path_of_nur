“Indeed, Allah loves those who act with excellence.” — Qur’an 2:195

Here’s the Phase 10 Codex prompt to remove only the verified legacy PNGs for the migrated high-impact set.

:::writing{variant=“standard” id=“45126”}
===== PHASE 10 — VERIFIED LEGACY PNG CLEANUP — HIGH-IMPACT MIGRATED SET ONLY =====

PRIMARY OBJECTIVE === DELETE ONLY THE VERIFIED LEGACY .png FILES FOR THE HIGH-IMPACT RUNTIME ASSETS THAT HAVE ALREADY BEEN CONVERTED TO WEBP, MIGRATED IN LIVE RUNTIME REFERENCES, AND VALIDATED BY POLICY / AUDIT

Context:
You are working inside the existing Flutter repo for “Path of Nūr”.

Completed and verified so far:
	•	sibling .webp files were generated for the migrated high-impact set
	•	live runtime references were migrated to .webp for the approved files
	•	policy / allowlist was tightened
	•	post-migration audit was rerun
	•	Loading.png remains an intentional runtime PNG holdout for now
	•	native/platform PNGs remain intentionally preserved where required

This phase is the first real source cleanup pass.

Scope must remain narrow and verified.

This phase is NOT a repo-wide PNG deletion pass.
Do not go haywire.
Do not delete files for no reason.
Do not delete anything unless it is explicitly verified safe.

⸻

PRIMARY GOALS
	1.	Audit the migrated high-impact set and identify which legacy .png files are now safe to remove.
	2.	Delete only those verified-safe legacy PNGs.
	3.	Preserve:
	•	assets/images/backgrounds/Loading.png
	•	native/platform PNGs
	•	any non-migrated runtime PNGs
	•	any file with ambiguous usage
	4.	Keep the cleanup narrow, deterministic, reviewable, and reversible in git.
	5.	Validate that runtime references and policy still pass after cleanup.

⸻

APPROVED CLEANUP SCOPE

Only consider deleting legacy PNGs from the migrated high-impact runtime set:
	•	assets/images/backgrounds
	•	assets/images/wudu
	•	assets/images/prophets

But even within these folders, delete ONLY files that pass the safety checks below.

Do not expand scope beyond this set in this phase.

⸻

🚨 CRITICAL SAFETY RULES
	1.	AUDIT FIRST before deleting anything.
	2.	DO NOT delete any PNG unless all required safety checks pass.
	3.	DO NOT delete assets/images/backgrounds/Loading.png.
	4.	DO NOT delete native/platform PNG assets.
	5.	DO NOT delete non-runtime PNGs, docs, design references, mockups, screenshots, or tooling artifacts.
	6.	DO NOT delete any PNG whose live runtime reference has not been migrated to .webp.
	7.	DO NOT delete any PNG lacking a verified sibling .webp.
	8.	DO NOT delete anything outside the approved cleanup scope.
	9.	If there is any uncertainty, KEEP the file and report it.
	10.	At the end, provide one clean summary of exactly what was deleted, what was kept, and why.

⸻

REQUIRED SAFETY CHECKS BEFORE DELETION

A legacy .png file in scope may be deleted ONLY IF ALL of the following are true:
	1.	A sibling .webp file exists on disk at the same base path.
	2.	Live runtime references for that asset now point to the .webp.
	3.	No remaining active runtime/code/config path still requires the .png.
	4.	The file is not an intentional PNG holdout.
	5.	The file is not needed by native/platform packaging or non-runtime workflows.
	6.	The post-migration policy/audit state indicates the file is no longer needed as a runtime PNG.

If any one of these fails:
	•	keep the PNG
	•	report it under KEEP or MANUAL REVIEW

⸻

AUDIT FIRST — MANDATORY

Before deleting anything:
	1.	Re-audit the three high-impact folders:
	•	assets/images/backgrounds
	•	assets/images/wudu
	•	assets/images/prophets
	2.	For each PNG candidate, determine:
	•	sibling .webp exists or not
	•	live runtime refs already migrated or not
	•	any remaining .png refs in active code/config or not
	•	explicit intentional holdout or not
	•	safe to delete / keep / manual review
	3.	Produce a concise deletion plan grouped into:
	•	SAFE_TO_DELETE
	•	KEEP
	•	MANUAL_REVIEW
	4.	Record the baseline counts before deletion:
	•	PNG files in cleanup scope
	•	WebP siblings in cleanup scope
	•	intentional holdouts in cleanup scope

Do not delete anything until this audit is done.

⸻

DELETION BEHAVIOR

Delete only files in the SAFE_TO_DELETE set.

Preserve exact folder structure otherwise.
Do not rename anything.
Do not touch the .webp siblings.

Preferred implementation approach:
	•	update or create a narrow cleanup helper script, for example:
	•	tooling/scripts/remove_verified_high_impact_legacy_pngs.sh

If you create a script:
	•	make it dry-run friendly
	•	make it scoped only to this phase’s approved set
	•	make it safe to rerun
	•	make logging explicit and readable

Suggested flags:
	•	DRY_RUN=true|false
	•	DELETE_CONFIRMED=true|false

Default should be safe/dry unless the execution context clearly allows the verified delete step.

⸻

LOGGING

Use clear categories such as:
	•	[AUDIT]
	•	[SAFE_TO_DELETE]
	•	[KEEP]
	•	[MANUAL_REVIEW]
	•	[DELETE]
	•	[ERROR]
	•	[SUMMARY]

For every deleted file, log:
	•	PNG path
	•	matching WebP path
	•	confirmation that live refs migrated
	•	reason safe to delete

For kept files, log concise rationale.

⸻

EXPLICIT PRESERVATION RULES

Keep these explicitly unless the audit proves otherwise:

Runtime intentional holdout
	•	assets/images/backgrounds/Loading.png

Native/platform PNGs

Examples:
	•	ios/Runner/Assets.xcassets/...
	•	android/app/src/main/res/...
	•	web/native packaging icons
	•	watch/tvOS/macOS platform resources if PNG is still required

Anything ambiguous

If unclear:
	•	KEEP
	•	document why

⸻

VALIDATION AFTER CLEANUP

After deleting the verified-safe PNGs:
	1.	Re-scan the cleanup scope and report:
	•	PNGs deleted
	•	PNGs remaining
	•	WebPs present
	2.	Re-scan repo/runtime references for .png usage in the three target folders.
	3.	Confirm:
	•	only Loading.png remains intentionally in the migrated high-impact runtime set, unless audit proves another justified holdout
	•	no active runtime references were broken
	4.	Run the runtime PNG policy check.
	5.	Run flutter analyze on any changed relevant files if needed.
	6.	Confirm the repo state is cleaner and still valid.

If a validation problem appears:
	•	fix the smallest correct issue
	•	do not reintroduce broad PNG reliance

⸻

IMPORTANT NON-GOALS

Do NOT do these in this phase:
	•	do not delete PNGs outside the approved high-impact set
	•	do not convert new folders
	•	do not migrate more runtime references unless a tiny fix is absolutely necessary
	•	do not change Loading.png
	•	do not fix unrelated missing asset debt in kids_stories or quran_teacher
	•	do not relax policy just to make cleanup easier

⸻

PATH OF NŪR APP-SPECIFIC EXPECTATIONS

Be especially careful with:
	•	backgrounds used across main surfaces
	•	Wudu instructional images
	•	Prophet imagery and card artwork
	•	centralized asset helper/resolver logic already migrated
	•	preserving app stability and visual fidelity

This cleanup should reflect reality:
	•	WebP is now the active runtime asset for the migrated set
	•	PNG should remain only where intentionally justified

⸻

DELIVERABLES

At the end, provide a concise summary with:
	1.	Files changed
	2.	Whether a cleanup script was created or updated
	3.	Baseline PNG count in cleanup scope
	4.	Total PNGs safely deleted
	5.	Total PNGs intentionally kept
	6.	Total PNGs flagged for manual review
	7.	Whether Loading.png remained untouched
	8.	Policy validation result
	9.	Analyzer / validation result
	10.	Any remaining cleanup blockers
	11.	Recommended next phase

⸻

NEXT PHASE — DO NOT IMPLEMENT YET

After this is complete:
	•	Phase 11: repeat the same convert → migrate refs → tighten policy → audit → cleanup workflow for the next heaviest runtime asset folders
	•	Phase 12: separately resolve unrelated asset-integrity debt such as missing kids_stories / quran_teacher references
	•	Phase 13: optionally tighten asset policy further now that more runtime PNG debt is removed

⸻

FINAL REQUIREMENT

At the very end, provide one full clean summary:
	•	what PNGs were deleted
	•	what PNGs were kept
	•	why they were kept
	•	whether the migrated high-impact set is now fully cleaned except for intentional holdouts
	•	what the next safest step is

Do not go haywire.
Do not delete records/files for no reason.
Prefer narrow verified cleanup over aggressive deletion.

===== END =====
:::

After this, the next sensible move is Phase 11: run the same workflow on the next heaviest runtime asset folders.
