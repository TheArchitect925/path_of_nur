# Prompt

“Indeed, Allah loves those who act with excellence.” — Qur’an 2:195

Here’s the Phase 4 Codex prompt for CI guardrails so runtime PNGs do not quietly creep back in.

:::writing{variant=“standard” id=“41756”}
===== PHASE 4 — ASSET POLICY ENFORCEMENT — CI GUARDRAILS FOR PNG RUNTIME ASSETS =====

PRIMARY OBJECTIVE === ADD SAFE, PRODUCTION-READY GUARDRAILS SO NEW RUNTIME .png ASSETS DO NOT QUIETLY GET INTRODUCED INTO THE FLUTTER APP WITHOUT INTENTIONAL REVIEW

Context:
You are working inside the existing Flutter repo for “Path of Nūr”.

Previous phases handled:
	•	Phase 1: PNG → WebP conversion
	•	Phase 2: runtime reference migration
	•	Phase 3: verified cleanup of legacy PNGs where safe

Now implement Phase 4:
	•	add repo-level asset policy enforcement
	•	protect the app from drifting back into mixed asset usage
	•	allow platform-required PNGs to remain where they are truly needed
	•	make the policy reviewable, deterministic, and CI-friendly

This phase is about guardrails, not mass refactoring.

⸻

PRIMARY POLICY

Default policy:
	•	Flutter runtime imagery under app asset folders should prefer .webp
	•	.png remains allowed only for explicitly approved cases, such as:
	•	iOS native app icons / asset catalogs
	•	Android launcher / notification / native drawable resources
	•	web favicons / manifest icons where needed
	•	clearly approved exceptions
	•	temporary manual-review exceptions listed in an allowlist

Goal:
	•	fail CI when a new disallowed runtime .png asset is introduced
	•	do not fail for approved native/platform PNGs
	•	do not create noisy false positives

⸻

🚨 CRITICAL SAFETY RULES
	1.	DO NOT break existing builds unnecessarily.
	2.	DO NOT flag native/platform PNGs that are intentionally required.
	3.	DO NOT enforce policy with a brittle naive grep alone if a more reliable check is easy to implement.
	4.	DO NOT rewrite assets in this phase.
	5.	DO NOT delete files in this phase.
	6.	DO NOT block the team on historical exceptions without a reviewable allowlist path.
	7.	Audit first before implementing.
	8.	Keep the solution deterministic and easy to maintain.
	9.	Keep the output human-readable.
	10.	At the very end, audit the entire implementation and provide one clean summary.

⸻

AUDIT FIRST — MANDATORY

Before editing:
	1.	Audit current remaining .png files in the repo.
	2.	Categorize them:
	•	approved native/platform PNGs
	•	approved temporary exceptions
	•	disallowed runtime asset candidates
	3.	Audit current CI/tooling structure in the repo:
	•	GitHub Actions
	•	custom scripts
	•	lint/test jobs
	•	pre-commit hooks if present
	4.	Determine the cleanest enforcement point:
	•	standalone repo script
	•	CI step in existing workflow
	•	both

Output a concise audit summary before changes.

⸻

IMPLEMENTATION REQUIREMENTS

Implement a policy enforcement system with these parts:

A. Policy check script

Create a small, production-ready script, for example:
	•	/tooling/scripts/check_runtime_png_policy.sh
or equivalent in Dart/Python if that fits the repo better

The script should:
	1.	scan relevant repo paths
	2.	detect .png files in Flutter runtime asset areas
	3.	ignore approved native/platform locations
	4.	ignore approved allowlisted exceptions
	5.	fail with a clear non-zero exit code if disallowed PNGs are found
	6.	print a clean report

Preferred output categories:
	•	[APPROVED_NATIVE]
	•	[APPROVED_EXCEPTION]
	•	[VIOLATION]
	•	[INFO]

⸻

B. Allowlist / policy config

Add a small configuration source so exceptions are explicit and reviewable.

Examples:
	•	/tooling/config/runtime_png_allowlist.txt
	•	/tooling/config/asset_policy.yaml

This should support:
	•	explicit file paths
	•	optional path prefixes if truly needed
	•	comments explaining why an exception exists

Rules:
	•	keep the allowlist small
	•	do not use it as a dumping ground
	•	document each exception clearly

