# Final i18n Checklist

## Fixed in final pass
- [x] Localized shared Quran reference block fallback and action text
- [x] Localized remaining Salah tracker/Qada helper UI text
- [x] Localized Quran teaching daily review empty states and actions
- [x] Localized Quran teaching listen-only helper text, mode labels, and progress templates
- [x] Re-ran `flutter gen-l10n` after final ARB changes
- [x] Re-ran `dart format` on touched Dart files
- [x] Re-ran `flutter analyze`

## Verified
- [x] `flutter gen-l10n` passes
- [x] `dart format` passes
- [x] `flutter analyze` passes
- [x] No new ARB syntax or placeholder-shape issues were introduced in the final pass

## Deferred / manual review
- [ ] Localize remaining Creation Explorer dialog/action/permission text
- [ ] Localize remaining Growth Reflection UI text
- [ ] Localize remaining Growth Habits UI text
- [ ] Localize remaining shared prayer helper/validation strings in `prayer_preferences.dart`
- [ ] Localize remaining prayer cadence summaries in `prayer_tracker_controller.dart`
- [ ] Localize remaining fasting enum/display helpers in `fasting_status.dart` and `fasting_type.dart`
- [ ] Complete a small fasting section wording cleanup
- [ ] Finish accessibility-localization sweep on untouched feature surfaces

## Translation still needed for non-English locales
- [ ] Translate newly added Batch 13 keys in supported non-English locale files
- [ ] Translate previously added Batch 1-12 keys still falling back to English
- [ ] Validate placeholder parity after non-English translations are added
