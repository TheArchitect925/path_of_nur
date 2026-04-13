===== PHASE 13 — FINAL ASSET VERIFICATION AUDIT — PNG REMOVAL, WEBP REPLACEMENT, AND LINK INTEGRITY =====

PRIMARY OBJECTIVE === PERFORM A FULL VERIFICATION AUDIT TO CONFIRM THAT THE COMPLETED PNG → WEBP MIGRATION WORK IS ACTUALLY CORRECT: LEGACY PNGS WERE REMOVED WHERE EXPECTED, WEBP REPLACEMENTS EXIST, LIVE RUNTIME REFERENCES POINT TO THE RIGHT FILES, AND THE APP HAS NO BROKEN ASSET LINKAGE IN THE MIGRATED AREAS

Context:
You are working inside the existing Flutter repo for “Path of Nūr”.

Previous phases have already handled parts of this workflow:
	•	readiness audit
	•	real PNG → WebP conversion
	•	verified runtime reference migration
	•	allowlist / policy tightening
	•	post-migration audit
	•	verified cleanup of legacy PNGs for migrated batches
	•	separate asset-integrity work may also exist for missing asset paths

Now run one final verification-style audit.

This phase is primarily an audit and validation pass.
Do not go haywire.
Do not delete files for no reason.
Do not make broad edits unless a tiny obvious fix is absolutely necessary and clearly reportable.

⸻

PRIMARY GOALS

Audit and verify all of the following:
	1.	Which runtime PNGs still exist under assets/
	2.	Which runtime PNGs were intentionally preserved
	3.	Which migrated runtime assets now have sibling .webp files
	4.	Which legacy PNGs were successfully removed in previously completed cleanup phases
	5.	Whether live runtime references now point to the correct .webp files
	6.	Whether any stale .png references still remain in active runtime code/config
	7.	Whether any runtime asset references point to missing files
	8.	Whether the current app asset graph is coherent and linked correctly
	9.	Whether policy / CI now passes for the right reasons
	10.	Final migration status:

	•	COMPLETE
	•	MOSTLY_COMPLETE
	•	PARTIAL
	•	BROKEN

⸻

🚨 CRITICAL SAFETY RULES
	1.	AUDIT FIRST. Do not begin with edits.
	2.	Do not assume all PNGs should be gone.
	3.	Distinguish clearly between:
	•	runtime app assets
	•	intentional runtime PNG holdouts
	•	native/platform PNG assets
	•	docs/mockups/non-runtime artifacts
	4.	Do not count platform-native PNGs as migration failures.
	5.	Do not count intentional explicit runtime holdouts as failures.
	6.	Do not blindly grep and dump raw output without classification.
	7.	Use repo-aware checks and exact filesystem verification.
	8.	If a tiny obvious fix is made, report it explicitly.
	9.	If uncertainty remains, classify it as manual review.
	10.	At the end, provide one clean summary in one place.

⸻

REQUIRED AUDIT QUESTIONS

A. PNG removal verification

For the already-migrated runtime folders/batches, verify:
	•	which original PNGs were deleted
	•	which original PNGs still remain
	•	whether remaining PNGs are intentional holdouts or unexpected leftovers

For each remaining runtime PNG in migrated scope, classify:
	•	INTENTIONAL_HOLDOUT
	•	EXPECTED_NOT_YET_MIGRATED
	•	UNEXPECTED_LEFTOVER
	•	MANUAL_REVIEW

B. WebP replacement verification

For the migrated runtime scope, verify:
	•	.webp exists on disk
	•	filename/path is correct
	•	runtime owner now references .webp
	•	no stale owner still points to removed .png

C. Link integrity verification

For active runtime asset references, verify:
	•	referenced file exists
	•	extension matches real file on disk
	•	no broken paths
	•	no stale renamed/mis-cased paths
	•	no resolver/config mismatch causing hidden failures

D. End-to-end asset integrity

Audit whether the current app state is consistent:
	•	runtime reference path exists
	•	asset is inside declared/usable runtime tree
	•	no dead links remain in migrated areas
	•	any remaining missing assets are clearly separated as unresolved content debt

⸻

AUDIT SCOPE

At minimum, audit these runtime areas thoroughly:

1. Previously migrated high-impact set
	•	assets/images/backgrounds
	•	assets/images/wudu
	•	assets/images/prophets

2. Other runtime asset folders under assets/

Audit remaining runtime folders to determine:
	•	not yet migrated
	•	partially migrated
	•	already coherent
	•	broken / missing references

3. Active runtime reference owners

Search active runtime references in:
	•	Dart files
	•	asset resolvers/helpers
	•	content/data/config files
	•	provider/viewmodel layers
	•	pubspec.yaml only if relevant to runtime linkage

Do not treat archived prompt files, docs, or comments as runtime truth.

⸻

REQUIRED AUDIT TASKS

1. Runtime asset inventory

Produce updated counts for:
	•	total repo .png
	•	total repo .webp
	•	total runtime .png
	•	total runtime .webp

Break down runtime counts by folder.

Also report:
	•	native/platform PNG count
	•	non-runtime PNG count

2. Migrated-scope verification

For each file in migrated scope:
	•	original PNG path
	•	PNG still exists or removed
	•	WebP exists or missing
	•	active runtime reference points to PNG or WebP
	•	classification
	•	notes

