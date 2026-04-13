“Indeed, with hardship comes ease.” — Qur’an 94:6

Excellent result.

What you achieved

The real migration has now actually started.
	•	53 new sibling WebPs created
	•	0 failures
	•	1 intentional holdout: assets/images/backgrounds/Loading.png
	•	67.55 MB saved
	•	52.15% reduction across this phase

That is a strong win.

Biggest takeaway

Your highest-value folders are now materially optimized:
	•	Backgrounds: massive win, about 90.01% reduction
	•	Wudu: solid win, about 36.86% reduction
	•	Prophets: strong win, about 34.17% reduction

And the most important part: these are now real on-disk files, not just policy or audit prep.

What this means now

You are ready for the next clean step:

Phase 7

Update runtime references from .png → .webp, but only where the new verified sibling .webp files now exist.

That means:
	•	no blind global replacement
	•	no deletions yet
	•	no allowlist tightening yet
	•	just safe reference migration for these 53 converted assets

Codex prompt for Phase 7

:::writing{variant=“standard” id=“51362”}
===== PHASE 7 — VERIFIED RUNTIME REFERENCE MIGRATION — HIGH-IMPACT WEBP SIBLINGS ONLY =====

PRIMARY OBJECTIVE === SAFELY UPDATE RUNTIME ASSET REFERENCES FROM .png TO .webp ONLY FOR THE VERIFIED HIGH-IMPACT SIBLING WEBPS THAT NOW EXIST ON DISK

Context:
You are working inside the existing Flutter repo for “Path of Nūr”.

The high-impact PNG → WebP execution phase is complete for these folders:
	•	assets/images/backgrounds
	•	assets/images/wudu
	•	assets/images/prophets

Execution result:
	•	53 new sibling .webp files were created
	•	0 failures
	•	1 intentional exclusion remains:
	•	assets/images/backgrounds/Loading.png
	•	original PNGs remain on disk
	•	runtime references have NOT yet been migrated

This phase is for verified reference migration only.

Do not go haywire.
Do not do a blind repo-wide search/replace.
Do not delete PNGs.
Do not migrate references for files that do not have a verified sibling .webp.

⸻

PRIMARY GOALS
	1.	Audit current runtime references to .png for the converted files in:
	•	assets/images/backgrounds
	•	assets/images/wudu
	•	assets/images/prophets
	2.	Replace those references with .webp only when:
	•	the .webp sibling exists on disk
	•	the reference is a real runtime asset reference
	3.	Leave assets/images/backgrounds/Loading.png untouched in this phase
	4.	Keep the migration safe, reviewable, and production-ready
	5.	Validate the result after edits

⸻

🚨 CRITICAL SAFETY RULES
	1.	AUDIT FIRST before editing.
	2.	DO NOT blindly replace every .png string in the repo.
	3.	ONLY replace runtime references for files that now have a verified sibling .webp.
	4.	DO NOT modify unrelated .png references.
	5.	DO NOT modify comments, docs, archived prompts, changelogs, or generated files unless they are true runtime asset sources.
	6.	DO NOT delete PNG files.
	7.	DO NOT tighten allowlists in this phase.
	8.	DO NOT touch native/platform PNG references.
	9.	Leave Loading.png unchanged.
	10.	At the end, provide one clean summary of exactly what changed.

⸻

AUDIT FIRST — MANDATORY

Before editing:
	1.	Search the repo for runtime references to .png assets under:
	•	assets/images/backgrounds
	•	assets/images/wudu
	•	assets/images/prophets
	2.	For each reference found, determine:
	•	file containing the reference
	•	exact asset path referenced
	•	whether matching .webp sibling exists
	•	whether the reference is active runtime code/config
	•	whether it is safe to replace
	3.	Build a replacement plan grouped by:
	•	Dart runtime code
	•	asset constants/helpers
	•	pubspec.yaml if relevant
	•	tests if applicable and safe

Output a concise audit summary before applying changes.

⸻

REPLACEMENT RULE

For each candidate runtime .png reference:

Replace:
	•	assets/.../file.png

