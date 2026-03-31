# Qur'an Summary Surah Image System Backlog

Date: 2026-03-31

## Recommended follow-ups

1. Generate and optimize the Top 10 `.webp` binaries externally, then activate them by updating `kQuranSurahSummaryBackgroundReadyNumbers`.
2. Add a lightweight golden-path visual QA pass for the Top 10 cards on small phones, regular phones, and larger text sizes after the images are dropped in.
3. Roll out the next batch by either:
   - Juz Amma first for high-frequency short-surah discovery, or
   - surahs 11–20 if you want strict sequential completion.
4. Once 20–30 surahs are live, add a focused widget or screenshot test that verifies cards with art still preserve readable contrast.
5. Consider one shared offline optimization script for future image drops so all new surah art is normalized to consistent width, quality, and `.webp` compression before commit.

## Notes

- This pass intentionally did not fake image binaries.
- The runtime card integration is already safe for future asset drop-in.
