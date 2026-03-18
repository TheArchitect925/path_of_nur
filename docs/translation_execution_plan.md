# Translation Execution Plan

## Scope reality

The repo is not blocked by code generation or analyzer failures. It is blocked by translation coverage volume.

Current scale:
- 15 non-English locale files
- 2,935 to 4,497 missing keys per locale
- 12 placeholder-shape mismatches per locale

## Safe execution order

1. Fix placeholder mismatches in all locale files first.
2. Fill high-risk UI groups first in every release locale:
   - navigation and shell
   - settings/profile/accounts/sync
   - prayer/fasting/notifications
   - home
   - learning shell and Quran teaching UI
3. Fill remaining feature keys.
4. Run `flutter gen-l10n` after every locale batch.
5. Do manual QA with app locale different from device locale.

## Why not bulk-copy English

Copying English into non-English ARB files would silence missing-key counts but would not make the app translated. That would create a false release signal.

## Recommended next operational step

Choose one:
- provide approved human translations for target release locales
- run a staged machine-translation workflow and then review by locale
- narrow release locales and complete only those first
