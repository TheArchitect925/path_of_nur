# Quran Focus Recitation Provider Lifecycle Fix Backlog

Date: 2026-03-31

## Completed in this pass

- Removed direct lifecycle writes to `quranFocusRecitationOpenProvider` from the full-screen Qur'an focus recitation page.
- Kept the shell behavior correct by relying on the existing route-based full-screen detection already present in `AppShellScaffold`.
- Verified the focused Qur'an player page and shell compile cleanly after the change.

## Enhancement options

- Remove `quranFocusRecitationOpenProvider` entirely if no non-route-based full-screen focus-recitation state still needs it.
- Add a small widget test that pushes the focus-recitation route and asserts the shell bottom bar stays hidden without provider lifecycle mutations.
- Review other Riverpod lifecycle writes in page `initState`/`dispose` methods for the same pattern before they surface as runtime exceptions.
