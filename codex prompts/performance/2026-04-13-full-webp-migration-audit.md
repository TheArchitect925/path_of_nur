“Indeed, Allah commands excellence.” — Qur’an 16:90

Here’s the audit Codex prompt to verify the full PNG → WebP migration, confirm coverage, and calculate space saved. It assumes the repo already ran the earlier conversion and migration phases. cwebp is the official WebP encoder for PNG/JPEG/TIFF inputs, and WebP commonly reduces lossless PNG size materially, which is why this audit should measure actual before/after totals rather than assume savings.

:::writing{variant=“standard” id=“45812”}
===== PHASE 5 — FULL PNG → WEBP MIGRATION AUDIT — COVERAGE, VALIDATION, AND STORAGE SAVINGS =====

PRIMARY OBJECTIVE === AUDIT THE REPO TO CONFIRM THE PNG → WEBP MIGRATION WAS ACTUALLY COMPLETED, IDENTIFY ANY GAPS, AND CALCULATE EXACT STORAGE SAVINGS

Context:
You are working inside the existing Flutter repo for “Path of Nūr”.

Previous phases were intended to:
	•	convert runtime PNG assets to WebP
	•	update runtime references from .png to .webp
	•	remove verified legacy PNGs where safe
	•	add CI guardrails for future PNG drift

Now perform a full audit of the migration result.

This is an audit and reporting phase.
Do not go haywire.
Do not delete files for no reason.
Do not make broad edits unless a tiny fix is clearly necessary and safe.

⸻

CORE GOALS

Audit and report on all of the following:
	1.	Was every intended runtime PNG asset converted to WebP?
	2.	Were all safe runtime references updated from .png to .webp?
	3.	Are any legacy runtime PNGs still present that should have been migrated?
	4.	Are any .png references still present in code/config that point to runtime assets?
	5.	Which PNGs remain intentionally and why?
	6.	How much total disk space was saved by the migration?
	7.	What percent reduction did we achieve?
	8.	Are there any risks, gaps, or cleanup items still remaining?

⸻

🚨 CRITICAL SAFETY RULES
	1.	AUDIT FIRST. Do not begin with edits.
	2.	Do not delete any files in this phase unless a tiny verified fix is truly necessary.
	3.	Do not rewrite large portions of the repo.
	4.	Do not count native/platform-required PNGs as migration failures.
	5.	Do not assume every PNG should have become WebP.
	6.	Distinguish clearly between:
	•	Flutter runtime assets
	•	native platform assets
	•	docs/mockups/screenshots
	•	tests/tooling artifacts
	7.	Use deterministic file-based checks and repo-aware reference checks.
	8.	Provide exact numbers, not vague estimates.
	9.	If something is uncertain, classify it as manual review.
	10.	At the very end, provide one clean audit summary I can review in one place.

⸻

AUDIT SCOPE

Audit these categories separately:

A. Flutter runtime assets

Examples:
	•	/assets/...
	•	other app-owned runtime asset folders if present

B. Native/platform PNGs that may be intentionally retained

Examples:
	•	ios/Runner/Assets.xcassets/...
	•	android/app/src/main/res/...
	•	web/native packaging icons
	•	notification icons
	•	launcher icons

C. Non-runtime PNGs

Examples:
	•	docs
	•	mockups
	•	screenshots
	•	exported references
	•	prompt attachments
	•	design source material

Only category A is the primary migration target.

⸻

REQUIRED AUDIT TASKS

1. Inventory all current image assets

Produce counts for:
	•	total .png files in repo
	•	total .webp files in repo
	•	total .png files under runtime asset folders
	•	total .webp files under runtime asset folders

Break counts down by folder/category.

⸻

2. Map runtime PNG ↔ WebP pairs

For each runtime PNG asset candidate:
	•	determine whether a sibling .webp exists
	•	determine whether the PNG is still referenced
	•	determine whether the PNG was intentionally retained
	•	classify it as:
	•	MIGRATED
	•	NOT_MIGRATED
	•	KEPT_INTENTIONALLY
	•	NEEDS_MANUAL_REVIEW

Do the inverse too:
	•	find runtime .webp files that replaced PNGs
	•	confirm whether matching .png still exists or has been removed

⸻

3. Audit code/config references

Search the repo for runtime .png references in:
	•	Dart files
	•	pubspec.yaml
	•	constants/helper files
	•	theme/image wrapper files
	•	JSON/config files if used for asset paths
	•	tests if relevant

Classify each .png reference as:
	•	valid intentional native/platform reference
	•	stale runtime reference that should have been migrated
	•	comment/doc/example only
	•	manual review

Do NOT do a naive text dump.
Group findings cleanly.

⸻

4. Calculate space saved

Calculate exact storage metrics for the runtime asset migration.

