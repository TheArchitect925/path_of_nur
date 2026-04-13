“Indeed, Allah commands justice, excellence, and generosity…” — Qur’an 16:90

Here’s the Phase 8 Codex prompt to tighten the runtime PNG allowlist now that the high-impact assets are actually converted and live.

:::writing{variant=“standard” id=“28461”}
===== PHASE 8 — TIGHTEN RUNTIME PNG ALLOWLIST — REMOVE HIGH-IMPACT MIGRATED FOLDER EXEMPTIONS =====

PRIMARY OBJECTIVE === TIGHTEN THE RUNTIME PNG POLICY / ALLOWLIST SO THE RECENTLY MIGRATED HIGH-IMPACT RUNTIME ASSETS ARE NO LONGER BROADLY EXEMPT, WHILE KEEPING ONLY THE TRUE INTENTIONAL PNG EXCEPTIONS

Context:
You are working inside the existing Flutter repo for “Path of Nūr”.

Completed work so far:
	•	real sibling .webp files were generated for the high-impact runtime folders
	•	verified live runtime references were migrated to .webp in the active owners
	•	analyzer passed on the changed runtime files

Converted / migrated scope:
	•	assets/images/backgrounds (except Loading.png, intentionally kept on PNG for now)
	•	assets/images/wudu
	•	assets/images/prophets

Current issue:
	•	CI / policy still passes partly because runtime PNG areas remain broadly allowlisted
	•	that broad allowlist now hides real progress and weakens the guardrail
	•	we now need to tighten the allowlist so only true intentional PNG exceptions remain

This phase is a policy-tightening phase.
Do not go haywire.
Do not delete files.
Do not convert new assets.
Do not change runtime code references except for tiny policy-related corrections if absolutely necessary.

⸻

PRIMARY GOALS
	1.	Audit the current runtime PNG allowlist / policy configuration.
	2.	Identify the broad exemptions currently covering:
	•	assets/images/backgrounds
	•	assets/images/wudu
	•	assets/images/prophets
	3.	Remove or narrow those exemptions now that the converted assets exist and the live runtime references were migrated.
	4.	Preserve only the true intentional PNG exceptions, especially:
	•	assets/images/backgrounds/Loading.png
	•	any other genuinely required runtime PNG holdouts if they still exist and are actually needed
	5.	Keep native/platform PNG exemptions intact.
	6.	Ensure CI/policy still passes for the correct reasons after tightening.
	7.	Produce a clean post-tightening audit summary.

⸻

🚨 CRITICAL SAFETY RULES
	1.	AUDIT FIRST before editing.
	2.	DO NOT remove native/platform PNG exemptions that are still legitimately required.
	3.	DO NOT leave broad runtime folder exemptions in place if they are no longer justified.
	4.	DO NOT add new broad exemptions as a shortcut.
	5.	DO NOT delete any PNG files in this phase.
	6.	DO NOT change runtime Dart/code references except for a tiny verified policy-related fix if absolutely necessary.
	7.	DO NOT touch unrelated folders outside the policy scope unless clearly needed.
	8.	If uncertainty exists, keep the smaller explicit exception and report it.
	9.	Keep the policy deterministic, reviewable, and easy to maintain.
	10.	At the end, provide one clean summary of exactly what changed and why.

⸻

AUDIT FIRST — MANDATORY

Before editing:
	1.	Locate the current runtime PNG policy implementation and allowlist/config.
Examples may include:
	•	policy shell script
	•	allowlist text file
	•	YAML config
	•	CI workflow wiring
	2.	Audit the current exemptions and classify them as:
	•	broad runtime exemption
	•	explicit file exception
	•	native/platform exemption
	•	legacy temporary exception
	3.	Specifically determine:
	•	which current allowlist entries are still covering backgrounds, wudu, and prophets
	•	whether those entries are path-prefix exemptions, folder-level exemptions, or explicit file entries
	•	which exemptions can now be removed safely
	4.	Run the current policy check before any edits and record the baseline result.

Output a concise audit summary before changing anything.

⸻

REQUIRED POLICY TIGHTENING

A. Remove or narrow broad runtime exemptions

Tighten the policy so that migrated high-impact runtime folders are no longer broadly allowlisted.

