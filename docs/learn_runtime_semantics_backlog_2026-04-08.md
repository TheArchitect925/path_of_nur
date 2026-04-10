# Learn Runtime Semantics Backlog

Date: 2026-04-08

## Follow-up options

- Re-test the Learn landing and Kids Learn landing after hot restart and tab switching to confirm the nested-grid removal eliminated the semantics assertion.
- If the assertion still appears, next inspect the shared `MainPageSearchLauncher` and `MainPageShortcutStack` runtime path on Learn and Qur'an.
- If it still persists after that, audit `PremiumCard` press-scale animation as a shared semantics/layout churn source on dense card grids.
