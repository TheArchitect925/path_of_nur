“Indeed, Allah loves those who act with excellence.” — Qur’an 2:195

Yes — that is the right next move.

Do a focused pre-conversion readiness pass first, so Codex can:
	•	classify the heaviest folders,
	•	decide lossless vs lossy safely,
	•	detect existing sibling WebPs,
	•	and produce the exact conversion sequence without touching runtime references yet.

Here’s the Codex prompt:

:::writing{variant=“standard” id=“31847”}
===== PHASE 6A — PRE-CONVERSION READINESS AUDIT — HIGH-IMPACT PNG → WEBP PLAN =====

PRIMARY OBJECTIVE === PERFORM A SAFE, DETAILED PRE-CONVERSION READINESS PASS FOR THE HEAVIEST RUNTIME PNG FOLDERS SO WE KNOW EXACTLY WHAT TO CONVERT, HOW TO CONVERT IT, AND IN WHAT ORDER

Context:
You are working inside the existing Flutter repo for “Path of Nūr”.

The previous audit confirmed:
	•	the runtime PNG → WebP migration has not actually happened yet in the source asset tree
	•	the current size savings are therefore unrealized
	•	the highest-impact runtime PNG folders are:

	1.	assets/images/prophets
	2.	assets/images/backgrounds
	3.	assets/images/wudu

This phase is a readiness and planning pass only.
Do not go haywire.
Do not mass-convert yet unless a tiny harmless validation sample is explicitly needed.
Do not delete files.
Do not update runtime references in this phase.

⸻

PRIMARY GOALS
	1.	Audit the three highest-impact runtime PNG folders in detail.
	2.	Build a conversion-ready inventory of all PNG files in those folders and subfolders.
	3.	Classify files by likely best conversion mode:
	•	lossless WebP
	•	lossy WebP
	•	manual review
	4.	Detect any existing sibling .webp files.
	5.	Detect any filename/path issues that would block clean conversion.
	6.	Detect any obviously risky assets such as:
	•	text baked into image
	•	line-art-like illustrations
	•	icon-like sharp graphics
	•	tiny assets where lossy compression would look bad
	7.	Produce an exact recommended conversion sequence and command strategy.
	8.	Keep the output production-ready and reviewable.

⸻

🚨 CRITICAL SAFETY RULES
	1.	AUDIT FIRST.
	2.	DO NOT bulk-convert in this phase.
	3.	DO NOT delete original PNGs.
	4.	DO NOT update Dart/code references.
	5.	DO NOT modify unrelated folders.
	6.	DO NOT touch native/platform PNG assets.
	7.	DO NOT assume one quality setting fits all images.
	8.	Prefer conservative classification over aggressive guessing.
	9.	If uncertain, classify as manual review.
	10.	At the very end, provide one clean summary I can review in one place.

⸻

TARGET SCOPE

Only audit these runtime folders recursively:
	•	assets/images/prophets
	•	assets/images/backgrounds
	•	assets/images/wudu

Do not expand scope beyond these folders in this phase.

⸻

REQUIRED AUDIT TASKS

1. Folder inventory

For each target folder, report:
	•	total .png files
	•	total existing .webp files
	•	total bytes occupied by PNGs
	•	total bytes occupied by existing WebPs
	•	subfolder breakdown
	•	largest files first

2. Per-file inventory

Build an inventory for every PNG in scope including:
	•	relative path
	•	file size
	•	dimensions if easily available
	•	existing sibling .webp present or not
	•	likely asset type
	•	recommended conversion mode:
	•	LOSSLESS
	•	LOSSY_Q85
	•	MANUAL_REVIEW
	•	rationale for classification

3. Classification guidance

Use practical heuristics such as:

Prefer LOSSLESS for:
	•	sharp-edged illustrations
	•	flat-color assets
	•	images containing text
	•	card-style artwork with clean edges
	•	smaller graphics where blur would be obvious
	•	assets that appear icon-like or poster-like

Prefer LOSSY_Q85 for:
	•	large scenic backgrounds
	•	textured full-frame artwork
	•	photographic or painterly imagery
	•	larger illustration-heavy assets where slight compression is acceptable