Priority targets:
	•	assets/images/wudu
	•	assets/images/prophets
	•	assets/images/backgrounds

Expected result:
	•	these should no longer pass merely because entire folders are exempted

B. Keep only true explicit runtime PNG exceptions

Retain explicit runtime PNG exceptions only where still justified.

Known intentional runtime holdout:
	•	assets/images/backgrounds/Loading.png

If any other explicit runtime PNG exceptions remain after audit:
	•	keep them only if clearly justified
	•	document why
	•	prefer exact file-path exceptions over folder-level prefixes

C. Preserve native/platform exemptions

Do NOT disturb valid exemptions for:
	•	ios/Runner/Assets.xcassets/...
	•	android/app/src/main/res/...
	•	web/native packaging icons
	•	other platform-required PNG locations already approved by policy

⸻

POLICY QUALITY BAR

The final allowlist/config should be:
	•	narrower than before
	•	explicit
	•	easy to read
	•	easy to review in PRs
	•	resistant to future PNG drift

Preferred pattern:
	•	explicit single-file exceptions
	•	very limited path-prefix exceptions only where absolutely unavoidable

Avoid:
	•	giant catch-all folder exemptions
	•	vague comments
	•	policy clutter that hides real violations

⸻

VALIDATION AFTER TIGHTENING

After editing the policy / allowlist:
	1.	Run the runtime PNG policy check.
	2.	Confirm the check passes.
	3.	Confirm it passes for the right reasons:
	•	migrated WebP-backed folders are no longer broadly exempt
	•	Loading.png remains allowed explicitly if needed
	•	native/platform PNGs remain approved
	4.	Confirm no new violations appear for the just-migrated high-impact runtime references.
	5.	If the policy fails, fix the smallest correct thing rather than re-broadening exemptions.

If practical, also verify:
	•	the policy would now fail if a new runtime PNG were added under the migrated folders without being allowlisted

⸻

IMPLEMENTATION SCOPE

Potential files to inspect/update:
	•	runtime PNG policy script
	•	allowlist/config file
	•	CI workflow if needed for readability or clarity
	•	small docs note only if it materially improves maintainability

Do not add unnecessary files.
Do not overbuild the solution.

⸻

IMPORTANT NON-GOALS

Do NOT do these yet:
	•	do not delete legacy PNGs
	•	do not rerun the full repo cleanup
	•	do not convert more folders
	•	do not change Loading.png
	•	do not fix unrelated missing asset debt in kids_stories or quran_teacher
	•	do not loosen CI just to get green

Those come later.

⸻

PATH OF NŪR APP-SPECIFIC EXPECTATIONS

Be especially careful that:
	•	backgrounds, Wudu, and Prophet runtime assets are no longer protected by broad temporary policy shields
	•	Loading.png remains the only intentional high-impact runtime PNG holdout unless the audit proves another true exception
	•	policy readability stays high for future asset work

Preserve the spirit of the migration:
	•	WebP for runtime assets where migrated
	•	PNG only where intentionally retained

⸻

DELIVERABLES

At the end, provide a concise summary with:
	1.	Files changed
	2.	Which broad exemptions were removed or narrowed
	3.	Which explicit runtime PNG exceptions remain
	4.	Whether Loading.png remains explicitly allowlisted
	5.	Whether native/platform exemptions were unchanged
	6.	Policy / CI validation result
	7.	Any remaining temporary exceptions still in place
	8.	Recommended next phase

⸻

NEXT PHASE — DO NOT IMPLEMENT YET

After this is complete:
	•	Phase 9: rerun the full WebP migration audit so savings and runtime usage are reflected accurately
	•	Phase 10: remove verified legacy PNGs only after the tightened policy and post-migration audit both pass
	•	Phase 11: continue the same conversion/migration pattern for the next heaviest runtime asset folders

⸻

FINAL REQUIREMENT

At the very end, provide one full clean summary:
	•	what broad allowlist coverage was removed
	•	what explicit exceptions remain
	•	why they remain
	•	whether CI now passes for the right reasons
	•	what the next safest step is

Do not go haywire.
Do not delete records/files for no reason.
Prefer a narrow explicit production-ready policy over permissive temporary exemptions.

===== END =====
:::

After this, the clean next move is Phase 9: rerun the full WebP migration audit with the tightened allowlist in place.
