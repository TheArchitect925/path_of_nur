“Indeed, Allah is with those who are mindful and those who do good.” — Qur’an 16:128

Here’s the Phase 9 Codex prompt to rerun the full WebP migration audit after the tightened allowlist, so the numbers reflect actual runtime usage and current policy truth.

:::writing{variant=“standard” id=“33842”}
===== PHASE 9 — POST-MIGRATION FULL WEBP AUDIT — REAL USAGE, REAL SAVINGS, TIGHTENED POLICY =====

PRIMARY OBJECTIVE === RERUN THE FULL WEBP MIGRATION AUDIT NOW THAT THE HIGH-IMPACT ASSETS WERE CONVERTED, LIVE RUNTIME REFERENCES WERE MIGRATED, AND THE PNG POLICY / ALLOWLIST HAS BEEN TIGHTENED

Context:
You are working inside the existing Flutter repo for “Path of Nūr”.

Completed phases already established:
	•	high-impact PNG → WebP conversion was executed for:
	•	assets/images/backgrounds except Loading.png
	•	assets/images/wudu
	•	assets/images/prophets
	•	verified live runtime references for those converted files were migrated to .webp
	•	runtime PNG allowlist / policy was tightened so those folders should no longer be broadly exempt
	•	Loading.png remains an intentional runtime PNG holdout for now
	•	native/platform PNGs remain intentionally allowed where required

Now perform a full post-migration audit so the repo reflects the true current state.

This phase is an audit and reporting phase.
Do not go haywire.
Do not delete files for no reason.
Do not make broad edits unless a tiny safe correction is absolutely necessary and clearly justified.

⸻

PRIMARY GOALS
	1.	Recalculate the full repo image inventory after the completed high-impact migration.
	2.	Recalculate runtime PNG and WebP inventory under assets/.
	3.	Confirm the converted high-impact folders now have:
	•	real sibling .webp files on disk
	•	live runtime references pointing to .webp
	4.	Confirm the tightened PNG policy passes for the right reasons.
	5.	Compute exact updated storage savings.
	6.	Identify what runtime PNG debt still remains.
	7.	Produce a clean final status:
	•	COMPLETE
	•	MOSTLY_COMPLETE
	•	PARTIAL

⸻

🚨 CRITICAL SAFETY RULES
	1.	AUDIT FIRST. Do not start with edits.
	2.	Do not delete PNGs in this phase.
	3.	Do not broadly rewrite references in this phase.
	4.	Do not count native/platform-required PNGs as migration failures.
	5.	Distinguish clearly between:
	•	active runtime app assets
	•	intentional runtime PNG holdouts
	•	native/platform assets
	•	docs/mockups/non-runtime artifacts
	6.	Provide exact numbers using filesystem and repo-aware checks.
	7.	If something is uncertain, classify it as manual review.
	8.	If a tiny obvious fix is made, report it explicitly.
	9.	Keep the report deterministic and reviewable.
	10.	At the very end, provide one clean audit summary in one place.

⸻

REQUIRED AUDIT TASKS

1. Full repo inventory

Produce updated counts for:
	•	total .png files in repo
	•	total .webp files in repo
	•	total runtime .png files under app asset folders
	•	total runtime .webp files under app asset folders

Break these down by:
	•	runtime app assets
	•	native/platform assets
	•	non-runtime artifacts

2. High-impact folder verification

Specifically verify these folders:
	•	assets/images/backgrounds
	•	assets/images/wudu
	•	assets/images/prophets

For each folder, report:
	•	PNG count
	•	WebP count
	•	which PNGs still remain intentionally
	•	whether live runtime references now point to .webp
	•	whether any stale runtime .png refs remain
	•	whether any sibling WebPs are missing where expected

Special handling:
	•	confirm assets/images/backgrounds/Loading.png remains intentionally on PNG
	•	confirm it is the only intentional holdout in the migrated high-impact set unless audit proves otherwise

3. Runtime reference audit

Search the repo again for runtime .png references in active code/config.
Classify findings as:
	•	intentional runtime PNG holdout
	•	active migrated runtime now on .webp
	•	stale runtime .png reference that should have been migrated
	•	non-runtime/doc/comment/example reference
	•	missing asset/manual review

Give exact counts.

4. Storage savings audit

Recompute exact storage metrics for the converted high-impact files and the runtime asset tree overall.

At minimum provide:
	•	original PNG total bytes for the converted high-impact set
	•	WebP total bytes for the converted high-impact set
	•	exact bytes saved
	•	MB saved
	•	percentage saved

Also provide updated runtime inventory totals:
	•	total bytes in runtime PNGs still present
	•	total bytes in runtime WebPs
	•	top remaining PNG-heavy folders
	•	top converted savings by file/folder

