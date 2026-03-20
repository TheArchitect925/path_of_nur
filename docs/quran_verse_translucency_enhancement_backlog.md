# Qur'an Verse Translucency Enhancement Backlog

- Audit remaining feature-local Qur'an snippets outside the shared quote/reference/reader path to see whether they should move onto `QuranPresentationStyle` or stay intentionally bespoke.
- If product wants a user-facing verse readability control later, add it as a bounded multiplier on top of the shared Qur'an translucency helper rather than per-screen overrides.
- Consider extracting a shared `QuranVerseBlock` wrapper for small custom verse sections so future pages stop rebuilding Arabic/transliteration/translation/reference stacks manually.