Prefer a structured table or CSV-friendly output.

3. Active reference audit

Search active runtime code/config for asset references ending in .png and .webp.

Classify findings as:
	•	ACTIVE_WEBP_OK
	•	INTENTIONAL_RUNTIME_PNG
	•	STALE_RUNTIME_PNG_REF
	•	BROKEN_MISSING_REF
	•	NON_RUNTIME_REFERENCE
	•	MANUAL_REVIEW

Give exact counts and file owners.

4. Broken-link audit

Explicitly verify whether any active asset references point to files missing on disk.

For each broken reference:
	•	referencing file
	•	referenced path
	•	likely cause:
	•	removed file still referenced
	•	path typo
	•	case mismatch
	•	wrong extension
	•	wrong folder
	•	true missing asset
	•	whether it is inside migrated scope or separate integrity debt

5. Removal-vs-replacement consistency check

For any runtime PNG that was deleted:
	•	confirm matching .webp exists
	•	confirm live refs no longer point to .png

For any runtime .webp now referenced:
	•	confirm file exists
	•	confirm it is the correct sibling or intended replacement

6. Policy / CI verification

Run the runtime PNG policy check.

Confirm:
	•	pass/fail
	•	why it passes
	•	whether migrated folders are no longer broadly exempt
	•	which explicit runtime PNG exceptions remain
	•	whether native/platform PNGs remain correctly approved

7. Validation pass

If practical, run:
	•	flutter analyze on files changed in recent asset migration work, or on relevant touched owners if no broad changes are made
	•	any existing asset audit helper scripts
	•	any missing-asset audit scripts if present

The goal is confidence that the app is linked correctly, not just that the file tree looks good.

⸻

IMPLEMENTATION APPROACH

Reuse existing tooling where possible, such as:
	•	tooling/scripts/audit_webp_migration.sh
	•	policy check scripts
	•	missing asset audit helpers
	•	readiness / cleanup scripts if useful for classification

You may create or update one small final verification helper script if it materially improves determinism, for example:
	•	tooling/scripts/final_asset_verification_audit.sh

If you create/update a script:
	•	keep it narrow
	•	keep it deterministic
	•	keep it safe to rerun
	•	report that clearly

⸻

SUGGESTED OUTPUT STRUCTURE

A. Executive summary
	•	final verification status: COMPLETE / MOSTLY_COMPLETE / PARTIAL / BROKEN
	•	runtime PNG count
	•	runtime WebP count
	•	migrated-scope verification result
	•	broken-link count
	•	policy result
	•	top remaining issues

B. Migrated-scope table

Columns:
	•	asset path base
	•	PNG exists
	•	WebP exists
	•	active ref target
	•	classification
	•	notes

C. Remaining runtime PNG report

Group by:
	•	intentional holdouts
	•	not yet migrated
	•	unexpected leftovers
	•	manual review

D. Active reference report

Group by:
	•	live WebP OK
	•	intentional PNG OK
	•	stale PNG refs
	•	broken missing refs
	•	non-runtime refs

E. Policy report
	•	pass/fail
	•	explicit runtime exceptions
	•	native/platform approvals
	•	any still-too-broad exemptions

F. Recommended next actions

Only small, safe, concrete follow-ups.

⸻

IMPORTANT NON-GOALS

Do NOT do these yet unless a tiny obvious fix is unavoidable:
	•	do not start a new broad conversion batch
	•	do not delete more PNGs broadly
	•	do not fabricate missing assets
	•	do not refactor unrelated asset systems
	•	do not loosen policy just to get green

This is a verification phase, not a major implementation phase.

⸻

PATH OF NŪR APP-SPECIFIC EXPECTATIONS

Be especially careful around:
	•	backgrounds and wallpapers
	•	Wudu instructional assets
	•	Prophet image resolvers/cards
	•	garden asset paths
	•	any centralized asset helper/resolver
	•	loading/startup assets
	•	previous kids_stories / quran_teacher debt as separate integrity issues if still present

If one central resolver is still wrong, identify it as the root cause instead of treating every broken path as isolated.

⸻

DELIVERABLES

At the end, provide a concise summary with:
	1.	Files changed, if any
	2.	Whether a final verification helper script was created/updated
	3.	Updated repo PNG/WebP counts
	4.	Updated runtime PNG/WebP counts
	5.	Total migrated-scope assets fully verified
	6.	Total intentional runtime PNG holdouts
	7.	Total unexpected leftover PNGs in migrated scope
	8.	Total stale runtime .png refs
	9.	Total broken runtime asset references
	10.	Policy / CI result
	11.	Final verification status:

	•	COMPLETE
	•	MOSTLY_COMPLETE
	•	PARTIAL
	•	BROKEN

	12.	Exact recommended next steps

⸻

FINAL REQUIREMENT

At the very end, provide one full clean summary in one place:
	•	whether PNGs were actually removed where expected
	•	whether WebPs actually replaced them correctly
	•	whether the app is linked correctly
	•	what still remains intentionally on PNG
	•	what still remains broken or incomplete
	•	what the next safest action is

Do not go haywire.
Do not delete records/files for no reason.
Prefer exact, reviewable, production-ready verification over assumptions.

===== END =====
