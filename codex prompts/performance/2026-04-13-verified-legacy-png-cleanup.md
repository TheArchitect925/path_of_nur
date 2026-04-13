# Prompt

“Allah does not burden a soul beyond that it can bear.” — Qur’an 2:286

Here’s the Phase 3 Codex prompt to safely remove legacy PNGs only after verified migration.

:::writing{variant=“standard” id=“60427”}
===== PHASE 3 — VERIFIED LEGACY ASSET CLEANUP — SAFE PNG REMOVAL =====

PRIMARY OBJECTIVE === REMOVE LEGACY .png ASSETS ONLY WHERE THE MIGRATION TO .webp IS FULLY VERIFIED AND SAFE

Context:
You are working inside the existing Flutter repo for “Path of Nūr”.

Phase 1:
	•	converted PNG assets under /assets and subfolders into .webp

Phase 2:
	•	updated runtime/code references from .png to .webp where matching .webp files existed

Now implement Phase 3:
	•	audit all remaining .png files
	•	determine which are now truly unused
	•	remove only the PNG files that are safe to remove
	•	preserve any PNGs still required by the app, platform packaging, tests, docs, tooling, or fallback cases
	•	keep the cleanup production-safe, reviewable, and reversible

This is a verified cleanup phase, not an aggressive deletion pass.

⸻

🚨 CRITICAL SAFETY RULES
	1.	DO NOT blindly delete all .png files.
	2.	DO NOT delete any asset unless both of these are true:
	•	the equivalent .webp exists
	•	no live runtime/code/config reference still requires the .png
	3.	DO NOT delete platform-required PNGs such as:
	•	iOS app icons / launch-related assets
	•	Android mipmap/drawable launcher assets if still needed
	•	notification icons or platform-specific assets that must remain PNG
	4.	DO NOT delete files used by package configuration, native manifests, Xcode asset catalogs, or Android resources.
	5.	DO NOT delete test fixtures unless clearly migrated and safe.
	6.	DO NOT delete docs/examples/comments-only references as a basis for cleanup.
	7.	DO NOT remove anything outside intended asset scope unless clearly verified.
	8.	Prefer quarantine/reporting if uncertain.
	9.	Audit first before editing.
	10.	Run validation after cleanup and summarize results.

⸻

AUDIT FIRST — MANDATORY

Before deleting anything:
	1.	Scan the repo for all remaining .png files.
	2.	Categorize them into groups, for example:
	•	Flutter app runtime assets under /assets
	•	iOS native assets
	•	Android native assets
	•	test fixtures
	•	docs/examples
	•	tooling/generated/export artifacts
	3.	For each remaining .png, determine:
	•	does a sibling .webp exist?
	•	is the .png still referenced anywhere in repo code/config?
	•	is it platform-required and therefore must remain PNG?
	•	is it safe to delete?
	4.	Produce a deletion plan with categories:
	•	SAFE TO DELETE
	•	KEEP
	•	NEEDS MANUAL REVIEW

Output a concise audit summary before making changes.

⸻

REQUIRED SEARCH/VERIFICATION

For every candidate .png:
	•	search repo references for the exact file path and filename
	•	inspect:
	•	Dart files
	•	pubspec.yaml
	•	native iOS project files
	•	Android resource references
	•	tests
	•	scripts/tooling
	•	config/constants/helper files

Deletion rule:
A .png can only be removed if:
	1.	matching .webp exists
	2.	runtime references have already been migrated
	3.	no platform or tooling requirement still depends on PNG
	4.	file is not intentionally retained as a native/platform asset

⸻

PLATFORM PRESERVATION RULES

Be extremely careful around these:

iOS

Keep PNGs that are still required in:
	•	ios/Runner/Assets.xcassets
	•	app icons
	•	launch / branding assets if native-side
	•	notification or widget packaging assets if required as PNG

Android

Keep PNGs that are still required in:
	•	android/app/src/main/res/...
	•	mipmap launcher icons
	•	notification icons
	•	drawable resources that must remain PNG

Other

