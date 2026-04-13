# Prompt

“Indeed, Allah is with those who are mindful and those who do good.” — Qur’an 16:128

Here is the Phase 2 Codex prompt to safely replace PNG references with WebP across the Flutter repo.

:::writing{variant=“standard” id=“53184”}
===== PHASE 2 — ASSET REFERENCE MIGRATION — PNG → WEBP USAGE UPDATE =====

PRIMARY OBJECTIVE === SAFELY UPDATE THE EXISTING FLUTTER CODEBASE TO USE .webp ASSET REFERENCES INSTEAD OF .png WHERE THE CORRESPONDING WEBP FILE EXISTS

Context:
You are working inside the existing Flutter repo for “Path of Nūr”.

Phase 1 converted image assets under /assets and its subfolders from .png to .webp.

Now implement Phase 2:
	•	audit the repo for .png asset references
	•	safely replace those references with .webp
	•	ONLY replace references when the matching .webp file actually exists
	•	keep the codebase production-safe
	•	do not break runtime behavior
	•	do not remove .png files in this phase

This is a repo-aware migration, not a blind find/replace.

⸻

🚨 CRITICAL SAFETY RULES
	1.	DO NOT blindly replace every .png string in the repo.
	2.	DO NOT modify anything outside the actual app/relevant project files unless needed.
	3.	DO NOT delete any files.
	4.	DO NOT rename assets on disk in this phase.
	5.	DO NOT change non-asset examples, comments, docs, generated files, lock files, or unrelated markdown unless necessary.
	6.	ONLY replace a .png reference if the same relative asset path with .webp exists.
	7.	Preserve localization, routing, architecture, and existing UI behavior.
	8.	Prefer small, targeted edits over sweeping unsafe replacements.
	9.	Audit first before editing.
	10.	Run analyzer / validation after changes and summarize results.

⸻

AUDIT FIRST — MANDATORY

Before editing anything:
	1.	Search the repo for all .png references.
	2.	Group findings by file type and usage pattern, for example:
	•	pubspec.yaml
	•	Dart files
	•	JSON/config/constants
	•	tests
	•	platform-specific config
	3.	Identify which references are true runtime asset references versus:
	•	comments
	•	docs
	•	dead code
	•	generated files
	•	examples/snippets
	4.	Build a replacement plan:
	•	original .png reference
	•	proposed .webp reference
	•	whether the .webp file exists
	•	whether the change is safe

Output a concise audit summary before making edits.

⸻

IMPLEMENTATION SCOPE

Update asset references in places such as:
	•	Image.asset(...)
	•	AssetImage(...)
	•	ExactAssetImage(...)
	•	decoration/background image paths
	•	constant asset path classes
	•	helper utilities that resolve local asset strings
	•	widget test asset references if they point to real assets and the .webp exists

Also inspect:
	•	pubspec.yaml asset declarations
	•	central asset registries/constants
	•	theme/image helper files
	•	onboarding/artwork/background references
	•	any Path of Nūr-specific UI asset wrappers

Do NOT update:
	•	comments
	•	unrelated docs
	•	changelogs
	•	codex prompt files
	•	generated localization or generated code unless it truly contains runtime asset paths and is supposed to be source-controlled

⸻

REPLACEMENT RULE

For each .png reference:
	•	compute the matching .webp path
	•	confirm the .webp file exists on disk
	•	only then replace the reference

If .webp does not exist:
	•	leave the .png reference untouched
	•	include it in the final report under “not replaced”

Example:
	•	replace assets/images/foo.png → assets/images/foo.webp
	•	only if assets/images/foo.webp exists

⸻

PUBSPEC HANDLING

Inspect pubspec.yaml carefully.

Rules:
	1.	If assets are directory-declared, do not make unnecessary changes.
	2.	If individual files are declared and .png files are explicitly listed, update those entries to .webp only where the .webp file exists and the asset is actually intended to migrate.
	3.	Do not disturb unrelated asset declarations.

Keep pubspec.yaml minimal and correct.

⸻

IMPLEMENTATION APPROACH

Preferred approach:
	•	use a repo-aware migration script or targeted edits
	•	avoid a naive global search/replace

Good options:
	1.	Create a one-off migration helper script under a tooling folder and use it to generate safe replacements
	2.	Then apply targeted edits to source files
	3.	Or do carefully scoped replacements directly if the reference count is manageable

Whichever approach is used:
	•	make it deterministic
	•	log what changed
	•	keep changes reviewable

⸻

VALIDATION

After edits:
	1.	Run Flutter analyzer on changed app files
	2.	Validate there are no broken asset path references introduced by the migration
	3.	Re-scan the repo for .png references and classify remaining ones:
	•	intentionally left as-is
	•	missing .webp
	•	non-runtime reference
	4.	Confirm:
	•	no original assets were deleted
	•	no invalid path rewrites occurred
	•	no unrelated text was changed

If feasible, also run:
	•	flutter pub get if pubspec changed
	•	a lightweight grep/search verification for changed asset paths

⸻

PATH OF NŪR APP-SPECIFIC EXPECTATIONS

Be especially careful around:
	•	loading screen assets
	•	home screen artwork
	•	prayer/salah imagery
	•	Qur’an / Learn hub artwork
	•	kids section assets
	•	icon/background image helpers
	•	any central asset constants class already in the repo

Preserve the current visual structure and architecture.
Do not redesign UI.
Do not introduce placeholder assets.

⸻

CLEANUP
	•	keep any migration helper script small and self-explanatory
	•	do not leave broken temporary code behind
	•	keep naming clean
	•	keep ownership clear

⸻

DELIVERABLES

After implementation, provide a concise summary with:
	1.	Files changed
	2.	Total .png references found
	3.	Total references safely replaced with .webp
	4.	References intentionally left unchanged
	5.	Any missing .webp files that blocked replacement
	6.	Whether pubspec.yaml changed
	7.	Analyzer / validation results
	8.	Any follow-up recommendations for Phase 3

⸻

PHASE 3 PREVIEW — DO NOT IMPLEMENT YET

Possible next phase after this is verified:
	•	remove old .png files only after all runtime references are confirmed migrated
	•	add CI enforcement to prevent new .png assets from being introduced without reason
	•	optionally standardize asset loading helpers for future-proofing

⸻

FINAL REQUIREMENT

At the very end, audit the full migration result and provide one clean summary of:
	•	what was changed
	•	what remains
	•	what is safe to do next
	•	any risks still present

Do not go haywire.
Do not remove or delete records/files for no reason.
Prefer safe, reviewable, production-ready migration over aggressive cleanup.

===== END =====
:::

Next clean step is Phase 3: remove legacy PNGs only after verification.
