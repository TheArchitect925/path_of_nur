# ===== PHASE V21 PROMPT — COMPANION SURFACES LOCALIZATION HARDENING =====

## PRIMARY OBJECTIVE === BUILDING COMPANION SURFACES LOCALIZATION HARDENING

You are working in the existing Flutter codebase for Path of Nūr.

Goal:
Harden localization quality for the companion surfaces now that they are live.

Critical safety rule:
Do not break gen-l10n.
Do not remove translation keys recklessly.
Do not change route/page behavior just for localization cleanup.

Task type:
Localization hardening + copy cleanup.

Implement:
1. Audit all V10–V13 companion-surface localization keys and current ARB state.
2. Identify:
   - English fallback values still propagated into non-English ARBs
   - inconsistent key naming
   - awkward or duplicated copy
3. Clean up localization structure where safe.
4. Improve user-facing copy quality for:
   - Seerah
   - Character
   - Daily Wisdom
5. Keep all new strings localization-ready and grouped cleanly.
6. Regenerate localization output.
7. Run analyzer and relevant tests.

Deliverables:
- localization audit findings
- keys/copy cleaned up
- files changed
- gen-l10n result
- tests run
- analyzer result
- remaining translation debt clearly listed
