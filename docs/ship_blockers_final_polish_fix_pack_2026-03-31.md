# Ship Blockers & Final Polish Fix Pack

Date: 2026-03-31

## Summary

This pre-launch pass stayed intentionally narrow:
- Character Path hardening
- Salah Path first-step polish
- light QA sweep for obvious `/learn` issues

No route ownership, canonical Qur'an ownership, kids architecture, search, analytics, or reward boundaries were changed.

## Character Path

### Before

- opened with a broad companion surface
- then jumped to `learnLifeLanding`
- then jumped to Qur'an learning pathways
- then ended on the broad `beautiful-character` journey detail page

Main problems:
- too abstract
- too surface-hopping
- weak closure
- no explicit final handoff

### After

The path now moves through:
1. `learnCharacterCompanion`
2. focused `learnCharacterCompanion?focus=sabr`
3. `learnJourneyStage(beautiful-character / character-kindness)`
4. `learnJourneyStage(beautiful-character / character-completion)`

Result:
- clearer intro through the existing companion owner
- more grounded trait focus
- real-life application
- explicit reflection step
- meaningful final direction into Stories or deeper Character study through the existing completion state and sequencing layer

## Salah Path

### Before

- first step opened the full Salah hub immediately

Main problem:
- safe, but still more hub-like than the hardened beginner paths

### After

The first step now opens:
- `learnJourneyStage(salah-foundations / salah-hub)`

This gives beginners:
- what Salah is
- why it matters
- a calmer emotional and spiritual frame

Downstream steps were preserved:
- wudu guide
- wudu trainer
- guided prayer

## QA sweep

Focused audit areas:
- `/learn` launch-critical guided path flow
- path-route safety
- route smoke for bridge/next-step pages
- obvious large-text / layout risk by code inspection on touched surfaces

Safe code-side QA fixes made:
- none beyond the path polish itself

Reason:
- no obvious overflow or layout bug in the touched Learn surfaces justified a late UI change
- avoiding unnecessary pre-launch churn was safer

## Validation

- `flutter gen-l10n`
- `flutter analyze ...` on changed Character/Salah/path files
- `flutter test test/features/learn/guided_paths/data/guided_learning_paths_seed_test.dart`
- `flutter test test/app/router_smoke_test.dart`

Results:
- analyzer clean
- tests passed

## Risks and follow-ups

- Character Path is now launch-safe, but still could gain one deeper follow-up lane later if product wants more trait-specific continuity.
- Salah Path is much better at the entry point now, but could still gain a stronger end-of-path completion moment in a future non-blocking pass.