With:
	•	assets/.../file.webp

ONLY IF:
	1.	the .webp sibling exists on disk
	2.	the reference is a live runtime asset reference
	3.	the file is part of the approved converted set

If any of those are false:
	•	leave it unchanged
	•	report it in the final summary

Special case:
	•	assets/images/backgrounds/Loading.png must remain .png in this phase

⸻

IMPLEMENTATION SCOPE

Inspect and safely update places such as:
	•	Image.asset(...)
	•	AssetImage(...)
	•	ExactAssetImage(...)
	•	DecorationImage(...)
	•	custom asset resolver/helper classes
	•	centralized asset constants
	•	provider/viewmodel/config files that store real runtime asset paths
	•	widget tests only if they use the real runtime assets and replacement is clearly safe

Be especially careful around:
	•	startup/loading backgrounds
	•	home and learn backgrounds
	•	Wudu instructional asset references
	•	prophet artwork/card resolvers
	•	centralized image helper/resolver logic

Do NOT touch:
	•	comments
	•	docs
	•	old archived prompts
	•	non-runtime examples
	•	native platform resource references

⸻

PUBSPEC HANDLING

Inspect pubspec.yaml carefully.

Rules:
	1.	If assets are directory-declared, do not make unnecessary changes.
	2.	If any individual PNG files from the approved converted set are explicitly listed, update them only where the .webp exists and the app should now use it.
	3.	Leave Loading.png declarations untouched if applicable.

Keep pubspec changes minimal.

⸻

VALIDATION

After edits:
	1.	Re-scan the repo for .png references in the three target folders
	2.	Confirm that:
	•	converted assets now point to .webp where safe
	•	Loading.png still points to .png
	•	no unrelated .png references were changed
	3.	Run analyzer on changed files
	4.	If pubspec.yaml changed, run flutter pub get
	5.	Summarize:
	•	total references found
	•	total safely replaced
	•	total intentionally left unchanged
	•	total blocked because reference was non-runtime or ambiguous

If practical, also do a lightweight runtime consistency check for changed paths.

⸻

PATH OF NŪR APP-SPECIFIC EXPECTATIONS

Be especially careful with:
	•	background image helpers and page shells
	•	prophet image resolver logic
	•	Wudu page cards and instructional flows
	•	any startup or spiritual page artwork
	•	anything tied to top-level navigation surfaces

Preserve architecture, routing, localization, and current UI behavior.
Do not redesign anything.

⸻

IMPORTANT NON-GOALS

Do NOT do these yet:
	•	do not delete PNGs
	•	do not migrate Loading.png
	•	do not tighten CI allowlists
	•	do not rerun the full repo cleanup
	•	do not fix unrelated asset-integrity debt such as missing kids_stories / quran_teacher assets unless a tiny related fix is absolutely necessary

⸻

DELIVERABLES

At the end, provide a concise summary with:
	1.	Files changed
	2.	Total runtime .png references found in scope
	3.	Total safely replaced with .webp
	4.	Total intentionally left unchanged
	5.	Whether Loading.png remained untouched
	6.	Whether pubspec.yaml changed
	7.	Analyzer / validation results
	8.	Any remaining follow-up items

⸻

NEXT PHASE — DO NOT IMPLEMENT YET

After this is complete:
	•	Phase 8: tighten the runtime PNG allowlist now that migrated references exist
	•	Phase 9: rerun the full WebP migration audit for real repo-wide savings
	•	Phase 10: delete verified legacy PNGs only after references are fully migrated and validated

⸻

FINAL REQUIREMENT

At the very end, provide one full clean summary:
	•	what references were migrated
	•	what remained on PNG intentionally
	•	whether any ambiguities remain
	•	what the next safest step is

Do not go haywire.
Do not delete records/files for no reason.
Prefer safe verified reference migration over aggressive replacement.

===== END =====
:::

Clean status now

You’ve moved from prepared-but-not-migrated to partially migrated with measurable savings.

That is real progress. The next audit after Phase 7 should finally show the app actually using much more of the WebP savings.