Call out:
	•	any files where WebP is larger
	•	any measurable regressions

5. Policy / CI verification

Run the runtime PNG policy / allowlist check.
Confirm:
	•	pass/fail result
	•	whether high-impact folders are no longer broadly exempt
	•	whether Loading.png remains explicitly allowed if intended
	•	whether native/platform exemptions still behave correctly

If possible, summarize:
	•	approved runtime exceptions
	•	approved native PNGs
	•	violations found or none

6. Remaining migration debt

Identify what still remains after the successful high-impact phase.

Examples:
	•	runtime PNG folders not yet converted
	•	missing asset integrity issues unrelated to WebP conversion
	•	runtime .png references still legitimately pending
	•	temporary policy exceptions still left in place

Group these cleanly into:
	•	NEXT CONVERSION TARGETS
	•	POLICY FOLLOW-UP
	•	ASSET INTEGRITY DEBT
	•	MANUAL REVIEW

⸻

IMPLEMENTATION APPROACH

Use the existing audit tooling if appropriate, especially:
	•	tooling/scripts/audit_webp_migration.sh
	•	any related policy check scripts
	•	any readiness / conversion reporting helpers already created

You may update the audit script only if a small improvement is clearly needed for accurate reporting.
If you update it:
	•	keep changes minimal
	•	keep it deterministic
	•	report that change explicitly

Otherwise prefer audit-only execution.

⸻

SUGGESTED OUTPUT STRUCTURE

A. Executive summary
	•	final status: COMPLETE / MOSTLY_COMPLETE / PARTIAL
	•	runtime PNG candidates
	•	runtime WebPs present
	•	high-impact migration verified or not
	•	policy result
	•	exact storage saved
	•	top remaining debt

B. Folder verification

Per target folder:
	•	PNG count
	•	WebP count
	•	intentional PNG holdouts
	•	stale refs or none
	•	notes

C. Runtime reference audit

Grouped by:
	•	migrated to WebP
	•	intentional PNG
	•	stale runtime PNG refs
	•	non-runtime refs
	•	missing/manual review

D. Storage report
	•	exact totals
	•	percentage saved
	•	top per-folder and per-file savings
	•	top remaining PNG-heavy folders

E. Policy report
	•	pass/fail
	•	explicit runtime exceptions
	•	native exemptions
	•	remaining temporary exceptions if any

F. Recommended next steps

Only small, safe, concrete next actions.

⸻

IMPORTANT NON-GOALS

Do NOT do these yet:
	•	do not delete legacy PNGs
	•	do not broaden conversion to other folders
	•	do not change Loading.png
	•	do not fix unrelated missing asset debt unless a tiny necessary correction is obvious
	•	do not add new broad allowlist exemptions

⸻

PATH OF NŪR APP-SPECIFIC EXPECTATIONS

Be especially careful around:
	•	backgrounds
	•	Wudu assets
	•	Prophet images
	•	any central asset helper/resolver logic
	•	policy truth versus temporary exceptions
	•	remaining missing kids_stories / quran_teacher assets as separate integrity debt

Preserve architecture, localization, routing, and the current UI behavior.

⸻

DELIVERABLES

At the end, provide a concise summary with:
	1.	Files changed, if any
	2.	Whether audit tooling changed
	3.	Updated total repo PNG/WebP counts
	4.	Updated runtime PNG/WebP counts
	5.	High-impact migration verification result
	6.	Updated exact storage savings
	7.	Policy / CI result
	8.	Remaining runtime PNG debt
	9.	Remaining temporary exceptions
	10.	Final status:

	•	COMPLETE
	•	MOSTLY_COMPLETE
	•	PARTIAL

	11.	Recommended next safest phase

⸻

NEXT PHASE — DO NOT IMPLEMENT YET

After this audit:
	•	Phase 10: delete verified legacy PNGs only for the migrated high-impact set, after confirming runtime references and policy are correct
	•	Phase 11: repeat the same conversion/migration process for the next heaviest runtime folders
	•	Phase 12: separately address unrelated asset-integrity debt such as missing kids_stories / quran_teacher paths

⸻

FINAL REQUIREMENT

At the very end, provide one full clean audit summary in one place:
	•	what is now migrated
	•	what is now actively used as WebP
	•	what remains intentionally on PNG
	•	exact space savings achieved so far
	•	whether policy now passes for the right reasons
	•	what remains to do next

Do not go haywire.
Do not delete records/files for no reason.
Prefer exact, reviewable, production-ready audit output over assumptions.

===== END =====
:::

After this, the next sensible prompt is Phase 10: delete only the verified legacy PNGs for the migrated high-impact set.
