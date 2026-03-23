# Phase 1 Urdu Localization Backlog

## Enhancement Options

- Review the highest-traffic Urdu strings manually with a native Urdu QA pass, especially Qur'an, Prayer, Journal, Learn, and Kids surfaces.
- Replace the remaining English fallback translations in non-Urdu locale ARBs with real human translations in a follow-up multilingual pass.
- Add a lightweight localization QA script that flags placeholder-name drift, ICU syntax drift, and locale-tag mismatches before `flutter gen-l10n`.
- Add screenshot-based Urdu layout QA for narrow mobile widths to catch overflow on longer labels.
- Add a glossary/term lock file for Islamic terms such as `Qur'an`, `Salah`, `Dhikr`, `Hadith`, `Surah`, `Ayah`, `Dua`, and `Wudu` so future locale passes stay consistent.
- Audit the Urdu file for a second-pass wording cleanup on machine-translated low-signal strings that are valid but could read more naturally.
