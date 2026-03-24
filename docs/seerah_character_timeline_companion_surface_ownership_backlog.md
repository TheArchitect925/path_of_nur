# Seerah / Character / Timeline Companion Surface Ownership Backlog

Date: 2026-03-23
Phase: V8 visible companion-surface ownership audit

## Safe ownership updates completed

- `short-surahs-meaning` lesson fallback now points to canonical `quranLearningHub`
- `timeline-khulafa` lesson fallback now points to canonical `learnHistoryArchive`
- `timeline-expansion` lesson fallback now points to canonical `learnHistoryArchive`
- localized timeline lesson overrides now preserve those owned tool links at runtime

## New surface candidates

1. Seerah companion surface
   - Needed for `seerah-journey`, `seerah-hijrah`, and `seerah-madinah-society`
   - Current fallback remains too generic, but Prophets/Hadith/History are only partial matches

2. Character / Adab companion surface
   - Needed for `beautiful-character`
   - Current fallback is broad Learn browsing, but no dedicated character/adab home exists yet

3. Daily wisdom / reflection companion surface
   - Needed for `wisdom-daily-quote`
   - Learn Notes is adjacent but not a true daily wisdom owner

## Deferred visible fallback items

- `seerah-journey`
- `seerah-hijrah`
- `seerah-madinah-society`
- `beautiful-character`
- `wisdom-daily-quote`

## Reason for deferral

- these links are no longer routing bugs
- they now depend on unresolved product-surface ownership
- forcing them into existing broad surfaces would reduce semantic clarity rather than improve it
