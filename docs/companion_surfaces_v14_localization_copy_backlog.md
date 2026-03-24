# Companion Surfaces Localization + Copy Backlog

Date: 2026-03-23
Topic: Companion surface localization and copy hardening follow-up

## Enhancement options

- Replace the current English fallback text in high-traffic locales with real translations, starting with Arabic, Urdu, German, Indonesian, and Turkish.
- Decide later whether the unused legacy key `learnDailyWisdomThemeIntention` should be removed after one more verification pass that confirms no runtime or archived content still references it.
- Run a multilingual visual QA pass on Seerah, Character, and Daily Wisdom at larger text sizes once real translations land.
- Tighten a second small copy pass later if product wants Seerah period cards and Daily Wisdom source subtitles to become even shorter for denser layouts.
- Consider adding a small localization lint/report step for companion-surface keys so English fallback debt is easier to track over time.
