# Development guide

This repo keeps the default quality gate intentionally small and strict enough to catch obvious regressions without slowing down feature work.

## Local setup

```bash
flutter pub get
flutter gen-l10n
```

For iOS:

```bash
cd ios
pod install
cd ..
```

## Daily workflow

Recommended before opening a PR:

```bash
dart format .
flutter gen-l10n
flutter analyze
flutter test
```

## Localization reminders

- ARB files live in `lib/l10n/`
- run `flutter gen-l10n` after localization changes
- keep placeholder names and shapes aligned across locales
- prefer reusing existing keys over creating near-duplicate wording

## Routing reminders

- keep routes explicit and grouped by feature
- avoid reintroducing generic fallback route scaffolding
- update focused smoke tests when changing aliases or startup redirects

## Before a PR

Checklist:
- code is formatted
- localization output is regenerated if needed
- `flutter analyze` passes
- `flutter test` passes
- user-facing strings are localized
- new routes are explicit and tested if they change navigation behavior