⸻

C. CI integration

Integrate the policy script into existing CI.

Examples:
	•	GitHub Actions workflow
	•	existing validation script pipeline

Behavior:
	•	run the asset policy check during CI
	•	fail the workflow if disallowed runtime PNGs are introduced
	•	keep log output readable and concise

If the repo already has a lint/validate workflow, add this there instead of creating unnecessary duplication.

⸻

D. Developer ergonomics

Optionally add:
	•	a local convenience command or script alias
	•	brief documentation so future contributors know the rule

Do not overbuild. Keep it simple.

⸻

SCOPE OF DETECTION

The check should primarily protect:
	•	Flutter runtime assets under /assets and equivalent app asset folders
	•	asset paths used by app UI/runtime

The check should NOT flag:
	•	ios/Runner/Assets.xcassets/...
	•	android/app/src/main/res/...
	•	web/native packaging icons that intentionally remain PNG
	•	docs, screenshots, design references, exported mockups, prompt files
	•	non-runtime artifacts unless policy explicitly says otherwise

Be path-aware.

⸻

RECOMMENDED DECISION MODEL

For each .png found:
	1.	Is it inside a platform-native folder that is allowed?
	•	yes → approved native
	2.	Is it in the explicit allowlist?
	•	yes → approved exception
	3.	Is it a Flutter runtime asset path?
	•	yes → violation
	4.	Otherwise:
	•	report informationally or ignore based on repo context

Keep the logic understandable.

⸻

OPTIONAL ENHANCEMENT — ONLY IF EASY

If easy and low-risk, also check for runtime asset string references ending in .png in Dart/source files and report them.

But:
	•	do not make this brittle
	•	do not block the build on low-confidence matches unless clearly safe

File-based asset policy is the priority.

⸻

DOCUMENTATION

Add a short policy document, for example:
	•	/docs/asset-policy.md

Keep it concise. Include:
	•	runtime app assets should prefer WebP
	•	native/platform assets may remain PNG where required
	•	how exceptions are allowlisted
	•	how to run the check locally
	•	what CI enforces

Do not write a giant document.

⸻

VALIDATION

After implementation:
	1.	Run the policy script locally
	2.	Confirm it passes for the current repo state
	3.	Confirm it would fail if a test violation is introduced
	•	simulate safely if needed, without leaving junk behind
	4.	Confirm CI wiring is correct
	5.	Confirm no existing native-required PNGs are incorrectly flagged
	6.	Confirm allowlisted exceptions are reported clearly

⸻

PATH OF NŪR APP-SPECIFIC EXPECTATIONS

Be especially mindful of:
	•	app runtime imagery under /assets
	•	prayer visuals
	•	Quran artwork
	•	kids assets
	•	loading/home backgrounds
	•	halo/icon visuals
	•	native mobile app icons and platform resource folders

Protect the app without blocking valid platform packaging needs.

⸻

CLEANUP QUALITY BAR

This must be:
	•	safe
	•	conservative
	•	production-ready
	•	easy to review
	•	easy to maintain

Do not create a fragile rule that becomes annoying noise.

⸻

DELIVERABLES

After implementation, provide a concise summary with:
	1.	Files changed
	2.	Policy script created
	3.	Allowlist/config created
	4.	CI workflow changes
	5.	Documentation added or not
	6.	Current repo result:
	•	approved native PNGs
	•	approved exceptions
	•	violations found or none
	7.	Validation result
	8.	Any follow-up suggestions

⸻

FUTURE PHASE — DO NOT IMPLEMENT YET

Possible future phase:
	•	add a helper command to auto-suggest WebP conversion for violations
	•	add a repo asset dashboard/report
	•	optionally extend policy to large JPG/JPEG optimization checks

⸻

FINAL REQUIREMENT

At the very end, do one full audit summary so I can review in one place:
	•	what guardrails were added
	•	what paths are exempt
	•	how CI now behaves
	•	what current exceptions remain
	•	any risks or maintenance notes

Do not go haywire.
Do not remove/delete records/files for no reason.
Prefer safe, explicit, production-ready enforcement over clever but fragile automation.

===== END =====
:::

After this, the best next move is a single master Codex prompt that chains all four phases into one repo audit and final cleanup summary.
