# i18n Follow-up Checklist: Batches 1A to 3B

## Must fix before calling Batches 1A-3B complete
- [ ] Localize remaining hardcoded Home shortcut labels and status text in `home_page.dart`
- [ ] Localize Home duration/countdown strings in `home_page.dart`
- [ ] Localize Home daily learning card copy and CTA labels in `home_page.dart`
- [ ] Fix notification/live-activity locale resolution to respect the app-selected locale
- [ ] Remove duplicated `settings*` keys from `app_en.arb`
- [ ] Normalize `settingsCurrentProfileSummary` placeholder contract in `app_en.arb`

## Strongly recommended cleanup
- [ ] Replace Home search fallback subtitle template with a localized template
- [ ] Replace `Reflection Draft` English sentinel logic with a stable identifier
- [ ] Localize adhan option catalog display text or add an ID-to-label mapping layer
- [ ] Remove or isolate English fallback getters in `prayer_name.dart` and `prayer_status.dart`
- [ ] Replace English-coupled transport label matching in accounts sync with stable identifiers

## Safe to defer
- [ ] Add a localized template for `What’s new` version/date subtitle
- [ ] Add explicit semantics/tooltip labels for Home shortcut chips
