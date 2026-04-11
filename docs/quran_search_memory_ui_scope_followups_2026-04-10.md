# Quran Search Memory UI Scope Follow-ups

Date: 2026-04-10

## Recommended enhancement options

1. Add one focused widget test that explicitly verifies compact Home/Qur’an hub/Read Qur’an search surfaces do not render memory sections when query is empty.
2. Consider whether `/quran/search` should later show a slightly richer empty-state grouping between saved searches and recents, while keeping compact surfaces minimal.
3. If product wants even tighter separation later, decide whether reader-sheet recents should become reader-only again or stay shared with `/quran/search`.
4. Consider one lightweight privacy setting to disable local Qur’an search history while leaving static suggestions intact.

## Notes

- This pass intentionally kept the local storage/providers intact.
- The change only reduced where the memory UI appears.
