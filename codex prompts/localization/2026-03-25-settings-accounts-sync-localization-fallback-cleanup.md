===== PHASE X PROMPT — SETTINGS + ACCOUNTS/SYNC LOCALIZATION FALLBACK CLEANUP =====

PRIMARY OBJECTIVE === BUILDING SETTINGS AND ACCOUNTS LOCALIZATION CLEANUP

You are working inside the existing Flutter codebase for Path of Nūr.

A repo-wide localization audit has already been completed.
The onboarding localization pass is also already complete.

This phase is to clean up localization fallback debt across:
1. Settings surfaces
2. Accounts / Sync surfaces

The goal is not to rebuild these pages.
The goal is to remove remaining English fallback exposure, eliminate hardcoded strings if any remain, and make these surfaces feel intentionally localized and translation-ready.

==================================================
CRITICAL RULES
==================================================

1. AUDIT FIRST within this scope before editing.
2. DO NOT change settings or sync behavior unless needed for localization safety.
3. DO NOT hardcode new strings.
4. DO NOT introduce duplicate localization keys where suitable keys already exist.
5. DO NOT break routing, persistence, sync contracts, or account flows.
6. Keep copy concise, user-friendly, and consistent with Path of Nūr tone.
7. End with a full Codex audit summary.

==================================================
PHASE GOAL
==================================================

Clean up localization coverage and fallback quality across Settings and Accounts/Sync so that:
- hardcoded English is removed
- existing fallback-heavy strings are normalized behind AppLocalizations
- labels and helper copy are consistent
- settings/account pages feel localization-safe
- new keys are added only when truly needed

==================================================
A. AUDIT SCOPE
==================================================

Audit all relevant Settings and Accounts/Sync surfaces, including but not limited to:
- settings summary/settings home pages
- profile/settings-related cards and rows
- account sync setup pages
- backup/sync mode labels
- cloud/manual sync descriptions
- account connection banners, warnings, or helper text
- sign-in / sign-out / connect / disconnect labels
- any settings bottom sheets, dialogs, banners, or chips
- any hardcoded subtitles, button labels, helper text, or error copy in these surfaces

Identify:
1. all hardcoded English strings
2. all strings already using AppLocalizations
3. strings currently localized but still semantically weak or inconsistent
4. duplicated labels that should reuse shared keys
5. new keys that truly must be added
6. places where English fallback is especially visible to end users

==================================================
B. IMPLEMENTATION REQUIREMENTS
==================================================

After the audit, localize these surfaces end-to-end within scope.

Requirements:
- replace hardcoded strings with localization access
- reuse existing keys wherever semantically correct
- add new ARB keys only where needed
- keep labels short and readable
- keep helper copy clear and calm
- preserve placeholders/variables where applicable
- normalize terminology across settings/sync pages

Examples of likely terminology that should be consistent:
- sync
- backup
- restore
- connect
- disconnect
- sign in
- sign out
- manual
- cloud
- device
- local backup

Do not:
- create near-duplicate keys
- change product meaning while rewriting
- leave mixed localized/non-localized rows on the same surface

==================================================
C. LOCALIZATION / ARB WORK
==================================================

Update:
- app_en.arb
- relevant non-English app_*.arb files
- generated localization outputs

If non-English translations are not fully available in this pass:
- propagate new keys with English fallback values
- document clearly which newly added keys remain fallback-only

Use clean key names, preferably scoped to settings/account/sync where appropriate.

==================================================
D. QA / UI REQUIREMENTS
==================================================

Verify these surfaces remain stable under localization:
- no button overflow
- no broken row layout
- no clipped helper text
- no obviously mixed English/localized content in the same screen
- RTL behavior remains safe where applicable
- preserve accessibility/readability

==================================================
E. TESTING / VALIDATION
==================================================

Add or update focused tests where useful.

Run:
- flutter gen-l10n
- flutter analyze on changed settings/accounts/localization files
- focused widget tests if present/reasonable

At minimum validate:
1. settings/account pages build cleanly
2. no confirmed hardcoded English remains in the audited scope unless intentionally documented
3. generated localization output is clean
4. no behavior regressions were introduced in account/sync flows

==================================================
F. FILE PRIORITIES
==================================================

Start with the main Settings and Accounts/Sync entry surfaces, then inspect supporting widgets used by those pages.

Also update:
- lib/l10n/app_en.arb
- relevant app_*.arb files
- generated localization outputs

==================================================
G. DELIVERABLES
==================================================

At the end provide:

1. AUDIT FINDINGS
- hardcoded strings found
- keys reused
- new keys added

2. FILES CHANGED
- added
- modified
- removed

3. LOCALIZATION RESULT
- what Settings/Accounts strings are now localized
- whether any new fallbacks remain

4. LOCALIZATION REPORT
- new translation keys added
- locale files/resources updated
- intentionally left translation-ready but not yet fully translated

5. VALIDATION
- gen-l10n run
- analyze run
- tests run

6. FINAL CODEX AUDIT
End with:
- what was completed
- what localization debt remains in settings/accounts if any
- what the next best localization pass should be

==================================================
NEXT PHASE RECOMMENDATION
==================================================

After this phase, recommend the best next pass from:
- worship/prayer surface localization
- high-traffic Learn browse page localization
- locale-by-locale fallback reduction

IMPORTANT PRODUCT INTENT
Settings and Accounts/Sync should feel dependable and intentional in every language, not partly localized.
