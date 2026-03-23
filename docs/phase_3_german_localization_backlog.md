# Phase 3 German Localization Backlog

## Enhancement Options

- Run a native German UX copy review on high-traffic screens first: Home, Prayer, Koran, Learn, Journey, Kids, and Settings.
- Review the remaining identical strings and separate intentional Arabic/scriptural content from English fallback copy that still deserves manual German refinement.
- Add a localization QA check that flags unescaped apostrophes like `Jumu'ah` before `flutter gen-l10n`.
- Audit German line length and truncation on small mobile widths, especially for chips, cards, and button labels.
- Create a small terminology lock list for German so terms like `Koran`, `Gebet`, `Dhikr`, `Hadith`, `Sure`, `Vers`, `Dua`, and `Wudu` stay consistent in future passes.
- Add a second-pass editorial cleanup for low-signal machine-translated strings that are structurally valid but could read more naturally in native German.
