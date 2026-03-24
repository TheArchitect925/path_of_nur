# Visible Learning Journey Fallback Audit Backlog

Date: 2026-03-23

## Safe replacements completed in V7

- `short-surahs` journey detail fallback now points to `quranLearningHub`.
- `daily-dhikr` journey detail fallback now points to `worshipDhikrPage`.
- `timeline-of-islam` journey detail fallback now points to `learnHistoryArchive`.

## Visible fallbacks still preserved

- `seerah-journey` journey detail fallback
- `ramadan-foundations` journey detail fallback
- `beautiful-character` journey detail fallback
- stage-level fallback cards:
  - `seerah-hijrah`
  - `character-shukr`
  - `character-anger`
  - `character-kindness`
- lesson-level fallback actions:
  - `seerah-hijrah`
  - `seerah-madinah-society`
  - `short-surahs-meaning`
  - `timeline-khulafa`
  - `timeline-expansion`
  - `wisdom-daily-quote`

These still use `learnLegacy` because they are broad companion-library links rather than exact one-to-one route replacements.

## Deferred follow-up

- Audit whether `short-surahs-meaning` should now move from the lesson-level legacy fallback to the canonical Qur'an learning hub as a second-pass cleanup.
- Audit whether `timeline-expansion` can safely use `learnHistoryArchive` at the lesson level without changing the intended “companion library” behavior.
- Decide whether `seerah-journey` needs a canonical Seerah-owned supporting route before its visible legacy fallback can be retired.
- Decide whether `beautiful-character` should gain a dedicated character/adab owner before replacing its visible legacy fallback.
