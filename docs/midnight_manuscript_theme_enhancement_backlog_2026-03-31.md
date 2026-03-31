# Midnight Manuscript Theme Enhancement Backlog

Date: 2026-03-31
Feature area: theme system / appearance

## Recommended follow-up enhancements

1. Add screenshot-based visual QA
- Capture Home, Qur'an, Learn, Journey, and Settings in all shipped theme modes so future theme tweaks can be checked against a stable baseline.

2. Extend theme preview tiles
- Upgrade the settings theme chips into richer preview mini-cards if you want stronger visual differentiation during selection.

3. Add theme-specific nav-shell tuning
- If desired, slightly refine bottom-nav glow and border strength specifically for Midnight Manuscript after real-device review.

4. Audit more shared hardcoded fallback colors
- Continue replacing a few remaining fallback literals in shared widgets with `AppAppearanceTheme` tokens where they still visibly fight custom themes.

5. Expand Qur'an-specific visual polish
- Add a subtle Midnight Manuscript header glow/divider treatment for more Qur'an surfaces that already use the shared Qur'an presentation system.

6. Add widget tests for theme switching
- Cover `AppThemeMode` persistence and settings-theme selection UI so future theme additions don’t regress restore behavior.

7. Add visual/accessibility QA for large text
- Specifically review Settings, Qur'an summary/detail, and the nav shell with large text and reduced transparency enabled.

8. Consider a second premium theme family later
- If you want more visual choice after Midnight Manuscript stabilizes, the next safe direction would be another shared tokenized variant rather than page-specific skins.