Use MANUAL_REVIEW for:
	•	ambiguous edge cases
	•	images where visual role is unclear
	•	assets that might contain important small text/details
	•	files already suspiciously optimized or unusual

Keep classification deterministic and explainable.

4. Existing WebP conflict audit

Detect:
	•	PNG files that already have sibling WebPs
	•	cases where existing WebP naming/path does not match cleanly
	•	cases where path casing or naming inconsistencies could break future migration
	•	duplicates that should be noted before conversion

5. Conversion wave planning

Create a recommended rollout order, for example:
	•	Wave 1: backgrounds
	•	Wave 2: wudu
	•	Wave 3: prophets

Or another order if the audit shows a better safer sequence.

For each wave, report:
	•	file count
	•	estimated total PNG size
	•	expected best conversion mode mix
	•	why this wave order makes sense

6. Command plan

Produce a safe recommended command strategy using cwebp, including:
	•	lossless command pattern
	•	lossy command pattern
	•	output naming/path convention
	•	skip-if-exists behavior
	•	dry-run suggestion
	•	logging expectations

Do not actually perform the bulk conversion unless a tiny sample is explicitly needed for validation.

7. Optional tiny validation sample

Only if useful and safe:
	•	choose up to 1–2 representative files per major folder type
	•	generate sample WebPs in a reversible and clearly labeled way
	•	compare sizes
	•	note whether the classification seems sound

This is optional and should remain tiny, not a stealth conversion phase.

⸻

OUTPUT / REPORT FORMAT

Provide:

A. Executive summary
	•	readiness status: READY / READY_WITH_NOTES / BLOCKED
	•	total PNGs in scope
	•	total bytes in scope
	•	existing WebPs already present
	•	key blockers or none

B. Folder breakdown

For each target folder:
	•	PNG count
	•	total PNG size
	•	existing WebP count
	•	recommended mode distribution
	•	notable risks

C. Per-file or grouped inventory

Prefer a structured table or CSV-friendly format with:
	•	path
	•	size
	•	sibling WebP exists
	•	recommended mode
	•	notes

D. Wave plan
	•	exact recommended conversion order
	•	why
	•	what should be lossless vs lossy in each wave

E. Safe command plan
	•	exact command patterns Codex recommends using next
	•	dry run first
	•	no delete behavior
	•	no reference migration yet

F. Risks / blockers

Examples:
	•	weird naming/path mismatches
	•	already-present WebPs with inconsistent names
	•	files needing manual visual review
	•	folders that should stay out of the first pass

⸻

IMPLEMENTATION APPROACH

You may create a small reusable audit helper script if helpful, for example:
	•	tooling/scripts/audit_high_impact_webp_readiness.sh

If you create a script:
	•	keep it production-ready
	•	keep it deterministic
	•	do not let it modify assets by default
	•	make it safe to rerun

If no script is needed, targeted audit output is acceptable.

⸻

NON-GOALS

Do NOT:
	•	bulk-convert all files in this phase
	•	update code references
	•	delete PNGs
	•	tighten CI allowlists yet
	•	mix in unrelated asset-integrity debt from kids_stories or quran_teacher

Those come later.

⸻

DELIVERABLES

At the end provide:
	1.	Files changed, if any
	2.	Whether a readiness script was created
	3.	Total PNG count in scope
	4.	Total PNG size in scope
	5.	Existing sibling WebP count
	6.	Folder-by-folder breakdown
	7.	Recommended conversion mode split
	8.	Recommended wave order
	9.	Exact next-step command strategy
	10.	Any blockers or manual-review files

⸻

FINAL REQUIREMENT

At the very end, do one clean summary I can review in one place:
	•	what is ready
	•	what should be converted first
	•	what should be lossless vs lossy
	•	what should wait for manual review
	•	the safest exact next step

Do not go haywire.
Do not delete records/files for no reason.
Prefer a clean production-ready readiness plan over premature bulk conversion.

===== END =====
:::

After this, the next prompt should be the actual execution pass using the exact wave plan Codex finds.

