“Indeed, Allah is with the patient.” — Qur’an 2:153

Perfect. This is now clear and actionable.

What this means

You are ready to execute, but with 3 notes:
	•	cwebp must be installed first
	•	assets/images/backgrounds/Loading.png should stay out of the first bulk lossy pass
	•	Adam’s prophet asset naming mismatch should be acknowledged, but it does not block conversion

Best next move

Run the actual execution phase in 3 waves:
	1.	backgrounds → lossy q=85, excluding Loading.png
	2.	wudu → lossless
	3.	prophets → lossless

That is the safest and smartest order.

Codex prompt for execution

:::writing{variant=“standard” id=“64218”}
===== PHASE 6B — EXECUTE HIGH-IMPACT PNG → WEBP CONVERSION — BACKGROUNDS, WUDU, PROPHETS =====

PRIMARY OBJECTIVE === EXECUTE THE REAL ON-DISK PNG → WEBP CONVERSION FOR THE HIGH-IMPACT RUNTIME FOLDERS USING THE APPROVED READINESS PLAN, SAFELY, RECURSIVELY, AND WITHOUT TOUCHING RUNTIME REFERENCES YET

Context:
You are working inside the existing Flutter repo for “Path of Nūr”.

The readiness audit is complete and the status is:

READY_WITH_NOTES

Readiness findings:
	•	total PNGs in scope: 54
	•	total PNG bytes in scope: 138,416,422
	•	existing WebPs already in scope: 9
	•	verified sibling WebP matches for target PNGs: 0

Target folders:
	•	assets/images/backgrounds
	•	assets/images/wudu
	•	assets/images/prophets

Approved conversion mode split:
	•	backgrounds: 14 files → LOSSY_Q85
	•	backgrounds/Loading.png → MANUAL_REVIEW, exclude from this bulk pass
	•	wudu: 14 files → LOSSLESS
	•	prophets: 25 files → LOSSLESS

Important notes:
	•	cwebp is not currently installed in the environment, so install/validate it first
	•	Adam has a naming mismatch:
	•	PNG: assets/images/prophets/1. AdamAS.png
	•	existing related WebP: assets/images/prophets/1_prophet_adam_card.webp
This does not block generating a proper sibling WebP for the PNG in this phase
	•	No runtime code references should be changed in this phase
	•	No PNGs should be deleted in this phase

This phase is the real conversion pass.
Do not go haywire.
Do not pretend conversion happened unless the .webp files are truly generated on disk.

⸻

PRIMARY GOALS
	1.	Generate real sibling .webp files next to the PNGs in the three approved target folders
	2.	Preserve folder structure and base filenames
	3.	Exclude assets/images/backgrounds/Loading.png from the bulk lossy pass
	4.	Keep original .png files untouched
	5.	Make the conversion safe, reviewable, and idempotent
	6.	Produce exact measurable size results for the converted files
	7.	Leave runtime references unchanged for the next phase

⸻

🚨 CRITICAL SAFETY RULES
	1.	Validate cwebp availability before starting conversion
	2.	If cwebp is missing, install it or document the exact blocker clearly before proceeding
	3.	DO NOT delete PNGs
	4.	DO NOT overwrite existing WebPs unless explicitly enabled and verified safe
	5.	DO NOT modify code references in Dart, YAML, or config in this phase
	6.	DO NOT touch native/platform PNG assets
	7.	DO NOT process folders outside the approved scope
	8.	DO NOT include backgrounds/Loading.png in the bulk lossy pass
	9.	Log every conversion decision clearly
	10.	At the end, provide one clean summary with exact numbers

⸻

STEP 1 — TOOL VALIDATION

Before conversion:
	1.	Verify cwebp is installed and callable
	2.	If not installed, install it using the safest appropriate package method for the environment
	3.	Log the detected version

Do not continue until the encoder is actually available.

⸻

STEP 2 — CREATE OR UPDATE THE EXECUTION SCRIPT

Use or update a reusable script, preferably:
	•	tooling/scripts/convert_high_impact_pngs_to_webp.sh

If a generic script already exists, you may reuse it, but ensure this phase remains tightly scoped to the approved folders and rules.

The script must support:
	•	DRY_RUN=true|false
	•	OVERWRITE_EXISTING=false
	•	DELETE_ORIGINAL=false hard default
	•	clear per-wave logging
	•	skip-if-sibling-exists behavior

⸻

STEP 3 — WAVE EXECUTION PLAN

Wave 1 — Backgrounds

Folder:
	•	assets/images/backgrounds

Rules:
	•	process recursively
	•	exclude assets/images/backgrounds/Loading.png
	•	convert remaining approved PNGs with lossy WebP quality 85

