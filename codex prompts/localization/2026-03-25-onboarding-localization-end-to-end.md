===== PHASE X PROMPT — ONBOARDING LOCALIZATION END-TO-END =====

PRIMARY OBJECTIVE === BUILDING ONBOARDING LOCALIZATION CLEANUP

You are working inside the existing Flutter codebase for Path of Nūr.

A repo-wide localization audit has already been completed.
The localization system itself is healthy, but content coverage and fallback quality still have debt.

This phase is to localize the onboarding experience end-to-end and remove confirmed hardcoded English from the onboarding flow.

Known confirmed hardcoded examples already found in onboarding_page.dart:
- "Skip"
- "You can change this anytime in Settings."

This phase should be audit-first within the onboarding scope, then implement the localization cleanup fully and safely.

==================================================
CRITICAL RULES
==================================================

1. AUDIT the onboarding flow first before editing.
2. DO NOT change onboarding behavior, routing, or product logic unless needed for localization safety.
3. DO NOT hardcode new strings.
4. DO NOT break generated AppLocalizations usage.
5. DO NOT introduce duplicate localization keys if suitable ones already exist.
6. Keep naming clean and scalable.
7. End with a full Codex audit summary.

==================================================
PHASE GOAL
==================================================

Make the onboarding experience localization-safe and translation-ready end-to-end.

This means:
- remove hardcoded English from onboarding
- replace strings with AppLocalizations-backed values
- add any missing ARB keys cleanly
- ensure onboarding renders correctly across supported locales
- preserve current UX and flow

==================================================
A. AUDIT SCOPE
==================================================

Audit the full onboarding experience, including but not limited to:
- onboarding_page.dart
- any onboarding step widgets
- any onboarding CTA text
- helper text
- skip / continue / next / finish labels
- permissions explainer text if present
- welcome / intro copy
- settings-related messaging inside onboarding
- any bottom sheets / modals / banners used by onboarding
- any localized asset labels or chips shown during onboarding

Identify:
1. all hardcoded English strings
2. all strings already using AppLocalizations
3. any duplicate or inconsistent copy
4. any existing localization keys that can be reused
5. any new keys that must be added

==================================================
B. IMPLEMENTATION REQUIREMENTS
==================================================

After the audit, localize onboarding end-to-end.

Requirements:
- replace hardcoded strings with localization access
- prefer reusing existing keys where semantically correct
- add new ARB keys only where needed
- keep copy user-friendly and consistent with Path of Nūr tone
- preserve placeholders/variables where applicable
- ensure settings references are localized cleanly
- keep button labels concise

Do not:
- create awkward near-duplicate keys
- leave mixed localized/non-localized onboarding strings
- silently alter product meaning while rewriting copy

==================================================
C. ARB / LOCALIZATION WORK
==================================================

Update:
- app_en.arb
- other locale ARBs as needed
- generated localization outputs

If non-English translations are not fully available in this pass:
- keep the new keys translation-ready
- document which locales still use English fallback for the newly added onboarding strings

Use clean key names, onboarding-scoped where appropriate.

==================================================
D. UI / QA REQUIREMENTS
==================================================

Verify onboarding still behaves correctly under localization:
- no overflow on buttons or helper text
- no broken alignment from longer translations
- no hardcoded English remains in the live onboarding surface
- RTL behavior remains safe if onboarding is viewed in Arabic/Urdu/Persian contexts where applicable
- preserve accessibility/readability

==================================================
E. TESTING / VALIDATION
==================================================

Add or update focused tests where useful for onboarding localization.

Run:
- flutter gen-l10n
- flutter analyze on changed onboarding/localization files
- focused widget tests for onboarding if present/reasonable

At minimum validate:
1. onboarding builds with localization changes
2. no hardcoded English remains in the audited onboarding scope unless intentionally documented
3. generated localization output is clean
4. no routing/behavior regressions introduced

==================================================
F. FILE PRIORITIES
==================================================

Start with:
- onboarding_page.dart

Then inspect any onboarding-related widgets/files it uses.

Also update:
- lib/l10n/app_en.arb
- relevant app_*.arb files
- generated localization outputs

==================================================
G. DELIVERABLES
==================================================

At the end provide:

1. AUDIT FINDINGS
- onboarding hardcoded strings found
- keys reused
- new keys added

2. FILES CHANGED
- added
- modified
- removed

3. LOCALIZATION RESULT
- what onboarding strings are now localized
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
- what onboarding localization debt remains if any
- what the next best localization pass should be

==================================================
NEXT PHASE RECOMMENDATION
==================================================

After this phase, recommend the best next pass from:
- settings + accounts/sync fallback cleanup
- worship/prayer surface localization
- high-traffic Learn browse page localization
- locale-by-locale fallback reduction

IMPORTANT PRODUCT INTENT
Onboarding is a first-impression surface.
It should feel fully intentional and localization-safe, not partially translated.
