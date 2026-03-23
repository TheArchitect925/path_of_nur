# Source Prompt

User ran `flutter run` and hit an iOS build failure after localization generation warnings.

The pasted terminal output showed:

- many untranslated locale warnings from `flutter gen-l10n`
- an undefined `NavTab` error
- a large set of missing `AppLocalizations` getters and methods across:
  - Qur'an learning and reflections
  - kids Qur'an ayah insights
  - kids Arabic words, practice, reading mode, and mastery
  - growth path and growth habit detail surfaces
  - contained learn pages
  - tajweed journey localized metadata

Primary request implied by the prompt:

- make the app build again
- resolve the compile errors shown in the pasted `flutter run` output
- preserve the existing app structure while fixing the localization and routing regressions
