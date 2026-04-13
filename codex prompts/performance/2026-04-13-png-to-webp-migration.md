# Prompt

Here’s your production-ready Codex prompt — structured exactly how you like (safe, recursive, no accidental deletions, repo-aware).

⸻

:::writing{variant=“standard” id=“48291”}
===== PHASE 1 — ASSET OPTIMIZATION — PNG → WEBP MIGRATION =====

PRIMARY OBJECTIVE === CONVERT ALL PNG IMAGES TO WEBP (RECURSIVE, SAFE, PRODUCTION-READY)

Context:
You are working inside the existing Flutter repo for “Path of Nūr”.

We need to:
	•	Traverse the /assets directory
	•	Include ALL subfolders
	•	Convert every .png file → .webp
	•	Preserve structure and naming
	•	DO NOT break asset references
	•	DO NOT delete anything without explicit safety checks

⸻

🚨 CRITICAL RULES (DO NOT VIOLATE)
	1.	DO NOT delete original PNGs unless explicitly enabled via a flag.
	2.	DO NOT overwrite existing files without validation.
	3.	DO NOT change folder structure.
	4.	DO NOT modify pubspec.yaml automatically (only suggest changes).
	5.	Ensure script is idempotent (safe to run multiple times).
	6.	Log all operations clearly.

⸻

🧠 AUDIT FIRST (MANDATORY)
	•	Scan /assets folder structure
	•	Count:
	•	total PNG files
	•	existing WEBP files
	•	Identify:
	•	duplicate assets
	•	already converted files
	•	Output audit summary BEFORE making changes

⸻

🛠 IMPLEMENTATION

Create a script:

Location:
/tooling/scripts/convert_png_to_webp.sh

⸻

SCRIPT REQUIREMENTS
	•	Recursive traversal of /assets
	•	Convert .png → .webp using cwebp
	•	Maintain same relative path
	•	Skip if .webp already exists
	•	Configurable quality

Use:
	•	lossless for icons/UI
	•	lossy (quality ~85) for large images

Reference:
cwebp -q 80 input.png -o output.webp

⸻

🧾 SCRIPT IMPLEMENTATION (EXPECTED LOGIC)
	•	Traverse:
use find or equivalent recursive traversal
	•	For each .png:
	1.	Generate output path .webp
	2.	If exists → skip
	3.	Detect file type (simple heuristic):
	•	small files (<200KB) → lossless
	•	large files → lossy
	4.	Convert using cwebp
	•	Example conversion:
cwebp -q 85 input.png -o output.webp

⸻

🔒 SAFETY MODE

Add flags:
	•	DRY_RUN=true → only logs actions
	•	DELETE_ORIGINAL=false → never delete PNGs by default

⸻

🧪 VALIDATION

After script runs:
	1.	Confirm all PNGs have corresponding WEBP
	2.	Confirm folder structure unchanged
	3.	Confirm no files overwritten incorrectly
	4.	Print:
	•	total converted
	•	skipped
	•	failed

⸻

📦 OPTIONAL (DO NOT AUTO APPLY)

Suggest (DO NOT EXECUTE):
	•	updating pubspec.yaml to prefer .webp
	•	replacing image references in codebase

⸻

🧹 CLEANUP (SAFE)
	•	Ensure script is reusable
	•	Add clear logging:
	•	[SKIP]
	•	[CONVERT]
	•	[ERROR]

⸻

📤 DELIVERABLES
	1.	Script file created
	2.	Audit summary
	3.	Conversion summary
	4.	Notes on:
	•	any failures
	•	any duplicate assets
	•	recommended next steps

⸻

🔮 FUTURE PHASE (DO NOT IMPLEMENT YET)
	•	Auto-replace PNG references in Flutter code
	•	Remove PNGs after verification
	•	Integrate into CI/CD

⸻

END OF PROMPT
:::

⸻

🔥 What this gives you (important)
	•	Safe (no accidental deletes — many scripts online WILL delete originals ⚠️)
	•	Recursive (covers all subfolders)
	•	Production-ready (logging + audit + dry run)
	•	Matches your Codex workflow style
