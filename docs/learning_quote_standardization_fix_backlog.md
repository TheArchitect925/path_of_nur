# Learning Quote Standardization Follow-ups

- Date: 2026-03-19
- Scope: follow-up options after reconnecting the Learning hub quote to the shared Qur'an quote rendering and global reader settings

## Next options

- Add a widget test covering `LearningHubRabbiZidniIlmaHeader` against the shared Qur'an reader settings toggles so Arabic, transliteration, translation, and font scales do not regress.
- Audit other special quote headers outside Learn to confirm they also use `QuranQuoteBlock` / `QuranVerseContent` instead of custom rendering.
- Decide whether the shortened `Rabbi zidni ilma` transliteration rule should remain Learning-only or become a named reusable quote-transform preset if other surfaces need the same behavior later.
