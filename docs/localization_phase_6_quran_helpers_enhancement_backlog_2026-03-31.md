# Localization Phase 6 Enhancement Backlog

Date: 2026-03-31

## High-value next improvements

- Continue the Qur''an localization sweep into `quran_surah_insight_page.dart`, where the ARB audit still showed meaningful German and Urdu same-as-English helper text.
- Do a focused hardcoded-string cleanup in `quran_reader_page.dart` only after the smaller helper surfaces are stable, because that page has the highest string volume and the highest regression risk.
- Review Qur''an learning/support terminology for locale quality, especially words like `theme`, `path`, `insight`, and `memorization`, so they feel consistent across the Qur''an hub and related helper pages.
- Add a lightweight regression script or check for same-as-English fallback on the most active Qur''an helper keys so new fallback debt is easier to catch before release.
- Run manual RTL and large-text checks on `Daily Qur''an Companion` and `Focus Recitation`, especially chip labels, action rows, and timer labels.