Keep any file required by:
	•	web favicons or manifest icons
	•	desktop packaging assets
	•	CI/tooling snapshots if still used

Do not convert framework/platform conventions into breakage.

⸻

IMPLEMENTATION APPROACH

Preferred safe approach:

Option A — Recommended

Create a cleanup helper script such as:
/tooling/scripts/remove_verified_legacy_pngs.sh

The script should:
	•	run in dry-run mode by default
	•	list all candidate deletions
	•	only delete files explicitly verified as safe
	•	log each decision

Suggested flags:
	•	DRY_RUN=true
	•	DELETE_CONFIRMED=false by default, then enabled only after verification

Logging

Use clear categories:
	•	[KEEP]
	•	[DELETE]
	•	[REVIEW]
	•	[ERROR]

Keep output deterministic and reviewable.

⸻

DELETION SCOPE

Delete only:
	•	legacy Flutter asset PNGs under /assets that have already been safely replaced by .webp
	•	duplicate PNGs no longer needed by runtime

Do NOT delete:
	•	platform-native PNG assets still required
	•	screenshots/mockups/docs
	•	temporary user design sources unless clearly part of runtime assets and approved for cleanup
	•	any file with ambiguous usage

⸻

PUBSPEC HANDLING

Inspect pubspec.yaml after cleanup.

Rules:
	1.	If asset directories are declared, confirm the cleanup does not leave broken runtime references.
	2.	If individual PNG files were explicitly declared and removed, clean those declarations only when safe.
	3.	Do not disturb unrelated entries.

If pubspec.yaml needs changes, keep them minimal.

⸻

VALIDATION

After cleanup:
	1.	Re-scan the repo for .png references
	2.	Re-scan remaining .png files and classify why they remain
	3.	Run analyzer on changed app files
	4.	If asset declarations changed, run flutter pub get
	5.	Confirm:
	•	removed PNGs all had .webp replacements
	•	no broken references were introduced
	•	platform assets still required as PNG remain untouched
	•	folder structure remains sane

If practical, also produce:
	•	total PNGs before cleanup
	•	total deleted
	•	total retained
	•	total requiring manual review

⸻

PATH OF NŪR APP-SPECIFIC EXPECTATIONS

Be especially careful around:
	•	loading screen assets
	•	home / learn / prayer artwork
	•	salah position images
	•	kids assets
	•	Quran artwork
	•	icons and halos
	•	any UI helper/asset constants
	•	any native app icon resources

Do not redesign anything.
Do not introduce placeholders.
Do not remove source-of-truth native assets that still matter.

⸻

CLEANUP QUALITY BAR

This must be:
	•	safe
	•	production-ready
	•	reviewable
	•	conservative

If there is uncertainty, KEEP the file and report it instead of deleting it.

⸻

DELIVERABLES

After implementation, provide a concise summary with:
	1.	Files changed
	2.	Cleanup script created or not
	3.	Total remaining .png files found before cleanup
	4.	Total safely deleted
	5.	Total intentionally kept
	6.	Total flagged for manual review
	7.	Whether pubspec.yaml changed
	8.	Analyzer / validation results
	9.	Categories of PNGs that still remain and why

⸻

PHASE 4 PREVIEW — DO NOT IMPLEMENT YET

Potential next phase:
	•	add CI guardrails so new PNG runtime assets are flagged unless intentionally allowed
	•	optionally add an asset policy doc:
	•	UI/runtime imagery prefers WebP
	•	platform launcher/native assets remain PNG where required
	•	optionally add a repo audit command for assets

⸻

FINAL REQUIREMENT

At the very end, perform one full audit summary so I can review in one place:
	•	what was deleted
	•	what was kept
	•	why it was kept
	•	what remains to be done
	•	any risks or manual follow-up still needed

Do not go haywire.
Do not delete records/files for no reason.
Prefer safe verified cleanup over aggressive removal.

===== END =====
:::

After this, the smart next phase is Phase 4: CI guardrails so PNGs do not quietly creep back into runtime assets.
