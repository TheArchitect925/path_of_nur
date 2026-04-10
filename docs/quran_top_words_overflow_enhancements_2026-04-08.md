# Qur'an Top Words Overflow Enhancements

Date: 2026-04-08

## Follow-up Ideas

- Run a small-device visual QA pass on the Top Words page with the largest supported Arabic and translation text scales.
- Review the word detail and usage sheet surfaces for the same narrow-width edge cases, especially under accessibility text scaling.
- Add a widget test that pumps the word cards inside a narrow-width layout to guard against future `RenderFlex` overflows.
