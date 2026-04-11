# Qur'an Text Search Phase 3 Follow-ups

Date: 2026-04-10

## Recommended next enhancements

- Bundle a deterministic transliteration dataset locally so transliteration search stops depending on first-run remote fetches.
- Extend the shared search normalizer with transliteration-specific alias handling for forms like `rahman`, `ar-rahman`, `al rahman`, and `rahmaan`.
- Decide whether transliteration should rank inside the primary `/quran/search` text results or stay as a clearly labeled fallback section.
- Add device-level QA for common transliteration queries after the local dataset path is finalized.
- Evaluate whether future Arabic search should reuse the same repository index row shape with an added Arabic token field, rather than starting a separate engine.