For all runtime assets that have both original PNG and corresponding WebP, compute:
	•	original PNG total bytes
	•	new WebP total bytes
	•	total bytes saved
	•	total MB saved
	•	percent reduction

Also provide:
	•	top 20 largest savings by file
	•	files where WebP is larger than PNG
	•	aggregate savings by folder if useful

Use exact filesystem sizes, not assumptions.

Formula examples:
	•	bytes_saved = png_size - webp_size
	•	percent_saved = ((png_size - webp_size) / png_size) * 100

Round for display, but retain exact underlying totals where practical.

⸻

5. Validate runtime safety

Confirm:
	•	no broken runtime asset declarations were introduced
	•	no stale .png references remain in active runtime code for files that should use .webp
	•	pubspec.yaml remains coherent
	•	native/platform PNGs still required have not been incorrectly treated as failures

If reasonable, run:
	•	analyzer on changed/relevant files if any tiny fixes were applied
	•	a lightweight validation scan for asset path consistency

⸻

6. Audit CI/policy coverage

If the Phase 4 guardrail script exists:
	•	run it
	•	confirm whether current repo passes
	•	report any current violations or allowlisted exceptions

If it does not exist:
	•	say so explicitly

⸻

IMPLEMENTATION APPROACH

Preferred approach:
	•	create or reuse a small audit script under tooling, for example:
	•	/tooling/scripts/audit_webp_migration.sh
	•	or a Dart/Python audit tool if better suited to the repo

The audit should:
	•	scan repo files deterministically
	•	produce structured output
	•	separate runtime assets from native/platform assets
	•	compute exact storage metrics
	•	be safe to rerun

If a script is created or updated, keep it production-ready and reviewable.

⸻

SUGGESTED OUTPUT STRUCTURE

The audit report should include:

1. Executive summary
	•	migration status: COMPLETE / MOSTLY_COMPLETE / PARTIAL
	•	total runtime PNG candidates
	•	total successfully migrated
	•	total intentionally retained
	•	total missing WebP
	•	total stale references found
	•	total storage saved

2. Runtime asset migration table

Columns such as:
	•	original PNG path
	•	WebP path
	•	PNG exists
	•	WebP exists
	•	PNG referenced
	•	WebP referenced
	•	classification
	•	bytes saved

3. Remaining PNG report

Group by:
	•	native/platform required
	•	non-runtime/docs/mockups
	•	stale runtime PNGs
	•	manual review

4. Reference audit

Group remaining .png references by file and classification.

5. Space savings report
	•	exact totals
	•	percentage reduction
	•	top savings
	•	regressions where WebP is bigger

6. Recommended next actions

Only small, safe, specific actions.

⸻

PATH OF NŪR APP-SPECIFIC AREAS TO CHECK CAREFULLY

Pay particular attention to:
	•	loading screen assets
	•	home screen artwork
	•	prayer/salah imagery
	•	Quran artwork
	•	kids section assets
	•	icon/halo/background images
	•	any centralized asset constants/helpers
	•	any custom image wrappers

Do not redesign UI.
Do not introduce placeholders.

⸻

OPTIONAL SAFE FIXES

Only if trivial and clearly safe:
	•	fix a tiny stale .png runtime reference where the .webp definitely exists
	•	fix a tiny pubspec.yaml declaration mismatch if obvious

If any fix is made:
	•	keep it minimal
	•	report it clearly
	•	run validation

Otherwise keep this phase audit-only.

⸻

DELIVERABLES

At the end, provide a concise but complete summary with:
	1.	Files changed, if any
	2.	Whether an audit script was created/updated
	3.	Total runtime PNG migration candidates
	4.	Total runtime assets successfully migrated to WebP
	5.	Total runtime PNGs intentionally kept
	6.	Total runtime PNGs still not migrated
	7.	Total stale .png runtime references found
	8.	Exact storage savings:
	•	original total size
	•	new total size
	•	bytes saved
	•	MB saved
	•	percentage saved
	9.	Largest individual file savings
	10.	Any cases where WebP got larger
	11.	Whether CI/policy check passes
	12.	Final status:

	•	COMPLETE
	•	MOSTLY_COMPLETE
	•	PARTIAL

	13.	Specific follow-up actions still needed

⸻

FINAL REQUIREMENT

At the very end, perform one full audit summary so I can review everything in one place:
	•	what was converted
	•	what still remains
	•	what was intentionally kept
	•	what references remain
	•	exactly how much space was saved
	•	what the next safest actions are

Do not go haywire.
Do not remove/delete records/files for no reason.
Prefer exact, reviewable, production-ready audit results over assumptions.

===== END =====
:::

A useful add-on is asking Codex to produce a CSV report with per-file savings so you can sort the biggest wins fast.

