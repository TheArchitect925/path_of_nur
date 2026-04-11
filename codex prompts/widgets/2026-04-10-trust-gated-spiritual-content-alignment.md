===== PHASE STABILIZATION — TRUST-GATED SPIRITUAL CONTENT ALIGNMENT (PATH OF NUR) =====

PRIMARY OBJECTIVE === ALIGN THE BROADER SPIRITUAL WIDGET ENGINE WITH THE RELEASE-SAFE DUA TRUST POLICY BEFORE ANY FURTHER WIDGET/WATCH EXPANSION

You are working in the existing Path of Nūr repo.

This is a stabilization-first phase.
Do not expand the feature set.
Do not add new widget families.
Do not redesign the watch or live activity architecture.

==================================================
AUDIT TRUTH TO RESPECT
==================================================

The repo audit found:

- the dedicated Daily Dua Content Service is mostly ready and trust-gated correctly
- the broader spiritual widget engine is real, but its dua sourcing is looser than the dedicated service
- iPhone widgets and watch spiritual prompt surfaces may therefore consume dua content that is richer than the finalized trust discipline
- the iPhone widget target now exists in Xcode, but full native shipping validation is still not closed out
- the dua hub still relies heavily on legacy category browsing, but that is NOT the first blocker

The single highest-priority problem to fix now:
- align spiritual_widget_content_engine.dart with the same release-safe dua trust policy used by daily_dua_content_service.dart

==================================================
CRITICAL RULES
==================================================

- Audit first before editing
- Do not expand widget/watch feature scope
- Do not add new payload families
- Do not loosen trust gating
- Do not rewrite sacred content
- Do not change watch sync architecture unless required for safety
- Do not break existing prayer/dhikr/journey widgets
- Do not remove or mutate unrelated records
- Keep changes production-ready, minimal, and well-contained

WHEN UNSURE:
- prefer the stricter trust policy
- prefer reusing existing trusted selection logic over re-implementing it
- flag ambiguity rather than weakening trust rules

==================================================
PHASE 1 — AUDIT THE TRUST MISMATCH
==================================================

Inspect and summarize the current behavior and differences between:

- lib/features/learn/dua/application/daily_dua_content_service.dart
- lib/features/ios_widgets/application/spiritual_widget_content_engine.dart

Identify:
1. how the dedicated dua service selects and trust-gates content
2. how the broader spiritual engine currently selects dua content
3. where the policies differ
4. whether the broader engine is using items that are not safe for default public surfacing
5. the safest reuse path

Do not skip this audit.

==================================================
PHASE 2 — ALIGN THE DUA SOURCING POLICY
==================================================

Make the broader spiritual widget engine use the same release-safe dua policy as the dedicated Daily Dua Content Service.

Requirements:
- default to trusted release-safe duas only
- prefer verified_strong
- allow verified_general only if the existing policy explicitly allows it
- never default to needs_review
- never default to exclude_from_default_surface items
- preserve deterministic behavior
- keep fallback behavior conservative

Prefer reusing shared trust-filtering logic rather than duplicating inconsistent rules.

==================================================
PHASE 3 — KEEP NON-DUA SPIRITUAL CONTENT STABLE
==================================================

Do not over-scope this phase into a full content-engine rewrite.

For:
- hadith
- ayah
- reflection
- names of Allah

only make minimal adjustments if needed for interface consistency.
Do not redesign their selection models unless required to keep the engine coherent.

This phase is about fixing the dua trust mismatch first.

==================================================
PHASE 4 — VERIFY CROSS-SURFACE SAFETY
==================================================

Audit how the aligned spiritual engine now feeds:
- iPhone widgets
- lock screen widgets
- watch spiritual prompt surfaces
- any in-app spiritual prompt consumers if present

Ensure:
- no unsafe dua content is surfaced by default
- no watch/live activity regression is introduced
- existing prayer/dhikr/journey widgets continue to work unchanged

==================================================
PHASE 5 — OPTIONAL MINIMAL REFACTOR
==================================================

If needed, introduce a small shared helper or trust-filter abstraction so:
- daily_dua_content_service.dart
- spiritual_widget_content_engine.dart

do not drift again.

Keep it small and targeted.
Do not create a giant new framework.

==================================================
PHASE 6 — VALIDATION
==================================================

Validate:
1. broader spiritual engine now follows release-safe dua trust policy
2. no needs_review dua is surfaced by default
3. excluded dua items are not surfaced by default
4. deterministic fallback still works
5. existing prayer/dhikr/journey widget payloads are unaffected
6. watch spiritual prompt data remains coherent
7. analyzer passes on changed files

==================================================
EXPECTED DELIVERABLE
==================================================

After implementation, provide:

1. Audit findings
- exact mismatch found
- why it mattered
- reuse path chosen

2. Files changed

3. Alignment summary
- how the broader engine’s dua sourcing changed
- what trust levels are now allowed by default
- whether any shared helper was introduced

4. Cross-surface impact summary
- iPhone widgets
- lock screen widgets
- watch spiritual prompt
- in-app consumers if any

5. Validation results
- analyzer output
- any remaining trust-related caveats

6. Final recommendation
- whether the next safest phase is:
  a) native widget/device validation
  b) dua hub taxonomy adoption
  c) further spiritual widget expansion

IMPORTANT:
Do not broaden scope.
Stabilize trust first.
===== END =====
