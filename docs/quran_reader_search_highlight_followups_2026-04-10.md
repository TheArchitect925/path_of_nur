# Quran Reader Search Highlight Follow-ups

Date: 2026-04-10

## Safe enhancement options
- Add phrase-range highlighting for translation/transliteration so multi-word matches can render as a continuous highlighted span instead of per-word emphasis.
- Add optional "matched in Translation / Arabic / Transliteration" micro-label inside the reader pill or sheet for clearer field context.
- Add a narrow integration test that inspects rendered highlight spans for a known route like `/quran/surah/2?ayah=233&search=father&searchField=translation`.
- Consider adding a small reader-side toggle later for "highlight current matched field only" vs "highlight all matching fields" if product direction ever needs it. Keep the default as matched-field-only.