Recommended command pattern:
	•	cwebp -q 85 -m 6 -af "input.png" -o "output.webp"

Wave 2 — Wudu

Folder:
	•	assets/images/wudu

Rules:
	•	process recursively
	•	convert all approved PNGs with lossless WebP

Recommended command pattern:
	•	cwebp -lossless -z 9 "input.png" -o "output.webp"

Wave 3 — Prophets

Folder:
	•	assets/images/prophets

Rules:
	•	process recursively
	•	convert all approved PNGs with lossless WebP
	•	generate proper sibling WebPs for the PNGs even if unrelated non-sibling WebPs already exist
	•	do not let the Adam naming mismatch block normal sibling generation

Recommended command pattern:
	•	cwebp -lossless -z 9 "input.png" -o "output.webp"

⸻

STEP 4 — SKIP / SAFETY BEHAVIOR

For each PNG:
	1.	compute sibling WebP path
	2.	if sibling WebP already exists and overwrite is disabled:
	•	log [SKIP_EXISTING]
	•	do not regenerate
	3.	otherwise:
	•	run the appropriate conversion mode
	•	log original size, new size, bytes delta, and mode used

Keep behavior deterministic and rerunnable.

⸻

STEP 5 — LOGGING

Use categories such as:
	•	[PRECHECK]
	•	[INSTALL]
	•	[WAVE_BACKGROUND]
	•	[WAVE_WUDU]
	•	[WAVE_PROPHETS]
	•	[SKIP_EXISTING]
	•	[CONVERT_LOSSY]
	•	[CONVERT_LOSSLESS]
	•	[EXCLUDE_MANUAL_REVIEW]
	•	[ERROR]
	•	[SUMMARY]

For each converted file, log:
	•	source path
	•	destination path
	•	mode
	•	original bytes
	•	new bytes
	•	bytes saved or increased

⸻

STEP 6 — VALIDATION

After conversion:
	1.	confirm .webp files exist on disk for the converted PNGs
	2.	confirm original PNGs still exist
	3.	confirm Loading.png was excluded
	4.	summarize:
	•	total PNGs scanned in scope
	•	total files converted
	•	total skipped due to existing sibling WebP
	•	total manually excluded
	•	total failures
	5.	calculate exact size results for the files converted in this phase:
	•	original PNG total bytes
	•	new WebP total bytes
	•	bytes saved
	•	MB saved
	•	percentage saved
	6.	report:
	•	top 20 largest savings
	•	any files where WebP became larger
	7.	spot-check output validity for a few representative files in each wave

⸻

IMPORTANT NON-GOALS

Do NOT do these in this phase:
	•	do not replace runtime asset references
	•	do not delete PNGs
	•	do not tighten the CI allowlist
	•	do not audit unrelated missing asset debt in kids_stories or quran_teacher
	•	do not broaden conversion beyond the approved folders

⸻

PATH OF NŪR APP-SPECIFIC EXPECTATIONS

Be especially careful with:
	•	scenic backgrounds and wallpapers
	•	Wudu instructional illustrations
	•	Prophet artwork and poster-like cards

Preserve quality.
If any output looks obviously degraded, report it clearly and keep the file for manual review rather than hiding the issue.

⸻

DELIVERABLES

At the end, provide a concise summary with:
	1.	Files changed
	2.	Whether cwebp was installed or already present
	3.	Script created or updated
	4.	Total PNGs scanned in scope
	5.	Total WebPs created
	6.	Total skipped due to existing sibling WebP
	7.	Total manually excluded
	8.	Total failures
	9.	Exact size savings for this phase
	10.	Savings by wave
	11.	Top individual file savings
	12.	Any files where WebP became larger
	13.	Any manual quality-review flags
	14.	Recommended next phase

⸻

NEXT PHASE — DO NOT IMPLEMENT YET

After this is complete:
	•	Phase 7: migrate runtime references only for verified sibling WebPs that now exist
	•	Phase 8: tighten runtime PNG allowlist
	•	Phase 9: rerun the full migration audit for real measurable repo-wide savings
	•	Phase 10: delete verified legacy PNGs only after references are fully migrated

⸻

FINAL REQUIREMENT

At the very end, provide one clean final summary:
	•	what actually got converted
	•	what was excluded
	•	exact savings achieved
	•	any quality issues found
	•	what remains for the next safe step

Do not go haywire.
Do not delete records/files for no reason.
Prefer real on-disk conversion and exact measurable results over assumptions.

===== END =====
:::

Tiny extra recommendation

Have Codex do a dry run first, then the real run, even in this phase. That keeps the first execution safe.

