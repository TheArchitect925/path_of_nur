# Shortcut Pills Backlog

Date: 2026-04-07

Context:
- Audited Home and Learn shortcut pills after reports that they seemed missing.

Recommended enhancements:
- Run a focused shell-level widget test with both the global Qur'an mini player and the Learn floating shortcut stack visible at the same time, so overlap or obscured hit-target regressions are caught automatically.
- Consider promoting the Home shortcut opener slightly higher or giving it stronger contrast if product QA still reports that it feels missing on first glance.
- Consider adding a shared `ValueKey` to the shortcut opener pill to make future regression tests less dependent on localized text.
- If real-device QA shows shortcut overlap with the global mini player on smaller phones, tune the shared floating offsets in the shell/page scaffold instead of forking page-local shortcut layouts.

Notes:
- No new localization keys were needed for this pass.
